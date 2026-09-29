@experiment(explicitopen)

package standard_properties

import utilsPkg "example.com/lca_format/cue_schemas:utils"
import unitPkg "example.com/lca_format/cue_schemas:units"
import propertyPkg "example.com/lca_format/cue_schemas:properties"
import referencePkg "example.com/lca_format/cue_schemas:references"
import categoryPkg "example.com/lca_format/cue_schemas:categories"
import quantityPkg "example.com/lca_format/cue_schemas:quantities"
import stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"

#MassDimensionality: {
	mass!: 1
}

#VolumeDimensionality: {
	length!: 3
}

#EnergyDimensionality: {
	length!: 2
	mass!: 1
	time!: -2
}

#RegistryProp: propertyPkg.#PropertyRegistry
#CategoricalProp: propertyPkg.#CategoricalProperty
#QuantitativeProp: propertyPkg.#QuantitativeProperty
#CompositePropBase: propertyPkg.#CompositePropertyBase
#CompositeProp: propertyPkg.#CompositeProperty
#CategoricalPropWithSystem: #CategoricalProp... & {
	categorySystem: referencePkg.#CategoryReference
}

// Boolean properties

#IsDataValidForEntirePeriodValue: #CategoricalProp... & {
	property: #IsDataValidForEntirePeriodProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsDataValidForEntirePeriodProperty: #RegistryProp... & {
	id: "7e79e7af-71de-41a3-9dad-862e37cbe9ca"
	name: "is data valid for entire period"
	type: "categorical"
	context: ["process"]
}

#IsReferenceValue: #CategoricalProp... & {
	property: #IsReferenceProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsReferenceProperty: #RegistryProp... & { // Can be done better.
	id: "eb06d312-7738-42b2-a6c9-ac1fe9a018f4"
	name: "is reference"
	type: "categorical"
	context: ["exchange"]
}

#IsInfrastructureValue: #CategoricalProp... & {
	property: #IsInfrastructureProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsInfrastructureProperty: #RegistryProp... & {
	id: "1b3e0b6a-ea22-40ea-bb04-5fdebd21ed1a"
	name: "is infrastructure"
	type: "categorical"
	context: ["exchange"]
}


// Categorical properties

#ProcessLCATypeValue: #CategoricalPropWithSystem... & {
	property: #ProcessLCATypeProperty.id
	categorySystem: stdCategoryPkg.#ProcessLCATypeCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#ProcessLCATypeCategorySystemEnum
	}
}

#ProcessLCATypeProperty: #RegistryProp... & {
	id: "6cd90a91-83d9-4c97-b4ec-aac59c8553ea"
	name: "process LCA type"
	type: "categorical"
	context: ["process"]
}

#FlowLCATypeValue: #CategoricalPropWithSystem... & {
	property: #FlowLCATypeProperty.id
	categorySystem: stdCategoryPkg.#FlowLCATypeCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#FlowLCATypeCategorySystemEnum
	}
}

#FlowLCATypeProperty: #RegistryProp... & {
	id: "5cc54527-0cb9-4180-82cc-d13240e94e50"
	name: "flow LCA type"
	type: "categorical"
	context: ["exchange"]
}

#FlowIOTypeValue: #CategoricalPropWithSystem... & {
	property: #FlowIOTypeProperty.id
	categorySystem: stdCategoryPkg.#FlowIOTypeCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#FlowIOTypeCategorySystemEnum
	}
}

#FlowIOTypeProperty: #RegistryProp... & {
	id: "42b3c201-539f-4891-97cc-66156ac53083"
	name: "flow input-output type"
	type: "categorical"
	context: ["exchange"]
}

#ElementaryFlowDirectionValue: #CategoricalPropWithSystem... & {
	property: #ElementaryFlowDirectionProperty.id
	categorySystem: stdCategoryPkg.#ElementaryFlowDirectionCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#ElementaryFlowDirectionCategorySystemEnum
	}
}

#ElementaryFlowDirectionProperty: #RegistryProp... & {
	id: "735f3642-52b0-4f1c-90b3-78b0f7bafbeb"
	name: "elementary flow direction"
	type: "categorical"
	context: ["exchange"]
}

#CarbonOriginValue: #CategoricalPropWithSystem... & {
	property: #CarbonOriginProperty.id
	categorySystem: stdCategoryPkg.#CarbonOriginCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#CarbonOriginCategorySystemEnum
	}
}

#CarbonOriginProperty: #RegistryProp... & {
	id: "c5c68857-fb07-46b8-8f0a-da499c4937df"
	name: "carbon origin"
	type: "categorical"
	context: ["flow"]
}

#ValidityValue: #CompositePropBase... & {
	property: #ValidityProperty.id
	properties: [#ValidFromValue, #ValidUntilValue]
}

#ValidityProperty: #RegistryProp... & {
	id: "6ee6a892-7c74-432f-a65d-261691d9f562"
	name: "validity"
	type: "composite"
	context: ["process"]
}

#ValidFromValue: #CategoricalProp... & {
	property: #ValidFromProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: utilsPkg.#Date
	}
}

#ValidFromProperty: #RegistryProp... & {
	id: "406bf044-7c7d-4a66-af04-4e19b1296cf3"
	name: "valid from"
	type: "categorical"
	context: ["process"]
}

#ValidUntilValue: #CategoricalProp... & {
	property: #ValidUntilProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: utilsPkg.#Date
	}
}

#ValidUntilProperty: #RegistryProp... & {
	id: "68e86569-fe18-4283-9a6a-4b9e4246021f"
	name: "valid until"
	type: "categorical"
	context: ["process"]
}


// Quantity kind transformation properties

#QuantityKindTransformationConstruct: #QuantitativeProp... & {
	unitTransformation!: {
		from!: unitPkg.#Dimensionality
		to!: unitPkg.#Dimensionality
	}
}

