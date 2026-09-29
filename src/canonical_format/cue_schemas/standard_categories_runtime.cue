@if(!jsonschema)

@experiment(explicitopen)

package standard_categories

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#ExtensionCategoryId: utilsPkg.#UUID & and([
	for standardId in #StandardCategoryIds {
		!=standardId
	}
])

#AnyCategoryRegistry:
	#StandardCategoryRegistry |
	#ExtensionCategoryRegistry

