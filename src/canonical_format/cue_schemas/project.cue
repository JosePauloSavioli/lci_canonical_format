@experiment(explicitopen)

package project

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import provenancePkg "example.com/lca_format/cue_schemas:provenance"
import referencePkg "example.com/lca_format/cue_schemas:references"
import rightsPkg "example.com/lca_format/cue_schemas:rights"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"

#HashFileInformation: {
	file: referencePkg.#InternalFileReference
	hashInformation: provenancePkg.#HashInformation
}

#Language: {
	referenceSystem!: stdCategoryPkg.#BCP47ReferenceSystem.id
	value: utilsPkg.#NonEmptyString
}

#ProjectDataSet: provenancePkg.#WithFileInformation... & referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & {
	id: utilsPkg.#UUID
	datasetType!: "project"
	name: utilsPkg.#NonEmptyString
	language: #Language
	registry!: referencePkg.#RegistryFileReference
	commissioners?: [referencePkg.#ActorReference, ...referencePkg.#ActorReference]
	rights!: rightsPkg.#Rights
	modelling: #Modelling
	provenance: provenancePkg.#Provenance
	productionSystems: [referencePkg.#ProductionSystemReference, ...referencePkg.#ProductionSystemReference]
	hashes?: [#HashFileInformation, ...#HashFileInformation]
}

#Modelling: {
	dataHandlingComment?: utilsPkg.#NonEmptyString
	samplingComment: utilsPkg.#NonEmptyString
	extrapolationsComment: utilsPkg.#NonEmptyString
	modellingDocumentation?: [referencePkg.#SourceReference, ...referencePkg.#SourceReference]
}

