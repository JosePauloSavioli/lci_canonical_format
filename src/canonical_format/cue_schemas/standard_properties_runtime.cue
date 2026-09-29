@if(!jsonschema)

@experiment(explicitopen)

package standard_properties

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#ExtensionPropertyId: utilsPkg.#UUID & and([
	for standardId in #StandardPropertyIds {
		!=standardId
	}
])

#AnyPropertyRegistry:
	#StandardPropertyRegistry |
	#ExtensionPropertyRegistry

#AnyProperty:
	#StandardProperty |
	#ExtensionProperty

#PropertyList: [#AnyProperty, ...#AnyProperty]

#WithProperties: {
	properties?: #PropertyList
}

#WithPropertyRegistry: {
	properties?: [#AnyPropertyRegistry, ...#AnyPropertyRegistry]
}

