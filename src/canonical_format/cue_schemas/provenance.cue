@experiment(explicitopen)

package provenance

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"
import categoryPkg "example.com/lca_format/cue_schemas:categories"

#StandardNonReviewActivityType:
	"dataCollection" |
	"dataGeneration" |
	"dataModelling" |
	"dataEntry" |
	"dataModification" |
	"dataConversion" |
	"dataValidation" |
	"dataPublication" |
	"dataRegistration"

#StandardActivityType:
	"dataReview" |
	#StandardNonReviewActivityType

#ReviewActivityType: {
	typeSystem!: "standard"
	value!: "dataReview"
}

#NonReviewActivityType:
	{
		typeSystem!: "standard"
		value!: #StandardNonReviewActivityType
	} |
	{
		typeSystem!: utilsPkg.#NonEmptyString & !="standard"
		value!: utilsPkg.#NonEmptyString
	}

#ActivityType:
	#ReviewActivityType |
	#NonReviewActivityType

#ActivityDate: {
    start: utilsPkg.#Timestamp
    end?: utilsPkg.#Timestamp
}

#ComplianceDeclaration: {
	status: "compliant" | "compliantWithReservations" | "nonCompliant"
	complianceSystem: referencePkg.#SourceReference
	report?: referencePkg.#SourceReference
}

#ActivityBase: referencePkg.#WithCommentSection... & {
	id: utilsPkg.#UUID
	date: #ActivityDate
	used?: [referencePkg.#ExternalFileReference, ...referencePkg.#ExternalFileReference]
	actors: [referencePkg.#ActorReference, ...referencePkg.#ActorReference]
	complianceDeclarations?: [#ComplianceDeclaration, ...#ComplianceDeclaration]
}

#NonReviewActivity: #ActivityBase... & {
	activityType: #NonReviewActivityType
}

#ILCDReviewTypes:
	"Dependent internal review" |
	"Independent internal review" |
	"Independent external review" |
	"Accredited third party review" |
	"Independent review panel" |
	"Not reviewed"

#ReviewType:
	{
		reviewSystem!: "ILCD"
		value: #ILCDReviewTypes
	} |
	{
		reviewSystem!: utilsPkg.#NonEmptyString & !="ILCD"
		value: utilsPkg.#NonEmptyString
	}

#WithReviewAdditionalInformation: {
	referenceToReport?: referencePkg.#SourceReference
	reviewType: #ReviewType
	reviewedVersion?: utilsPkg.#NonEmptyString
	reviewAssessment?: [categoryPkg.#NonLazyCategory, ...categoryPkg.#NonLazyCategory]
}

#ReviewActivity: #ActivityBase... & #WithReviewAdditionalInformation... & {
	activityType: #ReviewActivityType
}

#Activity:
	#ReviewActivity |
	#NonReviewActivity

#Provenance: {
	activities: [#Activity, ...#Activity]
}

#FileVersioning: {
	datasetVersion: utilsPkg.#SemanticVersion
	schemaVersion: utilsPkg.#SemanticVersion
}

#Timestamps: {
	creation: utilsPkg.#Timestamp
	lastEdit: utilsPkg.#Timestamp
}

#Hash:
	{
		algorithm: {
			typeSystem!: "standard"
			value!: "SHA-256"
		}
		checksum: utilsPkg.#SHA256
	} |
	{
		algorithm: {
			typeSystem!: utilsPkg.#NonEmptyString & !="standard"
			value!: utilsPkg.#NonEmptyString
		}
		checksum: utilsPkg.#NonEmptyString
	}

#BlockchainProof: {
	network: utilsPkg.#NonEmptyString
	transactionId: utilsPkg.#NonEmptyString
}

#HashInformation: {
	hash: #Hash
	blockchainProof?: #BlockchainProof
}

#FileInformation: {
	downloadableURI?: utilsPkg.#HTTPURL
	versioning: #FileVersioning
	timestamp: #Timestamps
}

#WithFileInformation: {
	fileInformation: #FileInformation
}