#QuantityKindTransformationPropertyBase: #RegistryProp... & {
	type!: "quantitative"
	context: ["flow"]
}

#QuantityKindTransformationValue: #QuantityKindTransformationConstruct... & {
	property: #QuantityKindTransformationProperty.id
}

#QuantityKindTransformationProperty: #QuantityKindTransformationPropertyBase... & {
	id: "44dbceee-8310-4ed5-b520-9f0638025a06"
	name: "quantity kind"
	type!: "quantitative"
	context: ["flow"]
}

#DensityValue: #QuantitativeProp... & {
	property: #DensityProperty.id
	densityBasis: "bulk" | "apparent" | "basic" | "dry" | "loose" | "gas" | "unspecified"
	unitTransformation!: {
		from!: #VolumeDimensionality
		to!: #MassDimensionality
	}
}

#DensityProperty: #QuantityKindTransformationPropertyBase... & {
	id: "2aa79563-670b-448a-9edf-28f4954dfc74"
	name: "density"
	type!: "quantitative"
	context: ["flow"]
}

#EnergyContentValue: #QuantitativeProp... & {
	property: #EnergyContentProperty.id
	energyMeasure: "net calorific value" | "gross calorific value" | "unspecified"
	unitTransformation!: {
		from!: #MassDimensionality
		to!: #EnergyDimensionality
	}
}

#EnergyContentProperty: #QuantityKindTransformationPropertyBase... & {
	id: "5ac08789-7f70-439a-b60e-18c0d612d4ac"
	name: "energy content"
	type!: "quantitative"
	context: ["flow"]
}


// Quantitative properties

#VarianceValue: #QuantitativeProp... & {
	property: #VarianceProperty.id
}

#VarianceProperty: #RegistryProp... & {
	id: "6cb57f90-10b6-406c-8d19-ac777ec074fa"
	name: "variance"
	type: "quantitative"
	context: ["exchange", "parameter"]
}

#PriceValue: #QuantitativeProp... & {
	property: #PriceProperty.id
}

#PriceProperty: #RegistryProp... & {
	id: "2c74cc35-dcef-4f9e-bda0-89d275526454"
	name: "price"
	type: "quantitative"
	context: ["flow"]
}

#MolarMassValue: #QuantitativeProp... & {
	property: #MolarMassProperty.id
}

#MolarMassProperty: #RegistryProp... & {
	id: "1eabd6d5-adc3-4e72-8430-a9679630abf8"
	name: "molar mass"
	type: "quantitative"
	context: ["flow"]
}

#DryMassValue: #QuantitativeProp... & {
	property: #DryMassProperty.id
}

#DryMassProperty: #RegistryProp... & {
	id: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
	name: "dry mass"
	type: "quantitative"
	context: ["flow"]
}

#WaterContentValue: #QuantitativeProp... & {
	property: #WaterContentProperty.id
}

#WaterContentProperty: #RegistryProp... & {
	id: "a9358458-9724-4f03-b622-106eda248916"
	name: "water content"
	type: "quantitative"
	context: ["flow"]
}

#NonFossilCarbonContentValue: #QuantitativeProp... & {
	property: #NonFossilCarbonContentProperty.id
}

#NonFossilCarbonContentProperty: #RegistryProp... & {
	id: "6393c14b-db78-445d-a47b-c0cb866a1b25"
	name: "carbon content, non-fossil"
	type: "quantitative"
	context: ["flow"]
}

#WetMassValue: #QuantitativeProp... & {
	property: #WetMassProperty.id
}

#WetMassProperty: #RegistryProp... & {
	id: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
	name: "wet mass"
	type: "quantitative"
	context: ["flow"]
}

#FossilCarbonContentValue: #QuantitativeProp... & {
	property: #FossilCarbonContentProperty.id
}

#FossilCarbonContentProperty: #RegistryProp... & {
	id: "c74c3729-e577-4081-b572-a283d2561a75"
	name: "carbon content, fossil"
	type: "quantitative"
	context: ["flow"]
}

#WaterInWetMassValue: #QuantitativeProp... & {
	property: #WaterInWetMassProperty.id
}

#WaterInWetMassProperty: #RegistryProp... & {
	id: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
	name: "water in wet mass"
	type: "quantitative"
	context: ["flow"]
}

#ProductionVolumeValue: #QuantitativeProp... & {
	property: #ProductionVolumeProperty.id
}

#ProductionVolumeProperty: #RegistryProp... & {
	id: "b3b96e47-db1f-496c-b73d-55b91716a5e7"
	name: "production volume"
	type: "quantitative"
	context: ["exchange"]
}

#MarketCoverageValue: #QuantitativeProp... & {
	property: #MarketCoverageProperty.id
}

#MarketCoverageProperty: #RegistryProp... & {
	id: "542f6612-0aa9-4d52-82c0-7bb0f6c21d19"
	name: "market coverage"
	type: "quantitative"
	context: ["process"]
}

#ContentBasis: 
	"mass fraction" |
	"dry-mass fraction" |
	"wet-mass fraction" |
	"total content" |
	"fossil fraction" |
	"non-fossil fraction"

#FractionBasisValue: #QuantitativeProp... & {
	property: #FractionBasisProperty.id
	contentBasis: #ContentBasis
}

#FractionBasisProperty: #RegistryProp... & {
	id: "ceda76c8-b912-471c-bdea-6722b1a9dec3"
	name: "fraction basis"
	type: "quantitative"
	context: ["flow"]
}

#ContentValue: #QuantitativeProp... & {
	property: #ContentProperty.id
	substance: utilsPkg.#NonEmptyString
	contentBasis?: #ContentBasis
}

