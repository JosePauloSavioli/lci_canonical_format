@experiment(explicitopen)

package processes

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import provenancePkg "example.com/lca_format/cue_schemas:provenance"
import referencePkg "example.com/lca_format/cue_schemas:references"
import flowPkg "example.com/lca_format/cue_schemas:flows"

#IncludedProcess: {
	processName: utilsPkg.#NonEmptyString
	description?: utilsPkg.#NonEmptyString
	processReference?: referencePkg.#ProcessReference
}

#ProcessDataSet: referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & provenancePkg.#WithFileInformation... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	datasetType!: "process"
	name: utilsPkg.#NonEmptyString
	registry!: referencePkg.#RegistryFileReference
	aggregatedProcesses?: [#IncludedProcess, ...#IncludedProcess] // For aggregated processes
	exchanges: [flowPkg.#Exchange, ...flowPkg.#Exchange]
}

