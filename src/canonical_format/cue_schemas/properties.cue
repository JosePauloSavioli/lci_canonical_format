@experiment(explicitopen)

package properties

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import quantityPkg "example.com/lca_format/cue_schemas:quantities"
import categoryPkg "example.com/lca_format/cue_schemas:categories"
import referencePkg "example.com/lca_format/cue_schemas:references"

// Properties are identifiable placeholders for category and quantity information.

#PropertyBase: referencePkg.#WithSources... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	property: referencePkg.#PropertyReference
}

#PropertyContext: "actor" | "source" | "project" | "exchange" | "flow" | "process" | "processInstance" | "productionSystem" | "parameter"

#PropertyRegistry: {
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
	type: "quantitative" | "categorical" | "composite"
	context?: [#PropertyContext, ...#PropertyContext]
}

#CategoricalProperty: #PropertyBase... & {
	_type: "categorical"
	categorySystem?: referencePkg.#CategoryReference
	value: categoryPkg.#Category
}

#QuantitativeProperty: #PropertyBase... & {
	_type: "quantitative"
	value: quantityPkg.#Quantity
}

// In a way, a composite property can always become a pattern property
#CompositePropertyBase: #PropertyBase... & {
	_type: "composite"
}

#CompositeProperty: #CompositePropertyBase... & {
	properties: [#Property, ...#Property]
}

#Property:
	#CategoricalProperty |
	#QuantitativeProperty |
	#CompositeProperty