#ContentProperty: #RegistryProp... & {
	id: "69bbe11a-4501-41ba-b3bf-2271e2ad155f"
	name: "content"
	type: "quantitative"
	context: ["flow"]
}

#ConcentrationValue: #QuantitativeProp... & {
	property: #ConcentrationProperty.id
	substance: utilsPkg.#NonEmptyString
	fractionContext?: #ContentBasis
}

#ConcentrationProperty: #RegistryProp... & {
	id: "4fdbc2e4-439f-4f9f-9efe-3494f8693658"
	name: "concentration"
	type: "quantitative"
	context: ["flow"]
}

#QuantityAsUnitValue: #QuantitativeProp... & {
	property: #QuantityAsUnitProperty.id
}

#QuantityAsUnitProperty: #RegistryProp... & {
	id: "d22b9834-9137-4e0b-81bd-eb174e716117"
	name: "as unit"
	type: "quantitative"
	context: ["flow"]
}

#FuelUseValue: #QuantitativeProp... & {
	property: #FuelUseProperty.id
}

#FuelUseProperty: #RegistryProp... & {
	id: "f765f62d-81e0-4072-8c5f-e5ee771cb63d"
	name: "fuel use"
	type: "quantitative"
	context: ["flow"]
}

#CapacityValue: #QuantitativeProp... & {
	property: #CapacityProperty.id
}

#CapacityProperty: #RegistryProp... & {
	id: "d1a05915-1dd0-44b0-bc1b-f389e2ac3e52"
	name: "capacity"
	type: "quantitative"
	context: ["flow"]
}


// Classification properties

#CopernicusLandUseClassificationValue: #CategoricalPropWithSystem... & {
	property: #CopernicusLandUseClassificationProperty.id
	categorySystem: stdCategoryPkg.#CopernicusLandUseClassificationSystem.id
}

#CopernicusLandUseClassificationProperty: #RegistryProp... & {
	id: "5ca53a8e-426c-484d-aa48-d3e91730bd9b"
	name: "Copernicus CORINE land-cover classification"
	type: "categorical"
	context: ["flow"]
}

#CPCCategoryValue: #CategoricalPropWithSystem... & {
	property: #CPCProperty.id
	categorySystem: stdCategoryPkg.#CPCClassificationSystem.id
}

#CPCProperty: #RegistryProp... & {
	id: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
	name: "CPC classification"
	type: "categorical"
	context: ["flow"]
}

#ISICRev4CategoryValue: #CategoricalPropWithSystem... & {
	property: #ISICRev4Property.id
	categorySystem: stdCategoryPkg.#ISICRev4ClassificationSystem.id
}

#ISICRev4Property: #RegistryProp... & {
	id: "a158ab98-408a-430e-9cba-4bce9b85b9e1"
	name: "ISIC Rev. 4 classification"
	type: "categorical"
	context: ["process"]
}


// Identification properties

#ChemicalFormulaValue: #CategoricalProp... & {
	property: #ChemicalFormulaProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: utilsPkg.#NonEmptyString
	}
}

#ChemicalFormulaProperty: #RegistryProp... & {
	id: "ed3b8a28-02a1-4a78-95d5-b6b1c3910d23"
	name: "chemical formula"
	type: "categorical"
	context: ["flow"]
}

#CASNumberValue: #CategoricalPropWithSystem... & {
	property: #CASNumberProperty.id
	categorySystem: stdCategoryPkg.#CASNumberCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: string & =~stdCategoryPkg.#CASNumberCategorySystem.labelPattern
	}
}

#CASNumberProperty: #RegistryProp... & {
	id: "55e46169-4f58-4204-a574-20703fdc02c4"
	name: "CAS number"
	type: "categorical"
	context: ["flow"]
}

#ECNumberValue: #CategoricalPropWithSystem... & {
	property: #ECNumberProperty.id
	categorySystem: stdCategoryPkg.#ECNumberCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: string & =~stdCategoryPkg.#ECNumberCategorySystem.labelPattern
	}
}

#ECNumberProperty: #RegistryProp... & {
	id: "54bd63a4-d728-4081-9f0b-58de4976e11c"
	name: "EC number"
	type: "categorical"
	context: ["flow"]
}


// ecoinvent properties

#EcoinventSpecialActivityTypeValue: #CategoricalPropWithSystem... & {
	property: #SpecialActivityTypeProperty.id
	categorySystem: stdCategoryPkg.#EcoinventSpecialActivityTypeCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#EcoinventSpecialActivityTypeCategorySystemEnum
	}
}

#SpecialActivityTypeProperty: #RegistryProp... & {
	id: "da8735d7-e473-4c5b-8532-25bc40aba761"
	name: "special activity type"
	type: "categorical"
	context: ["process"]
}

#EcoinventInheritanceDepthValue: #CategoricalPropWithSystem... & {
	property: #InheritanceDepthProperty.id
	categorySystem: stdCategoryPkg.#EcoinventInheritanceDepthCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#EcoinventInheritanceDepthCategorySystemEnum
	}
}

#InheritanceDepthProperty: #RegistryProp... & {
	id: "85194c11-6de9-4272-a7ff-c64aa0bea6ea"
	name: "inheritance depth"
	type: "categorical"
	context: ["process"]
}

#EcoinventTechnologyLevelValue: #CategoricalPropWithSystem... & {
	property: #TechnologyLevelProperty.id
	categorySystem: stdCategoryPkg.#EcoinventTechnologyLevelCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#EcoinventTechnologyLevelCategorySystemEnum
	}
}

#TechnologyLevelProperty: #RegistryProp... & {
	id: "ffb442e6-9601-417e-b8f5-08061ed41441"
	name: "technology level"
	type: "categorical"
	context: ["process"]
}

