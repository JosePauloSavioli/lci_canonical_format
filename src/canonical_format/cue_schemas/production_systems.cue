@experiment(explicitopen)

package production_systems

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import provenancePkg "example.com/lca_format/cue_schemas:provenance"
import referencePkg "example.com/lca_format/cue_schemas:references"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import categoryPkg "example.com/lca_format/cue_schemas:categories"
import uncertaintyPkg "example.com/lca_format/cue_schemas:uncertainty"

// No cross-process covariance was considered

// Sparse provider-share matrix.
// Needed validation for solvability, background and foreground summing rows to 1 and to see if providers and exchanges exist.
// For L[i, j]:
// 	- 0 means provider j does not supply exchange i;
// 	- 1 means provider j completely supplies exchange i;
// 	- 0 < L[i, j] < 1 means provider j supplies that share of exchange i as part of a provider mix.
// The sum of a row may be less than 1. The remaining share is not linked within the partial foreground and remains available for subsequent background linking.
// Values between 0 and 1 are shares, not inventory amounts. The amount distributed among providers remains defined by the corresponding consumer exchange.

#InternalProviderReference: {
	processId: referencePkg.#ProcessReference
	outputExchangeId: referencePkg.#ExchangeReference
}

#InternalConsumerReference: {
	processId: referencePkg.#ProcessReference
	inputExchangeId: referencePkg.#ExchangeReference
}

#ForegroundPartialLinkingMatrixValue: {
	id: #InternalProviderReference
	value: utilsPkg.#PositiveFractionNumber
}

#ForegroundPartialLinkingMatrixRow: {
	id: #InternalConsumerReference | #InternalProviderReference
	values: [#ForegroundPartialLinkingMatrixValue, ...#ForegroundPartialLinkingMatrixValue]
}

#ForegroundPartialLinking: {
	linking: [#ForegroundPartialLinkingMatrixRow, ...#ForegroundPartialLinkingMatrixRow]
}

#ExternalProviderReference: {
	processRegistry: referencePkg.#CategoryReference
	exchangeRegistry: referencePkg.#CategoryReference
	processId: categoryPkg.#SingleCategory
	exchangeId: categoryPkg.#SingleCategory
	geography?: utilsPkg.#NonEmptyString
	model?: utilsPkg.#NonEmptyString
}

#BackgroundPartialLinkingMatrixValue: {
	id: #ExternalProviderReference
	value: utilsPkg.#PositiveFractionNumber
}

#BackgroundPartialLinkingMatrixRow: {
	id: #InternalConsumerReference | #InternalProviderReference
	values: [#BackgroundPartialLinkingMatrixValue, ...#BackgroundPartialLinkingMatrixValue]
}

#BackgroundPartialLinking: {
	linking: [#BackgroundPartialLinkingMatrixRow, ...#BackgroundPartialLinkingMatrixRow]
}

// Transformation entries can be seen in the library wurst, for example.

#TransformationFamily: // Only a suggestion.
	"changing process values" |
	"cleaning process data" |
	"deriving processes" |
	"constructing markets" |
	"linking processes" |
	"allocating provider shares" |
	"normalizing process metadata" |
	"resolving parameterized values"

#Transformation: {
	reference: referencePkg.#RegistryReference
	name: utilsPkg.#NonEmptyString
	date: utilsPkg.#Date
	description: utilsPkg.#NonEmptyString
}

#TransformationSet: {
	name: utilsPkg.#NonEmptyString
	transformations: [#Transformation, ...#Transformation]
}

#ProcessInstance: stdPropertyPkg.#WithProperties... & {
	id: referencePkg.#ProcessReference
}

#ProductionSystemDataSet: referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & provenancePkg.#WithFileInformation... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	datasetType!: "productionSystem"
	registry!: referencePkg.#RegistryFileReference
	processInstances: [#ProcessInstance, ...#ProcessInstance]
	parameterizations?: [referencePkg.#ParameterSystemReference, ...referencePkg.#ParameterSystemReference]
	linking!: {
		foregroundPartialLinkingMatrix?: #ForegroundPartialLinking
		backgroundPartialLinkingMatrices?: [#BackgroundPartialLinking, ...#BackgroundPartialLinking] // Optional if the system is a complete matrix
	}
	appliedTransformationSets?: [#TransformationSet, ...#TransformationSet]
	covarianceMatrix?: uncertaintyPkg.#CovarianceMatrix
}

