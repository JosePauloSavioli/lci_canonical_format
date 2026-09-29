@experiment(explicitopen)

package bibo_dc

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#BIBODocumentClass:
	"bibo:AcademicArticle" |
	"bibo:Article" |
	"bibo:AudioDocument" |
	"bibo:AudioVisualDocument" |
	"bibo:Bill" |
	"bibo:Book" |
	"bibo:BookSection" |
	"bibo:Brief" |
	"bibo:Chapter" |
	"bibo:CollectedDocument" |
	"bibo:Document" |
	"bibo:DocumentPart" |
	"bibo:EditedBook" |
	"bibo:Email" |
	"bibo:Excerpt" |
	"bibo:Film" |
	"bibo:Image" |
	"bibo:Issue" |
	"bibo:LegalCaseDocument" |
	"bibo:LegalDecision" |
	"bibo:LegalDocument" |
	"bibo:Legislation" |
	"bibo:Letter" |
	"bibo:Manual" |
	"bibo:Manuscript" |
	"bibo:Map" |
	"bibo:Note" |
	"bibo:Patent" |
	"bibo:PersonalCommunicationDocument" |
	"bibo:Proceedings" |
	"bibo:Quote" |
	"bibo:ReferenceSource" |
	"bibo:Report" |
	"bibo:Slide" |
	"bibo:Slideshow" |
	"bibo:Specification" |
	"bibo:Standard" |
	"bibo:Statute" |
	"bibo:Thesis" |
	"bibo:Webpage"

#SemanticExtension: {
	property: utilsPkg.#HTTPURL
	value: string
}

#BIBOProperty:
	"http://purl.org/ontology/bibo/abstract" |
	"http://purl.org/ontology/bibo/affirmedBy" |
	"http://purl.org/ontology/bibo/annotates" |
	"http://purl.org/ontology/bibo/argued" |
	"http://purl.org/ontology/bibo/asin" |
	"http://purl.org/ontology/bibo/chapter" |
	"http://purl.org/ontology/bibo/citedBy" |
	"http://purl.org/ontology/bibo/cites" |
	"http://purl.org/ontology/bibo/coden" |
	"http://purl.org/ontology/bibo/contributorList" |
	"http://purl.org/ontology/bibo/court" |
	"http://purl.org/ontology/bibo/degree" |
	"http://purl.org/ontology/bibo/director" |
	"http://purl.org/ontology/bibo/distributor" |
	"http://purl.org/ontology/bibo/doi" |
	"http://purl.org/ontology/bibo/eanucc13" |
	"http://purl.org/ontology/bibo/edition" |
	"http://purl.org/ontology/bibo/editor" |
	"http://purl.org/ontology/bibo/editorList" |
	"http://purl.org/ontology/bibo/eissn" |
	"http://purl.org/ontology/bibo/gtin14" |
	"http://purl.org/ontology/bibo/handle" |
	"http://purl.org/ontology/bibo/identifier" |
	"http://purl.org/ontology/bibo/interviewee" |
	"http://purl.org/ontology/bibo/interviewer" |
	"http://purl.org/ontology/bibo/isbn" |
	"http://purl.org/ontology/bibo/isbn10" |
	"http://purl.org/ontology/bibo/isbn13" |
	"http://purl.org/ontology/bibo/issn" |
	"http://purl.org/ontology/bibo/issue" |
	"http://purl.org/ontology/bibo/issuer" |
	"http://purl.org/ontology/bibo/lccn" |
	"http://purl.org/ontology/bibo/locator" |
	"http://purl.org/ontology/bibo/numPages" |
	"http://purl.org/ontology/bibo/numVolumes" |
	"http://purl.org/ontology/bibo/number" |
	"http://purl.org/ontology/bibo/oclcnum" |
	"http://purl.org/ontology/bibo/organizer" |
	"http://purl.org/ontology/bibo/owner" |
	"http://purl.org/ontology/bibo/pageEnd" |
	"http://purl.org/ontology/bibo/pageStart" |
	"http://purl.org/ontology/bibo/pages" |
	"http://purl.org/ontology/bibo/performer" |
	"http://purl.org/ontology/bibo/pmid" |
	"http://purl.org/ontology/bibo/prefixName" |
	"http://purl.org/ontology/bibo/presentedAt" |
	"http://purl.org/ontology/bibo/presents" |
	"http://purl.org/ontology/bibo/producer" |
	"http://purl.org/ontology/bibo/recipient" |
	"http://purl.org/ontology/bibo/reproducedIn" |
	"http://purl.org/ontology/bibo/reversedBy" |
	"http://purl.org/ontology/bibo/reviewOf" |
	"http://purl.org/ontology/bibo/section" |
	"http://purl.org/ontology/bibo/shortDescription" |
	"http://purl.org/ontology/bibo/shortTitle" |
	"http://purl.org/ontology/bibo/sici" |
	"http://purl.org/ontology/bibo/status" |
	"http://purl.org/ontology/bibo/subsequentLegalDecision" |
	"http://purl.org/ontology/bibo/suffixName" |
	"http://purl.org/ontology/bibo/transcriptOf" |
	"http://purl.org/ontology/bibo/translationOf" |
	"http://purl.org/ontology/bibo/translator" |
	"http://purl.org/ontology/bibo/upc" |
	"http://purl.org/ontology/bibo/uri" |
	"http://purl.org/ontology/bibo/volume"

