@experiment(explicitopen)

package vcard

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#SemanticExtension: {
	property: utilsPkg.#HTTPURL
	value: string
}

#VCardProperty:
	"http://www.w3.org/2006/vcard/ns#additional-name" |
	"http://www.w3.org/2006/vcard/ns#adr" |
	"http://www.w3.org/2006/vcard/ns#anniversary" |
	"http://www.w3.org/2006/vcard/ns#bday" |
	"http://www.w3.org/2006/vcard/ns#category" |
	"http://www.w3.org/2006/vcard/ns#country-name" |
	"http://www.w3.org/2006/vcard/ns#email" |
	"http://www.w3.org/2006/vcard/ns#family-name" |
	"http://www.w3.org/2006/vcard/ns#geo" |
	"http://www.w3.org/2006/vcard/ns#given-name" |
	"http://www.w3.org/2006/vcard/ns#hasAdditionalName" |
	"http://www.w3.org/2006/vcard/ns#hasAddress" |
	"http://www.w3.org/2006/vcard/ns#hasCalendarBusy" |
	"http://www.w3.org/2006/vcard/ns#hasCalendarLink" |
	"http://www.w3.org/2006/vcard/ns#hasCalendarRequest" |
	"http://www.w3.org/2006/vcard/ns#hasCategory" |
	"http://www.w3.org/2006/vcard/ns#hasCountryName" |
	"http://www.w3.org/2006/vcard/ns#hasFN" |
	"http://www.w3.org/2006/vcard/ns#hasFamilyName" |
	"http://www.w3.org/2006/vcard/ns#hasGender" |
	"http://www.w3.org/2006/vcard/ns#hasGeo" |
	"http://www.w3.org/2006/vcard/ns#hasGivenName" |
	"http://www.w3.org/2006/vcard/ns#hasHonorificPrefix" |
	"http://www.w3.org/2006/vcard/ns#hasHonorificSuffix" |
	"http://www.w3.org/2006/vcard/ns#hasInstantMessage" |
	"http://www.w3.org/2006/vcard/ns#hasKey" |
	"http://www.w3.org/2006/vcard/ns#hasLanguage" |
	"http://www.w3.org/2006/vcard/ns#hasLocality" |
	"http://www.w3.org/2006/vcard/ns#hasLogo" |
	"http://www.w3.org/2006/vcard/ns#hasMember" |
	"http://www.w3.org/2006/vcard/ns#hasName" |
	"http://www.w3.org/2006/vcard/ns#hasNickname" |
	"http://www.w3.org/2006/vcard/ns#hasNote" |
	"http://www.w3.org/2006/vcard/ns#hasOrganizationName" |
	"http://www.w3.org/2006/vcard/ns#hasOrganizationUnit" |
	"http://www.w3.org/2006/vcard/ns#hasPhoto" |
	"http://www.w3.org/2006/vcard/ns#hasPostalCode" |
	"http://www.w3.org/2006/vcard/ns#hasRegion" |
	"http://www.w3.org/2006/vcard/ns#hasRelated" |
	"http://www.w3.org/2006/vcard/ns#hasRole" |
	"http://www.w3.org/2006/vcard/ns#hasSound" |
	"http://www.w3.org/2006/vcard/ns#hasSource" |
	"http://www.w3.org/2006/vcard/ns#hasStreetAddress" |
	"http://www.w3.org/2006/vcard/ns#hasTelephone" |
	"http://www.w3.org/2006/vcard/ns#hasTitle" |
	"http://www.w3.org/2006/vcard/ns#hasUID" |
	"http://www.w3.org/2006/vcard/ns#hasURL" |
	"http://www.w3.org/2006/vcard/ns#hasValue" |
	"http://www.w3.org/2006/vcard/ns#honorific-prefix" |
	"http://www.w3.org/2006/vcard/ns#honorific-suffix" |
	"http://www.w3.org/2006/vcard/ns#key" |
	"http://www.w3.org/2006/vcard/ns#language" |
	"http://www.w3.org/2006/vcard/ns#locality" |
	"http://www.w3.org/2006/vcard/ns#logo" |
	"http://www.w3.org/2006/vcard/ns#n" |
	"http://www.w3.org/2006/vcard/ns#nickname" |
	"http://www.w3.org/2006/vcard/ns#note" |
	"http://www.w3.org/2006/vcard/ns#org" |
	"http://www.w3.org/2006/vcard/ns#organization-name" |
	"http://www.w3.org/2006/vcard/ns#organization-unit" |
	"http://www.w3.org/2006/vcard/ns#photo" |
	"http://www.w3.org/2006/vcard/ns#postal-code" |
	"http://www.w3.org/2006/vcard/ns#prodid" |
	"http://www.w3.org/2006/vcard/ns#region" |
	"http://www.w3.org/2006/vcard/ns#rev" |
	"http://www.w3.org/2006/vcard/ns#role" |
	"http://www.w3.org/2006/vcard/ns#sort-string" |
	"http://www.w3.org/2006/vcard/ns#sound" |
	"http://www.w3.org/2006/vcard/ns#street-address" |
	"http://www.w3.org/2006/vcard/ns#tel" |
	"http://www.w3.org/2006/vcard/ns#title" |
	"http://www.w3.org/2006/vcard/ns#tz" |
	"http://www.w3.org/2006/vcard/ns#url" |
	"http://www.w3.org/2006/vcard/ns#value"

#VCardSemanticExtension: #SemanticExtension... & {
	property: #VCardProperty
}

#VCardSemanticExtensions: [#VCardSemanticExtension, ...#VCardSemanticExtension]

#AdditionalVCardInformation: {
	extensions?: #VCardSemanticExtensions
}

