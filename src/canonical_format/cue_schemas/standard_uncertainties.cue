@experiment(explicitopen)

package standard_uncertainties

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#ExternalUncertaintyField: // Expects that the uncertainty entry is together in the same file as the original data.
	{rasterBand: utilsPkg.#NonNegativeInt} |
	{dataColumnName: utilsPkg.#NonEmptyString} |
	{dataPath: utilsPkg.#JSONPointer}

#UncertaintyField: number | #ExternalUncertaintyField
#NonNegativeUncertaintyField: utilsPkg.#NonNegativeNumber | #ExternalUncertaintyField
#PositiveUncertaintyField: utilsPkg.#PositiveNumber | #ExternalUncertaintyField
#IntegerUncertaintyField: int | #ExternalUncertaintyField
#PositiveIntUncertaintyField: utilsPkg.#PositiveInt | #ExternalUncertaintyField
#NonNegativeIntUncertaintyField: utilsPkg.#NonNegativeInt | #ExternalUncertaintyField
#OpenUnitIntervalUncertaintyField: utilsPkg.#OpenUnitIntervalNumber | #ExternalUncertaintyField
#AtLeastTwoUncertaintyField: utilsPkg.#NumberAtLeastTwo | #ExternalUncertaintyField

#ProbontoId: {
	uri: utilsPkg.#HTTPURL // ProbOnto distribution parameterization identification. Verification of the name at runtime.
	name: utilsPkg.#NonEmptyString
}

#DistributionName: "Bernoulli" | "Beta" | "Binomial" | "Cauchy" | "ChiSquare" | "DiscreteUniform" | "Exponential" | "F" | "Gamma" | "Geometric" | "Gumbel" | "Hypergeometric" | "Laplace" | "Logistic" | "Lognormal" | "NegativeBinomial" | "Normal" | "Pareto" | "Poisson" | "StudentT" | "Triangular" | "Uniform" | "Weibull"

#StandardDistributionIdentity: utilsPkg.#UncertaintyType... & {
	uncertaintyType: "probabilityDistribution"
	probontoId: #ProbontoId 
	distributionName: #DistributionName
	parameters!: {
		[string]: #UncertaintyField
	}
}

#Bernoulli1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Bernoulli"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000000"
		name: "Bernoulli1"
	}
	parameters: {
		probability: #OpenUnitIntervalUncertaintyField
	}
}

#Bernoulli2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Bernoulli"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000028"
		name: "Bernoulli2"
	}
	parameters: {
		logitProbability: #UncertaintyField
	}
}

#Beta1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Beta"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000057"
		name: "Beta1"
	}
	parameters: {
		alpha: #PositiveUncertaintyField
		beta: #PositiveUncertaintyField
	}
}

#ChiSquared1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "ChiSquare"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0001359"
		name: "ChiSquared1"
	}
	parameters: {
		degreesOfFreedom: #PositiveIntUncertaintyField
	}
}

#UniformDiscrete1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "DiscreteUniform"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000727"
		name: "UniformDiscrete1"
	}
	parameters: {
		minimum: #IntegerUncertaintyField
		maximum: #IntegerUncertaintyField
	}
}

#UniformDiscrete2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "DiscreteUniform"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000750"
		name: "UniformDiscrete2"
	}
	parameters: {
		minimum!: 0
		numberOfValues: #PositiveIntUncertaintyField
	}
}

#Exponential1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Exponential"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000418"
		name: "Exponential1"
	}
	parameters: {
		rate: #PositiveUncertaintyField
	}
}

#Exponential2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Exponential"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000443"
		name: "Exponential2"
	}
	parameters: {
		mean: #PositiveUncertaintyField
	}
}

#F1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "F"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000492"
		name: "F1"
	}
	parameters: {
		numerator: #PositiveUncertaintyField
		denominator: #PositiveUncertaintyField
	}
}

#Gamma1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Gamma"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000571"
		name: "Gamma1"
	}
	parameters: {
		shape: #PositiveUncertaintyField
		scale: #PositiveUncertaintyField
	}
}

#Gamma2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Gamma"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000597"
		name: "Gamma2"
	}
	parameters: {
		shape: #PositiveUncertaintyField
		rate: #PositiveUncertaintyField
	}
}