#EcoinventEnergyBasisValue: #CategoricalPropWithSystem... & {
	property: #EnergyValueBasisProperty.id
	categorySystem: stdCategoryPkg.#EcoinventEnergyValueBasisCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: stdCategoryPkg.#EcoinventEnergyValueBasisCategorySystemEnum
	}
}

#EnergyValueBasisProperty: #RegistryProp... & {
	id: "b97e1868-4c04-4d7e-bd0c-45c79ddc8299"
	name: "energy value basis"
	type: "categorical"
	context: ["process"]
}

#EcoinventMacroEconomicScenarioCategoryValue: #CategoricalPropWithSystem... & {
	property: #EcoinventMacroEconomicScenarioProperty.id
	categorySystem: stdCategoryPkg.#EcoinventMacroEconomicScenarioRegistry.id
}

#EcoinventMacroEconomicScenarioProperty: #RegistryProp... & {
	id: "a4146cc4-35d8-4a5e-8c75-9d3b717b4a24"
	name: "macroeconomic scenario"
	type: "categorical"
	context: ["productionSystem", "processInstance"]
}

#EcoinventActivityNameIdentityValue: #CategoricalPropWithSystem... & {
	property: #EcoinventActivityNameIdentityProperty.id
	categorySystem: stdCategoryPkg.#EcoinventActivityNameRegistry.id
}

#EcoinventActivityNameIdentityProperty: #RegistryProp... & {
	id: "c1df2e5f-15a7-433f-a7cb-9e41add21c57"
	name: "ecoinvent activity-name identity"
	type: "categorical"
	context: ["process"]
}

#EcoinventIntermediateFlowIdentityValue: #CategoricalPropWithSystem... & {
	property: #EcoinventIntermediateFlowIdentityProperty.id
	categorySystem: stdCategoryPkg.#EcoinventIntermediateFlowRegistry.id
}

#EcoinventIntermediateFlowIdentityProperty: #RegistryProp... & {
	id: "0f21f048-7d0d-43df-a54a-716397a7fba6"
	name: "ecoinvent intermediate-flow identity"
	type: "categorical"
	context: ["flow"]
}

#EcoinventElementaryFlowIdentityValue: #CategoricalPropWithSystem... & {
	property: #EcoinventElementaryFlowIdentityProperty.id
	categorySystem: stdCategoryPkg.#EcoinventElementaryFlowRegistry.id
}

#EcoinventElementaryFlowIdentityProperty: #RegistryProp... & {
	id: "86ff6198-5381-46ec-b250-c3fb405b3303"
	name: "ecoinvent elementary-flow identity"
	type: "categorical"
	context: ["flow"]
}

#EcoinventByProductClassificationValue: #CategoricalPropWithSystem... & {
	property: #EcoinventByProductClassificationProperty.id
	categorySystem: stdCategoryPkg.#EcoinventByProductClassificationSystem.id
}

#EcoinventByProductClassificationProperty: #RegistryProp... & {
	id: "d695f836-5059-4e63-b6f0-bd093bc0e7f8"
	name: "by-product classification"
	type: "categorical"
	context: ["flow"]
}


// Pedigree Matrix

#PedigreeMatrixCategoryValue: #CategoricalPropWithSystem... & {
	property: #PedigreeMatrixProperty.id
	categorySystem: stdCategoryPkg.#EcoinventPedigreeMatrixCategorySystem.id
	value: categoryPkg.#SingleCategory... & {
		label: string & =~stdCategoryPkg.#EcoinventPedigreeMatrixCategorySystem.labelPattern
	}
}

#PedigreeMatrixProperty: #RegistryProp... & {
	id: "63435e58-cd43-4c7b-a916-b49bdf2aef49"
	name: "pedigree matrix"
	type: "categorical"
	context: ["exchange", "parameter"]
}

#PedigreeScore: int & >=1 & <=5

#PedigreeMatrixPropertyConstructor: {
	id: utilsPkg.#UUID
	values: [#PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore]
	_id: id
	_values: values
	_label: "\(_values[0])\(_values[1])\(_values[2])\(_values[3])\(_values[4])"

	property: #PedigreeMatrixCategoryValue... & {
		id: _id
		value: {label: _label}
	}
}

#AdditionalVarianceWithPedigreeValue: #QuantitativeProp... & {
	property: #AdditionalVarianceWithPedigreeProperty.id
}

#AdditionalVarianceWithPedigreeProperty: #RegistryProp... & {
	id: "24964ee1-b167-4921-90d9-1b7aa18394ae"
	name: "additional variance from pedigree matrix"
	type: "quantitative"
	context: ["exchange", "parameter"]
}

// 0 = reliability, 1 = completeness, 2 = temporal correlation, 3 = geographical correlation, 4 = further technological correlation
#AdditionalVarianceMatrix: [
	[0.0, 0.0005951200299200359, 0.002271007593583191, 0.008310287517942792, 0.04110048847329133],
	[0.0, 0.00009803601195785114, 0.0005951200299200359, 0.002271007593583191, 0.008310287517942792],
	[0.0, 0.0002184306974886829, 0.002271007593583191, 0.008310287517942792, 0.04110048847329133],
	[0.0, 0.00002475227102187641, 0.00009803601195785114, 0.0005951200299200359, 0.002271007593583191],
	[0.0, 0.0005951200299200359, 0.008310287517942792, 0.04110048847329133, 0.12011325347955039],
]

#PedigreeVarianceLookup: {
	values: [#PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore]
	amount: 
		#AdditionalVarianceMatrix[0][values[0]-1] +
		#AdditionalVarianceMatrix[1][values[1]-1] +
		#AdditionalVarianceMatrix[2][values[2]-1] +
		#AdditionalVarianceMatrix[3][values[3]-1] +
		#AdditionalVarianceMatrix[4][values[4]-1]
}

