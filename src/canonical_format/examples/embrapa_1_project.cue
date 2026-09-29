package main_project

import (
	projectPkg "example.com/lca_format/cue_schemas:project"
	referencePkg "example.com/lca_format/cue_schemas:references"
	provenancePkg "example.com/lca_format/cue_schemas:provenance"
	rightsPkg "example.com/lca_format/cue_schemas:rights"
	stdCategoryPkg "example.com/lca_format/cue_schemas:standard_categories"
)

project: projectPkg.#ProjectDataSet & {
	id: "47a414cc-d22d-48f1-a393-9614d41cc312"
	datasetType: "project"
	name: "Pilot project"
	language: {value: "en", referenceSystem: stdCategoryPkg.#BCP47ReferenceSystem.id}
	registry: referencePkg.#RegistryFileReference & {fileId: "6c2868ee-becc-4d3d-a843-327eb4dda312"}
	provenance: {
		activities: [
			provenancePkg.#ReviewActivity & {
				id: "6ab01936-f12f-427c-89a5-60a9bbf4f56a"
				date: {start: "2018-04-15T00:00:00Z"}
				actors: ["c4597934-ecac-422c-b431-382e85fdcb83"]
				activityType: {typeSystem: "standard", value: "dataReview"}
				reviewType: {reviewSystem: "other", value: "ecoinvent automated validation"}
				reviewedVersion: "3.0.1.4"
				comments: [
					{
						text: """
					Validation warnings:
					
					- Mass and/or economic deficit in activity dataset exceeds either 0.1% of input or output sum:
					
					Property 'water in wet mass':
					 - Input='0,063821141625', Output='0,442635476975'
					 - Input < output by 0,37881433535 kg (85,58% of output)
					
					Property 'wet mass':
					 - Input='2,501709525689', Output='3,12336672256043'
					 - Input < output by 0,621657196871432 kg (19,9% of output)
					
					Property 'carbon content, non-fossil':
					 - Input='0,1929596258055', Output='0,674356102233544'
					 - Input < output by 0,481396476428044 kg (71,39% of output)
					
					Property 'dry mass':
					 - Input='2,437888384064', Output='2,68073124558543'
					 - Input < output by 0,242842861521432 kg (9,06% of output)
					
					Property 'carbon content, fossil':
					 - Input='0,219410105132324', Output='0,221179344494484'
					 - Input < output by 0,00176923936215917 kg (0,8% of output)
					
					
					- Due to the use of the reference product property(s) 'energy content' by other exchanges this dataset will be subdivided by linking rule 3 (see Data Quality Guidelines for details) prior to the calculation of the database. If this is not intended, do not use the properties in question in mathematical relations of other exchanges.
					
					- The total water in wet mass of all input exchanges (0,063821141625) and output exchanges (0,442635476975) is unbalanced.
					
					- Uncertainty shall always be provided for all primary data inputs (exchange amounts, properties and parameters), except for the amount and properties of reference products.
					 -- Property(ies): water in wet mass=0,4, energy content=14,937, water content=0,666666666666667, carbon content, non-fossil=0,4928, carbon content, fossil=0, wet mass=1, dry mass=0,6, water in wet mass=0,2, carbon content, non-fossil=0,483675937122128, dry mass=0,8, carbon content, fossil=0, water content=0,25, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, wet mass=1, dry mass=1, water in wet mass=0, wet mass=0, carbon content, non-fossil=0, dry mass=0, carbon content, fossil=0, water in wet mass=0, dry mass=0, carbon content, fossil=0, water content=0, carbon content, non-fossil=0, wet mass=0, wet mass=1, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, water in wet mass=0, water content=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, water in wet mass=0, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, dry mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, wet mass=1, water content=0, wet mass=1, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, carbon content, fossil=0, water content=0, carbon content, fossil=0, water content=0, water in wet mass=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, wet mass=1, water content=0, water in wet mass=0, carbon content, non-fossil=0,748686634968048, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, water content=0, wet mass=1, carbon content, fossil=0, water content=0, dry mass=1, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, dry mass=1, carbon content, fossil=0, water in wet mass=0, water content=0, water in wet mass=0, dry mass=1, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, carbon content, fossil=0, water content=0, wet mass=1, carbon content, non-fossil=0, water content=0, carbon content, non-fossil=0, dry mass=1, carbon content, fossil=0, wet mass=1, water in wet mass=0, water in wet mass=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, wet mass=1, water in wet mass=0, water content=0, dry mass=1, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, fossil=0,272916486782489, water content=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, wet mass=1, water in wet mass=0, carbon content, fossil=0, dry mass=1, carbon content, non-fossil=0
					
					- Pedigree information shall always be provided for all uncertainties of primary data inputs (exchange amounts, properties and parameters), except for the amount and properties of reference products.
					 -- Property(ies): water in wet mass=0,4, energy content=14,937, water content=0,666666666666667, carbon content, non-fossil=0,4928, carbon content, fossil=0, wet mass=1, dry mass=0,6, water in wet mass=0,2, carbon content, non-fossil=0,483675937122128, dry mass=0,8, carbon content, fossil=0, water content=0,25, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, wet mass=1, dry mass=1, water in wet mass=0, wet mass=0, carbon content, non-fossil=0, dry mass=0, carbon content, fossil=0, water in wet mass=0, dry mass=0, carbon content, fossil=0, water content=0, carbon content, non-fossil=0, wet mass=0, wet mass=1, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, water in wet mass=0, water content=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, water in wet mass=0, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, dry mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, wet mass=1, water content=0, wet mass=1, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, carbon content, fossil=0, water content=0, carbon content, fossil=0, water content=0, water in wet mass=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, non-fossil=0, carbon content, fossil=0, dry mass=1, wet mass=1, water content=0, water in wet mass=0, carbon content, non-fossil=0,748686634968048, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, water content=0, wet mass=1, carbon content, fossil=0, water content=0, dry mass=1, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, dry mass=1, carbon content, fossil=0, water in wet mass=0, water content=0, water in wet mass=0, dry mass=1, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, wet mass=1, water in wet mass=0, dry mass=1, carbon content, fossil=0, water content=0, wet mass=1, carbon content, non-fossil=0, water content=0, carbon content, non-fossil=0, dry mass=1, carbon content, fossil=0, wet mass=1, water in wet mass=0, water in wet mass=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, wet mass=1, water in wet mass=0, water content=0, dry mass=1, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, fossil=0,272916486782489, water content=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, wet mass=1, water in wet mass=0, carbon content, fossil=0, dry mass=1, carbon content, non-fossil=0
					"""
					}
				]
			}
			provenancePkg.#ReviewActivity & {
				id: "931dd136-aef2-4308-98ca-b100372e7232"
				date: {start: "2018-04-15T00:00:00Z"}
				actors: ["35d091e9-38c2-4037-9efe-a73673c57123"]
				activityType: {typeSystem: "standard", value: "dataReview"}
				reviewType: {reviewSystem: "other", value: "ecoinvent review"}
				reviewedVersion: "3.0.1.4"
			}
			provenancePkg.#ReviewActivity & {
				id: "59aa6414-7ec8-41c1-94ec-602d76903559"
				date: {start: "2017-12-15T00:00:00Z"}
				actors: ["c4597934-ecac-422c-b431-382e85fdcb83"]
				activityType: {typeSystem: "standard", value: "dataReview"}
				reviewType: {reviewSystem: "other", value: "ecoinvent automated validation"}
				reviewedVersion: "3.0.0.25"
				comments: [
					{
						text: """
					Validation warnings:
					
					- Mass and/or economic deficit in activity dataset exceeds either 0.1% of input or output sum:
					
					Property 'water in wet mass':
					 - Input='0,063821141625', Output='0,442628'
					 - Input < output by 0,378806858375 kg (85,58% of output)
					
					Property 'carbon content, fossil':
					 - Input='0,219410105132324', Output='0,221179344494484'
					 - Input < output by 0,00176923936215917 kg (0,8% of output)
					
					Property 'carbon content, non-fossil':
					 - Input='0,1929596258055', Output='0,674341636501984'
					 - Input < output by 0,481382010696484 kg (71,39% of output)
					
					Property 'dry mass':
					 - Input='2,437888384064', Output='2,68017216768543'
					 - Input < output by 0,242283783621431 kg (9,04% of output)
					
					Property 'wet mass':
					 - Input='2,501709525689', Output='3,12280016768543'
					 - Input < output by 0,621090641996431 kg (19,89% of output)
					
					
					- Property 'price=4,8' of master data exchange was removed from exchange 'weaned heifers, live weight'.
					Amount of property 'water content=0,666666666666667' of exchange 'weaned heifers, live weight' deviates from the default amount in the master file.
					
					- Due to the use of the reference product property(s) 'energy content' by other exchanges this dataset will be subdivided by linking rule 3 (see Data Quality Guidelines for details) prior to the calculation of the database. If this is not intended, do not use the properties in question in mathematical relations of other exchanges.
					
					- The total water in wet mass of all input exchanges (0,063821141625) and output exchanges (0,442628) is unbalanced.
					
					- The dataset contains user added exchange master data entries. The following user added exchanges do not contain product information data. Please consider adding the appropriate data before submitting the dataset for review.
					 - weed control, by brush cutter, pasture
					 - tillage, harrowing, by offset leveling disc harrow
					 - tillage, harrowing, by offset disk harrow
					 - limestone and gypsum application, by spreader
					
					- Uncertainty shall always be provided for all primary data inputs (exchange amounts, properties and parameters), except for the amount and properties of reference products.
					 -- Property(ies): carbon content, fossil=0, carbon content, non-fossil=0,4928, dry mass=0,6, energy content=14,937, water content=0,666666666666667, water in wet mass=0,4, wet mass=1, water in wet mass=0, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=0, wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, wet mass=0, dry mass=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, fossil=0,272916486782489, wet mass=1, dry mass=1, water in wet mass=0, carbon content, fossil=0, water content=0, carbon content, non-fossil=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, water content=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, water content=0, water in wet mass=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, water in wet mass=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, dry mass=1, wet mass=1, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, dry mass=1, wet mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0,748686634968048, water content=0, carbon content, fossil=0, water in wet mass=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, wet mass=1, dry mass=1, water content=0, carbon content, non-fossil=0, water in wet mass=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, fossil=0, water in wet mass=0, carbon content, non-fossil=0, water content=0, wet mass=1, dry mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, water in wet mass=0, wet mass=1, dry mass=1
					
					- Pedigree information shall always be provided for all uncertainties of primary data inputs (exchange amounts, properties and parameters), except for the amount and properties of reference products.
					 -- Property(ies): carbon content, fossil=0, carbon content, non-fossil=0,4928, dry mass=0,6, energy content=14,937, water content=0,666666666666667, water in wet mass=0,4, wet mass=1, water in wet mass=0, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=0, wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, wet mass=0, dry mass=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, carbon content, fossil=0,272916486782489, wet mass=1, dry mass=1, water in wet mass=0, carbon content, fossil=0, water content=0, carbon content, non-fossil=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, water content=0, wet mass=1, dry mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0, water content=0, water in wet mass=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, water in wet mass=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, dry mass=1, wet mass=1, water content=0, carbon content, non-fossil=0, carbon content, fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, water content=0, dry mass=1, wet mass=1, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, water in wet mass=0, dry mass=1, wet mass=1, carbon content, non-fossil=0,748686634968048, water content=0, carbon content, fossil=0, water in wet mass=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, wet mass=1, dry mass=1, water content=0, carbon content, non-fossil=0, water in wet mass=0, carbon content, fossil=0, wet mass=1, dry mass=1, carbon content, fossil=0, water in wet mass=0, carbon content, non-fossil=0, water content=0, wet mass=1, dry mass=1, water in wet mass=0, carbon content, non-fossil=0, carbon content, fossil=0, water content=0, dry mass=1, wet mass=1, water in wet mass=0, water content=0, carbon content, fossil=0, carbon content, non-fossil=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, dry mass=1, wet mass=1, water in wet mass=0, carbon content, non-fossil=0, water content=0, carbon content, fossil=0, dry mass=1, wet mass=1, carbon content, fossil=0, carbon content, non-fossil=0, water content=0, water in wet mass=0, wet mass=1, dry mass=1
					
					- For by-products/wastes, a market activity (currently missing) that supplies the output 'weaned heifers, live weight' must exist for a geographical area and time period including the location and time period of the activity. If the the market dataset is not available the dataset will be put on hold at the end of its review and will remain on hold until such a market dataset has been accepted into the ecoinvent database.
					- The input exchange 'weed control, by brush cutter, pasture' does not have an activity link and therefore requires a market for that input to be available. If the market is not available the dataset will be put on hold at the end of its review and will remain on hold until such a market has been accepted into the ecoinvent database.
					- The input exchange 'tillage, harrowing, by offset leveling disc harrow' does not have an activity link and therefore requires a market for that input to be available. If the market is not available the dataset will be put on hold at the end of its review and will remain on hold until such a market has been accepted into the ecoinvent database.
					- The input exchange 'tillage, harrowing, by offset disk harrow' does not have an activity link and therefore requires a market for that input to be available. If the market is not available the dataset will be put on hold at the end of its review and will remain on hold until such a market has been accepted into the ecoinvent database.
					- The input exchange 'limestone and gypsum application, by spreader' does not have an activity link and therefore requires a market for that input to be available. If the market is not available the dataset will be put on hold at the end of its review and will remain on hold until such a market has been accepted into the ecoinvent database.
					"""
					}
				]
			}
			provenancePkg.#ReviewActivity & {
				id: "d6d69b92-ef69-4842-975f-f5bce27fb2e8"
				date: {start: "2017-08-17T00:00:00Z"}
				actors: ["f48a446f-c675-4da4-a835-637f2eb8250f"]
				activityType: {typeSystem: "standard", value: "dataReview"}
				reviewType: {reviewSystem: "other", value: "ecoinvent review"}
				reviewedVersion: "3.0.0.25"
				comments: [{text: "All comments considered."}]
			}
			provenancePkg.#ReviewActivity & {
				id: "13d450f9-77cd-44b7-965e-7f43db34b25b"
				date: {start: "2017-08-17T00:00:00Z"}
				actors: ["f86c02d3-2c12-4c25-ad03-33af05bcfe63"]
				activityType: {typeSystem: "standard", value: "dataReview"}
				reviewType: {reviewSystem: "other", value: "ecoinvent review"}
				reviewedVersion: "3.0.0.11"
			}
			provenancePkg.#NonReviewActivity & {
				id: "1f8eca66-bf1d-4f15-a051-8a4accfc04b0"
				date: {start: "2018-01-01T00:00:00Z"}
				activityType: {typeSystem: "standard", value: "dataEntry"}
				actors: ["c69691d9-f8ab-40f4-a00e-72e5024c924d"]
			}
			provenancePkg.#NonReviewActivity & {
				id: "647f97a5-68a2-4bf6-8d40-39b4dc83cff4"
				date: {start: "2018-01-01T00:00:00Z"}
				activityType: {typeSystem: "standard", value: "dataGeneration"}
				actors: [
					"c69691d9-f8ab-40f4-a00e-72e5024c924d"
					"adaad100-7a7f-4442-a3c9-9d49f82bb2df"
				]
			}
			provenancePkg.#NonReviewActivity & {
				id: "abb7025c-47aa-4c29-977e-ba2f7d497f48"
				date: {start: "2018-01-01T00:00:00Z"}
				activityType: {typeSystem: "standard", value: "dataPublication"}
				actors: ["c69691d9-f8ab-40f4-a00e-72e5024c924d"]
			}
		]
	}
	rights: rightsPkg.#Rights & {
		copyright: {
			referenceToCopyrightOwner: "bbf9cfb4-e253-4419-9d84-f206a3b64de7"
			referenceToCopyrightStatementURI: "https://support.ecoinvent.org/eula"
		}
		license: {
			licenseType: "ecoinvent End-User License Agreement"
			referenceToLicenseURI: "https://support.ecoinvent.org/eula"
		}
		access: {
			accessModel: "restricted to licensed ecoinvent users"
			referenceToPolicyURI: "https://support.ecoinvent.org/licensing"
			restrictedTo: ["bbf9cfb4-e253-4419-9d84-f206a3b64de7"]
		}
	}
	modelling: {
		samplingComment: "Inventory data for cattle systems obtained from Embrapa’s PECUS Project, literature and expert knowledge. Emissions from the agricultural process estimated according to Nemecek and Schnetzer (2011) and Canals (2003) and other references mentioned."
		extrapolationsComment: "Carbon content, water and gross calorific value are based on ecoinvent database."
	}
	productionSystems: [referencePkg.#ProductionSystemReference & {fileId: "e3704781-4853-4890-bb4d-3fd159a2e0dd"}]
	hashes: [
		{
			file: referencePkg.#RegistryFileReference & {
				fileId: "6c2868ee-becc-4d3d-a843-327eb4dda312"
			}
			hashInformation: {
				hash: {
					algorithm: {typeSystem: "standard", value: "SHA-256"}
					checksum: "d7488e3b542c6a7373f02bcb8660a010bd52d112532a9f587c9e37671c05ea00"
				}
			}
		}
		{
			file: referencePkg.#ProcessReference & {
				fileId: "fd97fd2b-c6c1-482d-9f90-4314950d1a56"
				version: "3.0.27"
			}
			hashInformation: {
				hash: {
					algorithm: {typeSystem: "standard", value: "SHA-256"}
					checksum: "9866ad57de76bdcb1891d3db881383b87c6590755073ecc6ff82ca38fcfb92d5"
				}
			}
		}
		{
			file: referencePkg.#ProductionSystemReference & {
				fileId: "e3704781-4853-4890-bb4d-3fd159a2e0dd"
				version: "0.1.0"
			}
			hashInformation: {
				hash: {
					algorithm: {typeSystem: "standard", value: "SHA-256"}
					checksum: "e0407e10e1511a030aaa2c6d4e4ee7d2ad524fa19bea4e7c04ce66b3a0343114"
				}
			}
		}
		{
			file: referencePkg.#ParameterSystemReference & {
				fileId: "b53dfab0-08c7-419f-94f7-26ef02013c70"
				version: "0.1.0"
			}
			hashInformation: {
				hash: {
					algorithm: {typeSystem: "standard", value: "SHA-256"}
					checksum: "61da1df54078ed009c74950df5e9014b34ed0d4218e5f403cdaf2ddb1e88fd05"
				}
			}
		}
	]
	sourceEntries: [{reference: "9c08da7f-924e-4455-a312-37a346693cb5", role: "main publication"}]
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
}
