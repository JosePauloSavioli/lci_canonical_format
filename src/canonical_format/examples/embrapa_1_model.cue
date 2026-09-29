package model

import (
	paramPkg "example.com/lca_format/cue_schemas:parameterization"
	quantityPkg "example.com/lca_format/cue_schemas:quantities"
	stdPropertyPkg "example.com/lca_format/cue_schemas:standard_properties"
	stdUncertaintyPkg "example.com/lca_format/cue_schemas:standard_uncertainties"
	referencePkg "example.com/lca_format/cue_schemas:references"
)

model: paramPkg.#ParameterizationDataSet & {
	id: "b53dfab0-08c7-419f-94f7-26ef02013c70"
	datasetType: "parameterization"
	registry: referencePkg.#RegistryFileReference & {fileId: "6c2868ee-becc-4d3d-a843-327eb4dda312"}
	models: [
		{
			id: "b4564dc2-6f34-4c61-97ee-f5950fb70139"
			name: "Process calculations"
			parameters: [
				paramPkg.#SimpleQuantityInput & {
					id: "e4994014-0ba2-4cb8-a95e-2c317265d167"
					name: "nitrogen uptake by plant"
					variableName: "Nuptake_plant"
					entry: quantityPkg.#SingleQuantity & {
						amount: 176.62
						unit: "82b72f26-5c69-45d1-af35-636f27ace152"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 176.62, stdevLog:  0.0244948974}}
					}
					comments: [
						{text: "N taken by plant during its growth. Used in the SQCB-NO3 model for the calculation of leaching of NO3. From Bernardi (2012)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "93e2ae96-24e5-4418-ba85-c12269d69542"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "cfa6212e-b944-45cd-ac12-15104876f54e"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "0b8ec398-8ee5-4213-8719-f31029497870"
					name: "soil eroded"
					variableName: "soil_eroded"
					entry: quantityPkg.#SingleQuantity & {
						amount: 200
						unit: "84f2f281-b9fa-4f2b-9e6f-889e8bdb4edd"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 200, stdevLog:  0.0244948974}}
					}
					comments: [
						{text: "Soil eroded. Used for the calculation of P emissions through water erosion to surface water. From Macedo et al. (2005)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "a82ba457-5a79-4043-b247-c174ab734a16"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "44633212-0753-469a-acd7-015ff62e2604"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "58c6135f-4069-4ffa-88ef-54d21951a142"
					name: "rooting depth"
					variableName: "root_depth"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0.2205
						unit: "fbf8c478-3e3d-4f5b-ae58-ba9619675648"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.2205, stdevLog:  0.0244948974}}
					}
					comments: [
						{text: "Plant rooting depth for pasture. Used in the SQCB-NO3 model for the calculation of leaching of NO3. From Cunha et al. (2010)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "5b9cc4ba-b7ee-4963-85f9-ab32e318d717"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "d1aa42d5-20b5-4aaa-b09b-07b2d2f84684"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "301ca225-47f0-478f-b6bd-a6a54d34cdd2"
					name: "precipitation, annual"
					variableName: "precipitation"
					entry: quantityPkg.#SingleQuantity & {
						amount: 1201.3
						unit: "834b69cf-03e3-4934-ab30-4f3902159d5c"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 1201.3, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Average annual precipitation in the BR-CO geographic region. Used in the SQCB-NO3 model for the calculation of leaching of NO3."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "0942e67b-a137-4207-9d20-8dd71b0c7578"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "333e4ba9-52dd-4961-b9a5-5c25bbbfaf7f"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "2743ad6b-b444-4af2-a9bb-88ee5e84bf9c"
					name: "emission factor N2O"
					variableName: "EF_N2O"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0.02
						unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.02, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Emission factor of N2O from manure deposited in pasture. From IPCC (2006)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "b71c9117-4b39-4c55-9bda-94081797cbcc"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "d429ae5e-3b57-4279-a5b5-5d3d433f7122"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "0ffe7ba5-9c92-4e15-9fe4-381236963e6c"
					name: "dinitrogen monoxide from manure in feedlot"
					variableName: "N2O_feedlot"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
					comments: [
						{text: "N2O from manure management in feedlot, direct and indirect emissions (IPCC 2006)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "6c06adae-e7c9-4b43-bd70-3f210eb8729f"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "a3ffe253-dae6-4c1f-a616-8cc9198a2072"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "b0a3a6fe-a758-4611-8deb-1bfc1dbd12a0"
					name: "clay content into soil"
					variableName: "Clay_content"
					entry: quantityPkg.#SingleQuantity & {
						amount: 53.06
						unit: "235d4569-26e3-4b6f-979d-ff2970ffecd4"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 53.06, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Fraction of clay content into soil. Used in the SQCB-NO3 model for the calculation of leaching of NO3. From Folegatti et al. (2015)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "66a41aa6-8e1a-493b-9f72-17755e69898a"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "2c3f88a9-1a32-4213-b445-f9a7adb257dd"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "d7d655f2-2c83-426a-bc42-31bcd0bcc872"
					name: "nitrogen fertilizer, as N"
					variableName: "N_fert"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#Normal2 & {parameters: {mean: 0, variance: 0.0573}}
					}
					comments: [
						{text: "Nitrogen fertilizer (not urea) for fertilization."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "3e5df49c-5622-4686-954c-749398fe7ea6"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "52570dae-b688-4805-800b-a3a742451147"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "1092ba2a-865d-4b8f-9a0d-fda13574a189"
					name: "nitrogen in crop residues"
					variableName: "Ncrop_residues"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0
						unit: "84f2f281-b9fa-4f2b-9e6f-889e8bdb4edd"
						uncertainty: stdUncertaintyPkg.#Normal2 & {parameters: {mean: 0, variance: 0.0573}}
					}
					comments: [
						{text: "N contained in the crop residues. Used for the calculation of emissions of N2O to the air.  Not considered for pastures because root is semiperennial."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "ed7f7df3-989d-4fde-a6ce-df2f9c42e92e"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "e21adf8d-d1ca-4641-b3ea-e148d5925d12"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "fb5c42f0-8423-4e33-b60a-20ec8c36423a"
					name: "urea, as N, as feed"
					variableName: "N_urea_feed"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0.025553
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.025553, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Urea for cattle feed."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "b67e9d52-ca7e-40b1-b731-62f87fbe320b"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "986a9f6b-669e-4caa-a1d2-29a37922637d"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "a22ddc56-6cb0-49ad-982e-9ed975cc4fb8"
					name: "organic nitrogen into soil"
					variableName: "Norg_soil"
					entry: quantityPkg.#SingleQuantity & {
						amount: 5520.7
						unit: "82b72f26-5c69-45d1-af35-636f27ace152"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 5520.7, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Mass of organic N contained in the upper 50 cm of soil per ha. Used in the SQCB-NO3 model for the calculation of leaching of NO3. From Folegatti et al. (2015)."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "1fae85f2-d0f7-4b68-8b83-a8498294cd0f"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "8620750a-18c8-4253-b9be-b863bea5bd0e"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "851543a1-8d99-432a-a7ba-4b837fa82b10"
					name: "nitrogen in manure on pasture"
					variableName: "N_ex"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0.52146
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: { median: 0.52146, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Manure deposited on pasture, as N, per year and kg of product."}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "f294b8be-ab71-492c-a6ff-dd3be3f15004"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "40a50c43-f6fc-42db-9324-4608a2df104c"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#SimpleQuantityInput & {
					id: "d921d0df-1a27-40cb-b260-69cd61f4fd60"
					name: "urea, as N, as fertilizer"
					variableName: "N_urea_fert"
					entry: quantityPkg.#SingleQuantity & {
						amount: 0.051332
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.051332, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Urea as fertilizer for pasture planting and maintenance. "}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "78eabf21-5782-4c26-ab1d-522adcc44507"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "deaae4a4-8781-4764-b0e7-cf4d844dd7f2"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "cb5ca3dc-cbd9-4c91-8b69-1ba79e87a217"
					name: "total nitrogen"
					variableName: "Ntot"
					formula: "(N_ex + N_urea_fert + N_fert) / T_t"
					expectedUnit: "84f2f281-b9fa-4f2b-9e6f-889e8bdb4edd"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 96.928960638982
						unit: "82b72f26-5c69-45d1-af35-636f27ace152"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 96.928960638982, stdevLog: 0.0244948974}}
					}
					comments: [
						{text: "Total nitrogen in mineral and organic fertilisers (kg N/ha)"}
					]
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "42b9339f-da10-42a0-b136-abf7ddc0f566"
							values: [4, 3, 4, 3, 4]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "a0eb79bd-4800-43a8-b162-e5748d7d814f"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [4, 3, 4, 3, 4]
						}).property
					]
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "cd96e788-b9e5-4f86-bbe4-2586c5c8c7dc"
					variableName: "WOOD"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "c502decc-6431-4ab2-8e00-cf2e30dfdddc"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "2fbb76d7-e054-4ec1-b1d0-40ccf0301ad2"
					variableName: "poles"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "4153292a-25d2-478d-adfe-bb056e5c7fad"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "99ec6ba8-3571-452c-b3d1-3cf7bf2c6206"
					variableName: "WOOD_WWM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "abbdce9d-bb05-4f09-bbb7-b95ee8fa81c6"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "16bc63ec-3163-416d-9435-b58547833003"
					variableName: "BY_PRODUCT"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "9adcc331-af66-4a02-a10d-a464f7ca61fe"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "2093f354-aa6c-485c-9f85-17faec7646af"
					formula: "REF_PRODUCT_VOLUME * (BY_PRODUCT / REF_PRODUCT)"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 2344497372
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "66324321-0ef2-4a05-9c90-891f29ee1642"
					variableName: "BY_PRODUCT_C_content_fossil"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "f0b99952-ac11-4567-b544-f028eef6d650"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "a1af1551-2cb6-4791-a527-af2f2291710c"
					variableName: "BY_PRODUCT_DM"
					formula: "BY_PRODUCT_WM - BY_PRODUCT_WWM"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.6
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "172eb400-56d5-465a-a363-aca66a838b89"
					variableName: "BY_PRODUCT_WWM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "a80e8338-ac9a-449a-835b-9f20290d60bf"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "16b00e3f-8f88-426b-9b8c-5921af844fcc"
					variableName: "BY_PRODUCT_C_content_non_fossil"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "e686af0d-bfb8-4aa6-8dde-f5a53133b069"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "05d29f00-dcef-4af8-83fa-d44b1dd28c45"
					variableName: "BY_PRODUCT_energy_content"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "2b01c769-951a-43de-9bc3-aef175cb89a9"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "594f07c7-9736-4c4a-b2ea-f39a3d6f8569"
					variableName: "BY_PRODUCT_WM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "226f2ddb-7eca-4a7e-9a2a-b31d6610dc44"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "c2939b4c-8dd3-434b-b04a-6c94b863d9ff"
					variableName: "BY_PRODUCT_water_content"
					formula: "BY_PRODUCT_WWM / BY_PRODUCT_DM"
					expectedUnit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.666666666666667
						unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "0d308d3e-36f2-4691-bf7d-a8ecc68e985b"
					variableName: "BY_PRODUCT_3"
					formula: "wire"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.00052917
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "ec7c7f69-6646-4520-ad51-fd2af09e4567"
					variableName: "BY_PRODUCT_3_VOLUME"
					formula: "REF_PRODUCT_VOLUME * ( BY_PRODUCT_3 / REF_PRODUCT)"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 11641528.332
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "b9bbc3a0-f20e-4141-8467-e73f4524df9a"
					variableName: "BY_PRODUCT_1"
					formula: "poles*quantity(1237.5, 'kg/m3')"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 3.7384875e-05
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "91c71307-71b4-41d3-b151-1b82c339bc9c"
					variableName: "BY_PRODUCT_1_VOLUME"
					formula: "REF_PRODUCT_VOLUME * (BY_PRODUCT_1 / REF_PRODUCT)"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 822452.29605
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "bb486ab7-7c2c-4bf6-aa5c-ca7b8cdc5978"
					variableName: "REF_PRODUCT"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "11da3d42-1a11-41d0-bc4d-7421ea4e0b2e"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "36efb3a7-0948-4aaa-9caf-d7d8c6f8fe91"
					variableName: "REF_PRODUCT_VOLUME"
					formula: "quantity(6.79E10, 'kg') * 18/100 * (1 - 10/100) / 0.5"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 21999600000
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "106c9c75-c7c8-463d-a663-6597ade2031b"
					variableName: "REF_PRODUCT_C_content_fossil"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "66bda67b-f3e3-467c-8e84-f368136218eb"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "862bc17b-8d30-4414-9fc8-fa8f96d777dc"
					variableName: "REF_PRODUCT_WM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "e482c707-8f76-46f1-ad0a-ece3bcc689a4"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "d0c52672-c043-4a67-8d1c-6c42850c84e5"
					variableName: "REF_PRODUCT_energy_content"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "96eb07f5-e615-4732-816a-59db78102ba5"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "9b350867-1023-4a3a-bd71-c90c3df7837f"
					variableName: "REF_PRODUCT_DM"
					formula: "REF_PRODUCT_WM - REF_PRODUCT_WWM"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.6
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "838f0650-3387-47f4-90fc-3d631810e9a4"
					variableName: "REF_PRODUCT_water_content"
					formula: "REF_PRODUCT_WWM / REF_PRODUCT_DM"
					expectedUnit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.666666666666667
						unit: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "1dcecbe2-2d75-4296-a582-7f408a14f191"
					variableName: "REF_PRODUCT_C_content_non_fossil"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "583a643d-6686-429e-99eb-1049e5ee13bb"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "ab99ca0c-533d-4ed4-a4b7-0281dd105546"
					variableName: "REF_PRODUCT_WWM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "02e26fc7-aa8b-43e3-a0a0-1bd440785fff"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "f0871429-0fd4-4796-9ce6-0b6e94f9b887"
					variableName: "MAIZE"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "7d1f96bb-1fee-4055-aacc-391d39b6b85f"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "5af7949d-707a-460b-bb06-180406a5779a"
					variableName: "MAIZE_energy_content"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "f9a57fe4-c8e5-4d7e-82c8-91fe0946b1c1"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "73a28464-f107-488c-9aaa-1ca1f8752127"
					variableName: "MAIZE_WWM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "bc9d47ec-f60b-442d-87b2-b9c561f86458"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "f23d0da4-d403-48ef-89f0-e52bbdf9acc4"
					variableName: "MEAL"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "e7673942-5cc4-4013-b6a4-f67e1117a302"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "e9f19189-16cf-4c6f-a0eb-198147078f42"
					variableName: "MEAL_WWM"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "fb8c3567-94bc-4c90-9df5-01ca8cb6e176"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "d20ce91a-36fa-4b12-a221-87dcefd73db7"
					variableName: "MEAL_energy_content"
					entryId: referencePkg.#PropertyInOtherFileReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						propertyId: "2d101f88-8ca4-44c5-bbb6-ae78ddc0edf2"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "cf049fba-1977-4747-88b8-ce52e3fe52e5"
					variableName: "lime"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "36081549-c72b-4da6-97e8-f783906ed2dd"
					}
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "78ec8a38-d703-449c-9ae1-580b2a343834"
					variableName: "wire"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "2fe8daf5-9cb1-4575-8baa-09c5a66cc898"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "0741ee4c-acee-456e-87ba-ef71069da402"
					variableName: "NH3"
					formula: "17/14 * (N_fert*0.20 + N_ex*0.6*0.06)"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.0227952514285714
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.0227952514285714, stdevLog: 0.0894427191}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "b5fb7b48-8417-4bc6-ab59-e72fb9d26333"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "0728fffb-02e4-4836-968b-c79e45bbe0ed"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "f7e0404d-af22-40f3-9366-14aa946087b1"
					variableName: "N2O"
					formula: "N2O_feedlot + 44/28 * ((0.01 * (N_fert + Ncrop_residues * T_t) + 0.01 * 14/17 * NH3 + 0.0075 * 14/62 * NO3) + N_ex * EF_N2O)"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.01853727165264
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.01853727165264, stdevLog: 0.1732}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "6ec163c5-7e28-46ea-833e-276722749aae"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "bdc99085-65c0-407a-9883-2d4094de3b2b"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "49716169-e3c6-4d6c-ae0b-559f7aa83b56"
					variableName: "NO3"
					formula: "T_t * 62/14 * (( quantity(21.37, 'kg/(har.a)') + precipitation / ( Clay_content * root_depth) * (quantity(0.0037, 'a.%.m/mm') * Ntot + quantity(0.0000601, '%.m/mm') * Norg_soil - quantity(0.00362, '%.m/mm') * Nuptake_plant)))"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.696478474498499
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.696478474498499, stdevLog: 0.0244948974}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "0272905a-358c-4303-9bce-33573f5ff27a"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "d2b30097-c9bc-4672-9f5b-a313fbb24862"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityInputFromEntry & {
					id: "b3982b2b-1f15-4bfa-a524-8bca2caa35fc"
					variableName: "T_t"
					entryId: referencePkg.#ExchangeReference & {
						fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
						exchangeId: "77152d21-4377-45c5-a60b-d518e06a23c8"
					}
				}
				paramPkg.#QuantityFormula & {
					id: "b6f5ce00-dd7b-479a-bd54-26c3232db9e4"
					formula: "N_urea_feed + N_urea_fert"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.076885
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.076885, stdevLog: 0.0244948974}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "6676612c-94f9-47cd-a794-1c34a79d47b1"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "7ee716ab-2367-46ce-9e50-ac8f607eeaa9"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "b125d35c-a319-4219-b5d9-ddb2d7729922"
					formula: "T_t / quantity(20, 'a')"
					expectedUnit: "1017f68a-f818-4f9d-a34d-a31e7386f628"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 2.9547
						unit: "1017f68a-f818-4f9d-a34d-a31e7386f628"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 2.9547, stdevLog: 0.0894427191}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "c827215a-95c7-4757-b676-0aced6db97ea"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "c8b6caaa-2d68-4f3c-b732-e81cc9c76fd0"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "8a9beb88-e3ba-43d7-b86c-e072feb802bc"
					formula: "44/12 * 0.13 * lime + 1.57 * N_fert"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.810428666666667
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.810428666666667, stdevLog: 0.0244948974}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "e0fe9738-3c46-4010-a2a0-3df81fa4da0f"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "d609fff2-9f29-4654-9522-88e419b03719"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "7e1078c8-85b7-4a70-92dc-7c9c21264115"
					formula: "T_t * soil_eroded * 0.00095 * 1.86 * 0.2"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.000417676392
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.000417676392, stdevLog: 0.2}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "102b4153-e5d5-48fc-a60c-6d6bf35ca8da"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "8818b10b-1a0d-42d8-90fe-79cb5f579426"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "a522090f-9b3c-422a-b836-2d2b7c74fd5d"
					formula: "N2O*0.21"
					expectedUnit: "1629204c-b659-4186-9495-dc257c41fab6"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 0.0038928270470544
						unit: "1629204c-b659-4186-9495-dc257c41fab6"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 0.0038928270470544, stdevLog: 0.1732050808}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "802b1b22-4bd9-4176-8eb5-546c366f7002"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "116e9b07-0bfc-421b-9f1d-2f37a697d7f2"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
				paramPkg.#QuantityFormula & {
					id: "e32f4297-9ef0-4bb8-bf96-4523eeebf90e"
					formula: "REF_PRODUCT_energy_content + BY_PRODUCT_energy_content * (BY_PRODUCT / REF_PRODUCT) -MAIZE_energy_content * (MAIZE / REF_PRODUCT) - MEAL_energy_content * (MEAL / REF_PRODUCT)"
					expectedUnit: "980b811e-3905-4797-82a5-173f5568bc7e"
					resultingEntry: quantityPkg.#SingleQuantity & {
						amount: 8.66671773
						unit: "980b811e-3905-4797-82a5-173f5568bc7e"
						uncertainty: stdUncertaintyPkg.#LogNormal3 & {parameters: {median: 8.66671773, stdevLog: 0.0244948974}}
					}
					properties: [
						(stdPropertyPkg.#PedigreeMatrixPropertyConstructor & {
							id: "c72a0240-6929-454f-8d0b-b7bcac60fad9"
							values: [3, 3, 4, 3, 2]
						}).property
						(stdPropertyPkg.#AdditionalVarianceWithPedigreeConstructor & {
							id: "02bcad10-7093-4476-8dee-c6fc126fe2c7"
							unitId: "0a37b4cb-85c4-4990-a01f-d0d15b329c94"
							values: [3, 3, 4, 3, 2]
						}).property
					]
				}
			]
		}
	]
	fileInformation: {
		downloadableURI: "https://example.com/file_e3704781-4853-4890-bb4d-3fd159a2e0dd"
		versioning: {
			datasetVersion: "0.1.0"
			schemaVersion: "0.1.0"
		}
		timestamp: {
			creation: "2026-08-01T21:08:00Z"
			lastEdit: "2026-08-01T21:09:00Z"
		}
	}
}

