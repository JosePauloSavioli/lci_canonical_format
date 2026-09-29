@experiment(explicitopen)

package actors_and_sources

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import vcardPkg "example.com/lca_format/cue_schemas:vcard"
import biboDcPkg "example.com/lca_format/cue_schemas:bibo_dc"
import stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"

#Email: string & =~"^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"
#Pages: string & =~"^([A-Za-z]?[0-9]+|[IVXLCDMivxlcdm]+)([-–]([A-Za-z]?[0-9]+|[IVXLCDMivxlcdm]+))?$"
#PhoneNumber: string & =~"^\\+[1-9][0-9]{1,14}$"
#DOI: string & =~"^10\\.[0-9]{4,9}/[^\\s]+$"
#ISSN: string & =~"^[0-9]{4}-[0-9]{3}[0-9X]$"
#ORCID: string & =~"^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]$"

#ORCIDActorIdentification: {
	system!: "orcid"
	value: #ORCID
}

#OtherActorIdentification: {
	system!: utilsPkg.#NonEmptyString & !="orcid"
	value: utilsPkg.#NonEmptyString
}

#ActorIdentification:
	#ORCIDActorIdentification |
	#OtherActorIdentification

#Actor: vcardPkg.#AdditionalVCardInformation... & stdPropertyPkg.#WithProperties... & {
	actorType: "group" | "individual" | "organization" | "software"
	id: utilsPkg.#UUID
	name: utilsPkg.#NonEmptyString
	organizationName?: utilsPkg.#NonEmptyString
	version?: utilsPkg.#NonEmptyString
	emails?: [#Email, ...#Email]
	phones?: [#PhoneNumber, ...#PhoneNumber]
	websites?: [utilsPkg.#HTTPURL, ...utilsPkg.#HTTPURL]
	identifiers?: [#ActorIdentification, ...#ActorIdentification]
}

// A source field may enter any identifiable field.

#DOISourceIdentification: {
	system!: "doi"
	value: #DOI
}

#ISSNSourceIdentification: {
	system!: "issn"
	value: #ISSN
}

#OtherSourceIdentification: {
	system!: utilsPkg.#NonEmptyString & !="doi" & !="issn"
	value: utilsPkg.#NonEmptyString
}

#SourceIdentification:
	#DOISourceIdentification |
	#ISSNSourceIdentification |
	#OtherSourceIdentification

#SourceAuthor: {
	name: utilsPkg.#NonEmptyString
	actorId?: utilsPkg.#UUID
}

#Source: biboDcPkg.#AdditionalSourceInformation... & stdPropertyPkg.#WithProperties... & {
	sourceType: biboDcPkg.#BIBODocumentClass
	id: utilsPkg.#UUID
	title: utilsPkg.#NonEmptyString
	authors?: [#SourceAuthor, ...#SourceAuthor]
	year?: utilsPkg.#Year
	pages?: #Pages
	identifiers?: [#SourceIdentification, ...#SourceIdentification]
}

