@experiment(explicitopen)

package units

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"
import referencePkg "example.com/lca_format/cue_schemas:references"

#Dimensionality: {
	length?: int
        mass?: int
        time?: int
        electricCurrent?: int
        thermodynamicTemperature?: int
        amountOfSubstance?: int
        luminousIntensity?: int
}

#UnitBase: {
	shortName: utilsPkg.#NonEmptyString // UCUM expression for UCUM units or ISO 4217 code for currencies. Validation at runtime.
}

#ReferenceUnit: #UnitBase... & {
	referenceSystem: referencePkg.#CategoryReference
	referenceUnit: utilsPkg.#NonEmptyString
	conversionFactor: utilsPkg.#PositiveNumber
	conversionOffset?: number
}

#UnitHolder: #UnitBase... & {
	unitType: "physical" | "currency"
	codeSystem: stdCategoryPkg.#UCUMReferenceSystem.id | stdCategoryPkg.#ISO4217ReferenceSystem.id
}

#UCUMUnit: #UnitHolder... & {
	id: utilsPkg.#UUID
	codeSystem: stdCategoryPkg.#UCUMReferenceSystem.id
	unitType: "physical"
	semanticName?: utilsPkg.#NonEmptyString
	dimensionality!: #Dimensionality
	references?: [#ReferenceUnit, ...#ReferenceUnit]
}

#CurrencyUnit: #UnitHolder... & {
	id: utilsPkg.#UUID
	codeSystem: stdCategoryPkg.#ISO4217ReferenceSystem.id
	unitType: "currency"
	year: utilsPkg.#Year
}

#Unit: #UCUMUnit | #CurrencyUnit

