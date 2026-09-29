package registry_example

import (
	registryPkg "example.com/lca_format/cue_schemas:registry"
	asPkg "example.com/lca_format/cue_schemas:actors_and_sources"
	propertyPkg "example.com/lca_format/cue_schemas:properties"
	quantityPkg "example.com/lca_format/cue_schemas:quantities"
	referencePkg "example.com/lca_format/cue_schemas:references"
	stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"
	stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
	unitPkg "example.com/lca_format/cue_schemas:units"
)

registry: registryPkg.#RegistryDataSet & {
	id: "6c2868ee-becc-4d3d-a843-327eb4dda312"
	datasetType: "registry"
	fileInformation: {
		downloadableURI: "https://example.com/file_47a414cc-d22d-48f1-a393-9614d41cc312"
		versioning: {
			datasetVersion: "0.1.0"
			schemaVersion: "0.1.0"
		}
		timestamp: {
			creation: "2026-08-01T21:08:00Z"
			lastEdit: "2026-08-01T21:09:00Z"
		}
	}
	actors: [
		asPkg.#Actor & {
			actorType: "organization"
			id: "c4597934-ecac-422c-b431-382e85fdcb83"
			name: "ecoinvent System"
			emails: ["mailto:support@ecoinvent.org"]
		}
		asPkg.#Actor & {
			actorType: "individual"
			id: "35d091e9-38c2-4037-9efe-a73673c57123"
			name: "Emilia Moreno Ruiz"
			emails: ["mailto:moreno@ecoinvent.org"]
		}
		asPkg.#Actor & {
			actorType: "individual"
			id: "f48a446f-c675-4da4-a835-637f2eb8250f"
			name: "Jens Lansche"
			emails: ["mailto:jens.lansche@art.admin.ch"]
		}
		asPkg.#Actor & {
			actorType: "individual"
			id: "f86c02d3-2c12-4c25-ad03-33af05bcfe63"
			name: "Tereza Levova"
			emails: ["mailto:levova@ecoinvent.org"]
		}
		asPkg.#Actor & {
			actorType: "individual"
			id: "c69691d9-f8ab-40f4-a00e-72e5024c924d"
			name: "Fernando Dias"
			emails: ["mailto:fernando.dias@embrapa.br"]
		}
		asPkg.#Actor & {
			actorType: "organization"
			id: "bbf9cfb4-e253-4419-9d84-f206a3b64de7"
			name: "ecoinvent"
			identifiers: [
				{
					system: "ecoinvent company code"
					value: "ECOINV"
				}
			]
		}
		asPkg.#Actor & {
			actorType: "software"
			id: "adaad100-7a7f-4442-a3c9-9d49f82bb2df"
			websites: ["https://support.ecoinvent.org/ecoeditor"]
			name: "EcoEditor"
			version: "3.8.600.15190"
		}
	]
	sources: [
		asPkg.#Source & {
			sourceType: "bibo:Document"
			id: "9c08da7f-924e-4455-a312-37a346693cb5"
			title: "Published source associated with the ecoinvent dataset"
			authors: [{name: "Marília Ieda da Silveira Folegatti"}]
			year: "2018"
		}
	]
	categories: [
		stdCategoryPkg.#BCP47ReferenceSystem
		stdCategoryPkg.#UCUMReferenceSystem
		stdCategoryPkg.#ProcessLCATypeCategorySystem
		stdCategoryPkg.#EcoinventSpecialActivityTypeCategorySystem
		stdCategoryPkg.#EcoinventInheritanceDepthCategorySystem
		stdCategoryPkg.#ISICRev4ClassificationSystem
		stdCategoryPkg.#EcoinventMacroEconomicScenarioRegistry
		stdCategoryPkg.#CPCClassificationSystem
		stdCategoryPkg.#CopernicusLandUseClassificationSystem
		stdCategoryPkg.#CASNumberCategorySystem
		stdCategoryPkg.#CarbonOriginCategorySystem
		stdCategoryPkg.#FlowLCATypeCategorySystem
		stdCategoryPkg.#FlowIOTypeCategorySystem
		stdCategoryPkg.#ElementaryFlowDirectionCategorySystem
		stdCategoryPkg.#EcoinventByProductClassificationSystem
		stdCategoryPkg.#EcoinventPedigreeMatrixCategorySystem
		referencePkg.#RegistryReference & {
			id: "d11d8db1-8e7d-4041-baff-7ebd0d2fca68"
			uri: "https://unstats.un.org/unsd/methodology/m49/"
			name: "UN M49 Code"
		}
		stdCategoryPkg.#EcoinventActivityNameRegistry
		stdCategoryPkg.#EcoinventIntermediateFlowRegistry
		stdCategoryPkg.#EcoinventSystemModelRegistry
	]
	flowables: [
		{
			id: "75168394-3da2-467a-90a1-285836ccd00d"
			name: "fertilising"
			properties: [
				propertyPkg.#CategoricalProperty & {
					id: "e578e867-b8b8-4e0f-a3bc-696dc29ca962"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by broadcaster"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "bd7c9b5d-22ad-4530-ad81-0b7bdfbc1e01"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
			]
		}
		{
			id: "6c365ae3-f8cb-4aff-8709-afea7fbf0a40"
			name: "sowing"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "e26c2d95-72e6-40b9-a1f9-0d640eaf813f"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
			]
		}
		{
			id: "1ff576ab-ba77-45cd-af5a-97708507cc75"
			name: "wood preservation"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "2de00cb2-b7ef-48d0-a6af-f248f715c030"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "54730", label: "Painting services"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "31b4f9aa-e276-4bbc-aae5-7ee5f5ff9c94"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "vacuum pressure method"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "4ec924ad-c7ba-4055-9dcf-cd53495bbc15"
					property: "57699a84-f17a-4519-a13c-80d70863939c"
					value: {label: "inorganic salt"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "6fb74f2b-29ed-4d3c-86ce-3e8b500e6138"
					property: "046a28ed-64e2-4d47-8920-c0324df9a54c"
					value: {label: true}
				}
				propertyPkg.#CategoricalProperty & {
					id: "e3fdc59a-f1ce-452b-a578-073f34036f5b"
					property: "fe667082-cd51-44f0-80c7-f711ba036239"
					value: {label: "outdoor use"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "5de073ad-7b2d-49c9-b69c-200c61352f76"
					property: "8711d627-f93c-4744-ad86-cd54c5cbfb31"
					value: {label: true}
				}
			]
		}
		{
			id: "3473bca6-5172-44d2-bda1-1f681e891ca8"
			name: "roundwood"
			properties: [
				stdPropertyPkg.#DryMassValue & {
					id: "16dcb096-3f87-4c89-bca2-1f6a93fb946d"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 825, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "6057d51d-2269-4191-9f12-b202f462836f"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0.5, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "b19fa83d-0be8-4994-9e06-4ec9c97b69ec"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.494, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "c7fa2616-a81f-4c94-a91b-875af7e294ef"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1237.5, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "4db4bbfa-7488-460f-bc36-6cbb1194666e"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "abbdce9d-bb05-4f09-bbb7-b95ee8fa81c6"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 412.5, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "c90def53-ce7d-44e2-b3ae-a506def63b84"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "031", label: "Wood in the rough"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "c1dc6017-e87b-45a5-b2dd-a24f21568153"
					property: "f72415d0-4aa4-48cf-ad89-667c909a2c78"
					value: {label: "eucalyptus ssp."}
				}
				propertyPkg.#CategoricalProperty & {
					id: "c57d43c0-4ef8-4cc2-90dc-b251c9f69445"
					property: "b2c28059-bc36-40df-b17d-8db569524486"
					value: {label: "sustainable forest management"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "994fcb57-7204-420f-a06e-161b100493d3"
					property: "03be1550-380a-4c7c-8300-ceebc07bd0ae"
					value: {label: "under bark"}
				}
			]
		}
		{
			id: "479ce50b-7465-4ee0-ada2-81418055c725"
			name: "mowing"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "c219b25d-c91e-40b4-ae02-1903d555c8b4"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "0ea17a24-15a8-46af-9248-c5bb60fabfdc"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by rotary mower"}
				}
			]
		}
		{
			id: "5f281e36-7bea-464e-b77c-83befc5332ae"
			name: "weed control"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "8f68b2af-6ffb-4a36-8783-7e901cb6828f"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86122", label: "Support services to farm animal husbandry"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "7841c45d-c9bc-4ff1-8d8d-f951e66b6056"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by brush cutter"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "8a1139db-077f-4df5-9f4d-d4b08518ee98"
					property: "cbb61eb8-7db7-409e-a2a0-98ba73f942be"
					value: {label: "pasture"}
				}
			]
		}
		{
			id: "f054b1e6-24cd-4d22-a001-1271cfa17a83"
			name: "limestone and gypsum application"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "e9d09296-0bc7-41f6-837a-3c4257b34327"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "c972dc29-6427-45bb-bda1-48e2dc74eb39"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by spreader"}
				}
			]
		}
		{
			id: "edcaa476-a810-42b5-bbf4-1220d8658c4a"
			name: "tillage, harrowing"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "0a79bd76-6ede-4e7f-838c-5c248748914d"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "fe7bbefe-4c14-4066-81c6-dc4ca13f8268"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by offset leveling disc harrow"}
				}
			]
		}
		{
			id: "2f618520-1bd4-440c-84cd-045335db2e6c"
			name: "tillage, harrowing"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "39afb89e-b8b3-4a64-ae59-adc9ad3bdb4e"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "86119", label: "Other support services to crop production"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "6be1e46c-d047-4bca-b175-2132eca3fb1c"
					property: "6ef56398-2da0-4ce0-a687-01e377445e8c"
					value: {label: "by offset disk harrow"}
				}
			]
		}
		{
			id: "4a62806e-17d6-473e-95fc-394ac760261e"
			name: "weaned heifers"
			properties: [
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "f0b99952-ac11-4567-b544-f028eef6d650"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "fossil carbon content on a dry matter basis"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "86a5a32d-f543-4b0d-8a0e-616c0f897523"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#ResultingQuantity & {parameter: referencePkg.#ParameterReference & {parameterId: "2093f354-aa6c-485c-9f85-17faec7646af", fileId: "b53dfab0-08c7-419f-94f7-26ef02013c70"}}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "a80e8338-ac9a-449a-835b-9f20290d60bf"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0.4, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "water content on a wet matter basis"}]
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "e686af0d-bfb8-4aa6-8dde-f5a53133b069"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.4928, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "biogenic carbon content on a dry matter basis"}]
				}
				stdPropertyPkg.#EnergyContentValue & {
					id: "2b01c769-951a-43de-9bc3-aef175cb89a9"
					property: "5ac08789-7f70-439a-b60e-18c0d612d4ac"
					energyMeasure: "gross calorific value"
					unitTransformation: {
						from: {mass: 1}
						to: {length: 2, mass: 1, time: -2}
					}
					value: quantityPkg.#SingleQuantity & {amount: 14.937, unit: "980b811e-3905-4797-82a5-173f5568bc7e"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "226f2ddb-7eca-4a7e-9a2a-b31d6610dc44"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "2778ea02-cd00-407e-9754-98983db110ca"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#ResultingQuantity & {parameter: referencePkg.#ParameterReference & {parameterId: "c2939b4c-8dd3-434b-b04a-6c94b863d9ff", fileId: "b53dfab0-08c7-419f-94f7-26ef02013c70"}}
					comments: [{text: "water content on a dry matter basis"}]
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "e2534c50-5745-47c1-aaeb-ffe4c5c95351"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "02111", label: "Cattle"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "43a9be4a-e684-4da7-88be-5c2837982bed"
					property: "ff07f4dc-e88e-4a9d-921c-58306f557ebf"
					value: {label: "live weight"}
				}
			]
		}
		{
			id: "d7432632-40dc-4af8-8125-cb70dd9742c5"
			name: "iron scrap"
			properties: [
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "4b238222-379e-4876-8fd7-248fd3b610c8"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "03754964-3cd9-48d5-9a95-51d5614d1097"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "a5f58be4-e617-4f13-b7de-f3dac852b436"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "b5b4e3bc-59c5-4627-a93e-53c62c4d65e3"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "ce0c05eb-b33a-4e83-90cb-cf99149c5553"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "aa2c05f9-1508-41c6-9744-ddcfccf13b6d"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "49a5cb0e-a492-40f3-84b9-6d06674709da"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "39310", label: "Slag, dross, scalings and other waste from the manufacture of iron or steel"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "ce3f66ba-786d-43c0-a15f-e1a84f1eca0c"
					property: "33abdebc-23d7-40be-810a-888552074d52"
					value: {label: "unsorted"}
				}
			]
		}
		{
			id: "7ef961a9-b8c2-425f-8b79-9ad184c86c00"
			name: "wood pole"
			properties: [
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "5a87a79c-dcb0-48f6-b9d0-ff47509d17a8"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0.2, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "7ea6580f-8aae-42b4-94e8-b5898036c489"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "88245644-92d8-4ddb-a553-12cac951816e"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0.25, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "bdf0b296-e006-4f0e-acab-1802d302dc65"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.483675937122128, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "e383782b-4ce9-4d4e-8d1a-3947c13653e5"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "29af7f2a-f01f-4f86-aef5-c7fa5e070481"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 0.8, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "c386aae3-b404-4ba8-a116-a9559af1c085"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "3928", label: "Sawdust and wood waste and scrap"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "b54fd93c-ad43-46fa-9045-780ba37785e0"
					property: "046a28ed-64e2-4d47-8920-c0324df9a54c"
					value: {label: true}
				}
			]
		}
		{
			id: "49719318-578e-40fe-b359-0780c8df9221"
			name: "cattle for slaughtering"
			properties: [
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "66bda67b-f3e3-467c-8e84-f368136218eb"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "e482c707-8f76-46f1-ad0a-ece3bcc689a4"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#EnergyContentValue & {
					id: "96eb07f5-e615-4732-816a-59db78102ba5"
					property: "5ac08789-7f70-439a-b60e-18c0d612d4ac"
					energyMeasure: "gross calorific value"
					unitTransformation: {
						from: {mass: 1}
						to: {length: 2, mass: 1, time: -2}
					}
					value: quantityPkg.#SingleQuantity & {amount: 14.9367, unit: "980b811e-3905-4797-82a5-173f5568bc7e"}
					comments: [{text: "Energy content calculated from animal fat and protein composition and energy content for animal fat and protein of 39.3 and 23.6 MJ/kg, respectively. Johnson, I.R. et al. (2012). J. Anim. Sci. 90(13):4741-475. Williams, C.B. (2005). J. Anim. Sci. 83(6):1262-1266."}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "ae1317a1-a19d-4818-af2f-c49b1719fc34"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#ResultingQuantity & {parameter: referencePkg.#ParameterReference & {parameterId: "9b350867-1023-4a3a-bd71-c90c3df7837f", fileId: "b53dfab0-08c7-419f-94f7-26ef02013c70"}}
					comments: [{text: "Moisture content for generic cattle, empty body live weight, of 40% wet mass."}]
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "d8502d33-51d0-4f85-9277-37e1759c948c"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#ResultingQuantity & {parameter: referencePkg.#ParameterReference & {parameterId: "838f0650-3387-47f4-90fc-3d631810e9a4", fileId: "b53dfab0-08c7-419f-94f7-26ef02013c70"}}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "583a643d-6686-429e-99eb-1049e5ee13bb"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.4928, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "Calculated from live weight empty body composition in fat and protein (Johnson, I.R. et al. (2012). J. Anim. Sci. 90(13):4741-475; Williams, C.B. (2005). J. Anim. Sci. 83(6):1262-1266) and from C content of nutrients (protein, fat) according to A.D. Kay and T. Vrede (\"Evolutionary and Biochemical Aspects\", in Global Ecology, 2010, Elsevier B.V., S.E. Jørgensen Ed.)."}]
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "02e26fc7-aa8b-43e3-a0a0-1bd440785fff"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0.4, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "Moisture content for generic cattle, empty body live weight, of 40% wet mass. Johnson, I.R. et al. (2012). J. Anim. Sci. 90(13):4741-475. Williams, C.B. (2005). J. Anim. Sci. 83(6):1262-1266."}]
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "b7fdf801-45a3-4c2e-b61e-07a7811bc7dd"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "02111", label: "Cattle"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "3afc6d07-af68-4779-bca7-3a8605fa4fcd"
					property: "ff07f4dc-e88e-4a9d-921c-58306f557ebf"
					value: {label: "live weight"}
				}
			]
		}
		{
			id: "dadc7057-9041-4fae-893c-20aba9725f29"
			name: "maize grain"
			properties: [
				stdPropertyPkg.#WetMassValue & {
					id: "3d59abf1-f1ed-43ae-a9ad-4cf30ec08710"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "269bd27e-e550-4379-bda5-4707cc8111b0"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 0.86, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "1189501e-89e2-441a-8f68-a07f06516609"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "707eb9bc-0e39-4ce7-b104-c18a15d49d71"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.46957, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#EnergyContentValue & {
					id: "f9a57fe4-c8e5-4d7e-82c8-91fe0946b1c1"
					property: "5ac08789-7f70-439a-b60e-18c0d612d4ac"
					energyMeasure: "gross calorific value"
					unitTransformation: {
						from: {mass: 1}
						to: {length: 2, mass: 1, time: -2}
					}
					value: quantityPkg.#SingleQuantity & {amount: 15.927, unit: "980b811e-3905-4797-82a5-173f5568bc7e"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "bc9d47ec-f60b-442d-87b2-b9c561f86458"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0.14, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "87cc490d-e262-4316-a303-c26fc818d379"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0.162790697674419, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "14e3f475-a231-4833-b22f-6ceffb980fa6"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "01122", label: "Maize (corn), other"}
				}
			]
		}
		{
			id: "9e0c9c28-7d8f-4f18-a769-bff3a4c8c1e5"
			name: "urea"
			properties: [
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "ab4564ed-f557-4cf3-96b6-fc84210d6782"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "1cd6823c-f73e-4b85-b640-3c8c86859017"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "c17127e5-c287-4527-bac7-b04af065c547"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "86d5cb82-f9b4-4d39-920a-ed3831b09b20"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "5a492e34-7156-452a-b6dd-08b52287197c"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0.2, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "H2NCONH2"}]
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "2733477c-ddc2-4aae-8bd8-a3cd4b6976f1"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "e4c8f863-46c4-42c0-98b2-ed729649c346"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "34611", label: "Urea"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "1937086c-e319-422c-aa50-8f6da7ce65dc"
					property: "9b5001c1-62e9-46f7-b704-4ac355e77255"
					value: {label: "as N"}
				}
			]
		}
		{
			id: "5321a299-0c03-4bfc-9dda-d020456f6b2e"
			name: "phosphate fertiliser"
			properties: [
				stdPropertyPkg.#WetMassValue & {
					id: "82b11bf8-3ee6-4f8e-8847-42000f4ed58c"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "d50c95df-a58d-478f-9ecf-e8bde1543798"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "4b79db28-89a0-4ccf-a864-a3da59fe0296"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "c3ca626b-632c-4197-8971-db6c640c01f3"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "a40a933d-6e48-4fb5-94e9-421a23be8b67"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "9499ea16-b14a-4173-bd7d-8f77f26acffa"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "61200d47-8237-4105-856f-b7a4da7727dd"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "3462", label: "Mineral or chemical fertilizers, phosphatic"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "9f4c9ff4-817c-44e7-acb4-84a1fa338369"
					property: "9b5001c1-62e9-46f7-b704-4ac355e77255"
					value: {label: "as P2O5"}
				}
			]
		}
		{
			id: "22cdac63-419a-4980-ad99-5c0caff0a614"
			name: "soybean meal"
			properties: [
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "fb8c3567-94bc-4c90-9df5-01ca8cb6e176"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0.11, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "295c080e-d7a8-493d-85ba-8990a71d7cd3"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "897dbe0f-4003-41ad-a889-87a709b775ef"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 0.89, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "44a9cf06-ec78-4a41-873b-a2d122ae088b"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0.123595505617978, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#EnergyContentValue & {
					id: "2d101f88-8ca4-44c5-bbb6-ae78ddc0edf2"
					property: "5ac08789-7f70-439a-b60e-18c0d612d4ac"
					energyMeasure: "gross calorific value"
					unitTransformation: {
						from: {mass: 1}
						to: {length: 2, mass: 1, time: -2}
					}
					value: quantityPkg.#SingleQuantity & {amount: 19.7, unit: "980b811e-3905-4797-82a5-173f5568bc7e"}
					comments: [{text: "From https://www.feedipedia.org/node/674, as in 15/nov/2017"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "ed3a6ea6-c413-4ab6-9b52-c7192caafc42"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "74e5401c-389b-4d23-a494-d4aa89d1d7f2"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.475626966292135, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "e9ed10f7-92c3-4b52-ac78-cbdebc0f0e32"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "21920", label: "Flours and meals of oil seeds or oleaginous fruits, except those of mustard"}
				}
			]
		}
		{
			id: "a00b7e35-1bc7-4b73-9df8-05f3dd07ffdb"
			name: "lime"
			properties: [
				stdPropertyPkg.#WetMassValue & {
					id: "7de39364-8716-4c48-84d7-af6900ffdb51"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "c2368f68-a153-4f71-af7d-f922382ef94a"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0.120005355330152, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "CaCO3 (MW=100)"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "316543cb-3657-42bd-a559-aa22ea7f3b65"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "11775ee9-a04d-4a91-b6f9-c87cd83e2e4a"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "6f920f04-23e4-405f-82b6-ac27f8e2e090"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "2da81f5a-d01c-4a21-83bc-ff19b47abe68"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "CaCO3"}]
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "6999029f-1cbd-4b07-b7e1-c11de66a7670"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "161", label: "Chemical and fertilizer minerals"}
				}
			]
		}
		{
			id: "2b12ef70-6607-4c11-9e28-c247ec9b59ce"
			name: "zinc coat"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "8aa3c94b-ddfe-46c0-afb3-ea5206043999"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "39365", label: "Waste and scrap of zinc"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "53da95b7-4df0-4f3a-a5b5-57ae1d021639"
					property: "2d92217c-7513-4aa7-b242-571a7239e60c"
					value: {label: "pieces"}
				}
			]
		}
		{
			id: "7c4dafff-fe18-45c0-92e4-857950032abb"
			name: "potassium fertiliser"
			properties: [
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "cd46631d-b758-4da4-b8dd-b80f69337aae"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "2f05e91e-1b0a-488d-9415-af84c2ffc8fb"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "9e6955d9-872a-4f37-b6d6-d9bccd409604"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#WetMassValue & {
					id: "49031f1a-f5df-43d2-9ab6-4a04f94df9ca"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "ec2f42e8-ac36-49fd-8df5-b790e94b8c62"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "0f82ee72-dbc3-4665-a1e0-414b8a0dc239"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "K2O"}]
				}
				stdPropertyPkg.#CPCCategoryValue & {
					id: "354ba91f-37a6-4329-b165-ce66a7065546"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "3463", label: "Mineral or chemical fertilizers, potassic"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "918c677e-a867-4886-aeba-9197b4b94b0c"
					property: "9b5001c1-62e9-46f7-b704-4ac355e77255"
					value: {label: "as K2O"}
				}
			]
		}
		{
			id: "444d81a0-13e0-41a4-8f63-e691b0133c04"
			name: "wire drawing"
			properties: [
				stdPropertyPkg.#CPCCategoryValue & {
					id: "05328733-595f-4fcb-ac5c-2d4b39a4784e"
					property: "c3988d68-211f-49f4-85c8-cbc47b30f83b"
					value: {code: "89330", label: "Metal forging, pressing, stamping, roll forming and powder metallurgy services"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "fcfc15c3-35dc-4524-8ac2-1bdb37f78c7a"
					property: "3a18db88-e6ac-4807-a0c6-0fd1265dd93e"
					value: {label: "steel"}
				}
			]
		}
		{
			id: "2c126bcc-bb63-4d63-bd72-f02a1e616809"
			name: "land transformation"
			properties: [
				propertyPkg.#CategoricalProperty & {
					id: "76cf8581-968c-4ac2-84e7-a838a19ed6ac"
					property: "25959fc4-848e-48c0-9305-a74c74df923c"
					value: {label: "transformation"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "fa8f7314-1a21-4b31-9451-261c7bc38c49"
					property: "d5b43aa4-6223-4cc9-872b-187bd4bb5cf6"
					value: {label: "from pasture"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "366f7fb7-5958-408e-bd47-39f115d6848d"
					property: "10e5abb5-85a3-4f15-83c7-a4334e0297ad"
					value: {label: "man made"}
				}
				stdPropertyPkg.#CopernicusLandUseClassificationValue & {
					id: "66a45364-c53a-4c44-b986-a3597aa42782"
					property: "5ca53a8e-426c-484d-aa48-d3e91730bd9b"
					value: {code: "231", label: "Pastures"}
				}
			]
		}
		{
			id: "0f440cc0-0f74-446d-99d6-8ff0e97a2444"
			name: "ammonia"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "68d25388-398d-49ea-a1e4-eb204db4a074"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7664-41-7"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "1d7717ce-b5bd-48e2-9c43-fb8f7d737a7a"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "eb4de8ed-426d-40ca-b7bd-e92a8dde78bd"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "e12810ec-ad52-429c-9e0f-e94767171418"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "6826f4bf-ce30-4852-93e0-f1a06cc6aab6"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WetMassValue & {
					id: "3700cf72-5fed-4739-8dfc-a706590fdbd8"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "26769f71-eb23-417f-a5e6-f303a2683745"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "aa7cac3a-3625-41d4-bc54-33e2cf11ec46"
			name: "carbon dioxide"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "7202138b-70dd-465e-a84c-42d7939e556d"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "124-38-9"}
				}
				stdPropertyPkg.#CarbonOriginValue & {
					id: "2c25fbb5-4257-4343-b777-803f12033917"
					property: "c5c68857-fb07-46b8-8f0a-da499c4937df"
					value: {label: "fossil"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "b417c20f-7b78-433e-92ed-4f365bcb5cf3"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0.272916486782489, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "ae1d263c-3a9c-42cf-b35d-ce71940c18e3"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "c18b280c-74ca-4e60-a82c-95148e2b9e3e"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "ed281241-6b3c-4a47-ac57-ce1555fb0cf1"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WetMassValue & {
					id: "c6782cae-4424-491e-91f0-8635339fd976"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "5bb933e3-7b32-4d03-b9f7-78425b08f09b"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "e429b852-e421-4fcb-8a9b-b0241863bfb2"
			name: "cadmium"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "c944ad04-2304-4b19-9f90-6af1325d5138"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7440-43-9"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "57ea3e74-a0d5-41df-8629-93a29cd401b6"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "20dfafcf-7c65-4261-b132-9952b589dbd0"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "67bdd513-4ef8-4ea9-ba00-b732f6f924b1"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "d6dd9515-c144-4092-82fe-850ab35a944b"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "c869c51d-649f-4fb9-aabb-1ae3ce3684cb"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "878cf085-a705-4272-a8b4-389b47d7a63b"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "af83b42f-a4e6-4457-be74-46a87798f82a"
			name: "cadmium"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "24aa08fa-28ac-46fc-a5ae-1188dd51ce91"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "22537-48-0"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "bd7459e1-78db-4509-9284-90db954dfdc0"
					property: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
					value: {label: "ion"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "4c7f4481-dd2a-4af6-93fb-4b5b946760c7"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "05cb6022-d741-4247-baf6-29b78d27fab0"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "fe749de8-263b-455d-8a72-95273252a3b8"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "326a07dd-a7e9-427b-bd58-3085369439a9"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "efcdcd7a-38c6-420e-b3ef-48189913c698"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "340b3177-a92e-4920-8968-80efc997894b"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "7a16b680-6d9a-4db3-a23e-0ec64aca5995"
			name: "land transformation"
			properties: [
				propertyPkg.#CategoricalProperty & {
					id: "265b60a7-52f6-4418-8d5b-47485774ab67"
					property: "d5b43aa4-6223-4cc9-872b-187bd4bb5cf6"
					value: {label: "to pasture"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "9e78153e-66c9-430a-9ee7-2f0213da24e4"
					property: "10e5abb5-85a3-4f15-83c7-a4334e0297ad"
					value: {label: "man made"}
				}
				stdPropertyPkg.#CopernicusLandUseClassificationValue & {
					id: "41c9087f-5482-45d6-bc79-e09a587b0775"
					property: "5ca53a8e-426c-484d-aa48-d3e91730bd9b"
					value: {code: "231", label: "Pastures"}
				}
			]
		}
		{
			id: "e7881581-21b3-4f5c-bd63-6b0684b5e712"
			name: "chromium"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "b3969353-16d5-44a2-87b4-df7423ca9e54"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7440-47-3"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "c90a68ac-4f0e-4da4-a82e-f16a71d583a0"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "60fe5410-a21f-4789-a950-6278fd0dc85e"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "64a39529-b379-47ec-9846-a02441deee99"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "298a83e7-42df-4f9a-8b28-b8a55596eb78"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "5dac9609-ed18-493e-b691-7f5295581948"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "132d39aa-dad3-4988-a793-91c0f11dcc06"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "7e66a41c-d311-4949-bdd8-eef09cdcfa47"
			name: "copper"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "d25f3672-1c61-4914-8a09-53ac75dc78d2"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7440-50-8"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "ea7f27fb-d444-4ec3-8528-f5a44e1f40bf"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "69ac41ae-cc00-483e-b130-e22d8a6cba59"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "925fe9bf-5314-407a-9cea-d18c2304791b"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "8ebc7f1c-6152-43ea-9771-fbe2dcd93a73"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "18aa34d6-2288-4e76-b654-f61ec161bfc7"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "67531786-f4d8-4786-a62e-492fe0ba3817"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "e34d3da4-a3d5-41be-84b5-458afe32c990"
			name: "chromium"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "3c55ee75-afdb-4aa2-9a51-36bc01dd8610"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "16065-83-1"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "40b665cf-11d9-4cb9-855e-09d0b5d919f7"
					property: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
					value: {label: "ion"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "3f4cb98b-9ef3-4f64-8381-c132bca536af"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "d8e2e552-fca6-45e0-843f-c91b49a631b7"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "57a881fb-687b-4c50-9cb7-ee0ff0db49c6"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "fb4da359-a886-462e-bafc-0bbe3c02edf9"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "0f642c55-c6d6-47a8-925a-c27fbb179572"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "25ae5eba-4096-478b-adc0-bc0e06278f40"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "afd6d670-bbb0-4625-9730-04088a5b035e"
			name: "dinitrogen monoxide"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "dc1d9eb3-1354-4d60-86b7-eb746d8ab1a0"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "10024-97-2"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "4b229c20-e115-4adf-8b83-78d31a032db4"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "8962e65b-0b62-421a-a8e9-f58fc54559fe"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "336dc92d-fea2-48c5-a632-ce1dbedc294e"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "5729ac03-d197-4976-bbed-762a59066d5a"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "b72c4804-473e-4ef4-85b7-7743ef227ead"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "e6a9b863-c159-4ac8-820f-b8818330c302"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "6d9550e2-e670-44c1-bad8-c0c4975ffca7"
			name: "copper"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "5d8ea5bf-1013-46e7-a336-134fcd5d6d49"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "17493-86-6"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "02cc4f60-0487-46fb-94af-7cf21b9f1ac4"
					property: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
					value: {label: "ion"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "5f5ab22e-d41a-40f0-88cd-fabd72f4abd6"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "b4cb25a5-d6f7-4eb2-9224-09139c6fdf36"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WetMassValue & {
					id: "2876a151-37ab-42a3-a7d8-9da48a6f090c"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "e0b70b05-5b19-4501-9101-2c17e98cf8a2"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "fc4fbba9-d92a-47bc-9a27-f35f35612bc7"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "fce5c76b-b46d-45cf-a022-6d837377ddda"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "b3ebdcc3-c588-4997-95d2-9785b26b34e1"
			name: "lead"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "69bb57d5-d07e-41ec-91a2-b6cc59a4d209"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7439-92-1"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "0e1e3466-2ccd-48b1-b7dd-7e928d90d87e"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "9f769e69-497f-4286-845f-5564475339a3"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "183c8d8e-61f4-461d-ba12-74e143ce159d"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "044589dc-c2f2-49ad-9461-e3ddd04bfcd0"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "9a72fc4c-438f-42c9-b72d-1a70cae55516"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "611205f1-c257-45fb-b51c-fb312d0c224a"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "b4580545-243d-48d2-a3a0-2633a4f46fb1"
			name: "nickel"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "d36aa6db-1d41-46d8-9e93-4eb961cd1837"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7440-02-0"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "5de9fcd0-c565-40fd-bfe0-887f378c0859"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "0d5ff1cf-1196-4279-a466-397a5c2c4ea2"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "e8e08530-b16f-4acb-b91a-b81baa383fd9"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "72e937c5-06d0-4dba-8a8f-aef9fdf6319e"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "a862208f-1a8e-49be-8bb7-b55c0fb0db1f"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "a3a05de1-cf91-4778-8c59-910f68489d90"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "57bdb443-d4a6-423d-8024-959b8261d02e"
			name: "methane"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "5a8ddf6e-4d7f-46cb-9ad7-990dd84b777f"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "74-82-8"}
				}
				stdPropertyPkg.#CarbonOriginValue & {
					id: "363d1a88-5d13-4281-a159-c8b64c541c55"
					property: "c5c68857-fb07-46b8-8f0a-da499c4937df"
					value: {label: "biogenic"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "493b860a-300c-4648-b4ab-f7e56dcc7665"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "33beb549-d78e-41bb-b5fc-faf2429de7f4"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "780d0c41-edde-4cc4-9927-19c04917981f"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "ff6aa465-e1ff-4ea5-ae63-76dddc3c0085"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "85d79a5a-cce6-4e67-bfd6-2568dd25882d"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0.748686634968048, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "3db36497-1996-46a1-926b-0fb5f854fd6b"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "4010918f-7fd0-4925-8fbb-8fd7a44a806c"
			name: "lead"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "eebbb102-2329-4b94-802b-27a8387210b6"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7439-92-1"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "fcb149ef-36c8-4900-8489-654a09ed443c"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "6e729bc2-7bc1-42fb-a45e-f524552cce96"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "6a3d7570-43e7-41fb-b020-9124666d39e7"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "29a674bd-963d-4dbd-91cc-020123749f36"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "c6446c93-77c9-4f21-a79e-681a88cc2066"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "a6ddba42-a670-4fc1-a351-62b5554f6753"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "b2631209-8374-431e-b7d5-56c96c6b6d79"
			name: "phosphorus"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "f179275d-f0c4-436b-b72c-a3738d6f2721"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7723-14-0"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "db846b98-16b3-48ca-b84d-1ec15894e374"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "97048d31-d9aa-4f81-a04d-da185159bb02"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "710fc721-f498-4a6f-b03d-85b3cc008d48"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "8e43126f-597a-4d6a-88e8-9bb8f50fb8c2"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "50697a70-00e7-4aac-baef-b89c813ac067"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "4c59af33-9b74-4afd-b57a-aa730f82364e"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "b1fca66f-8e83-469a-a7b5-018e14d5d545"
			name: "phosphorus"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "4aa87bf8-8127-44c4-89fd-9efdf845d676"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7723-14-0"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "3ced2c14-744d-451f-a543-a71d5e6ee51a"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "af54cb4d-970c-4f49-ade1-ca3419f9ff8d"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "b9c473a3-7254-4ebb-a77a-ac7e9ca16175"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "c6a19b28-06de-491f-ab2b-e5368fee4a50"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "572c6750-dc32-45e4-ae2c-1a6ad0ed87d6"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "4378b2d2-b7b9-4d3b-9e88-9430e63e033f"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "9798359e-a3ee-4362-a038-23a188582c6e"
			name: "nickel"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "938e54a0-c687-4df6-8a3e-0c34d1a585a3"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "14701-22-5"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "c50aab46-bc76-4b42-8550-abd72a92b93c"
					property: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
					value: {label: "ion"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "1d338e41-9c44-4350-a71d-b3b38baac0ef"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "0f11d238-7c9c-45f4-b177-9922ab3e7ec6"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "6e5d05b8-3139-4092-b856-cb2a91b82136"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "9ab8782a-37d1-41dc-ac53-2c3fde4150eb"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "00ff359d-10c3-4961-bbbd-72f4c40dbc79"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "86ed8021-7062-4b3b-a256-bedcd66009db"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "b9291c72-4b1d-4275-8068-4c707dc3ce33"
			name: "nitrate"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "3b55646c-2fbf-4f33-b89a-1b57d0a4667b"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "14797-55-8"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "a316dd1a-462f-4a5a-b2c4-f608e16b9ef1"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "b08bccc2-df9f-43ec-b452-dfb15f6b7f96"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "76483f03-859c-4a8f-b035-79a8841dc6e5"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "d948ea3d-23f5-433a-8dba-56d20b4a7cd2"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "0a145e70-1a32-45cc-8968-9d34d6270656"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "8caac5fc-9cb7-4e65-8125-15778e631558"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "84aa799e-9d98-4d34-85e0-516d28ab1be9"
			name: "zinc"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "0a48c37d-8472-4573-aff5-af11d8a1c060"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "7440-66-6"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "312c93a3-e80e-48cc-8bb5-29af860a79cf"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#DryMassValue & {
					id: "d61090ea-8c9b-4d5c-89ad-3f97d0386a00"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "34fde6e3-0995-4df1-803b-0d44d6bf7183"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "ce0d341e-e0b6-4e54-babe-a40c04c7c48d"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "57781fab-59a7-4d17-b79e-9917b0a56e1f"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "8349df6f-0bfa-464e-bfc2-2708018ee486"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "77357947-ccc5-438e-9996-95e65e1e1bce"
			name: "nitrogen oxides"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "f9052a7c-1aa5-46e6-bda3-14e8990a22f3"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "11104-93-1"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "b3adc244-18f3-4d90-9a32-9189497c10d9"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "ed8596d5-6d8c-4ed6-9c8e-42eb8b8b6b42"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "b49a60d4-4203-4220-b10f-b3f18ec93717"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "db104d2a-3e8d-49fc-b7e3-32d173ccf4d6"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "a6ee3d1d-b6fa-4b88-94a0-c754ced12fae"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "e3bf987e-69ea-4519-8b1a-4205366bb096"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
		{
			id: "59ded913-17fe-4b3e-80cb-79b97cdbef9a"
			name: "land occupation"
			properties: [
				propertyPkg.#CategoricalProperty & {
					id: "b1c52927-e4db-4136-8da5-b265ce5293fc"
					property: "25959fc4-848e-48c0-9305-a74c74df923c"
					value: {label: "occupation"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "f34ca938-d835-4323-9c12-01c01c2e1f8d"
					property: "10e5abb5-85a3-4f15-83c7-a4334e0297ad"
					value: {label: "man made"}
				}
				stdPropertyPkg.#CopernicusLandUseClassificationValue & {
					id: "4b8004ef-933f-4182-ab34-6fca7df54b44"
					property: "5ca53a8e-426c-484d-aa48-d3e91730bd9b"
					value: {code: "231", label: "Pastures"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "116305e7-9ad8-4c54-bcc0-06bf4d108f9a"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "1d8e1a1f-c323-4ebb-a91a-1e20c1440986"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "09f7c849-abf9-47e4-ac37-00d55be3f161"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "92a12e34-8968-4ab8-9091-78eac2362191"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "3c88a851-8fd5-4c3f-aa99-87b5358344b3"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "01c12fca-ad8b-4902-8b48-2d5afe3d3a0f"
			name: "energy, gross calorific value, in biomass"
			properties: [
				stdPropertyPkg.#WaterContentValue & {
					id: "e35d5e4e-caff-42ac-b89f-bd1ea7e975a4"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "54e7e6c7-16c7-47b5-8a10-b30da5579cc2"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "4901fb4e-b013-4baf-905d-6f2ede08bee1"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "967ec4be-8758-4503-8e7a-bdf6a8da6b8d"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "a1e05891-f107-4b11-86c6-cc6db9f92a44"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
					comments: [{text: "gross calorific value, measured in dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "4e332f5d-ed75-4a0b-8411-0f57198d2025"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
			]
		}
		{
			id: "541b633c-17a3-4047-bce6-0c0e4fdb7c10"
			name: "zinc"
			properties: [
				stdPropertyPkg.#CASNumberValue & {
					id: "67e4da9c-4d58-4f78-ba69-8a1987cdd199"
					property: "55e46169-4f58-4204-a574-20703fdc02c4"
					value: {label: "23713-49-7"}
				}
				propertyPkg.#CategoricalProperty & {
					id: "f7ea01ed-b2b5-41b0-b927-ab1067486223"
					property: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
					value: {label: "ion"}
				}
				stdPropertyPkg.#WaterInWetMassValue & {
					id: "8d7c4b97-4377-4316-ad41-c7ccb111447d"
					property: "6d9e1462-80e3-4f10-b3f4-71febd6f1168"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#NonFossilCarbonContentValue & {
					id: "f16e4279-4928-4616-a17e-409136b217f0"
					property: "6393c14b-db78-445d-a47b-c0cb866a1b25"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WaterContentValue & {
					id: "32043c90-9adc-4a40-92e1-7591ee77bc29"
					property: "a9358458-9724-4f03-b622-106eda248916"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
					comments: [{text: "water mass/dry mass"}]
				}
				stdPropertyPkg.#FossilCarbonContentValue & {
					id: "59ed82ac-95c3-49b4-b60b-302b36296abb"
					property: "c74c3729-e577-4081-b572-a283d2561a75"
					value: quantityPkg.#SingleQuantity & {amount: 0, unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"}
				}
				stdPropertyPkg.#WetMassValue & {
					id: "3dc89ec4-6c5a-447c-ad92-d401fd71c839"
					property: "67f102e2-9cb6-4d20-aa16-bf74d8a03326"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
				stdPropertyPkg.#DryMassValue & {
					id: "f48062e6-7c30-4836-8275-6ddc2def121e"
					property: "3a0af1d6-04c3-41c6-a3da-92c4f61e0eaa"
					value: quantityPkg.#SingleQuantity & {amount: 1, unit: "1629204c-b659-4186-9495-dc257c41fab6"}
				}
			]
		}
	]
	properties: [
		stdPropertyPkg.#ProcessLCATypeProperty
		stdPropertyPkg.#SpecialActivityTypeProperty
		stdPropertyPkg.#InheritanceDepthProperty
		stdPropertyPkg.#ISICRev4Property
		stdPropertyPkg.#DurationProperty
		stdPropertyPkg.#GeographicalScopeProperty
		stdPropertyPkg.#PoliticalBoundaryGeographicalScopeProperty
		stdPropertyPkg.#EcoinventMacroEconomicScenarioProperty
		stdPropertyPkg.#ProductionVolumeProperty
		stdPropertyPkg.#MarketCoverageProperty
		stdPropertyPkg.#CPCProperty
		stdPropertyPkg.#DryMassProperty
		stdPropertyPkg.#WaterContentProperty
		stdPropertyPkg.#FossilCarbonContentProperty
		stdPropertyPkg.#NonFossilCarbonContentProperty
		stdPropertyPkg.#WetMassProperty
		stdPropertyPkg.#WaterInWetMassProperty
		stdPropertyPkg.#EnergyContentProperty
		stdPropertyPkg.#CopernicusLandUseClassificationProperty
		stdPropertyPkg.#CASNumberProperty
		stdPropertyPkg.#CarbonOriginProperty
		stdPropertyPkg.#PedigreeMatrixProperty
		stdPropertyPkg.#AdditionalVarianceWithPedigreeProperty
		stdPropertyPkg.#EcoinventByProductClassificationProperty
		stdPropertyPkg.#FlowLCATypeProperty
		stdPropertyPkg.#FlowIOTypeProperty
		stdPropertyPkg.#IsReferenceProperty
		stdPropertyPkg.#ElementaryFlowDirectionProperty
		stdPropertyPkg.#ElementaryFlowContextProperty
		stdPropertyPkg.#MajorElementaryFlowContextProperty
		stdPropertyPkg.#WaterTypeElementaryFlowContextProperty
		stdPropertyPkg.#NaturalResourceTypeElementaryFlowContextProperty
		stdPropertyPkg.#AirAtmosphericReleaseHeightElementaryFlowContextProperty
		stdPropertyPkg.#AirSettlementTypeElementaryFlowContextProperty
		stdPropertyPkg.#SoilTypeElementaryFlowContextProperty
		{
			id: "6ef56398-2da0-4ce0-a687-01e377445e8c"
			name: "method"
			type: "categorical"
		}
		{
			id: "57699a84-f17a-4519-a13c-80d70863939c"
			name: "wood preservative type"
			type: "categorical"
		}
		{
			id: "046a28ed-64e2-4d47-8920-c0324df9a54c"
			name: "contains chromium"
			type: "categorical"
		}
		{
			id: "fe667082-cd51-44f0-80c7-f711ba036239"
			name: "use environment"
			type: "categorical"
		}
		{
			id: "8711d627-f93c-4744-ad86-cd54c5cbfb31"
			name: "ground contact"
			type: "categorical"
		}
		{
			id: "f72415d0-4aa4-48cf-ad89-667c909a2c78"
			name: "tree species"
			type: "categorical"
		}
		{
			id: "b2c28059-bc36-40df-b17d-8db569524486"
			name: "forest management"
			type: "categorical"
		}
		{
			id: "03be1550-380a-4c7c-8300-ceebc07bd0ae"
			name: "bark condition"
			type: "categorical"
		}
		{
			id: "cbb61eb8-7db7-409e-a2a0-98ba73f942be"
			name: "land use"
			type: "categorical"
		}
		{
			id: "ff07f4dc-e88e-4a9d-921c-58306f557ebf"
			name: "mass basis"
			type: "categorical"
		}
		{
			id: "33abdebc-23d7-40be-810a-888552074d52"
			name: "sorting status"
			type: "categorical"
		}
		{
			id: "9b5001c1-62e9-46f7-b704-4ac355e77255"
			name: "quantity basis"
			type: "categorical"
		}
		{
			id: "2d92217c-7513-4aa7-b242-571a7239e60c"
			name: "form"
			type: "categorical"
		}
		{
			id: "3a18db88-e6ac-4807-a0c6-0fd1265dd93e"
			name: "material"
			type: "categorical"
		}
		{
			id: "25959fc4-848e-48c0-9305-a74c74df923c"
			name: "land-use change type"
			type: "categorical"
		}
		{
			id: "10e5abb5-85a3-4f15-83c7-a4334e0297ad"
			name: "land-use origin"
			type: "categorical"
		}
		{
			id: "d5b43aa4-6223-4cc9-872b-187bd4bb5cf6"
			name: "transformation direction"
			type: "categorical"
		}
		{
			id: "e8a710e0-fd92-4ffc-a3b8-2798a7925597"
			name: "chemical form"
			type: "categorical"
		}
		stdPropertyPkg.#ValidityProperty
		stdPropertyPkg.#ValidFromProperty
		stdPropertyPkg.#ValidUntilProperty
		stdPropertyPkg.#AppliedAllocationPrincipleProperty
	]
	units: [
		unitPkg.#UCUMUnit & {
			id: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
			shortName: "1"
			dimensionality: {}
		}
		unitPkg.#UCUMUnit & {
			id: "1629204c-b659-4186-9495-dc257c41fab6"
			shortName: "kg"
			dimensionality: {
				mass: 1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "235d4569-26e3-4b6f-979d-ff2970ffecd4"
			shortName: "%"
			dimensionality: {}
		}
		unitPkg.#UCUMUnit & {
			id: "644ab3e0-2dcc-4c85-9efa-e21eca141f06"
			shortName: "har"
			semanticName: "ha"
			dimensionality: {
				length: 2
			}
		}
		unitPkg.#UCUMUnit & {
			id: "de5b3c87-0e35-4fb0-9765-4f3ba34c99e5"
			shortName: "m3"
			dimensionality: {
				length: 3
			}
		}
		unitPkg.#UCUMUnit & {
			id: "980b811e-3905-4797-82a5-173f5568bc7e"
			shortName: "MJ"
			dimensionality: {
				length: 2
				mass: 1
				time: -2
			}
		}
		unitPkg.#UCUMUnit & {
			id: "1017f68a-f818-4f9d-a34d-a31e7386f628"
			shortName: "m2"
			dimensionality: {
				length: 2
			}
		}
		unitPkg.#UCUMUnit & {
			id: "9a7feed4-56f4-4376-9834-20bd9f7352ac"
			shortName: "m2.a"
			dimensionality: {
				length: 2
				time: 1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "02ac6827-7736-4992-8642-dc378b62ee41"
			shortName: "mo"
			dimensionality: {
				time: 1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "82b72f26-5c69-45d1-af35-636f27ace152"
			shortName: "kg/har"
			semanticName: "kg N/ha"
			dimensionality: {
				length: -2
				mass: 1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "84f2f281-b9fa-4f2b-9e6f-889e8bdb4edd"
			shortName: "kg/(har.a)"
			semanticName: "kg/ha.yr"
			dimensionality: {
				length: -2
				mass: 1
				time: -1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "fbf8c478-3e3d-4f5b-ae58-ba9619675648"
			shortName: "m"
			dimensionality: {
				length: 1
			}
		}
		unitPkg.#UCUMUnit & {
			id: "834b69cf-03e3-4934-ab30-4f3902159d5c"
			shortName: "mm/a"
			semanticName: "mm/year"
			dimensionality: {
				length: 1
				time: -1
			}
		}
	]
}