#AdditionalVarianceWithPedigreeConstructor: {
	id: utilsPkg.#UUID
	unitId: utilsPkg.#UUID
	values: [#PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore, #PedigreeScore]

	_id: id
	_unitId: unitId
	_values: values

	_variance: #PedigreeVarianceLookup... & {
		values: _values
	}

	property: #AdditionalVarianceWithPedigreeValue... & {
		id: _id
		value: quantityPkg.#SingleQuantity & {
			amount: _variance.amount
			unit: _unitId
		}
	}
}


// Allocation: Process partition allocation < flow partition allocation < causal flow allocation.

#EcoinventAppliedAllocationPrincipleValue: #CategoricalPropWithSystem... & {
	property: #AppliedAllocationPrincipleProperty.id
	categorySystem: stdCategoryPkg.#EcoinventSystemModelRegistry.id
}

#AppliedAllocationPrincipleProperty: #RegistryProp... & {
	id: "9767911c-ab5d-4eff-b150-215ca2a2ecb9"
	name: "allocation model"
	type: "categorical"
	context: ["productionSystem"]
}

#IsAvoidedProductionValue: #CategoricalProp... & {
	property: #IsAvoidedProductionProperty.id
	exchangeId: referencePkg.#ExchangeReference
	allocationType!: "substitution"
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsAvoidedProductionProperty: #RegistryProp... & {
	id: "b520224b-590c-45b5-bd61-f824858a3028"
	name: "is avoided production"
	type: "categorical"
	context: ["processInstance"]
}

#IsMarginalSupplierValue: #CategoricalProp... & {
	property: #IsMarginalSupplierProperty.id
	exchangeId: referencePkg.#ExchangeReference
	marketProcessId: referencePkg.#ProcessReference
	allocationType!: "substitution"
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsMarginalSupplierProperty: #RegistryProp... & {
	id: "7c6f3b95-cfcc-4eb2-9b0c-22e980499f19"
	name: "is marginal supplier"
	type: "categorical"
	context: ["processInstance"]
}

#CausalAllocationValue: #QuantitativeProp... & {
	property: #CausalAllocationProperty.id
	allocationType!: "causal"
	referenceFlowId: referencePkg.#FlowReference
}

#CausalAllocationProperty: #RegistryProp... & {
	id: "6d02f6e6-9fe6-491f-a6bd-9d3e1a5b5a9b"
	name: "specific causal allocation"
	type: "quantitative"
	context: ["exchange"]
}

#CausalAllocationCompositeValue: #CompositePropBase... & { // Declared for intermediate exchanges
	property: #CausalAllocationCompositeProperty.id
	properties: [#CausalAllocationValue, ...#CausalAllocationValue]
}

#CausalAllocationCompositeProperty: #RegistryProp... & { // Overwrites process allocation.
	id: "460627ce-15f9-4139-92ff-6099137aa6f6"
	name: "causal allocation"
	type: "composite"
	context: ["exchange"]
}

#PartitionAllocationValue: #QuantitativeProp... & { // Declared for reference exchanges
	property: #PartitionAllocationProperty.id
	allocationType!: "partition"
}

#PartitionAllocationProperty: #RegistryProp... & {
	id: "0ff19c18-de70-4a64-a595-ac569b94b06e"
	name: "partition allocation"
	type: "categorical"
	context: ["exchange"]
}


// Context property for elementary flows. Context of the emission or resource

#ElementaryFlowContextValue: #CompositePropBase... & {
	property: #ElementaryFlowContextProperty.id
	properties: [#ElementaryFlowContextValues, ...#ElementaryFlowContextValues]
}

#ElementaryFlowContextProperty: #RegistryProp... & {
	id: "5119af08-62a1-4cb3-aa30-527cd72b5d90"
	name: "elementary flow context"
	type: "composite"
	context: ["exchange"]
}

#ElementaryFlowContextValues: 
	#MajorElementaryFlowContextValue |
	#AirAtmosphericReleaseHeightElementaryFlowContextValue |
	#AirSettlementTypeElementaryFlowContextValue |
	#SoilTypeElementaryFlowContextValue |
	#NaturalResourceTypeElementaryFlowContextValue |
	#NaturalResourceRenewabilityElementaryFlowContextValue |
	#NaturalResourceLocaleElementaryFlowContextValue |
	#WaterTypeElementaryFlowContextValue |
	#EcoinventElementaryFlowContextValue

#MajorElementaryFlowContextValue: #CategoricalProp... & {
	property: #MajorElementaryFlowContextProperty.id
}

#MajorElementaryFlowContextProperty: #RegistryProp... & {
	id: "35478f20-e60e-4aad-82a9-1fcf0f4aea98"
	name: "major elementary flow context"
	type: "categorical"
	context: ["exchange"]
}

#AirAtmosphericReleaseHeightElementaryFlowContextValue: #CategoricalProp... & {
	property: #AirAtmosphericReleaseHeightElementaryFlowContextProperty.id
}

#AirAtmosphericReleaseHeightElementaryFlowContextProperty: #RegistryProp... & {
	id: "f84fa310-200d-4359-bc12-7b99c4659ec6"
	name: "atmospheric release height"
	type: "categorical"
	context: ["exchange"]
}

#AirSettlementTypeElementaryFlowContextValue: #CategoricalProp... & {
	property: #AirSettlementTypeElementaryFlowContextProperty.id
}

#AirSettlementTypeElementaryFlowContextProperty: #RegistryProp... & {
	id: "9398d975-d406-4276-9755-8c01804a9d61"
	name: "settlement type"
	type: "categorical"
	context: ["exchange"]
}

#SoilTypeElementaryFlowContextValue: #CategoricalProp... & {
	property: #SoilTypeElementaryFlowContextProperty.id
}

