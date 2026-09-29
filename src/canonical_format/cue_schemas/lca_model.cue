@if(jsonschema)

package lca_model

import parameterizationPkg "example.com/lca_format/cue_schemas:parameterization"
import processesPkg "example.com/lca_format/cue_schemas:processes"
import productionSystemsPkg "example.com/lca_format/cue_schemas:production_systems"
import projectPkg "example.com/lca_format/cue_schemas:project"
import categorySystemPkg "example.com/lca_format/cue_schemas:category_system"
import registryPkg "example.com/lca_format/cue_schemas:registry"

#AnyDataSet:
	parameterizationPkg.#ParameterizationDataSet |
	processesPkg.#ProcessDataSet |
	productionSystemsPkg.#ProductionSystemDataSet |
	projectPkg.#ProjectDataSet |
	registryPkg.#RegistryDataSet |
	categorySystemPkg.#CategorySystemDataSet