#Geometric1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Geometric"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000782"
		name: "Geometric1"
	}
	parameters: {
		probability: #OpenUnitIntervalUncertaintyField
	}
}

#Gumbel1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Gumbel"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000032"
		name: "Gumbel1"
	}
	parameters: {
		location: #UncertaintyField
		scale: #PositiveUncertaintyField
	}
}

#Hypergeometric1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Hypergeometric"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000126"
		name: "Hypergeometric1"
	}
	parameters: {
		populationSize: #NonNegativeIntUncertaintyField
		numberOfSuccesses: #NonNegativeIntUncertaintyField
		numberOfTrials: #NonNegativeIntUncertaintyField
	}
}

#Laplace1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Laplace"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000256"
		name: "Laplace1"
	}
	parameters: {
		location: #UncertaintyField
		scale: #PositiveUncertaintyField
	}
}

#Laplace2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Laplace"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000283"
		name: "Laplace2"
	}
	parameters: {
		location: #UncertaintyField
		inverseScale: #PositiveUncertaintyField
	}
}

#Logistic1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Logistic"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000307"
		name: "Logistic1"
	}
	parameters: {
		location: #UncertaintyField
		scale: #PositiveUncertaintyField
	}
}

#Logistic2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Logistic"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000331"
		name: "Logistic2"
	}
	parameters: {
		location: #UncertaintyField
		inverseScale: #PositiveUncertaintyField
	}
}

#LogNormal1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000428"
		name: "LogNormal1"
	}
	parameters: {
		meanLog: #UncertaintyField
		stdevLog: #PositiveUncertaintyField
	}
}

#LogNormal2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000453"
		name: "LogNormal2"
	}
	parameters: {
		meanLog: #UncertaintyField
		varLog: #PositiveUncertaintyField
	}
}

#LogNormal3: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000478"
		name: "LogNormal3"
	}
	parameters: {
		median: #PositiveUncertaintyField
		stdevLog: #PositiveUncertaintyField
	}
}

#LogNormal4: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000500"
		name: "LogNormal4"
	}
	parameters: {
		median: #PositiveUncertaintyField
		coefVar: #PositiveUncertaintyField
	}
}

#LogNormal5: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000526"
		name: "LogNormal5"
	}
	parameters: {
		meanLog: #UncertaintyField
		precision: #PositiveUncertaintyField
	}
}

#LogNormal6: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000553"
		name: "LogNormal6"
	}
	parameters: {
		median: #PositiveUncertaintyField
		geometricStdev: #PositiveUncertaintyField
	}
}

#LogNormal7: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Lognormal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0001028"
		name: "LogNormal7"
	}
	parameters: {
		mean: #PositiveUncertaintyField
		stdev: #PositiveUncertaintyField
	}
}

#NegativeBinomial1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000074"
		name: "NegativeBinomial1"
	}
	parameters: {
		numberOfSuccesses: #PositiveIntUncertaintyField
		probability: #OpenUnitIntervalUncertaintyField
	}
}

#NegativeBinomial2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000105"
		name: "NegativeBinomial2"
	}
	parameters: {
		rate: #PositiveUncertaintyField
		overdispersion: #PositiveUncertaintyField
	}
}

#NegativeBinomial3: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000135"
		name: "NegativeBinomial3"
	}
	parameters: {
		mean: #PositiveUncertaintyField
		index: #PositiveUncertaintyField
	}
}

#NegativeBinomial4: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000161"
		name: "NegativeBinomial4"
	}
	parameters: {
		numberOfFailures: #PositiveIntUncertaintyField
		probability: #OpenUnitIntervalUncertaintyField
	}
}

#NegativeBinomial5: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000190"
		name: "NegativeBinomial5"
	}
	parameters: {
		shape: #PositiveUncertaintyField
		inverseScale: #PositiveUncertaintyField
	}
}

#NegativeBinomial6: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "NegativeBinomial"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000217"
		name: "NegativeBinomial6"
	}
	parameters: {
		logMean: #UncertaintyField
		dispersion: #PositiveUncertaintyField
	}
}