#SoilTypeElementaryFlowContextProperty: #RegistryProp... & {
	id: "67bba357-b663-452c-874e-4f0c063a3647"
	name: "soil compartment type"
	type: "categorical"
	context: ["exchange"]
}

#NaturalResourceTypeElementaryFlowContextValue: #CategoricalProp... & {
	property: #NaturalResourceTypeElementaryFlowContextProperty.id
}

#NaturalResourceTypeElementaryFlowContextProperty: #RegistryProp... & {
	id: "5027f4e3-6af1-47c9-b151-12088a5200b0"
	name: "natural resource compartment type"
	type: "categorical"
	context: ["exchange"]
}

#NaturalResourceRenewabilityElementaryFlowContextValue: #CategoricalProp... & {
	property: #NaturalResourceRenewabilityElementaryFlowContextProperty.id
}

#NaturalResourceRenewabilityElementaryFlowContextProperty: #RegistryProp... & {
	id: "85b28e60-bd7b-4d15-92b6-c6e59a2ae9eb"
	name: "natural resource renewability"
	type: "categorical"
	context: ["exchange"]
}

#NaturalResourceLocaleElementaryFlowContextValue: #CategoricalProp... & {
	property: #NaturalResourceLocaleElementaryFlowContextProperty.id
}

#NaturalResourceLocaleElementaryFlowContextProperty: #RegistryProp... & {
	id: "9da994fa-37bc-4020-b0f7-121e6da6c3d6"
	name: "natural resource locale"
	type: "categorical"
	context: ["exchange"]
}

#WaterTypeElementaryFlowContextValue: #CategoricalProp... & {
	property: #WaterTypeElementaryFlowContextProperty.id
}

#WaterTypeElementaryFlowContextProperty: #RegistryProp... & {
	id: "8868d6d3-6776-443b-90eb-c9ad9119348b"
	name: "water compartment type"
	type: "categorical"
	context: ["exchange"]
}

#EcoinventElementaryFlowContextValue: #CategoricalPropWithSystem... & {
	property: #EcoinventElementaryFlowContextProperty.id
	categorySystem: stdCategoryPkg.#EcoinventElementaryFlowContextRegistry.id
}

#EcoinventElementaryFlowContextProperty: #RegistryProp... & {
	id: "51d9968a-d5d3-41e7-9fcd-f127f54ab761"
	name: "ecoinvent elementary flow context"
	type: "categorical"
	context: ["exchange"]
}


// Temporal scope. For processes, this indicates the time spend to make the process. For flows, this indicates the frequency of the flow entry

#DurationValue: #QuantitativeProp... & {
	property: #DurationProperty.id
}

#DurationProperty: #RegistryProp... & {
	id: "4e598c59-fec6-412d-9227-2c7929ce1985"
	name: "duration"
	type: "quantitative"
	context: ["exchange", "process"]
}

#FrequencyValue: #QuantitativeProp... & {
	property: #FrequencyProperty.id
}

#FrequencyProperty: #RegistryProp... & {
	id: "af945329-fd8d-4d5c-921e-bdb86385674e"
	name: "frequency"
	type: "quantitative"
	context: ["exchange"]
}

#LifetimeValue: #QuantitativeProp... & {
	property: #LifetimeProperty.id
}

#LifetimeProperty: #RegistryProp... & {
	id: "e5de893a-3c8d-465c-84d6-c8098112c9a8"
	name: "lifetime"
	type: "quantitative"
	context: ["flow", "process"]
}


// Geographical scope. It is a location and a semantic family. It is a location in the sense that it does not characterize an emission. Geographical scopes are different for elementary flows, intermediate flows and processes

#GeographicalScopeValue: #CompositePropBase... & {
	property: #GeographicalScopeProperty.id
	properties: [#GeographicalScopeSingleValues, ...#GeographicalScopeSingleValues]
}

#GeographicalScopeProperty: #RegistryProp... & {
	id: "99a6248f-dbb0-49dc-a4ad-23abab6ba25f"
	name: "geographical scope"
	type: "composite"
	context: ["exchange", "process"]
}

#GeographicalScopeSingleValues: 
	#PoliticalBoundaryGeographicalScopeValue |
	#TerrestrialEcoregionGeographicalScopeValue |
	#WatershedGeographicalScopeValue |
	#GroundwaterGeographicalScopeValue |
	#FishingAreaGeographicalScopeValue |
	#MarineEcosystemGeographicalScopeValue |
	#GeographicalScopeFromFileValue |
	#EcoinventGeographicalScopeValue |
	#IsEcoinventRestOfWorldValue |
	#GeographicalCoordinatesValue |
	#ExtensionCategoricalProperty


#EcoinventGeographicalScopeValue: #CategoricalPropWithSystem... & {
	property: #EcoinventGeographicalScopeProperty.id
	categorySystem: stdCategoryPkg.#EcoinventGeographyRegistry.id
}

#EcoinventGeographicalScopeProperty: #RegistryProp... & {
	id: "107b99d0-ba7e-4825-b1c7-e4a25f2bfd08"
	name: "ecoinvent geographical scope"
	type: "categorical"
	context: ["exchange", "process"]
}

#IsEcoinventRestOfWorldValue: #CategoricalProp... & {
	property: #IsEcoinventRestOfWorldProperty.id
	value: categoryPkg.#SingleCategory... & {
		label: bool
	}
}

#IsEcoinventRestOfWorldProperty: #RegistryProp... & {
	id: "51d34877-ad44-47b9-b157-12b8b05f8c3b"
	name: "is ecoinvent RoW (rest-of-world)"
	type: "categorical"
	context: ["process"]
}

