@experiment(explicitopen)

package quantities

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import uncertaintyPkg "example.com/lca_format/cue_schemas:uncertainty"
import referencePkg "example.com/lca_format/cue_schemas:references"

// The choice of a quantity set is always passed as a runtime entry and not as a defined variable.
// Quantities are direct values and quantity sets function as a choice-based placeholder for files and a raster or time-series entry for other LCA types.

#LazyQuantity: utilsPkg.#QuantityHolder... & { // When a value comes from a calculation
	quantityType: "lazyQuantity"
}

#ResultingQuantity: utilsPkg.#QuantityHolder... & { // When a value comes from a calculation
	quantityType: "resultingQuantity"
	parameter: referencePkg.#ParameterReference
}

#QuantityBase: utilsPkg.#QuantityHolder... & {
	unit: referencePkg.#UnitReference
	uncertainty?: uncertaintyPkg.#Uncertainty
}

#SingleQuantity: #QuantityBase... & {
	quantityType: "singleQuantity"
	amount: number
}

#FileQuantitySetBase: #QuantityBase... & {
	file: utilsPkg.#RelativeFilePath
}

#RegionalizedQuantitySet: #FileQuantitySetBase... & {
	quantityType: "regionalizedQuantitySet"
	rasterBand: utilsPkg.#NonNegativeInt
}

#CSVQuantityBase: #FileQuantitySetBase... & {
	dataColumnName: utilsPkg.#NonEmptyString
}

#TimeSeriesQuantitySet: #CSVQuantityBase... & {
	quantityType: "timeSeriesQuantitySet"
	timeColumnName: utilsPkg.#NonEmptyString // Timestamp column using ISO 8601.
}

#Quantity:
	#LazyQuantity |
	#ResultingQuantity |
	#SingleQuantity

#NonLazyQuantity:
	#SingleQuantity

#NonLazyQuantitySet:
	#RegionalizedQuantitySet |
	#TimeSeriesQuantitySet

#AnyQuantity:
	#Quantity |
	#NonLazyQuantitySet

#AnyNonLazyQuantity:
	#NonLazyQuantity |
	#NonLazyQuantitySet