#DCTermsProperty:
	"http://purl.org/dc/terms/abstract" |
	"http://purl.org/dc/terms/accessRights" |
	"http://purl.org/dc/terms/accrualMethod" |
	"http://purl.org/dc/terms/accrualPeriodicity" |
	"http://purl.org/dc/terms/accrualPolicy" |
	"http://purl.org/dc/terms/alternative" |
	"http://purl.org/dc/terms/audience" |
	"http://purl.org/dc/terms/available" |
	"http://purl.org/dc/terms/bibliographicCitation" |
	"http://purl.org/dc/terms/conformsTo" |
	"http://purl.org/dc/terms/contributor" |
	"http://purl.org/dc/terms/coverage" |
	"http://purl.org/dc/terms/created" |
	"http://purl.org/dc/terms/creator" |
	"http://purl.org/dc/terms/date" |
	"http://purl.org/dc/terms/dateAccepted" |
	"http://purl.org/dc/terms/dateCopyrighted" |
	"http://purl.org/dc/terms/dateSubmitted" |
	"http://purl.org/dc/terms/description" |
	"http://purl.org/dc/terms/educationLevel" |
	"http://purl.org/dc/terms/extent" |
	"http://purl.org/dc/terms/format" |
	"http://purl.org/dc/terms/hasFormat" |
	"http://purl.org/dc/terms/hasPart" |
	"http://purl.org/dc/terms/hasVersion" |
	"http://purl.org/dc/terms/identifier" |
	"http://purl.org/dc/terms/instructionalMethod" |
	"http://purl.org/dc/terms/isFormatOf" |
	"http://purl.org/dc/terms/isPartOf" |
	"http://purl.org/dc/terms/isReferencedBy" |
	"http://purl.org/dc/terms/isReplacedBy" |
	"http://purl.org/dc/terms/isRequiredBy" |
	"http://purl.org/dc/terms/isVersionOf" |
	"http://purl.org/dc/terms/language" |
	"http://purl.org/dc/terms/license" |
	"http://purl.org/dc/terms/mediator" |
	"http://purl.org/dc/terms/medium" |
	"http://purl.org/dc/terms/modified" |
	"http://purl.org/dc/terms/provenance" |
	"http://purl.org/dc/terms/publisher" |
	"http://purl.org/dc/terms/references" |
	"http://purl.org/dc/terms/relation" |
	"http://purl.org/dc/terms/replaces" |
	"http://purl.org/dc/terms/requires" |
	"http://purl.org/dc/terms/rights" |
	"http://purl.org/dc/terms/rightsHolder" |
	"http://purl.org/dc/terms/source" |
	"http://purl.org/dc/terms/spatial" |
	"http://purl.org/dc/terms/subject" |
	"http://purl.org/dc/terms/tableOfContents" |
	"http://purl.org/dc/terms/temporal" |
	"http://purl.org/dc/terms/type" |
	"http://purl.org/dc/terms/valid"

#SourceSemanticProperty:
	#BIBOProperty |
	#DCTermsProperty

#SourceSemanticExtension: #SemanticExtension... & {
	property: #SourceSemanticProperty
}

#SourceSemanticExtensions: [#SourceSemanticExtension, ...#SourceSemanticExtension]

#AdditionalSourceInformation: {
	extensions?: #SourceSemanticExtensions
}

