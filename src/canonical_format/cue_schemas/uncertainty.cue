@experiment(explicitopen)

package uncertainty

import "list"
import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"
import stdUncertaintyPkg "example.com/lca_format/cue_schemas:standard_uncertainties"

#Variance: utilsPkg.#UncertaintyType... & {
	uncertaintyType: "variance"
	variance: stdUncertaintyPkg.#NonNegativeUncertaintyField
}

#TruncatedDistribution: {
	utilsPkg.#UncertaintyType... & {
		uncertaintyType: "truncatedProbabilityDistribution"
		distribution: stdUncertaintyPkg.#StandardDistribution
		minimum: stdUncertaintyPkg.#UncertaintyField
		maximum?: stdUncertaintyPkg.#UncertaintyField
	} |
	utilsPkg.#UncertaintyType... & {
		uncertaintyType: "truncatedProbabilityDistribution"
		distribution: stdUncertaintyPkg.#StandardDistribution
		minimum?: stdUncertaintyPkg.#UncertaintyField
		maximum: stdUncertaintyPkg.#UncertaintyField
	}
}

#WeightedDistribution: {
	weight: utilsPkg.#PositiveFractionNumber
	distribution: stdUncertaintyPkg.#StandardDistribution
}

#MixtureDistribution: utilsPkg.#UncertaintyType... & { // Only base distributions.
	uncertaintyType: "mixtureProbabilityDistribution"
	distributions: [#WeightedDistribution, #WeightedDistribution, ...#WeightedDistribution]
}

#AffineTransformedDistribution: utilsPkg.#UncertaintyType... & {
    	uncertaintyType: "transformedProbabilityDistribution"
    	distribution: stdUncertaintyPkg.#StandardDistribution
    	offset: stdUncertaintyPkg.#UncertaintyField
    	scale: stdUncertaintyPkg.#PositiveUncertaintyField
}

#Empirical: utilsPkg.#UncertaintyType... & {
	uncertaintyType: "empirical"
	values: [...number] & list.MinItems(30)
}

#Uncertainty:
	#Variance |
	stdUncertaintyPkg.#StandardDistribution |
	#TruncatedDistribution |
	#MixtureDistribution |
	#AffineTransformedDistribution |
	#Empirical

// Covariance has rows as specific ids of identifiable values. It is sparse and incomplete entries have no covariance. Runtime validation is applied.

#MatrixValue: {
	id: referencePkg.#InternalQuantitativeReference
	value: number
}

#MatrixRow: {
	id: referencePkg.#InternalQuantitativeReference
	values: [#MatrixValue, ...#MatrixValue]
}

#CovarianceMatrix: {
	matrix: [#MatrixRow, ...#MatrixRow]
}

