@experiment(explicitopen)

package categories

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"

#SingleCategoryEntry: {
	entryId?: utilsPkg.#UUID // canonical/source identity of the represented category entry
	code?: utilsPkg.#NonEmptyString // identifier within the category system
	label: utilsPkg.#NonEmptyString | bool // human-readable value
}

#LazyCategory: utilsPkg.#CategoryHolder... & { // When a value has to be passed as input
	categoryType: "lazyCategory"
}

#ResultingCategory: utilsPkg.#CategoryHolder... & { // When a value comes from a calculation
	categoryType: "resultingCategory"
	parameter: referencePkg.#ParameterReference
}

#SingleCategory: #SingleCategoryEntry... & utilsPkg.#CategoryHolder... & { // Flattened. Got to correspond to an existing category system.
	categoryType: "singleCategory"
}

#NonLazyCategory:
	#SingleCategory

#Category:
	#LazyCategory |
	#ResultingCategory |
	#NonLazyCategory

