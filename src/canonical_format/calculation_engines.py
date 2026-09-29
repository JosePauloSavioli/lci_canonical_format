#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 12:58:01 2026

@author: jotape42p
"""

from decimal import Decimal
from math import exp, log, sqrt
from numbers import Real
import re

import numpy as np
import openturns as ot
from scipy import stats
from ucumvert import PintUcumRegistry

from uncertainties import std_dev, ufloat
from pydantic import TypeAdapter

from Lavoisier.conversions.calculation_quantities import (
    ArrayQuantity,
    Quantity,
    QuantityWithDistribution,
    QuantityWithVariance,
    decimal,
)
from Lavoisier.conversions.models.lca import SingleQuantity


DISTRIBUTION_IDENTITIES = {
    "Bernoulli": ("http://www.probonto.org/ontology#PROB_k0000000", "Bernoulli1"),
    "Beta": ("http://www.probonto.org/ontology#PROB_k0000057", "Beta1"),
    "ChiSquare": ("http://www.probonto.org/ontology#PROB_k0001359", "ChiSquared1"),
    "DiscreteUniform": ("http://www.probonto.org/ontology#PROB_k0000727", "UniformDiscrete1"),
    "Exponential": ("http://www.probonto.org/ontology#PROB_k0000418", "Exponential1"),
    "F": ("http://www.probonto.org/ontology#PROB_k0000492", "F1"),
    "Gamma": ("http://www.probonto.org/ontology#PROB_k0000597", "Gamma2"),
    "Geometric": ("http://www.probonto.org/ontology#PROB_k0000782", "Geometric1"),
    "Gumbel": ("http://www.probonto.org/ontology#PROB_k0000032", "Gumbel1"),
    "Hypergeometric": ("http://www.probonto.org/ontology#PROB_k0000126", "Hypergeometric1"),
    "Laplace": ("http://www.probonto.org/ontology#PROB_k0000256", "Laplace1"),
    "Logistic": ("http://www.probonto.org/ontology#PROB_k0000307", "Logistic1"),
    "Lognormal": ("http://www.probonto.org/ontology#PROB_k0000478", "LogNormal3"),
    "NegativeBinomial": ("http://www.probonto.org/ontology#PROB_k0000074", "NegativeBinomial1"),
    "Normal": ("http://www.probonto.org/ontology#PROB_k0000265", "Normal2"),
    "Pareto": ("http://www.probonto.org/ontology#PROB_k0000361", "ParetoTypeI1"),
    "Poisson": ("http://www.probonto.org/ontology#PROB_k0000410", "Poisson1"),
    "StudentT": ("http://www.probonto.org/ontology#PROB_k0000635", "StudentT2"),
    "Triangular": ("http://www.probonto.org/ontology#PROB_k0000661", "Triangular1"),
    "Uniform": ("http://www.probonto.org/ontology#PROB_k0000703", "Uniform1"),
    "Weibull": ("http://www.probonto.org/ontology#PROB_k0000800", "Weibull1")
}


# Creation of uncertainties

def _pick(parameters, *names, default=None):
    for name in names:
        if name in parameters:
            return parameters[name]
    if default is not None:
        return default() if callable(default) else default
    raise KeyError(f"Missing distribution parameter: {' or '.join(names)}")


def _direct(constructor, arguments, fixed=()):
    def build(parameters, code_name):
        values = [converter(parameters[name]) for name, converter in arguments]
        return constructor(*values, *fixed)
    return build


# Output of uncertainties

def _standard(name, parameters):
    uri, code_name = DISTRIBUTION_IDENTITIES[name]
    return {
        "uncertaintyType": "probabilityDistribution",
        "distributionName": name,
        "probontoId": {"uri": uri, "name": code_name},
        "parameters": parameters,
    }


def _direct_entry(name, keys):
    return lambda parameters: _standard(name, dict(zip(keys, parameters)))


def _located_entry(name, keys):
    return (
        lambda parameters: None
        if parameters[-1] != 0
        else _standard(name, dict(zip(keys, parameters[:-1])))
    )


# Specific funcitons for distributions

def _normal_stdev(parameters):
    if "stdev" in parameters:
        return parameters["stdev"]
    if "variance" in parameters:
        return parameters["variance"].sqrt()
    return Decimal("1") / parameters["precision"].sqrt()


def _lognormal_parameters(parameters):
    if "meanLog" in parameters:
        median = parameters["meanLog"].exp()
        if "stdevLog" in parameters:
            return median, parameters["stdevLog"]
        if "varLog" in parameters:
            return median, parameters["varLog"].sqrt()
        return median, Decimal("1") / parameters["precision"].sqrt()

    if "median" in parameters:
        median = parameters["median"]
        if "stdevLog" in parameters:
            return median, parameters["stdevLog"]
        if "geometricStdev" in parameters:
            return median, parameters["geometricStdev"].ln()
        return median, (parameters["coefVar"] ** 2 + 1).ln().sqrt()

    mean = parameters["mean"]
    stdev = parameters["stdev"]
    variance_log = (Decimal("1") + (stdev / mean) ** 2).ln()
    return mean / (variance_log / 2).exp(), variance_log.sqrt()


def _negative_binomial_parameters(parameters, code_name):
    if code_name == "NegativeBinomial1":
        return parameters["numberOfSuccesses"], parameters["probability"]
    if code_name == "NegativeBinomial4":
        return parameters["numberOfFailures"], parameters["probability"]
    if code_name == "NegativeBinomial5":
        failures = parameters["shape"]
        inverse_scale = parameters["inverseScale"]
        return failures, inverse_scale / (inverse_scale + 1)

    means = {
        "NegativeBinomial2": (
            parameters.get("rate"),
            Decimal("1") / parameters.get("overdispersion", Decimal("1")),
        ),
        "NegativeBinomial3": (
            parameters.get("mean"),
            parameters.get("index"),
        ),
        "NegativeBinomial6": (
            parameters.get("logMean", Decimal("0")).exp(),
            Decimal("1") / parameters.get("dispersion", Decimal("1")),
        ),
    }

    if code_name not in means:
        raise NotImplementedError(f"Negative binomial parameterization is not implemented: {code_name}")

    mean, failures = means[code_name]
    return failures, failures / (failures + mean)


def _discrete_uniform(parameters, code_name):
    minimum = int(parameters.get("minimum", 0))
    maximum = int(parameters.get("maximum", minimum + parameters["numberOfValues"] - 1))
    return ot.UserDefined([[float(value)] for value in range(minimum, maximum + 1)])


def _lognormal(parameters, code_name):
    median, stdev = _lognormal_parameters(parameters)
    return ot.LogNormal(float(median.ln()), float(stdev), 0.0)


def _negative_binomial(parameters, code_name):
    failures, probability = _negative_binomial_parameters(parameters, code_name)
    return ot.Polya(float(failures), float(probability))


# Input implementations

DIRECT_DISTRIBUTIONS = {
    "Beta": _direct(ot.Beta, (("alpha", float), ("beta", float)), (0.0, 1.0)),
    "ChiSquare": _direct(ot.ChiSquare, (("degreesOfFreedom", float),)),
    "F": _direct(ot.FisherSnedecor, (("numerator", float), ("denominator", float))),
    "Geometric": _direct(ot.Geometric, (("probability", float),)),
    "Gumbel": _direct(ot.Gumbel, (("scale", float), ("location", float))),
    "Hypergeometric": _direct(ot.Hypergeometric, (("populationSize", int), ("numberOfSuccesses", int), ("numberOfTrials", int))),
    "Triangular": _direct(ot.Triangular, (("lowerLimit", float), ("shape", float), ("upperLimit", float))),
    "Uniform": _direct(ot.Uniform, (("minimum", float), ("maximum", float))),
}


INDIRECT_DISTRIBUTIONS = {
    "Bernoulli": lambda p, c: ot.Bernoulli(
        float(_pick(p, "probability", default=lambda: Decimal("1") / (Decimal("1") + (-p["logitProbability"]).exp())))
    ),
    "Binomial": lambda p, c: ot.Binomial(
        int(_pick(p, "numberOfTrials", "trials")),
        float(p["probability"]),
    ),
    "Cauchy": lambda p, c: ot.Cauchy(
        float(p["scale"]),
        float(_pick(p, "location", "median", default=Decimal("0"))),
    ),
    "DiscreteUniform": _discrete_uniform,
    "Exponential": lambda p, c: ot.Exponential(
        float(_pick(p, "rate", default=lambda: Decimal("1") / p["mean"])),
        0.0,
    ),
    "Gamma": lambda p, c: ot.Gamma(
        float(p["shape"]),
        float(_pick(p, "rate", default=lambda: Decimal("1") / p["scale"])),
        0.0,
    ),
    "Laplace": lambda p, c: ot.Laplace(
        float(p["location"]),
        float(Decimal("1") / _pick(p, "scale", default=lambda: Decimal("1") / p["inverseScale"])),
    ),
    "Logistic": lambda p, c: ot.Logistic(
        float(p["location"]),
        float(_pick(p, "scale", default=lambda: Decimal("1") / p["inverseScale"])),
    ),
    "Lognormal": _lognormal,
    "NegativeBinomial": _negative_binomial,
    "Normal": lambda p, c: ot.Normal(
        float(p["mean"]),
        float(_normal_stdev(p))
    ),
    "Pareto": lambda p, c: ot.Pareto(
        float(p["scale"]),
        float(_pick(p, "shape", "tailIndex")),
        float(p.get("location", Decimal("0"))),
    ),
    "Poisson": lambda p, c: ot.Poisson(float(
        _pick(p, "rate", default=lambda: p["logRate"].exp())
    )),
    "StudentT": lambda p, c: ot.Student(
        float(p["degreesOfFreedom"]),
        float(_pick(p, "mean", "location", default=Decimal("0"))),
        float(p.get("scale", Decimal("1"))),
    ),
    "Weibull": lambda p, c: ot.WeibullMin(
        float(_pick(p, "scale", default=lambda: p["lambda"] ** (Decimal("-1") / p["shape"]))),
        float(p["shape"]),
        0.0,
    ),
}


# Array input implementations

def _array_discrete_uniform(p):
    minimum = p.get("minimum", 0)
    maximum = p["maximum"] if "maximum" in p else minimum + p["numberOfValues"] - 1
    return stats.randint, (minimum, maximum + 1), {}


def _array_lognormal(p):
    if "meanLog" in p:
        median = np.ma.exp(p["meanLog"])
        variance_log = (
            p["varLog"]
            if "varLog" in p
            else p["stdevLog"] ** 2 if "stdevLog" in p else 1 / p["precision"]
        )
    elif "median" in p:
        median = p["median"]
        variance_log = (
            p["stdevLog"] ** 2
            if "stdevLog" in p
            else (
                np.ma.log(p["geometricStdev"]) ** 2
                if "geometricStdev" in p
                else np.ma.log1p(p["coefVar"] ** 2)
            )
        )
    else:
        variance_log = np.ma.log(1 + (p["stdev"] / p["mean"]) ** 2)
        median = p["mean"] / np.ma.exp(variance_log / 2)
    return stats.lognorm, (np.ma.sqrt(variance_log),), {"scale": median}


def _array_negative_binomial(p):
    if "numberOfSuccesses" in p or "numberOfFailures" in p:
        failures = p.get("numberOfSuccesses", p.get("numberOfFailures"))
        probability = p["probability"]
    elif "shape" in p:
        failures = p["shape"]
        probability = p["inverseScale"] / (p["inverseScale"] + 1)
    else:
        mean = p["rate"] if "rate" in p else p["mean"] if "mean" in p else np.ma.exp(p.get("logMean", 0))
        failures = 1 / p.get("overdispersion", p.get("dispersion", 1 / p.get("index", 1)))
        probability = failures / (failures + mean)
    return stats.nbinom, (failures, probability), {}


def _array_normal(p):
    scale = p["stdev"] if "stdev" in p else np.ma.sqrt(p["variance"] if "variance" in p else 1 / p["precision"])
    return stats.norm, (), {"loc": p["mean"], "scale": scale}


def _array_triangular(p):
    width = p["upperLimit"] - p["lowerLimit"]
    return stats.triang, ((p["shape"] - p["lowerLimit"]) / width,), {"loc": p["lowerLimit"], "scale": width}


ARRAY_DISTRIBUTIONS = {
    "Bernoulli": 
        lambda p: (stats.bernoulli, (_pick(p, "probability", default=lambda: 1 / (1 + np.ma.exp(-p["logitProbability"]))),), {}),
    "Beta": 
        lambda p: (stats.beta, (p["alpha"], p["beta"]), {}),
    "Binomial": 
        lambda p: (stats.binom, (_pick(p, "numberOfTrials", "trials"), p["probability"]), {}),
    "Cauchy": 
        lambda p: (stats.cauchy, (), {"loc": _pick(p, "location", "median", default=0), "scale": p["scale"]}),
    "ChiSquare": 
        lambda p: (stats.chi2, (p["degreesOfFreedom"],), {}),
    "DiscreteUniform": 
        _array_discrete_uniform,
    "Exponential": 
        lambda p: (stats.expon, (), {"scale": _pick(p, "mean", default=lambda: 1 / p["rate"])}),
    "F": 
        lambda p: (stats.f, (p["numerator"], p["denominator"]), {}),
    "Gamma": 
        lambda p: (stats.gamma, (p["shape"],), {"scale": _pick(p, "scale", default=lambda: 1 / p["rate"])}),
    "Geometric": 
        lambda p: (stats.geom, (p["probability"],), {}),
    "Gumbel": 
        lambda p: (stats.gumbel_r, (), {"loc": p["location"], "scale": p["scale"]}),
    "Hypergeometric": 
        lambda p: (stats.hypergeom, (p["populationSize"], p["numberOfSuccesses"], p["numberOfTrials"]), {}),
    "Laplace": 
        lambda p: (stats.laplace, (), {"loc": p["location"], "scale": _pick(p, "scale", default=lambda: 1 / p["inverseScale"])}),
    "Logistic": 
        lambda p: (stats.logistic, (), {"loc": p["location"], "scale": _pick(p, "scale", default=lambda: 1 / p["inverseScale"])}),
    "Lognormal": 
        _array_lognormal,
    "NegativeBinomial": 
        _array_negative_binomial,
    "Normal": 
        _array_normal,
    "Pareto": 
        lambda p: (stats.lomax if "tailIndex" in p else stats.pareto, (_pick(p, "tailIndex", "shape"),), {"loc": p.get("location", 0), "scale": p["scale"]}),
    "Poisson": 
        lambda p: (stats.poisson, (_pick(p, "rate", default=lambda: np.ma.exp(p["logRate"])),), {}),
    "StudentT": 
        lambda p: (stats.t, (p["degreesOfFreedom"],), {"loc": _pick(p, "mean", "location", default=0), "scale": p.get("scale", 1)}),
    "Triangular": 
        _array_triangular,
    "Uniform": 
        lambda p: (stats.uniform, (), {"loc": p["minimum"], "scale": p["maximum"] - p["minimum"]}),
    "Weibull": 
        lambda p: (stats.weibull_min, (p["shape"],), {"scale": _pick(p, "scale", default=lambda: p["lambda"] ** (-1 / p["shape"]))}),
}


# Output implementations

DIRECT_ENTRIES = {
    "Uniform": _direct_entry("Uniform", ("minimum", "maximum")),
    "Triangular": _direct_entry("Triangular", ("lowerLimit", "shape", "upperLimit")),
    "Poisson": _direct_entry("Poisson", ("rate",)),
    "Bernoulli": _direct_entry("Bernoulli", ("probability",)),
    "ChiSquare": _direct_entry("ChiSquare", ("degreesOfFreedom",)),
    "FisherSnedecor": _direct_entry("F", ("numerator", "denominator")),
    "Geometric": _direct_entry("Geometric", ("probability",)),
    "Gumbel": _direct_entry("Gumbel", ("scale", "location")),
    "Hypergeometric": _direct_entry("Hypergeometric", ("populationSize", "numberOfSuccesses", "numberOfTrials")),
    "Logistic": _direct_entry("Logistic", ("location", "scale")),
    "Student": _direct_entry("StudentT", ("degreesOfFreedom", "mean", "scale")),
}


INDIRECT_ENTRIES = {
    "Normal": 
        lambda p: _standard("Normal", {"mean": p[0], "variance": p[1] ** 2}),
    "LogNormal": 
        lambda p: None if p[2] != 0 else _standard("Lognormal", {"median": p[0].exp(), "stdevLog": p[1]}),
    "Beta": 
        lambda p: None if p[2:] != [0, 1] else _standard("Beta", {"alpha": p[0], "beta": p[1]}),
    "Gamma": 
        _located_entry("Gamma", ("shape", "rate")),
    "Exponential": 
        _located_entry("Exponential", ("rate",)),
    "Pareto": 
        _located_entry("Pareto", ("scale", "shape")),
    "Polya": 
        lambda p: None if p[0] != p[0].to_integral_value() else _standard("NegativeBinomial", {"numberOfSuccesses": int(p[0]), "probability": p[1]}),
    "Laplace": 
        lambda p: _standard("Laplace", {"location": p[0], "scale": Decimal("1") / p[1]}),
    "WeibullMin": _located_entry("Weibull", ("scale", "shape")),
}


# Engines

UNCERTAINTY_ADAPTER = TypeAdapter(SingleQuantity.model_fields["uncertainty"].annotation)

SI_UCUM = {
    "meter": "m",
    "kilogram": "kg",
    "second": "s",
    "ampere": "A",
    "kelvin": "K",
    "mole": "mol",
    "candela": "cd",
}
DIMENSION_FIELDS = {
    "[length]": "length",
    "[mass]": "mass",
    "[time]": "time",
    "[current]": "electricCurrent",
    "[temperature]": "thermodynamicTemperature",
    "[substance]": "amountOfSubstance",
    "[luminosity]": "luminousIntensity",
}

class UnitEngine:

    def __init__(self):
        self.registry = PintUcumRegistry(non_int_type=Decimal)
        self.registry.formatter.default_format = "~C"
        self.dimensionless = self.registry.from_ucum("1").units
        self.units = {}
        self.definitions = {}

    def add(self, definition):
        unit_id = definition.id
    
        if definition.unitType == "physical":
            unit = self.parse(definition.shortName)
            dimensionality = {
                DIMENSION_FIELDS[str(name)]: int(exponent)
                for name, exponent in unit.dimensionality.items()
                if exponent
            }
            declared = definition.dimensionality.model_dump(exclude_none=True)
            if dimensionality != declared:
                raise ValueError(
                    f"Unit {definition.id!r} dimensionality does not match "
                    f"{definition.shortName!r}: {declared!r} != {dimensionality!r}"
                )
        elif definition.unitType == "currency":
            unit = self.dimensionless
        else:
            raise ValueError(f"Unsupported unit type: {definition.unitType!r}")
    
        if unit_id in self.definitions and self.definitions[unit_id] != definition:
            raise ValueError(f"Conflicting unit definition: {unit_id}")
    
        self.units[unit_id] = unit
        self.definitions[unit_id] = definition
        return unit

    def unit(self, unit_id):
        return self.units[unit_id]

    def is_currency(self, unit_id):
        return (
            unit_id is not None
            and unit_id in self.definitions
            and self.definitions[unit_id].unitType == "currency"
        )

    def parse(self, unit):
        try:
            return self.registry.from_ucum(unit).units
        except Exception as error:
            raise ValueError(f"Invalid UCUM unit: {unit!r}") from error

    def unit_id(self, unit):
        exact = [
            unit_id
            for unit_id, definition in self.definitions.items()
            if definition.unitType == "physical" and definition.shortName == unit
        ]
        if len(exact) == 1:
            return exact[0]

        parsed = self.parse(unit)
        matches = [
            unit_id
            for unit_id, value in self.units.items()
            if self.definitions[unit_id].unitType == "physical" and value == parsed
        ]
        if len(matches) != 1:
            raise ValueError(f"UCUM unit is not uniquely registered: {unit!r}")
        return matches[0]

    def references(self, unit_id):
        return tuple(self.definitions[unit_id].references or ())

    def reference_unit(self, unit):
        quantity = self.registry.from_ucum(unit)
        factor, reference = self.registry.get_base_units(quantity.units, system="SI")
        if factor is None:
            return None

        numerator = []
        denominator = []
        for name, exponent in reference._units.items():
            exponent = int(exponent)
            if not exponent:
                continue
            value = SI_UCUM[name] + (str(abs(exponent)) if abs(exponent) != 1 else "")
            (numerator if exponent > 0 else denominator).append(value)

        short_name = ".".join(numerator) or "1"
        if denominator:
            value = ".".join(denominator)
            short_name += f"/({value})" if "." in value else f"/{value}"

        factor = Decimal(str(quantity.magnitude)) * Decimal(str(factor))
        if short_name == unit and factor == 1:
            return None
        return {"shortName": short_name, "conversionFactor": factor}


class UncertaintyEngine:

    def __init__(self, sample_count=1000, seed=None):
        if sample_count != 0 and sample_count < 30:
            raise ValueError("Uncertainty sample count must be zero or at least 30")
        self.sample_count = sample_count
        if seed is not None:
            ot.RandomGenerator.SetSeed(int(seed))

    def attach(self, quantity, uncertainty):
        if uncertainty is None:
            return quantity

        data = uncertainty
        builders = {
            "variance": self._variance,
            "probabilityDistribution": self._probability,
            "truncatedProbabilityDistribution": self._truncated,
            "mixtureProbabilityDistribution": self._mixture,
            "transformedProbabilityDistribution": self._transformed,
            "empirical": self._empirical,
        }
        uncertainty_type = data["uncertaintyType"]
        builder = builders.get(uncertainty_type)
        if builder is None:
            raise NotImplementedError(f"Uncertainty type is not implemented: {uncertainty_type!r}")
        return builder(quantity, data)

    def from_samples(self, quantity, values):
        distribution = ot.UserDefined([[float(decimal(value))] for value in values])
        return QuantityWithDistribution._from_parts(quantity, distribution)

    def to_entry(self, quantity):
        if isinstance(quantity, QuantityWithVariance):
            entry = {
                "uncertaintyType": "variance",
                "variance": decimal(std_dev(quantity.uncertainty)) ** 2,
            }
        elif not isinstance(quantity, QuantityWithDistribution):
            return None
        else:
            uncertainty = self._unwrap(quantity.uncertainty)
            if uncertainty.getClassName() == "Dirac":
                return None

            entry = self._distribution_entry(uncertainty)

            if entry is None:
                if self.sample_count == 0:
                    raise ValueError(
                        "OpenTURNS result has no exact canonical schema distribution and uncertainty sampling is disabled"
                    )

                sample = uncertainty.getSample(self.sample_count)
                entry = {
                    "uncertaintyType": "empirical",
                    "values": [decimal(sample[index, 0]) for index in range(self.sample_count)],
                }

        return UNCERTAINTY_ADAPTER.validate_python(entry)

    def _unwrap(self, distribution):
        while distribution.getClassName() == "Distribution":
            implementation = distribution.getImplementation()
            if implementation.getClassName() == "Distribution":
                break
            distribution = implementation
        return distribution

    def _distribution_entry(self, distribution):
        distribution = self._unwrap(distribution)
        class_name = distribution.getClassName()
        builder = DIRECT_ENTRIES.get(class_name) or INDIRECT_ENTRIES.get(class_name)
        if builder is not None:
            entry = builder([decimal(value) for value in distribution.getParameter()])
            if entry is not None:
                return entry

        normal = self._as_normal(distribution)
        if normal is not None:
            return _standard("Normal", {
                "mean": decimal(normal[0]),
                "variance": decimal(normal[1]) ** 2,
            })

        lognormal = self._as_lognormal(distribution)
        if lognormal is not None:
            return _standard("Lognormal", {
                "median": decimal(exp(lognormal[0])),
                "stdevLog": decimal(lognormal[1]),
            })

        handlers = {
            "LinearCombinationDistribution": self._linear_entry,
            "RandomMixture": self._linear_entry,
            "ProductDistribution": self._product_entry,
            "CompositeDistribution": self._composite_entry,
            "SquaredNormal": self._squared_normal_entry,
            "TruncatedDistribution": self._truncated_entry,
            "Mixture": self._mixture_entry,
            "UserDefined": self._user_defined_entry,
            "FiniteDiscreteDistribution": self._user_defined_entry,
        }
        handler = handlers.get(class_name)
        return None if handler is None else handler(distribution)

    def _as_normal(self, distribution):
        distribution = self._unwrap(distribution)
        class_name = distribution.getClassName()

        if class_name == "Normal":
            parameters = distribution.getParameter()
            return float(parameters[0]), float(parameters[1])

        if class_name in {"LinearCombinationDistribution", "RandomMixture"}:
            distributions = [self._unwrap(item) for item in distribution.getDistributionCollection()]
            weights = self._linear_weights(distribution, len(distributions))
            normals = [self._as_normal(item) for item in distributions]
            if any(item is None for item in normals):
                return None
            mean = float(distribution.getConstant()[0]) + sum(
                weight * item[0]
                for weight, item in zip(weights, normals)
            )
            variance = sum(
                (weight * item[1]) ** 2
                for weight, item in zip(weights, normals)
            )
            return mean, sqrt(variance)

        if class_name == "CompositeDistribution":
            formula = self._formula(distribution)
            if formula in {"log(x)", "ln(x)"}:
                return self._as_lognormal(distribution.getAntecedent())

        return None

    def _as_lognormal(self, distribution):
        distribution = self._unwrap(distribution)
        class_name = distribution.getClassName()

        if class_name == "LogNormal":
            parameters = distribution.getParameter()
            if parameters[2] == 0:
                return float(parameters[0]), float(parameters[1])
            return None

        if class_name in {"LinearCombinationDistribution", "RandomMixture"}:
            distributions = list(distribution.getDistributionCollection())
            if len(distributions) != 1 or distribution.getConstant()[0] != 0:
                return None
            factor = self._linear_weights(distribution, 1)[0]
            if factor <= 0:
                return None
            parameters = self._as_lognormal(distributions[0])
            if parameters is None:
                return None
            return parameters[0] + log(factor), parameters[1]

        if class_name == "ProductDistribution":
            left = self._as_lognormal(distribution.getLeft())
            right = self._as_lognormal(distribution.getRight())
            if left is None or right is None:
                return None
            return left[0] + right[0], sqrt(left[1] ** 2 + right[1] ** 2)

        if class_name == "CompositeDistribution":
            formula = self._formula(distribution)
            antecedent = distribution.getAntecedent()

            if formula == "exp(x)":
                return self._as_normal(antecedent)

            power = self._power(distribution)
            if power is not None:
                parameters = self._as_lognormal(antecedent)
                if parameters is not None and power != 0:
                    return power * parameters[0], abs(power) * parameters[1]

            base = self._exponential_base(formula)
            if base is not None and base > 0 and base != 1:
                normal = self._as_normal(antecedent)
                if normal is not None:
                    factor = log(base)
                    return factor * normal[0], abs(factor) * normal[1]

        return None

    def _linear_entry(self, distribution):
        distribution = self._unwrap(distribution)
        distributions = [self._unwrap(item) for item in distribution.getDistributionCollection()]
        weights = self._linear_weights(distribution, len(distributions))
        constant = float(distribution.getConstant()[0])

        if len(distributions) == 1:
            if distributions[0].getClassName() in {"UserDefined", "FiniteDiscreteDistribution"}:
                entry = self._user_defined_entry(distributions[0], weights[0], constant)
                if entry is not None:
                    return entry
            transformed = self._affine(distributions[0], weights[0], constant)
            if transformed is not None:
                return self._distribution_entry(transformed)
            entry = self._distribution_entry(distributions[0])
            if (
                weights[0] > 0
                and entry is not None
                and entry.get("uncertaintyType") == "probabilityDistribution"
            ):
                return {
                    "uncertaintyType": "transformedProbabilityDistribution",
                    "distribution": entry,
                    "offset": decimal(constant),
                    "scale": decimal(weights[0]),
                }

        if constant == 0:
            gamma = [
                self._gamma_component(item, weight)
                for item, weight in zip(distributions, weights)
            ]
            if gamma and all(item is not None for item in gamma):
                rates = [item[1] for item in gamma]
                if all(rate == rates[0] for rate in rates[1:]):
                    return _standard("Gamma", {
                        "shape": decimal(sum(item[0] for item in gamma)),
                        "rate": decimal(rates[0]),
                    })

            if all(weight == 1 for weight in weights):
                if distributions and all(item.getClassName() == "Poisson" for item in distributions):
                    return _standard("Poisson", {
                        "rate": decimal(sum(item.getParameter()[0] for item in distributions)),
                    })

                if distributions and all(item.getClassName() == "Polya" for item in distributions):
                    parameters = [item.getParameter() for item in distributions]
                    probabilities = [item[1] for item in parameters]
                    failures = sum(item[0] for item in parameters)
                    if all(value == probabilities[0] for value in probabilities[1:]) and failures == int(failures):
                        return _standard("NegativeBinomial", {
                            "numberOfSuccesses": int(failures),
                            "probability": decimal(probabilities[0]),
                        })

        return None

    def _product_entry(self, distribution):
        distribution = self._unwrap(distribution)
        parameters = self._as_lognormal(distribution)
        if parameters is None:
            return None
        return _standard("Lognormal", {
            "median": decimal(exp(parameters[0])),
            "stdevLog": decimal(parameters[1]),
        })

    def _composite_entry(self, distribution):
        distribution = self._unwrap(distribution)
        formula = self._formula(distribution)
        antecedent = distribution.getAntecedent()

        if self._power(distribution) == 2:
            normal = self._as_normal(antecedent)
            if normal is not None and normal[0] == 0:
                return _standard("Gamma", {
                    "shape": Decimal("0.5"),
                    "rate": Decimal("1") / (Decimal("2") * decimal(normal[1]) ** 2),
                })

        return None

    def _squared_normal_entry(self, distribution):
        mu = float(distribution.getMu())
        if mu != 0:
            return None
        sigma = decimal(distribution.getSigma())
        return _standard("Gamma", {
            "shape": Decimal("0.5"),
            "rate": Decimal("1") / (Decimal("2") * sigma ** 2),
        })

    def _truncated_entry(self, distribution):
        distribution = self._unwrap(distribution)
        entry = self._distribution_entry(distribution.getDistribution())
        if entry is None or entry.get("uncertaintyType") != "probabilityDistribution":
            return None

        bounds = distribution.getBounds()
        result = {
            "uncertaintyType": "truncatedProbabilityDistribution",
            "distribution": entry,
        }
        if bounds.getFiniteLowerBound()[0]:
            result["minimum"] = decimal(bounds.getLowerBound()[0])
        if bounds.getFiniteUpperBound()[0]:
            result["maximum"] = decimal(bounds.getUpperBound()[0])
        return result if "minimum" in result or "maximum" in result else None

    def _mixture_entry(self, distribution):
        distribution = self._unwrap(distribution)
        distributions = [self._unwrap(item) for item in distribution.getDistributionCollection()]
        weights = list(distribution.getWeights())
        entries = [self._distribution_entry(item) for item in distributions]
        if any(entry is None or entry.get("uncertaintyType") != "probabilityDistribution" for entry in entries):
            return None
        return {
            "uncertaintyType": "mixtureProbabilityDistribution",
            "distributions": [
                {"weight": decimal(weight), "distribution": entry}
                for weight, entry in zip(weights, entries)
            ],
        }

    def _user_defined_entry(self, distribution, factor=1, offset=0):
        distribution = self._unwrap(distribution)
        support = distribution.getSupport()
        probabilities = list(distribution.getProbabilities())
        values = [decimal(factor * point[0] + offset) for point in support]
        if not values or len(values) != len(probabilities):
            return None

        equal = all(probability == probabilities[0] for probability in probabilities[1:])
        integers = all(value == value.to_integral_value() for value in values)
        ordered = sorted(int(value) for value in values) if integers else []
        if equal and ordered and ordered == list(range(ordered[0], ordered[-1] + 1)):
            return _standard("DiscreteUniform", {
                "minimum": ordered[0],
                "maximum": ordered[-1],
            })

        if equal and len(values) >= 30:
            return {
                "uncertaintyType": "empirical",
                "values": values,
            }

        return None

    def _affine(self, distribution, factor, offset):
        distribution = self._unwrap(distribution)
        if factor == 1 and offset == 0:
            return distribution
        if factor == 0:
            return None

        parameters = list(distribution.getParameter())
        class_name = distribution.getClassName()

        if class_name == "Normal":
            return ot.Normal(factor * parameters[0] + offset, abs(factor) * parameters[1])
        if class_name == "Uniform":
            bounds = sorted((factor * parameters[0] + offset, factor * parameters[1] + offset))
            return ot.Uniform(*bounds)
        if class_name == "Triangular":
            bounds = sorted((factor * parameters[0] + offset, factor * parameters[2] + offset))
            return ot.Triangular(bounds[0], factor * parameters[1] + offset, bounds[1])
        if class_name == "Logistic":
            return ot.Logistic(factor * parameters[0] + offset, abs(factor) * parameters[1])
        if class_name == "Student":
            return ot.Student(parameters[0], factor * parameters[1] + offset, abs(factor) * parameters[2])
        if class_name == "Laplace":
            return ot.Laplace(factor * parameters[0] + offset, parameters[1] / abs(factor))
        if class_name == "Gumbel" and factor > 0:
            return ot.Gumbel(factor * parameters[0], factor * parameters[1] + offset)
        if class_name == "LogNormal" and factor > 0:
            return ot.LogNormal(parameters[0] + log(factor), parameters[1], factor * parameters[2] + offset)
        if class_name == "Gamma" and factor > 0:
            return ot.Gamma(parameters[0], parameters[1] / factor, factor * parameters[2] + offset)
        if class_name == "Exponential" and factor > 0:
            return ot.Exponential(parameters[0] / factor, factor * parameters[1] + offset)
        if class_name == "Pareto" and factor > 0:
            return ot.Pareto(factor * parameters[0], parameters[1], factor * parameters[2] + offset)
        if class_name == "WeibullMin" and factor > 0:
            return ot.WeibullMin(factor * parameters[0], parameters[1], factor * parameters[2] + offset)
        if class_name == "Beta":
            lower = factor * parameters[2] + offset
            upper = factor * parameters[3] + offset
            if factor > 0:
                return ot.Beta(parameters[0], parameters[1], lower, upper)
            return ot.Beta(parameters[1], parameters[0], upper, lower)
        if class_name == "Bernoulli" and factor == -1 and offset == 1:
            return ot.Bernoulli(1 - parameters[0])
        if class_name == "ChiSquare" and factor > 0 and offset == 0:
            return ot.Gamma(parameters[0] / 2, 0.5 / factor, 0.0)
        if class_name == "Mixture":
            distributions = [self._affine(item, factor, offset) for item in distribution.getDistributionCollection()]
            if all(item is not None for item in distributions):
                return ot.Mixture(distributions, distribution.getWeights())
        if class_name == "TruncatedDistribution":
            antecedent = self._affine(distribution.getDistribution(), factor, offset)
            if antecedent is None:
                return None
            bounds = distribution.getBounds()
            lower = factor * bounds.getLowerBound()[0] + offset
            upper = factor * bounds.getUpperBound()[0] + offset
            finite_lower = bool(bounds.getFiniteLowerBound()[0])
            finite_upper = bool(bounds.getFiniteUpperBound()[0])
            if factor < 0:
                lower, upper = upper, lower
                finite_lower, finite_upper = finite_upper, finite_lower
            return ot.TruncatedDistribution(
                antecedent,
                ot.Interval([lower], [upper], [finite_lower], [finite_upper]),
            )

        return None

    def _gamma_component(self, distribution, weight):
        distribution = self._unwrap(distribution)
        if weight <= 0:
            return None
        parameters = distribution.getParameter()
        class_name = distribution.getClassName()

        if class_name == "Gamma" and parameters[2] == 0:
            return float(parameters[0]), float(parameters[1]) / weight
        if class_name == "Exponential" and parameters[1] == 0:
            return 1.0, float(parameters[0]) / weight
        if class_name == "ChiSquare":
            return float(parameters[0]) / 2, 0.5 / weight
        return None

    @staticmethod
    def _linear_weights(distribution, size):
        weights = distribution.getWeights()
        if weights.getNbRows() == size:
            return [float(weights[index, 0]) for index in range(size)]
        return [float(weights[0, index]) for index in range(size)]

    @staticmethod
    def _formula(distribution):
        try:
            evaluation = distribution.getFunction().getEvaluation()
            formula = str(evaluation.getFormulas()[0]).replace(" ", "").lower()
            names = list(evaluation.getInputVariablesNames())
            return formula.replace(str(names[0]).lower(), "x") if names else formula
        except Exception:
            return None

    def _power(self, distribution):
        formula = self._formula(distribution)

        if formula == "sqrt(x)":
            return 0.5
        if formula in {"1/x", "1.0/x"}:
            return -1.0
        if formula in {"x*x", "x^2", "x^(2)"}:
            return 2.0

        if formula is not None:
            match = re.fullmatch(
                r"x\^\(?([+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?)\)?",
                formula,
            )
            if match is not None:
                return float(match.group(1))

        try:
            function = distribution.getFunction()
            values = [
                float(function([2.0])[0]),
                float(function([4.0])[0]),
            ]

            if np.allclose(values, [0.5, 0.25]):
                return -1.0
            if np.allclose(values, [4.0, 16.0]):
                return 2.0
            if np.allclose(values, [sqrt(2.0), 2.0]):
                return 0.5
        except Exception:
            pass

        return None

    @staticmethod
    def _exponential_base(formula):
        if formula is None:
            return None
        match = re.fullmatch(r"([+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?)\^x", formula)
        return None if match is None else float(match.group(1))

    @staticmethod
    def _array_stats(distribution, *args, **kwargs):
        values = [np.ma.asarray(value, dtype=float) for value in (*args, *kwargs.values())]
        data = np.broadcast_arrays(*(np.ma.getdata(value) for value in values))
        mask = np.logical_or.reduce(np.broadcast_arrays(*(np.ma.getmaskarray(value) for value in values)))
        mean, variance = distribution.stats(*data[:len(args)], **dict(zip(kwargs, data[len(args):])), moments="mv")
        return np.ma.array(mean, mask=mask), np.ma.array(variance, mask=mask)

    def _array_distribution_moments(self, uncertainty):
        name = uncertainty["distributionName"]
        builder = ARRAY_DISTRIBUTIONS.get(name)
        if builder is None:
            raise NotImplementedError(f"Array distribution is not implemented: {name!r}")
        parameters = {key: np.ma.asarray(value, dtype=float) for key, value in uncertainty["parameters"].items()}
        distribution, args, kwargs = builder(parameters)
        return self._array_stats(distribution, *args, **kwargs)

    def array_variance(self, uncertainty):
        data = uncertainty
        uncertainty_type = data["uncertaintyType"]
        if uncertainty_type == "variance":
            return data["variance"]
        if uncertainty_type == "probabilityDistribution":
            return self._array_distribution_moments(data)[1]
        if uncertainty_type == "mixtureProbabilityDistribution":
            mean = second = 0
            for item in data["distributions"]:
                item_mean, item_variance = self._array_distribution_moments(item["distribution"])
                weight = np.ma.asarray(item["weight"], dtype=float)
                mean += weight * item_mean
                second += weight * (item_variance + item_mean ** 2)
            return second - mean ** 2
        if uncertainty_type == "transformedProbabilityDistribution":
            variance = self._array_distribution_moments(data["distribution"])[1]
            scale = np.ma.asarray(data["scale"], dtype=float)
            valid = scale.compressed()
            if np.any(~np.isfinite(valid)) or np.any(valid <= 0):
                raise ValueError("Transformed uncertainty scale must be positive")
            return scale ** 2 * variance
        if uncertainty_type == "empirical":
            return np.ma.var(np.ma.asarray(data["values"], dtype=float), axis=0)
        raise NotImplementedError(f"Array uncertainty is not implemented: {uncertainty_type!r}")

    def _variance(self, quantity, uncertainty):
        variance = self._number(uncertainty["variance"])
        return QuantityWithVariance._from_parts(
            quantity,
            ufloat(float(quantity.magnitude), float(variance.sqrt())),
        )

    def _probability(self, quantity, uncertainty):
        return QuantityWithDistribution._from_parts(
            quantity,
            self._probability_distribution(uncertainty),
        )

    def _truncated(self, quantity, uncertainty):
        distribution = self._probability_distribution(
            uncertainty["distribution"]
        )
        minimum = uncertainty.get("minimum")
        maximum = uncertainty.get("maximum")

        if minimum is not None and maximum is not None:
            distribution = ot.TruncatedDistribution(
                distribution, float(self._number(minimum)), float(self._number(maximum)),
            )
        elif minimum is not None:
            distribution = ot.TruncatedDistribution(
                distribution, float(self._number(minimum)), ot.TruncatedDistribution.LOWER,
            )
        elif maximum is not None:
            distribution = ot.TruncatedDistribution(
                distribution, float(self._number(maximum)), ot.TruncatedDistribution.UPPER,
            )

        return QuantityWithDistribution._from_parts(quantity, distribution)

    def _mixture(self, quantity, uncertainty):
        distribution = ot.Mixture(
            [
                self._probability_distribution(item["distribution"])
                for item in uncertainty["distributions"]
            ],
            [
                float(self._number(item["weight"]))
                for item in uncertainty["distributions"]
            ],
        )
        return QuantityWithDistribution._from_parts(quantity, distribution)

    def _transformed(self, quantity, uncertainty):
        distribution = self._probability_distribution(uncertainty["distribution"])
        scale = self._number(uncertainty["scale"])
        if scale <= 0:
            raise ValueError("Transformed uncertainty scale must be positive")
        distribution = float(scale) * distribution
        offset = self._number(uncertainty["offset"])
        if offset:
            distribution += float(offset)
        return QuantityWithDistribution._from_parts(quantity, distribution)

    def _empirical(self, quantity, uncertainty):
        return self.from_samples(quantity, uncertainty["values"])

    def _probability_distribution(self, uncertainty):
        name = uncertainty["distributionName"]
        parameters = {
            key: self._number(value)
            for key, value in uncertainty["parameters"].items()
        }
        builder = DIRECT_DISTRIBUTIONS.get(name) or INDIRECT_DISTRIBUTIONS.get(name)

        if builder is None:
            code_name = uncertainty.get("probontoId", {}).get("name", "")
            raise NotImplementedError(f"Distribution is not implemented: {name!r} ({code_name})")

        return builder(parameters, uncertainty.get("probontoId", {}).get("name", ""))

    @staticmethod
    def _number(value):
        return decimal(value)


class QuantityFactory:

    def __init__(self, sample_count=1000, seed=None):
        self._units = UnitEngine()
        self._uncertainties = UncertaintyEngine(sample_count, seed)

    def add_unit(self, definition):
        return self._units.add(definition)

    def unit(self, unit_id):
        return self._units.unit(unit_id)

    def is_currency(self, unit_id):
        return self._units.is_currency(unit_id)

    def references(self, unit_id):
        return self._units.references(unit_id)

    def reference_unit(self, unit):
        return self._units.reference_unit(unit)

    def quantity(self, magnitude, unit, uncertainty=None):
        return self._uncertainties.attach(
            Quantity(decimal(magnitude), unit), uncertainty
        )

    def scalar(self, magnitude, unit_id, uncertainty=None):
        return self.quantity(magnitude, self.unit(unit_id), uncertainty)

    def array(self, values, unit_id, kind, context, uncertainty=None):
        values = np.ma.asarray(values)
        variance = None
        if uncertainty is not None:
            variance = np.ma.asarray(
                self._uncertainties.array_variance(uncertainty), dtype=float
            )
            if variance.ndim == 0:
                variance = np.ma.full(values.shape, float(variance))
            elif variance.shape != values.shape:
                variance = np.ma.array(
                    np.broadcast_to(np.ma.getdata(variance), values.shape),
                    mask=np.broadcast_to(np.ma.getmaskarray(variance), values.shape),
                )

            value_mask = np.ma.getmaskarray(values)
            if np.any(~value_mask & np.ma.getmaskarray(variance)):
                raise ValueError("A value participating in the calculation has no variance")
            variance = np.ma.array(np.ma.getdata(variance), mask=value_mask)
            valid = variance.compressed()
            if np.any(~np.isfinite(valid)) or np.any(valid < 0):
                raise ValueError("Array variance must contain finite non-negative values")

        return ArrayQuantity(values, self.unit(unit_id), kind, context, variance)

    def from_ucum(self, magnitude, unit, uncertainty=None):
        return self.quantity(magnitude, self._units.parse(unit), uncertainty)

    def entry_from_ucum(self, magnitude, unit, uncertainty=None):
        unit_id = self._units.unit_id(unit)
        return self.to_entry(self.from_ucum(magnitude, unit, uncertainty), unit_id)

    def unit_id(self, unit):
        return self._units.unit_id(unit)

    def number(self, magnitude):
        return self.quantity(magnitude, self._units.dimensionless)

    def convert(self, quantity, unit_id):
        return quantity.to(self.unit(unit_id))

    def to_entry(self, value, unit_id):
        if not isinstance(value, Quantity):
            if isinstance(value, bool) or not isinstance(value, (Real, Decimal)):
                raise ValueError(f"Quantity formula returned: {type(value).__name__}")
            value = self.number(value)

        value = self.convert(value, unit_id)
        return SingleQuantity(
            amount=decimal(value.magnitude),
            quantityType="singleQuantity",
            unit=unit_id,
            uncertainty=self._uncertainties.to_entry(value),
        )

