@experiment(explicitopen)

package registry

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import unitPkg "example.com/lca_format/cue_schemas:units"
import asPkg "example.com/lca_format/cue_schemas:actors_and_sources"
import flowPkg "example.com/lca_format/cue_schemas:flows"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"
import paramPkg "example.com/lca_format/cue_schemas:parameterization"
import provenancePkg "example.com/lca_format/cue_schemas:provenance"

#RegistryDataSet: provenancePkg.#WithFileInformation... & {
	id: utilsPkg.#UUID
	datasetType!: "registry"
	actors?: [asPkg.#Actor, ...asPkg.#Actor]
	sources?: [asPkg.#Source, ...asPkg.#Source]
	categories!: [stdCategoryPkg.#BCP47ReferenceSystem, stdCategoryPkg.#UCUMReferenceSystem, ...stdCategoryPkg.#AnyCategoryRegistry]
	flowables: [flowPkg.#Flowable, ...flowPkg.#Flowable]
	properties?: [stdPropertyPkg.#AnyPropertyRegistry, ...stdPropertyPkg.#AnyPropertyRegistry]
	units: [unitPkg.#Unit, ...unitPkg.#Unit]
	tables?: [paramPkg.#Table, ...paramPkg.#Table]
}

