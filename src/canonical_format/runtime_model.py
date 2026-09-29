#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  6 21:10:00 2026

@author: jotape42p
"""

import copy
import hashlib
import json
from datetime import date, datetime, timezone
from decimal import Decimal
from enum import Enum
from graphlib import CycleError, TopologicalSorter
from pathlib import Path
from uuid import UUID, uuid4

from pydantic import BaseModel, TypeAdapter

from .calculation_engines import QuantityFactory
from .runtime_files import RuntimeFiles
from .models.lca import (
    DATASET_MODELS,
    FORMULAS,
    INPUTS,
    QUANTITIES,
    REFERENCES,
    TABLES,
    CategoricalChoice,
    CategorySystemDataSet1,
    CategorySystemDataSet2,
    CategorySystemDataSet3,
    CurrencyUnit,
    Exchange,
    ExtensionCategorySystemFileReference,
    ParameterReference,
    ProductionSystemDataSet,
    ProjectDataSet,
    RegionalizedQuantitySet,
    RegistryReference,
    ResultingCategory,
    ResultingQuantity,
    Scenario,
    SingleCategory,
    Transformation,
    TimeSeriesQuantitySet,
    TransformationSet,
    UCUMUnit,
    QuantitativeChoice,
    SimpleQuantityInput,
)
from .runtime_values import (
    RuntimeFormula,
    RuntimeRasterQuantity,
    RuntimeScalarQuantity,
    RuntimeTimeSeriesQuantity,
    runtime_choice,
    runtime_value,
)


CATEGORY_SYSTEM_DATASETS = (
    CategorySystemDataSet1,
    CategorySystemDataSet2,
    CategorySystemDataSet3,
)
CHOICES = QuantitativeChoice, CategoricalChoice


class Runtime:

    def __init__(self, root, functions=None, sample_count=1000, seed=None):
        self.files = RuntimeFiles(root)
        self.quantities = QuantityFactory(sample_count, seed)
        self.functions = {} if functions is None else dict(functions)


class RuntimeModel:

    def __init__(self, root, runtime):
        self.root = Path(root)
        self.runtime = runtime
        self.datasets = {}
        self.dataset_paths = {}
        self._load_datasets()
        self._index_category_systems()
        self.production_systems = {
            data.id: RuntimeProductionSystem(self, data)
            for data in self.datasets.values()
            if isinstance(data, ProductionSystemDataSet)
        }

    @staticmethod
    def _invalid_constant(value): # Rules out infinity values or NaN values
        raise ValueError(f"Invalid JSON numeric constant: {value}")

    def _load_datasets(self):
        for path in self.root.rglob("*.json"):
            raw = json.loads(
                path.read_text(encoding="utf-8"),
                parse_float=Decimal,
                parse_constant=self._invalid_constant,
            )
            if not isinstance(raw, dict) or "datasetType" not in raw:
                continue

            dataset_type = raw["datasetType"]
            if dataset_type not in DATASET_MODELS:
                raise ValueError(f"Unsupported dataset type {dataset_type!r} in {path.relative_to(self.root)!s}")
            
            data = TypeAdapter(DATASET_MODELS[dataset_type]).validate_python(raw)
            if data.id in self.datasets:
                raise ValueError(f"Repeated dataset id: {data.id!r}")
            
            self.datasets[data.id] = data
            self.dataset_paths[data.id] = path

    @classmethod
    def _walk(cls, value):
        yield value
        if isinstance(value, BaseModel):
            for name in type(value).model_fields:
                item = getattr(value, name)
                if item is not None:
                    yield from cls._walk(item)
        elif isinstance(value, (list, tuple)):
            for item in value:
                yield from cls._walk(item)
        elif isinstance(value, dict):
            for item in value.values():
                yield from cls._walk(item)

    @staticmethod
    def _category_content(value):
        data = value.model_dump(mode="python", exclude_none=True)
        data.pop("datasetType", None)
        return data

    def _add_category_system(self, value):
        identifier = value.id
        self.known_category_systems.add(identifier)
        previous = self.category_systems.get(identifier)
        if (
            previous is not None
            and self._category_content(previous) != self._category_content(value)
        ):
            raise ValueError(f"Conflicting category system: {identifier!r}")
        self.category_systems[identifier] = value
        for component in getattr(value, "components", None) or []:
            self._add_category_system(component)

    @staticmethod
    def _category_entries(value):
        entries = getattr(value, "entries", None)
        if entries is None:
            entries = getattr(value, "children", None)
        for entry in entries or []:
            yield entry
            yield from RuntimeModel._category_entries(entry)

    @staticmethod
    def _category_matches(category, entry):
        return all(
            getattr(category, field, None) is None
            or getattr(category, field, None) == getattr(entry, field, None)
            for field in ("entryId", "code", "label")
        )

    def _validate_category_values(self):
        for dataset_id, data in self.datasets.items():
            for value in self._walk(data):
                if not isinstance(value, BaseModel):
                    continue
                fields = type(value).model_fields
                if "categorySystem" not in fields:
                    continue

                category_system = getattr(value, "categorySystem")
                if category_system is None:
                    continue
                if category_system not in self.known_category_systems:
                    raise KeyError(
                        f"Dataset {dataset_id!r} references an unknown category system: "
                        f"{category_system!r}"
                    )

                category = (
                    getattr(value, "value", None)
                    if "value" in fields
                    else getattr(value, "entry", None)
                )
                if getattr(category, "categoryType", None) != "singleCategory":
                    continue

                system = self.category_systems.get(category_system)
                if (
                    system is not None
                    and system.categorySystemType == "single"
                    and not any(
                        self._category_matches(category, entry)
                        for entry in self._category_entries(system)
                    )
                ):
                    raise ValueError(
                        f"Category {category.label!r} is not present in category system "
                        f"{category_system!r}"
                    )

    def _index_category_systems(self):
        self.category_systems = {}
        self.known_category_systems = set()
        self.category_system_dependencies = {
            dataset_id: set() for dataset_id in self.datasets
        }

        for data in self.datasets.values():
            if isinstance(data, CATEGORY_SYSTEM_DATASETS):
                self.known_category_systems.add(data.id)
                self._add_category_system(data)

        for dataset_id, data in self.datasets.items():
            registry_ref = getattr(data, "registry", None)
            if registry_ref is None:
                continue
            registry = self.datasets.get(registry_ref.fileId)
            for category in getattr(registry, "categories", None) or []:
                identifier = getattr(category, "id", None)
                if identifier is not None:
                    self.known_category_systems.add(identifier)
                if isinstance(category, ExtensionCategorySystemFileReference):
                    target = self.datasets.get(category.fileId)
                    if target is None:
                        raise KeyError(
                            f"Category-system file {category.fileId!r} referenced by "
                            f"{dataset_id!r} was not found"
                        )
                    if not isinstance(target, CATEGORY_SYSTEM_DATASETS):
                        raise TypeError(
                            f"Category-system reference {category.fileId!r} points to "
                            f"{type(target).__name__}"
                        )
                    self.known_category_systems.add(category.fileId)
                    self.category_system_dependencies[dataset_id].add(category.fileId)
                elif hasattr(category, "categorySystemType"):
                    self._add_category_system(category)

        registered_units = set()
        for dataset_id, data in self.datasets.items():
            registry_ref = getattr(data, "registry", None)
            if registry_ref is None:
                continue
            registry = self.datasets.get(registry_ref.fileId)
            for unit in getattr(registry, "units", None) or []:
                if unit.id not in registered_units:
                    self.runtime.quantities.add_unit(unit)
                    registered_units.add(unit.id)
                for reference in getattr(unit, "references", None) or []:
                    if reference.referenceSystem not in self.known_category_systems:
                        raise KeyError(
                            f"Unit {unit.id!r} in {dataset_id!r} references an unknown "
                            f"unit system: {reference.referenceSystem!r}"
                        )

        self._validate_category_values()


    def context(self, production_system_id, scenario=None, changes=None):
        return RuntimeContext(self.production_systems[production_system_id], scenario, changes)

    @staticmethod
    def _dump_json(value):
        marker = f"__decimal_{uuid4().hex}_"
        decimals = []
        def default(item):
            if isinstance(item, Decimal):
                if not item.is_finite():
                    raise ValueError(f"Non-finite Decimal cannot be written to JSON: {item}")
                token = f"{marker}{len(decimals)}__"
                decimals.append((json.dumps(token), str(item)))
                return token
            if isinstance(item, BaseModel):
                return item.model_dump(mode="python", by_alias=True, exclude_none=True)
            if isinstance(item, Enum):
                return item.value
            if isinstance(item, UUID):
                return str(item)
            if isinstance(item, (date, datetime)):
                return item.isoformat()
            if isinstance(item, Path):
                return str(item)
            raise TypeError(f"Object of type {type(item).__name__} is not JSON serializable")

        text = json.dumps(value, default=default, allow_nan=False, indent=2, ensure_ascii=False)
        for token, number in decimals:
            if text.count(token) != 1:
                raise ValueError("Decimal serialization marker collision")
            text = text.replace(token, number)
        return text

    def _write_dataset(self, dataset_id, data):
        validated = type(data).model_validate(
            data.model_dump(exclude_none=True, by_alias=True, serialize_as_any=True)
        )
        text = self._dump_json(
            validated.model_dump(
                mode="python", exclude_none=True, by_alias=True, serialize_as_any=True
            )
        )
        self.dataset_paths[dataset_id].write_text(f"{text}\n", encoding="utf-8")

    def _refresh_project_hashes(self, project_id, data, datasets):
        for item in data.hashes or []:
            hash_value = item.hashInformation.hash
            algorithm = hash_value.algorithm
            if algorithm.typeSystem != "standard" or algorithm.value != "SHA-256":
                continue

            file_id = item.file.fileId
            if file_id == project_id:
                raise ValueError(f"Project {project_id!r} cannot contain a hash of itself")
            path = self.dataset_paths.get(file_id)
            if path is None:
                raise KeyError(f"File {file_id!r} hashed by project {project_id!r} was not found")

            referenced = datasets[file_id] if file_id in datasets else self.datasets[file_id]
            file_information = getattr(referenced, "fileInformation", None)
            if file_information is not None:
                item.file.version = file_information.versioning.datasetVersion
            hash_value.checksum = hashlib.sha256(path.read_bytes()).hexdigest()

    @staticmethod
    def _content(data):
        value = data.model_dump(
            mode="python",
            exclude_none=True,
            by_alias=True,
            serialize_as_any=True,
        )
        if "fileInformation" not in value:
            return value
        info = value["fileInformation"]
        info["timestamp"].pop("lastEdit", None)
        info["versioning"].pop("datasetVersion", None)
        return value

    def _changed(self, dataset_id, data):
        return self._content(data) != self._content(self.datasets[dataset_id])

    @staticmethod
    def _touch(data):
        info = getattr(data, "fileInformation", None)
        if info is None:
            return
        info.timestamp.lastEdit = datetime.now(timezone.utc)
        major, minor, patch = map(int, info.versioning.datasetVersion.split("."))
        info.versioning.datasetVersion = f"{major}.{minor}.{patch + 1}"

    def dump(self, context):
        changed = set()

        for dataset_id, data in context.datasets.items():
            if isinstance(data, (ProductionSystemDataSet, ProjectDataSet)):
                continue
            if self._changed(dataset_id, data):
                self._touch(data)
                changed.add(dataset_id)

        context.system._add_transformations(context)

        system = context.datasets[context.system.id]
        if self._changed(context.system.id, system):
            self._touch(system)
            changed.add(context.system.id)

        for dataset_id in changed:
            self._write_dataset(dataset_id, context.datasets[dataset_id])

        for project_id, data in context.datasets.items():
            if not isinstance(data, ProjectDataSet):
                continue
            project = copy.deepcopy(data)
            self._refresh_project_hashes(project_id, project, context.datasets)
            source = self.datasets[project_id]
            if self._content(project) != self._content(source):
                self._touch(project)
                self._write_dataset(project_id, project)

        return context


class RuntimeProductionSystem:

    def __init__(self, model, source):
        self.model = model
        self.runtime = model.runtime
        self.source = source
        self.id = source.id
        process_ids = [instance.id.fileId for instance in source.processInstances]
        parameterization_ids = [
            reference.fileId for reference in source.parameterizations or []
        ]
        project_ids = [
            data.id
            for data in model.datasets.values()
            if isinstance(data, ProjectDataSet)
            and any(
                reference.fileId == source.id
                for reference in data.productionSystems or []
            )
        ]

        dataset_ids = set([source.id, *process_ids, *parameterization_ids, *project_ids])
        pending = list(dataset_ids)
        while pending:
            dataset_id = pending.pop()
            data = model.datasets[dataset_id]

            registry = getattr(data, "registry", None)
            dependencies = []
            if registry is not None:
                dependencies.append(registry.fileId)
            dependencies.extend(model.category_system_dependencies[dataset_id])

            for dependency_id in dependencies:
                if dependency_id not in model.datasets:
                    raise KeyError(
                        f"Dataset {dataset_id!r} references missing dependency "
                        f"{dependency_id!r}"
                    )
                if dependency_id not in dataset_ids:
                    dataset_ids.add(dependency_id)
                    pending.append(dependency_id)

        ordered_ids = [
            dataset_id for dataset_id in model.datasets
            if dataset_id in dataset_ids
        ]
        self.datasets = {
            dataset_id: model.datasets[dataset_id] for dataset_id in ordered_ids
        }
        self.output_dataset_ids = tuple(ordered_ids)
        self._index()
        self._build()
        self._compile_dependencies()


    def walk(self, value, path=()):
        yield path, value

        if isinstance(value, BaseModel):
            for name in type(value).model_fields:
                item = getattr(value, name)
                if item is not None:
                    yield from self.walk(item, path + (name,))
        elif isinstance(value, (list, tuple)):
            for index, item in enumerate(value):
                yield from self.walk(item, path + (index,))
        elif isinstance(value, dict):
            for name, item in value.items():
                yield from self.walk(item, path + (name,))

    def events(self):
        for dataset_id, data in self.datasets.items():
            for event in self.walk(data):
                yield dataset_id, *event


    @staticmethod
    def at(datasets, path):
        dataset_id, *parts = path
        value = datasets[dataset_id]
        for part in parts:
            value = getattr(value, part) if isinstance(value, BaseModel) else value[part]
        return value

    @staticmethod
    def replace(parent, field, value):
        if isinstance(parent, BaseModel):
            setattr(parent, field, value)
        else:
            parent[field] = value

    @staticmethod
    def parameter_key(reference):
        return reference.fileId, reference.parameterId

    @staticmethod
    def reference_key(reference):
        return (
            reference.targetType,
            reference.fileId,
            getattr(reference, f"{reference.targetType}Id"),
        )


    def _index_target(self, dataset_id, path, value):
        if isinstance(value, Exchange):
            target_type, target_id, field = "exchange", value.id, "quantity"
        elif isinstance(value, INPUTS) and hasattr(value, "entry"):
            target_type, target_id, field = "parameter", value.id, "entry"
        elif isinstance(value, BaseModel) and {"id", "property", "value"} <= type(value).model_fields.keys():
            target_type, target_id, field = "property", value.id, "value"
        else:
            return

        key = target_type, dataset_id, target_id
        if key in self.target_paths:
            raise ValueError(f"Repeated reference target: {key!r}")
        self.target_paths[key] = (dataset_id, *path), field
        
        target_id = str(target_id)
        if target_id in self.target_ids and self.target_ids[target_id] != key:
            raise ValueError(f"Repeated target id: {target_id!r}")
        self.target_ids[target_id] = key

    def _index(self):
        self.events_index = []
        self.parameters = {}
        self.parameter_paths = {}
        self.parameter_variables = {}
        self.target_paths = {}
        self.target_ids = {}
        self.choice_ids = {}
        self.table_paths = {}

        for reference in self.source.parameterizations or []:
            dataset_id = reference.fileId
            parameterization = self.datasets[dataset_id]
            for model_index, model in enumerate(parameterization.models):
                variables = {}
                for parameter_index, parameter in enumerate(model.parameters):
                    key = dataset_id, parameter.id
                    self.parameters[key] = parameter
                    self.parameter_paths[key] = (
                        dataset_id, "models", model_index, "parameters", parameter_index,
                    )
                    self.parameter_variables[key] = variables
                    if isinstance(parameter, CHOICES):
                        parameter_id = str(parameter.id)
                        if parameter_id in self.choice_ids:
                            raise ValueError(f"Repeated choice parameter id: {parameter_id!r}")
                        self.choice_ids[parameter_id] = key
                    if parameter.variableName is not None:
                        variables[parameter.variableName] = key

        for dataset_id, path, value in self.events():
            full_path = (dataset_id, *path)
            if isinstance(value, (UCUMUnit, CurrencyUnit)):
                self.runtime.quantities.add_unit(value)
            self._index_target(dataset_id, path, value)

            if isinstance(value, TABLES):
                key = dataset_id, value.id
                if key in self.table_paths:
                    raise ValueError(f"Repeated table id: {key!r}")
                self.table_paths[key] = full_path

            if isinstance(value, QUANTITIES + TABLES + FORMULAS + REFERENCES):
                self.events_index.append((dataset_id, path, value))

        repeated = self.choice_ids.keys() & self.target_ids.keys()
        if repeated:
            raise ValueError(f"Choice parameter ids conflict with targets: {sorted(repeated)!r}")


    def _build_formula(self, dataset_id, parameter):
        key = dataset_id, parameter.id
        formula = RuntimeFormula(parameter, self.runtime, self.parameter_variables[key])
        self.formulas[key] = formula
        self.dependencies[key].update(formula.dependencies)

    def _build_reference(self, dataset_id, parameter):
        key = dataset_id, parameter.id
        reference = parameter.entryId
        if isinstance(reference, ParameterReference):
            self.dependencies[key].add(self.parameter_key(reference))
            return

        path, field = self.target_paths[self.reference_key(reference)]
        entry = getattr(self.at(self.datasets, path), field)
        if isinstance(entry, (ResultingQuantity, ResultingCategory)):
            self.dependencies[key].add(self.parameter_key(entry.parameter))

    def _build_value(self, dataset_id, path, entry, runtime_values):
        key = id(entry)
        if key not in runtime_values:
            runtime_values[key] = runtime_value(self.runtime, entry)
        self.runtime_by_path[(dataset_id, *path)] = runtime_values[key]

    def _build(self):
        self.formulas = {}
        self.dependencies = {key: set() for key in self.parameters}
        self.runtime_by_path = {}
        runtime_values = {}

        for dataset_id, path, value in self.events_index:
            if isinstance(value, FORMULAS):
                self._build_formula(dataset_id, value)
            elif isinstance(value, REFERENCES):
                self._build_reference(dataset_id, value)

            if isinstance(value, QUANTITIES + TABLES):
                self._build_value(dataset_id, path, value, runtime_values)

        self.tables = {
            key: self.runtime_by_path[path]
            for key, path in self.table_paths.items()
        }
        for key, parameter in self.parameters.items():
            if isinstance(parameter, CHOICES) and (key[0], parameter.table) not in self.tables:
                raise KeyError(
                    f"Choice parameter {key!r} references an unknown table: "
                    f"{parameter.table!r}"
                )

        del self.events_index


    def _compile_dependencies(self):
        for key, values in self.dependencies.items():
            missing = values - self.parameters.keys()
            if missing:
                raise KeyError(f"Parameter {key!r} depends on missing parameters: {sorted(missing)!r}")

        try:
            self.parameter_order = tuple(TopologicalSorter(self.dependencies).static_order())
        except CycleError as error:
            raise ValueError(f"Circular parameter dependency: {error.args[1]!r}") from error
        self.dependencies = {key: frozenset(values) for key, values in self.dependencies.items()}


    def _transformation(self, context, parameterization_id):
        parameterization = context.datasets[parameterization_id]
        return Transformation(
            reference=RegistryReference(
                referenceType="registry",
                id=parameterization_id,
                uri=parameterization.fileInformation.downloadableURI,
                name=self.model.dataset_paths[parameterization_id].stem,
                version=parameterization.fileInformation.versioning.datasetVersion,
            ),
            date=date.today(),
            name="resolving parameterized values",
            description="Resolved formula parameters and propagated resulting quantities and categories.",
        )

    def _add_transformations(self, context):
        data = context.datasets[self.id]
        transformations = [
            self._transformation(context, reference.fileId)
            for reference in data.parameterizations or []
        ]
        if not transformations:
            return
        transformation_sets = [
            item
            for item in data.appliedTransformationSets or []
            if item.name != "Parameterization solving"
        ]
        transformation_sets.append(
            TransformationSet(
                name="Parameterization solving",
                transformations=transformations,
            )
        )
        data.appliedTransformationSets = transformation_sets


class RuntimeContext:

    def __init__(self, system, scenario=None, changes=None):
        self.system = system
        self.datasets = copy.deepcopy(system.datasets)
        self.scenario = (
            None
            if scenario is None
            else copy.deepcopy(
                scenario if isinstance(scenario, Scenario) else Scenario.model_validate(scenario)
            )
        )
        self.scenario_parameterization_id = None
        self.changes = {} if changes is None else dict(changes)
        self.choice_values = {
            system.choice_ids[str(target_id)]: change
            for target_id, change in self.changes.items()
            if str(target_id) in system.choice_ids
        }
        self.entry_changes = {
            target_id: change
            for target_id, change in self.changes.items()
            if str(target_id) not in system.choice_ids
        }
        self.results = {}
        self.solving = set()
        self.parameters = {
            key: system.at(self.datasets, path)
            for key, path in system.parameter_paths.items()
        }
        self.targets = {
            key: (system.at(self.datasets, path), field)
            for key, (path, field) in system.target_paths.items()
        }
        self.runtime_entries = {
            id(system.at(self.datasets, path)): value
            for path, value in system.runtime_by_path.items()
        }
        self._apply_scenario()
        self._apply_changes()

    def runtime(self, entry):
        return self.runtime_entries[id(entry)]

    def _apply_scenario(self):
        if self.scenario is None:
            return

        parameterizations = self.system.source.parameterizations or []
        if len(parameterizations) != 1:
            raise ValueError(
                "A scenario input requires exactly one parameterization in the production system"
            )
        self.scenario_parameterization_id = parameterizations[0].fileId

        for item in self.scenario.values:
            reference = item.entryId
            key = self.system.reference_key(reference)
            try:
                target, field = self.targets[key]
            except KeyError as error:
                raise KeyError(f"Scenario target not found: {key!r}") from error

            replacement = copy.deepcopy(item.value)
            setattr(target, field, replacement)

            if isinstance(replacement, QUANTITIES + TABLES):
                self.runtime_entries[id(replacement)] = runtime_value(
                    self.system.runtime, replacement
                )

    def _apply_changes(self):
        for target_id, change in self.entry_changes.items():
            try:
                key = self.system.target_ids[str(target_id)]
            except KeyError as error:
                raise KeyError(f"Runtime change target not found: {target_id}") from error

            if not isinstance(change, (tuple, list)) or len(change) != 3:
                raise TypeError("Runtime changes must be (number, UCUM unit, uncertainty) tuples")

            target, field = self.targets[key]
            entry = getattr(target, field)
            if not hasattr(entry, "quantityType"):
                raise TypeError(f"Runtime quantity change cannot replace {type(entry).__name__}")

            magnitude, unit, uncertainty = change
            replacement = self.system.runtime.quantities.entry_from_ucum(magnitude, unit, uncertainty)
            self.runtime_entries[id(replacement)] = runtime_value(self.system.runtime, replacement)
            setattr(target, field, replacement)

    def resolve_entry(self, entry):
        if isinstance(entry, (ResultingQuantity, ResultingCategory)):
            return self.resolve_parameter(self.system.parameter_key(entry.parameter))
        if (
            getattr(entry, "quantityType", None) == "lazyQuantity"
            or getattr(entry, "categoryType", None) == "lazyCategory"
        ):
            raise ValueError("Lazy input requires a scenario value")
        if isinstance(entry, QUANTITIES + TABLES):
            return self.runtime(entry)
        if getattr(entry, "categoryType", None) == "singleCategory":
            return entry.label
        return entry

    def _resolve_choice(self, key, parameter):
        if key not in self.choice_values:
            raise ValueError(
                f"Choice parameter {key!r} requires a runtime selection"
            )
        table = self.system.tables[key[0], parameter.table]
        return runtime_choice(
            self.system.runtime,
            parameter,
            table,
            self.choice_values[key],
        )

    def resolve_reference(self, reference):
        if isinstance(reference, ParameterReference):
            return self.resolve_parameter(self.system.parameter_key(reference))

        target, field = self.targets[self.system.reference_key(reference)]
        return self.resolve_entry(getattr(target, field))

    def resolve_parameter(self, key):
        if key in self.results:
            return self.results[key]
        if key in self.solving:
            raise ValueError(f"Circular parameter dependency: {key}")

        parameter = self.parameters[key]
        self.solving.add(key)
        try:
            if isinstance(parameter, FORMULAS):
                formula = self.system.formulas[key]
                result, parameter.resultingEntry = formula.solve(self.resolve_parameter)
            elif isinstance(parameter, REFERENCES):
                result = self.resolve_reference(parameter.entryId)
            elif isinstance(parameter, CHOICES):
                result = self._resolve_choice(key, parameter)
            else:
                result = self.resolve_entry(parameter.entry)

            self.results[key] = result
            return result
        finally:
            self.solving.discard(key)

    def solve_all(self):
        for key in self.system.parameter_order:
            self.resolve_parameter(key)
        if self.scenario is not None:
            self.datasets[self.scenario_parameterization_id].scenario = copy.deepcopy(
                self.scenario
            )
        return self

    def _parameter_entry(self, key):
        parameter = self.parameters[key]
        entry = getattr(parameter, "resultingEntry", None) or getattr(parameter, "entry", None)
        if entry is not None:
            return entry
        if isinstance(parameter, QuantitativeChoice):
            return parameter
        if isinstance(parameter, CategoricalChoice):
            return SingleCategory(
                categoryType="singleCategory", label=self.results[key],
            )
        reference = parameter.entryId
        if isinstance(reference, ParameterReference):
            return self._parameter_entry(self.system.parameter_key(reference))
        target, field = self.targets[self.system.reference_key(reference)]
        entry = getattr(target, field)
        return (
            self._parameter_entry(self.system.parameter_key(entry.parameter))
            if isinstance(entry, (ResultingQuantity, ResultingCategory))
            else entry
        )

    def _resolved_quantities(self):
        formula_results = {
            (*path, "resultingEntry"): key
            for key, path in self.system.parameter_paths.items()
            if isinstance(self.parameters[key], FORMULAS)
        }

        for dataset_id in self.system.output_dataset_ids:
            for path, entry in self.system.walk(self.datasets[dataset_id]):
                if isinstance(entry, (RegionalizedQuantitySet, TimeSeriesQuantitySet)):
                    full_path = (dataset_id, *path)
                    key = formula_results.get(full_path)
                    if key is not None:
                        value = self.results[key]
                    else:
                        try:
                            value = self.runtime(entry)
                        except KeyError:
                            value = runtime_value(self.system.runtime, entry)
                    yield dataset_id, path, entry, value
                elif isinstance(entry, ResultingQuantity):
                    key = self.system.parameter_key(entry.parameter)
                    yield dataset_id, path, self._parameter_entry(key), self.results[key]

    def _resolved_categories(self):
        for dataset_id in self.system.output_dataset_ids:
            for path, entry in self.system.walk(self.datasets[dataset_id]):
                if isinstance(entry, ResultingCategory):
                    key = self.system.parameter_key(entry.parameter)
                    yield dataset_id, path, self._parameter_entry(key)

    @staticmethod
    def _periods(values, step, start=None, end=None):
        series = [value for value in values if isinstance(value, RuntimeTimeSeriesQuantity)]
        if not series:
            return (None,)
        if step is None:
            raise ValueError("time_step is required to resolve time-series quantities")

        periods = [value.periods(step, start, end) for value in series]
        common = set(periods[0]).intersection(*periods[1:])
        result = tuple(period for period in periods[0] if period in common)
        if not result:
            raise ValueError("Time-series quantities have no common periods")
        return result

    def _zones(self, values, vector, field=None):
        if not any(isinstance(value, RuntimeRasterQuantity) for value in values):
            return (None,)
        if vector is None:
            raise ValueError("vector is required to resolve raster quantities")

        zones = []
        labels = set()
        with self.system.runtime.files.open_vector(vector) as source:
            for index, feature in enumerate(source):
                if feature["geometry"] is None:
                    continue
                label = str(index if field is None else feature["properties"][field])
                if label in labels:
                    raise ValueError(f"Repeated vector zone label: {label!r}")
                labels.add(label)
                zones.append((index, label))
        if not zones:
            raise ValueError("The geometry file contains no geometries")
        return tuple(zones)

    def expand(
            self, time_step=None, vector=None, zone_field=None, statistic="mean", start=None, end=None
        ):
        if self.results.keys() != self.parameters.keys():
            raise ValueError("Context must be fully solved before expansion")
        values = [value for *_, value in self._resolved_quantities()]
        periods = self._periods(values, time_step, start, end)
        zones = self._zones(values, vector, zone_field)
        return [
            RuntimeResolvedContext(
                self, time_step, period, vector, zone, statistic, start, end
            )
            for period in periods
            for zone in zones
        ]

    def dump(self):
        return self.system.model.dump(self)

class RuntimeResolvedContext:

    def __init__(
        self, context, time_step=None, period=None, vector=None, zone=None, statistic="mean", start=None, end=None,
    ):
        self.context = context
        self.time_step = time_step
        self.period = period
        self.vector = vector
        self.zone = zone
        self.statistic = statistic
        self.start = start
        self.end = end

        self.datasets = {
            dataset_id: copy.deepcopy(context.datasets[dataset_id])
            for dataset_id in context.system.output_dataset_ids
        }
        self._resolve()
        self._prepare_projects()

    @property
    def zone_index(self):
        return None if self.zone is None else self.zone[0]

    @property
    def zone_label(self):
        return None if self.zone is None else self.zone[1]

    @property
    def key(self):
        return self.period, self.zone_label

    def _single(self, entry, value):
        unit = entry.unit
        if isinstance(value, RuntimeTimeSeriesQuantity):
            if self.period is None:
                raise ValueError("Time period is required for a time-series quantity")
            value = value.mean_period(self.time_step, self.period, self.start, self.end)
        elif isinstance(value, RuntimeRasterQuantity):
            if self.zone is None:
                raise ValueError("Spatial zone is required for a raster quantity")
            value = value.zonal(self.vector, self.statistic, feature_index=self.zone_index)
            if self.statistic == "count":
                unit = self.context.system.runtime.quantities.unit_id("1")

        if not isinstance(value, RuntimeScalarQuantity):
            raise TypeError(f"Context resolution returned {type(value).__name__}")
        return value.result(unit)

    def _resolve(self):
        quantity_set_input_paths = {
            (*parameter_path, "entry"): key
            for key, parameter_path in self.context.system.parameter_paths.items()
            if getattr(self.context.parameters[key], "parameterType", None) == "quantitySetInput"
        }

        for dataset_id, path, entry, value in self.context._resolved_quantities():
            single = self._single(entry, value)
            full_path = (dataset_id, *path)
            parameter_key = quantity_set_input_paths.get(full_path)

            if parameter_key is not None:
                parameter_path = self.context.system.parameter_paths[parameter_key]
                parameter = self.context.system.at(self.datasets, parameter_path)
                data = parameter.model_dump(
                    mode="python",
                    exclude_none=True,
                    by_alias=True,
                    serialize_as_any=True,
                )
                data["parameterType"] = "simpleInput"
                data["entry"] = single.model_dump(
                    mode="python",
                    exclude_none=True,
                    by_alias=True,
                    serialize_as_any=True,
                )
                replacement = SimpleQuantityInput.model_validate(data)
                parent = self.context.system.at(self.datasets, parameter_path[:-1])
                self.context.system.replace(parent, parameter_path[-1], replacement)
                continue

            parent = self.context.system.at(self.datasets, (dataset_id, *path[:-1]))
            self.context.system.replace(parent, path[-1], single)

        for dataset_id, path, entry in self.context._resolved_categories():
            parent = self.context.system.at(self.datasets, (dataset_id, *path[:-1]))
            self.context.system.replace(parent, path[-1], copy.deepcopy(entry))

        for dataset_id, data in tuple(self.datasets.items()):
            self.datasets[dataset_id] = type(data).model_validate(
                data.model_dump(exclude_none=True, by_alias=True, serialize_as_any=True)
            )

    def _prepare_projects(self):
        included = set(self.datasets)
        system_id = self.context.system.id

        for dataset_id, data in tuple(self.datasets.items()):
            if not isinstance(data, ProjectDataSet):
                continue

            project = copy.deepcopy(data)
            project.productionSystems = [
                reference
                for reference in project.productionSystems
                if reference.fileId == system_id
            ]
            project.hashes = [
                item
                for item in project.hashes or []
                if item.file.fileId in included and item.file.fileId != dataset_id
            ] or None
            self.datasets[dataset_id] = type(project).model_validate(
                project.model_dump(
                    exclude_none=True,
                    by_alias=True,
                    serialize_as_any=True,
                )
            )

    @staticmethod
    def _file_references(value):
        if isinstance(value, BaseModel):
            for name in type(value).model_fields:
                item = getattr(value, name)
                if item is None:
                    continue
                if name == "file" and isinstance(item, (str, Path)):
                    yield Path(item)
                else:
                    yield from RuntimeResolvedContext._file_references(item)
        elif isinstance(value, (list, tuple)):
            for item in value:
                yield from RuntimeResolvedContext._file_references(item)
        elif isinstance(value, dict):
            for name, item in value.items():
                if name == "file" and isinstance(item, (str, Path)):
                    yield Path(item)
                else:
                    yield from RuntimeResolvedContext._file_references(item)

    def _dataset_target(self, root, dataset_id):
        source = self.context.system.model.dataset_paths[dataset_id]
        return root / source.relative_to(self.context.system.model.root)

    @staticmethod
    def _write_dataset(path, data):
        path.parent.mkdir(parents=True, exist_ok=True)
        text = RuntimeModel._dump_json(
            data.model_dump(
                mode="python",
                exclude_none=True,
                by_alias=True,
                serialize_as_any=True,
            )
        )
        path.write_text(f"{text}\n", encoding="utf-8")

    def _copy_referenced_files(self, root):
        model_root = self.context.system.model.root
        copied = set()
        for data in self.datasets.values():
            for reference in self._file_references(data):
                if reference.is_absolute() or reference in copied:
                    continue
                source = model_root / reference
                if not source.is_file():
                    continue
                target = root / reference
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(source.read_bytes())
                copied.add(reference)

    def _refresh_project_hashes(self, root):
        for project_id, project in tuple(self.datasets.items()):
            if not isinstance(project, ProjectDataSet):
                continue

            for item in project.hashes or []:
                file_id = item.file.fileId
                target = self._dataset_target(root, file_id)
                if not target.is_file():
                    raise FileNotFoundError(
                        f"Project {project_id!r} hashes missing dataset {file_id!r}: {target}"
                    )

                referenced = self.datasets[file_id]
                file_information = getattr(referenced, "fileInformation", None)
                if file_information is not None:
                    item.file.version = file_information.versioning.datasetVersion
                item.hashInformation.hash.checksum = hashlib.sha256(
                    target.read_bytes()
                ).hexdigest()

            self.datasets[project_id] = type(project).model_validate(
                project.model_dump(
                    exclude_none=True,
                    by_alias=True,
                    serialize_as_any=True,
                )
            )

    def dump(self, root):
        root = Path(root)
        root.mkdir(parents=True, exist_ok=True)

        for dataset_id, data in self.datasets.items():
            if isinstance(data, ProjectDataSet):
                continue
            self._write_dataset(self._dataset_target(root, dataset_id), data)

        self._copy_referenced_files(root)
        self._refresh_project_hashes(root)

        for dataset_id, data in self.datasets.items():
            if isinstance(data, ProjectDataSet):
                self._write_dataset(self._dataset_target(root, dataset_id), data)

        return self
