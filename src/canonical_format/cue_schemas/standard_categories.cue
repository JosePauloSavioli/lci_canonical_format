@experiment(explicitopen)

package standard_categories

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import referencePkg "example.com/lca_format/cue_schemas:references"
import categorySystemPkg "example.com/lca_format/cue_schemas:category_system"

#RegistryRef: referencePkg.#RegistryReference
#CategorySystemFileRef: referencePkg.#CategorySystemFileReference
#SingleCategory: categorySystemPkg.#SingleCategorySystem
#PatternCategory: categorySystemPkg.#PatternCategorySystem
#CompositionCategory: categorySystemPkg.#CompositeCategorySystem

// Reference system registries

#BCP47ReferenceSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "b4500324-3bff-433e-bbd9-4d0d2a6ea8ed"
	uri:  "https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry"
	name: "IETF BCP 47"
}

#UCUMReferenceSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "08eb4445-1582-4b75-9995-6847ebb2b94b"
	uri: "https://ucum.org/ucum"
	name: "Unified Code for Units of Measure (UCUM)"
}

#ISO4217ReferenceSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "c81a7de5-7176-43b8-b4e7-99c5c29cba2a"
	uri: "https://www.six-group.com/en/products-services/financial-information/market-reference-data/data-standards.html"
	name: "ISO 4217 Currency Codes"
}

#SIReferenceSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "960925c7-d713-48be-8df3-e025e782779e"
	uri: "https://doi.org/10.59161/AUEZ1291"
	name: "International System of Units (SI)"
}


// Classification registries

#CopernicusLandUseClassificationSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "b5cc481c-d0b4-4a1f-9b9b-f408f2b4113a"
	uri: "https://land.copernicus.eu/en/products/corine-land-cover"
	name: "Copernicus CORINE Land Cover"
}

#CPCClassificationSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "79b46f42-87df-4229-9ece-3e8140ca18d8"
	uri: "https://unstats.un.org/unsd/classifications/Econ/cpc"
	name: "Central Product Classification (CPC)"
}

#ISICRev4ClassificationSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "daabd84a-ed83-4851-87de-d39c21668d2a"
	uri: "https://unstats.un.org/unsd/classifications/Econ/isic/4"
	name: "International Standard Industrial Classification of All Economic Activities (ISIC)"
}


// Patterns

#CASNumberCategorySystem: utilsPkg.#CategorySystemHolder... & #PatternCategory... & {
	id: "e978db33-ee2e-44d2-a4ab-8d67ddd8d6ad"
	name: "CAS Registry Number"
	labelPattern: "^[0-9]{2,7}-[0-9]{2}-[0-9]$"
}

#ECNumberCategorySystem: utilsPkg.#CategorySystemHolder... & #PatternCategory... & {
	id: "ba67b961-c7d3-40be-a853-f4d5931ddf8a"
	name: "EC number"
	labelPattern: "^[0-9]{3}-[0-9]{3}-[0-9]$"
}


// ecoinvent registries

#EcoinventMacroEconomicScenarioRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "64905f6a-5218-4287-9ec9-7a81150c5ab3"
	uri: "https://support.ecoinvent.org/hubfs/Knowledge%20Base/Database/Fundamentals/dataqualityguideline_ecoinvent_3_20130506.pdf#page=88"
	name: "ecoinvent macroeconomic scenarios"
}

#EcoinventSystemModelRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "b565dbf7-39c5-4f4f-98e7-ce797ddea6c9"
	uri: "https://support.ecoinvent.org/system-models"
	name: "ecoinvent system models"
}

#EcoinventActivityNameRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "c17624df-9e4d-4a3d-aebd-476c936f9c76"
	uri: "https://support.ecoinvent.org/activities-products"
	name: "ecoinvent activity name master data"
}

#EcoinventIntermediateFlowRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "b900739f-d99c-4700-9c04-b09c5e3b4633"
	uri: "https://support.ecoinvent.org/activities-products"
	name: "ecoinvent intermediate flow master data"
}

#EcoinventElementaryFlowRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "56d9507a-28c5-452d-9d0d-8f62482781ce"
	uri: "https://support.ecoinvent.org/ecoinvent-version-3.9"
	name: "ecoinvent elementary flow master data"
}

#EcoinventElementaryFlowContextRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "43b6c40c-f055-4a86-9f98-5c5a58f95d4c"
	uri: "https://support.ecoinvent.org/changes-ecospold1-to-ecospold2"
	name: "ecoinvent elementary flow contexts"
}

#EcoinventByProductClassificationSystem: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "870f8b92-c608-4799-a75e-a46de92da782"
	uri: "https://support.ecoinvent.org/activities-products"
	name: "ecoinvent by-product classification"
}

#EcoinventGeographyRegistry: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: "8e23a4c6-284f-4f1b-b67b-88f1d56c5d31"
	uri: "https://support.ecoinvent.org/geographies"
	name: "ecoinvent geographies"
}

// enumerations

#ProcessLCATypeCategorySystemValues: ["Unit process", "LCI result"]
#ProcessLCATypeCategorySystemEnum: or(#ProcessLCATypeCategorySystemValues)

#ProcessLCATypeCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "d8dd18d8-375e-4a44-a907-d37cc90fb936"
	name: "process LCA type"
	entries: [for value in #ProcessLCATypeCategorySystemValues {label: value}]
}

#FlowLCATypeCategorySystemValues: ["elementary", "intermediate"]
#FlowLCATypeCategorySystemEnum: or(#FlowLCATypeCategorySystemValues)

#FlowLCATypeCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "e009a671-5251-4e7d-8da3-679385441e62"
	name: "flow LCA type"
	entries: [for value in #FlowLCATypeCategorySystemValues {label: value}]
}

#FlowIOTypeCategorySystemValues: ["input", "output"]
#FlowIOTypeCategorySystemEnum: or(#FlowIOTypeCategorySystemValues)

#FlowIOTypeCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "3515e1c0-99f6-48e8-a8bd-310c6c9392b5"
	name: "flow input-output type"
	entries: [for value in #FlowIOTypeCategorySystemValues {label: value}]
}

#ElementaryFlowDirectionCategorySystemValues: ["emission", "resource extraction"]
#ElementaryFlowDirectionCategorySystemEnum: or(#ElementaryFlowDirectionCategorySystemValues)

#ElementaryFlowDirectionCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "c7c8eb64-6072-44ab-9753-5e25f4bac7e2"
	name: "elementary flow direction"
	entries: [for value in #ElementaryFlowDirectionCategorySystemValues {label: value}]
}

#CarbonOriginCategorySystemValues: ["fossil", "biogenic", "unspecified"]
#CarbonOriginCategorySystemEnum: or(#CarbonOriginCategorySystemValues)

#CarbonOriginCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "59fcfad2-ba13-441d-90db-c066abb7d93e"
	name: "carbon origin"
	entries: [for value in #CarbonOriginCategorySystemValues {label: value}]
}


// ecoinvent enumerations

#EcoinventSpecialActivityTypeCategorySystemValues: ["ordinary transforming activity (default)", "market activity", "market group", "IO activity", "Residual activity", "production mix", "import activity", "supply mix", "export activity", "re-export activity", "correction activity"]
#EcoinventSpecialActivityTypeCategorySystemEnum: or(#EcoinventSpecialActivityTypeCategorySystemValues)

#EcoinventSpecialActivityTypeCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "62ed17d2-5585-4a99-9360-9bf3aab07573"
	name: "ecoinvent special activity type"
	entries: [for value in #EcoinventSpecialActivityTypeCategorySystemValues {label: value}]
}

#EcoinventInheritanceDepthCategorySystemValues: ["not a child", "geography child", "temporal child", "macro-economic scenario child"]
#EcoinventInheritanceDepthCategorySystemEnum: or(#EcoinventInheritanceDepthCategorySystemValues)

#EcoinventInheritanceDepthCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "9268a9e2-d395-4f4d-adce-d015f2e52dae"
	name: "ecoinvent inheritance depth"
	entries: [for value in #EcoinventInheritanceDepthCategorySystemValues {label: value}]
}

#EcoinventTechnologyLevelCategorySystemValues: ["undefined", "new", "modern", "current", "old", "outdated"]
#EcoinventTechnologyLevelCategorySystemEnum: or(#EcoinventTechnologyLevelCategorySystemValues)

#EcoinventTechnologyLevelCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "c5c4f84b-fbf3-4159-aa5d-2f7c4199d01d"
	name: "ecoinvent technology level"
	entries: [for value in #EcoinventTechnologyLevelCategorySystemValues {label: value}]
}

#EcoinventEnergyValueBasisCategorySystemValues: ["undefined", "net calorific value", "gross calorific value"]
#EcoinventEnergyValueBasisCategorySystemEnum: or(#EcoinventEnergyValueBasisCategorySystemValues)

#EcoinventEnergyValueBasisCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: "3a7d9db1-c553-487e-9166-22d25674ace7"
	name: "ecoinvent energy value basis"
	entries: [for value in #EcoinventEnergyValueBasisCategorySystemValues {label: value}]
}


// ecoinvent patterns

#EcoinventPedigreeMatrixCategorySystem: utilsPkg.#CategorySystemHolder... & #PatternCategory... & {
	id: "21252d11-0d48-484f-9ea0-0ea320b3b2aa"
	name: "ecoinvent pedigree matrix"
	labelPattern: "^[1-5]{5}$"
}

// Catalog

#StandardCategoryRegistryEntries: [
	#BCP47ReferenceSystem
	#UCUMReferenceSystem
	#ISO4217ReferenceSystem
	#SIReferenceSystem
	#CopernicusLandUseClassificationSystem
	#CPCClassificationSystem
	#ISICRev4ClassificationSystem
	#CASNumberCategorySystem
	#ECNumberCategorySystem
	#EcoinventMacroEconomicScenarioRegistry
	#EcoinventSystemModelRegistry
	#EcoinventActivityNameRegistry
	#EcoinventIntermediateFlowRegistry
	#EcoinventElementaryFlowRegistry
	#EcoinventElementaryFlowContextRegistry
	#EcoinventByProductClassificationSystem
	#EcoinventGeographyRegistry
	#ProcessLCATypeCategorySystem
	#FlowLCATypeCategorySystem
	#FlowIOTypeCategorySystem
	#ElementaryFlowDirectionCategorySystem
	#CarbonOriginCategorySystem
	#EcoinventSpecialActivityTypeCategorySystem
	#EcoinventInheritanceDepthCategorySystem
	#EcoinventTechnologyLevelCategorySystem
	#EcoinventEnergyValueBasisCategorySystem
	#EcoinventPedigreeMatrixCategorySystem
]

#StandardCategoryRegistryById: {
	for registryEntry in #StandardCategoryRegistryEntries {
		"\(registryEntry.id)": registryEntry
	}
}

#StandardCategoryRegistry: {
	I=id: utilsPkg.#UUID
	#StandardCategoryRegistryById[I]
}

#StandardCategoryIds: [
	for registryEntry in #StandardCategoryRegistryEntries {
		registryEntry.id
	}
]

#StandardCategoryId: or(#StandardCategoryIds)

#ExtensionRegistryReference: utilsPkg.#ReferenceHolder... & #RegistryRef... & {
	id: #ExtensionCategoryId
}

#ExtensionCategorySystemFileReference: utilsPkg.#TargetHolder... & utilsPkg.#ReferenceHolder... & #CategorySystemFileRef... & {
	fileId: #ExtensionCategoryId
}

#ExtensionCategoryReference:
	#ExtensionRegistryReference |
	#ExtensionCategorySystemFileReference

#ExtensionSingleCategorySystem: utilsPkg.#CategorySystemHolder... & #SingleCategory... & {
	id: #ExtensionCategoryId
}

#ExtensionPatternCategorySystem: utilsPkg.#CategorySystemHolder... & #PatternCategory... & {
	id: #ExtensionCategoryId
}

#ExtensionCompositeCategorySystem: utilsPkg.#CategorySystemHolder... & #CompositionCategory... & {
	id: #ExtensionCategoryId
}

#ExtensionCategorySystem:
	#ExtensionSingleCategorySystem |
	#ExtensionPatternCategorySystem |
	#ExtensionCompositeCategorySystem

#ExtensionCategoryRegistry:
	#ExtensionCategoryReference |
	#ExtensionCategorySystem

#CategoryRegistryList: [
	#AnyCategoryRegistry, ...#AnyCategoryRegistry
]
