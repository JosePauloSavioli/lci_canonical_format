@experiment(explicitopen)

package references

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#CategoryReference: utilsPkg.#UUID
#UnitReference: utilsPkg.#UUID
#PropertyReference: utilsPkg.#UUID
#FlowReference: utilsPkg.#UUID
#ActorReference: utilsPkg.#UUID
#SourceReference: utilsPkg.#UUID
#TableReference: utilsPkg.#UUID

#InternalReferenceInOtherFile: utilsPkg.#TargetHolder... & {
	referenceType: "internal"
	fileId: utilsPkg.#UUID
	version?: utilsPkg.#SemanticVersion
}

#ExchangeReference: #InternalReferenceInOtherFile... & utilsPkg.#ReferenceHolder... & {
	targetType: "exchange"
	exchangeId: utilsPkg.#UUID
}

#ParameterReference: #InternalReferenceInOtherFile... & utilsPkg.#ReferenceHolder... & {
	targetType: "parameter"
	parameterId: utilsPkg.#UUID
}

#PropertyInOtherFileReference: #InternalReferenceInOtherFile... & utilsPkg.#ReferenceHolder... & {
	targetType: "property"
	propertyId: utilsPkg.#UUID
}

#InternalCategoricalReference:
	#PropertyInOtherFileReference |
	#ParameterReference

#InternalQuantitativeReference:
	#InternalCategoricalReference |
	#ExchangeReference

#InternalReference:
	#InternalQuantitativeReference

#InternalFileReference: utilsPkg.#TargetHolder... & {
	referenceType: "internalFile"
	fileId: utilsPkg.#UUID
	version?: utilsPkg.#SemanticVersion
}

#ProcessReference: #InternalFileReference... & utilsPkg.#ReferenceHolder... & {
	targetType: "process"
}

#ProductionSystemReference: #InternalFileReference... & utilsPkg.#ReferenceHolder... & {
	targetType: "productionSystem"
}

#ParameterSystemReference: #InternalFileReference... & utilsPkg.#ReferenceHolder... & {
	targetType: "parameter"
}

#CategorySystemFileReference: #InternalFileReference... & utilsPkg.#ReferenceHolder... & {
    	targetType: "categorySystem"
}

#RegistryFileReference: #InternalFileReference... & utilsPkg.#ReferenceHolder... & {
	targetType: "registry"
}

#ExternalFileReference: utilsPkg.#ReferenceHolder... & {
	referenceType: "externalFile"
	id: utilsPkg.#UUID
	version?: utilsPkg.#SemanticVersion
}

#RegistryReference: utilsPkg.#ReferenceHolder... & {
	referenceType: "registry"
	id: utilsPkg.#UUID
	uri: utilsPkg.#HTTPURL
	name: utilsPkg.#NonEmptyString
	version?: utilsPkg.#NonEmptyString
}

#CategorySystemReference:
    #RegistryReference |
    #CategorySystemFileReference

#Variable: { // Should be referenced in text as {{{variableName}}}.
	name: utilsPkg.#NonEmptyString
	reference?: #InternalReference
	value?: utilsPkg.#NonEmptyString
}

#EntryWithRole: {
	role?: utilsPkg.#NonEmptyString
}

#CommentWithRole: #EntryWithRole... & {
	text: utilsPkg.#NonEmptyString
	variables?: [#Variable, ...#Variable]
}

#WithCommentSection: {
	comments?: [#CommentWithRole, ...#CommentWithRole]
}

#SourceWithRole: #EntryWithRole... & {
	reference: #SourceReference
}

#WithSources: {
	sourceEntries?: [#SourceWithRole, ...#SourceWithRole]
}