#Normal1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Normal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000239"
		name: "Normal1"
	}
	parameters: {
		mean: #UncertaintyField
		stdev: #PositiveUncertaintyField
	}
}

#Normal2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Normal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000265"
		name: "Normal2"
	}
	parameters: {
		mean: #UncertaintyField
		variance: #PositiveUncertaintyField
	}
}

#Normal3: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Normal"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000290"
		name: "Normal3"
	}
	parameters: {
		mean: #UncertaintyField
		precision: #PositiveUncertaintyField
	}
}

#ParetoTypeI1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Pareto"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000361"
		name: "ParetoTypeI1"
	}
	parameters: {
		scale: #PositiveUncertaintyField
		shape: #PositiveUncertaintyField
	}
}

#ParetoTypeII1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Pareto"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000386"
		name: "ParetoTypeII1"
	}
	parameters: {
		location: #UncertaintyField
		scale: #PositiveUncertaintyField
		tailIndex: #PositiveUncertaintyField
	}
}

#Poisson1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Poisson"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000410"
		name: "Poisson1"
	}
	parameters: {
		rate: #PositiveUncertaintyField
	}
}

#Poisson2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Poisson"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000437"
		name: "Poisson2"
	}
	parameters: {
		logRate: #UncertaintyField
	}
}

#StudentT1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "StudentT"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000613"
		name: "StudentT1"
	}
	parameters: {
		degreesOfFreedom: #PositiveUncertaintyField
	}
}

#StudentT2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "StudentT"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000635"
		name: "StudentT2"
	}
	parameters: {
		mean: #UncertaintyField
		scale: #PositiveUncertaintyField
		degreesOfFreedom: #AtLeastTwoUncertaintyField
	}
}

#StudentT3: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "StudentT"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0001091"
		name: "StudentT3"
	}
	parameters: {
		degreesOfFreedom: #PositiveUncertaintyField
		location: #UncertaintyField
		scale: #PositiveUncertaintyField
	}
}

#Triangular1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Triangular"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000661"
		name: "Triangular1"
	}
	parameters: {
		lowerLimit: #UncertaintyField
		upperLimit: #UncertaintyField
		shape: #UncertaintyField
	}
}

#Uniform1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Uniform"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000703"
		name: "Uniform1"
	}
	parameters: {
		minimum: #UncertaintyField
		maximum: #UncertaintyField
	}
}

#Weibull1: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Weibull"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000800"
		name: "Weibull1"
	}
	parameters: {
		scale: #PositiveUncertaintyField
		shape: #PositiveUncertaintyField
	}
}

#Weibull2: #StandardDistributionIdentity &  utilsPkg.#UncertaintyType... & {
	distributionName: "Weibull"
	probontoId: {
		uri: "http://www.probonto.org/ontology#PROB_k0000022"
		name: "Weibull2"
	}
	parameters: {
		lambda: #PositiveUncertaintyField
		shape: #PositiveUncertaintyField
	}
}

#StandardDistribution:
	#Bernoulli1 |
	#Bernoulli2 |
	#Beta1 |
	#ChiSquared1 |
	#UniformDiscrete1 |
	#UniformDiscrete2 |
	#Exponential1 |
	#Exponential2 |
	#F1 |
	#Gamma1 |
	#Gamma2 |
	#Geometric1 |
	#Gumbel1 |
	#Hypergeometric1 |
	#Laplace1 |
	#Laplace2 |
	#Logistic1 |
	#Logistic2 |
	#LogNormal1 |
	#LogNormal2 |
	#LogNormal3 |
	#LogNormal4 |
	#LogNormal5 |
	#LogNormal6 |
	#LogNormal7 |
	#NegativeBinomial1 |
	#NegativeBinomial2 |
	#NegativeBinomial3 |
	#NegativeBinomial4 |
	#NegativeBinomial5 |
	#NegativeBinomial6 |
	#Normal1 |
	#Normal2 |
	#Normal3 |
	#ParetoTypeI1 |
	#ParetoTypeII1 |
	#Poisson1 |
	#Poisson2 |
	#StudentT1 |
	#StudentT2 |
	#StudentT3 |
	#Triangular1 |
	#Uniform1 |
	#Weibull1 |
	#Weibull2

