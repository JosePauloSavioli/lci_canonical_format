@experiment(explicitopen)

package parameterization

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import quantityPkg "example.com/lca_format/cue_schemas:quantities"
import categoryPkg "example.com/lca_format/cue_schemas:categories"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import referencePkg "example.com/lca_format/cue_schemas:references"
import provenancePkg "example.com/lca_format/cue_schemas:provenance"
import uncertaintyPkg "example.com/lca_format/cue_schemas:uncertainty"

// Formulas would have a specific grammar syntax that can hold arithmetic, logic and internal functions. Its purpose is actually to produce a set of ordered operations rather than results.

#ParameterBase: referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & referencePkg.#WithCommentSection... & utilsPkg.#ParameterHolder... & {
	id: utilsPkg.#UUID
	resultType: "quantity" | "category" // Verification at runtime.
	name?: utilsPkg.#NonEmptyString
	variableName?: utilsPkg.#NonEmptyString
}

#QuantityInputFromEntry: #ParameterBase... & {
	parameterType: "inputFromEntry"
	resultType: "quantity"
	entryId: referencePkg.#InternalQuantitativeReference
}

#CategoryInputFromEntry: #ParameterBase... & {
	parameterType: "inputFromEntry"
	resultType: "category"
	entryId: referencePkg.#InternalCategoricalReference
}

#SimpleQuantityInput: #ParameterBase... & {
	parameterType: "simpleInput"
	resultType: "quantity"
	entry: quantityPkg.#LazyQuantity | quantityPkg.#NonLazyQuantity
}

#SimpleCategoryInput: #ParameterBase... & {
	parameterType: "simpleInput"
	resultType: "category"
	categorySystem?: referencePkg.#CategoryReference
	entry: categoryPkg.#LazyCategory | categoryPkg.#NonLazyCategory
}

#CSVTable: {
    	id: utilsPkg.#UUID
    	file: utilsPkg.#RelativeFilePath
    	keyColumnName: utilsPkg.#NonEmptyString
}

#JSONTable: {
    	id: utilsPkg.#UUID
    	file: utilsPkg.#RelativeFilePath
}

#Table:
    	#CSVTable |
    	#JSONTable

#ChoiceBase: #ParameterBase... & { // A choice never generates a result, it is only a container of information about a specific tabled entry.
    	parameterType: "choiceInput"
    	table: referencePkg.#TableReference
    	dataPath: utilsPkg.#NonEmptyString // identifies the value field to be retrieved from the selected table record. Column name for CSV and path to the internal table for JSON
}

#QuantitativeChoice: utilsPkg.#ParameterHolder... & #ChoiceBase... & {
    	resultType: "quantity"
    	unit: referencePkg.#UnitReference
    	uncertainty?: uncertaintyPkg.#Uncertainty
}

#CategoricalChoice: utilsPkg.#ParameterHolder... & #ChoiceBase... & {
    	resultType: "category"
	categorySystem?: referencePkg.#CategoryReference
}

#Choice:
    	#QuantitativeChoice |
    	#CategoricalChoice

#QuantitySetInput: #ParameterBase... & {
	parameterType: "quantitySetInput"
	resultType: "quantity"
	entry: quantityPkg.#NonLazyQuantitySet
}

#QuantityFormula: #ParameterBase... & {
	parameterType: "formula"
	resultType: "quantity"
	formula: utilsPkg.#NonEmptyString
	expectedUnit: referencePkg.#UnitReference
	resultingEntry?: quantityPkg.#AnyNonLazyQuantity
}

#CategoryFormula: #ParameterBase... & {
	parameterType: "formula"
	resultType: "category"
	formula: utilsPkg.#NonEmptyString
	resultingEntry?: categoryPkg.#NonLazyCategory
}

#SimpleInputFromEntry:
	#QuantityInputFromEntry |
	#CategoryInputFromEntry

#SimpleInput:
	#SimpleQuantityInput |
	#SimpleCategoryInput

#Formula:
	#QuantityFormula |
	#CategoryFormula

#Parameter:
	#SimpleInputFromEntry |
	#SimpleInput |
	#QuantitySetInput |
	#Formula |
	#Choice

#Model: {
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
	parameters: [#Parameter, ...#Parameter]
}

#Entries: {
	entryId: referencePkg.#InternalReference
	value: quantityPkg.#AnyNonLazyQuantity | categoryPkg.#NonLazyCategory
}

#Scenario: {
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
	values: [#Entries, ...#Entries]
}

#ParameterizationDataSet: referencePkg.#WithSources... & provenancePkg.#WithFileInformation... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	datasetType!: "parameterization"
	registry!: referencePkg.#RegistryFileReference
	scenario?: #Scenario // Only for solved parameterization
	models: [#Model, ...#Model]
}

