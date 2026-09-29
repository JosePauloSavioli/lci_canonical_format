@experiment(explicitopen)

package rights

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"

// The main update is that, for each rights entry, at least a URI is required.

#Copyright: {
	referenceToCopyrightOwner?: referencePkg.#ActorReference
	referenceToCopyrightStatementURI: utilsPkg.#HTTPURL
	validPeriod?: {
		start: utilsPkg.#Date
		end: utilsPkg.#Date
	}
	isCopyrightProtected?: bool
}

#License: {
	licenseType: utilsPkg.#NonEmptyString // Use SPDX or another catalogue of license identifications. As this is specific, it can be an internal registry entry, provided it comes with the URI
	referenceToLicenseURI: utilsPkg.#HTTPURL
}

#AccessRestriction: {
	accessModel: utilsPkg.#NonEmptyString
	referenceToPolicyURI: utilsPkg.#HTTPURL
	restrictedTo?: [referencePkg.#ActorReference, ...referencePkg.#ActorReference]
}

#Rights: {
	copyright?: #Copyright
	license?: #License
	access?: #AccessRestriction
}