#PoliticalBoundaryGeographicalScopeValue: #CategoricalProp... & {
	property: #PoliticalBoundaryGeographicalScopeProperty.id
}

#PoliticalBoundaryGeographicalScopeProperty: #RegistryProp... & {
	id: "b629e5bf-48a8-4410-9103-f5cda1d9f729"
	name: "political boundary"
	type: "categorical"
	context: ["exchange", "process"]
}

#TerrestrialEcoregionGeographicalScopeValue: #CategoricalProp... & {
	property: #TerrestrialEcoregionGeographicalScopeProperty.id
}

#TerrestrialEcoregionGeographicalScopeProperty: #RegistryProp... & {
	id: "a01a14d1-6bdd-4d7f-86a6-64022e5823e0"
	name: "terrestrial ecoregion"
	type: "categorical"
	context: ["exchange"]
}

#WatershedGeographicalScopeValue: #CategoricalProp... & {
	property: #WatershedGeographicalScopeProperty.id
}

#WatershedGeographicalScopeProperty: #RegistryProp... & {
	id: "b1f3624f-17d8-483e-9d4a-1ad4ea1c99a9"
	name: "watershed"
	type: "categorical"
	context: ["exchange"]
}

#GroundwaterGeographicalScopeValue: #CategoricalProp... & {
	property: #GroundwaterGeographicalScopeProperty.id
}

#GroundwaterGeographicalScopeProperty: #RegistryProp... & {
	id: "9d88b924-2962-43a9-b5de-efac371d6df7"
	name: "groundwater body"
	type: "categorical"
	context: ["exchange"]
}

#FishingAreaGeographicalScopeValue: #CategoricalProp... & {
	property: #FishingAreaGeographicalScopeProperty.id
}

#FishingAreaGeographicalScopeProperty: #RegistryProp... & {
	id: "69ef1630-cf9b-49af-88a0-3d7c8c9f88a3"
	name: "fishing area"
	type: "categorical"
	context: ["exchange"]
}

#MarineEcosystemGeographicalScopeValue: #CategoricalProp... & {
	property: #MarineEcosystemGeographicalScopeProperty.id
}

#MarineEcosystemGeographicalScopeProperty: #RegistryProp... & {
	id: "e8e13fcc-d4ad-4503-b0fe-4714e470ef57"
	name: "marine ecosystem"
	type: "categorical"
	context: ["exchange"]
}

#GeographicalScopeFromFileValue: #CategoricalProp... & {
	property: #GeographicalScopeFromFileProperty.id
	delimiterFile: referencePkg.#ExternalFileReference
}

#GeographicalScopeFromFileProperty: #RegistryProp... & {
	id: "47552ded-44d4-43ed-83c3-24fd00d750a7"
	name: "scope from file"
	type: "categorical"
	context: ["exchange", "process"]
}

#GeographicalCoordinatesValue: #CompositePropBase... & {
	property: #GeographicalCoordinatesProperty.id
	properties: [#LatitudeValue, #LongitudeValue]
}

#GeographicalCoordinatesProperty: #RegistryProp... & {
	id: "4ffc2088-6a3e-406b-aa61-aec116a66df1"
	name: "geographical coordinates"
	type: "composite"
	context: ["exchange", "process"]
}

#LatitudeValue: #QuantitativeProp... & {
	property: #LatitudeProperty.id
}

#LatitudeProperty: #RegistryProp... & {
	id: "60ae2f04-4ecb-4427-a00d-ed5b03a995f8"
	name: "latitude"
	type: "quantitative"
	context: ["exchange", "process"]
}

#LongitudeValue: #QuantitativeProp... & {
	property: #LongitudeProperty.id
}

#LongitudeProperty: #RegistryProp... & {
	id: "9d8898f8-8cd7-49f7-b63e-1ed7ec315423"
	name: "longitude"
	type: "quantitative"
	context: ["exchange", "process"]
}


// Catalog

#StandardPropertyRegistryEntries: [
	#CopernicusLandUseClassificationProperty
	#TechnologyLevelProperty
	#ChemicalFormulaProperty
	#PriceProperty
	#MolarMassProperty
	#IsDataValidForEntirePeriodProperty
	#EnergyValueBasisProperty
	#EcoinventActivityNameIdentityProperty
	#EcoinventIntermediateFlowIdentityProperty
	#EcoinventElementaryFlowIdentityProperty
	#SpecialActivityTypeProperty
	#InheritanceDepthProperty
	#EcoinventMacroEconomicScenarioProperty
	#DryMassProperty
	#WaterContentProperty
	#NonFossilCarbonContentProperty
	#WetMassProperty
	#FossilCarbonContentProperty
	#WaterInWetMassProperty
	#EcoinventByProductClassificationProperty
	#CPCProperty
	#ISICRev4Property
	#PedigreeMatrixProperty
	#AdditionalVarianceWithPedigreeProperty
	#VarianceProperty
	#QuantityKindTransformationProperty
	#AppliedAllocationPrincipleProperty
	#IsAvoidedProductionProperty
	#IsMarginalSupplierProperty
	#CausalAllocationProperty
	#CausalAllocationCompositeProperty
	#PartitionAllocationProperty
	#CASNumberProperty
	#ECNumberProperty
	#ProductionVolumeProperty
	#CarbonOriginProperty
	#FractionBasisProperty
	#ContentProperty
	#ConcentrationProperty
	#QuantityAsUnitProperty
	#FuelUseProperty
	#CapacityProperty
	#DensityProperty
	#EnergyContentProperty
	#MarketCoverageProperty
	#ProcessLCATypeProperty
	#FlowLCATypeProperty
	#FlowIOTypeProperty
	#IsReferenceProperty
	#IsInfrastructureProperty
	#ElementaryFlowDirectionProperty
	#ElementaryFlowContextProperty
	#MajorElementaryFlowContextProperty
	#AirAtmosphericReleaseHeightElementaryFlowContextProperty
	#AirSettlementTypeElementaryFlowContextProperty
	#SoilTypeElementaryFlowContextProperty
	#NaturalResourceTypeElementaryFlowContextProperty
	#NaturalResourceRenewabilityElementaryFlowContextProperty
	#NaturalResourceLocaleElementaryFlowContextProperty
	#WaterTypeElementaryFlowContextProperty
	#EcoinventElementaryFlowContextProperty
	#GeographicalScopeProperty
	#PoliticalBoundaryGeographicalScopeProperty
	#TerrestrialEcoregionGeographicalScopeProperty
	#WatershedGeographicalScopeProperty
	#GroundwaterGeographicalScopeProperty
	#FishingAreaGeographicalScopeProperty
	#MarineEcosystemGeographicalScopeProperty
	#GeographicalScopeFromFileProperty
	#EcoinventGeographicalScopeProperty
	#IsEcoinventRestOfWorldProperty
	#ValidityProperty
	#ValidFromProperty
	#ValidUntilProperty
	#DurationProperty
	#FrequencyProperty
	#LifetimeProperty
	#LongitudeProperty
	#LatitudeProperty
	#GeographicalCoordinatesProperty
]

