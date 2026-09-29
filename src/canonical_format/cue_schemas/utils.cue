@experiment(explicitopen)

package utils

import "time"

#PositiveNumber: number & >0
#NonNegativeNumber: number & >=0

#PositiveInt: int & >0
#NonNegativeInt: int & >=0

#PositiveFractionNumber: number & >0 & <=1
#OpenUnitIntervalNumber: number & >0 & <1
#NumberAtLeastTwo: number & >=2

#NonEmptyString: string & !=""

#HTTPURL: string & =~"^https?://[^\\s]+$"
#RelativeFilePath: string & =~"^((\\.\\.?|[A-Za-z0-9._~-]+)/)*[A-Za-z0-9._~-]+$"

#Year: string & =~"^[0-9]{4}$"
#Duration: string & =~"^P(?:[0-9]+Y)?(?:[0-9]+M)?(?:[0-9]+W)?(?:[0-9]+D)?(?:T(?:[0-9]+H)?(?:[0-9]+M)?(?:[0-9]+(?:\\.[0-9]+)?S)?)?$" & !="P" & !~"T$"
#Date: time.Format("2006-01-02") // ISO 8601
#Timestamp: time.Format("2006-01-02T15:04:05Z07:00")

#UUID: string & =~"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
#SemanticVersion: string & =~"^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$"
#JSONPointer: string & =~"^(|(/([^~/]|~[01])*)+)$"
#SHA256: string & =~"^[0-9a-fA-F]{64}$"

#UncertaintyType: {
	uncertaintyType: "variance" | "confidenceInterval95" | "probabilityDistribution" | "truncatedProbabilityDistribution" | "mixtureProbabilityDistribution" | "transformedProbabilityDistribution" | "empirical"
}

#ReferenceHolder: {
	referenceType: "internal" | "internalFile" | "externalFile" | "registry" | "uri" | "software"
}

#TargetHolder: #ReferenceHolder... & {
	targetType: #NonEmptyString
}

#QuantityHolder: {
	quantityType: "lazyQuantity" | "resultingQuantity" | "singleQuantity" | "regionalizedQuantitySet" | "timeSeriesQuantitySet"
}

#CategorySystemHolder: {
	categorySystemType: "single" | "pattern" | "composite"
}

#CategoryHolder: {
	categoryType: "lazyCategory" | "resultingCategory" | "singleCategory"
}

#ParameterHolder: {
	parameterType: "lazyParameter" | "inputFromEntry" | "simpleInput" | "choiceInput" | "quantitySetInput" | "formula"
}

