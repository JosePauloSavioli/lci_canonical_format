@experiment(explicitopen)

package flows

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import quantityPkg "example.com/lca_format/cue_schemas:quantities"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
import referencePkg "example.com/lca_format/cue_schemas:references"

#Flowable: referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
}

#Exchange: referencePkg.#WithSources... & stdPropertyPkg.#WithProperties... & referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	flowable: referencePkg.#FlowReference
	quantity: quantityPkg.#AnyQuantity
}