#StandardPropertyRegistryById: {
	for registryEntry in #StandardPropertyRegistryEntries {
		"\(registryEntry.id)": registryEntry
	}
}

#StandardPropertyRegistry: {
	I=id: utilsPkg.#UUID
	#StandardPropertyRegistryById[I]
}

#StandardPropertyValues: [
	#CopernicusLandUseClassificationValue
	#EcoinventTechnologyLevelValue
	#ChemicalFormulaValue
	#PriceValue
	#MolarMassValue
	#IsDataValidForEntirePeriodValue
	#EcoinventEnergyBasisValue
	#EcoinventActivityNameIdentityValue
	#EcoinventIntermediateFlowIdentityValue
	#EcoinventElementaryFlowIdentityValue
	#EcoinventSpecialActivityTypeValue
	#EcoinventInheritanceDepthValue
	#EcoinventMacroEconomicScenarioCategoryValue
	#DryMassValue
	#WaterContentValue
	#NonFossilCarbonContentValue
	#WetMassValue
	#FossilCarbonContentValue
	#WaterInWetMassValue
	#EcoinventByProductClassificationValue
	#CPCCategoryValue
	#ISICRev4CategoryValue
	#PedigreeMatrixCategoryValue
	#AdditionalVarianceWithPedigreeValue
	#VarianceValue
	#QuantityKindTransformationValue
	#EcoinventAppliedAllocationPrincipleValue
	#IsAvoidedProductionValue
	#IsMarginalSupplierValue
	#CausalAllocationValue
	#CausalAllocationCompositeValue
	#PartitionAllocationValue
	#CASNumberValue
	#ECNumberValue
	#ProductionVolumeValue
	#CarbonOriginValue
	#FractionBasisValue
	#ContentValue
	#ConcentrationValue
	#QuantityAsUnitValue
	#FuelUseValue
	#CapacityValue
	#DensityValue
	#EnergyContentValue
	#MarketCoverageValue
	#ProcessLCATypeValue
	#FlowLCATypeValue
	#FlowIOTypeValue
	#IsReferenceValue
	#IsInfrastructureValue
	#ElementaryFlowDirectionValue
	#ElementaryFlowContextValue
	#MajorElementaryFlowContextValue
	#AirAtmosphericReleaseHeightElementaryFlowContextValue
	#AirSettlementTypeElementaryFlowContextValue
	#SoilTypeElementaryFlowContextValue
	#NaturalResourceTypeElementaryFlowContextValue
	#NaturalResourceRenewabilityElementaryFlowContextValue
	#NaturalResourceLocaleElementaryFlowContextValue
	#WaterTypeElementaryFlowContextValue
	#EcoinventElementaryFlowContextValue
	#GeographicalScopeValue
	#PoliticalBoundaryGeographicalScopeValue
	#TerrestrialEcoregionGeographicalScopeValue
	#WatershedGeographicalScopeValue
	#GroundwaterGeographicalScopeValue
	#FishingAreaGeographicalScopeValue
	#MarineEcosystemGeographicalScopeValue
	#GeographicalScopeFromFileValue
	#EcoinventGeographicalScopeValue
	#IsEcoinventRestOfWorldValue
	#ValidityValue
	#ValidFromValue
	#ValidUntilValue
	#DurationValue
	#FrequencyValue
	#LifetimeValue
	#LongitudeValue
	#LatitudeValue
	#GeographicalCoordinatesValue
]

#StandardPropertyValueById: {
	for propertyValue in #StandardPropertyValues {
		"\(propertyValue.property)": propertyValue
	}
}

#StandardProperty: {
	P=property: utilsPkg.#UUID
	#StandardPropertyValueById[P]
}

#StandardPropertyIds: [
	for registryEntry in #StandardPropertyRegistryEntries {
		registryEntry.id
	}
]

#StandardPropertyId: or(#StandardPropertyIds)

#ExtensionPropertyRegistry: #RegistryProp... & {
	id: #ExtensionPropertyId
}

#ExtensionCategoricalProperty: #CategoricalProp... & {
	property: #ExtensionPropertyId
}

#ExtensionQuantitativeProperty: #QuantitativeProp... & {
	property: #ExtensionPropertyId
}

#ExtensionCompositeProperty: #CompositePropBase... & {
	property: #ExtensionPropertyId
	properties: #PropertyList
}

#ExtensionProperty:
	#ExtensionCategoricalProperty |
	#ExtensionQuantitativeProperty |
	#ExtensionCompositeProperty

