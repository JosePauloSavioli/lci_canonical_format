@experiment(explicitopen)

package category_system

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"
import categoryPkg "example.com/lca_format/cue_schemas:categories"

#ContextValues: "entryId" | "code"

#CategoryEntry: categoryPkg.#SingleCategoryEntry... & {
	children?: [#CategoryEntry, ...#CategoryEntry]
}

#SingleCategoryBase: {
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
}

#SingleCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategoryBase... & {
	categorySystemType: "single"
	entries: [#CategoryEntry, ...#CategoryEntry]
}

#PatternCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategoryBase... & {
	categorySystemType: "pattern"
	labelPattern: utilsPkg.#NonEmptyString
}

#CompositeCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategoryBase... & {
	categorySystemType: "composite"
	components: [#CategorySystem, ...#CategorySystem]
}

#CategorySystem:
	#SingleCategorySystem |
	#PatternCategorySystem |
	#CompositeCategorySystem

#CategoryRegistryEntry:
	#CategorySystem |
	referencePkg.#CategorySystemReference

#CategorySystemDataSet: close({
	datasetType!: "categorySystem"
	categorySystemType: "single" | "pattern" | "composite"
}) & (#SingleCategorySystem... | #PatternCategorySystem... | #CompositeCategorySystem...)

