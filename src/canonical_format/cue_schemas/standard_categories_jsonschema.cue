@if(jsonschema)

@experiment(explicitopen)

package standard_categories

import utilsPkg "example.com/lca_format/cue_schemas:utils"

#ExtensionCategoryId: utilsPkg.#UUID &
	!="b4500324-3bff-433e-bbd9-4d0d2a6ea8ed" &
	!="08eb4445-1582-4b75-9995-6847ebb2b94b" &
	!="c81a7de5-7176-43b8-b4e7-99c5c29cba2a" &
	!="960925c7-d713-48be-8df3-e025e782779e" &
	!="b5cc481c-d0b4-4a1f-9b9b-f408f2b4113a" &
	!="79b46f42-87df-4229-9ece-3e8140ca18d8" &
	!="daabd84a-ed83-4851-87de-d39c21668d2a" &
	!="e978db33-ee2e-44d2-a4ab-8d67ddd8d6ad" &
	!="ba67b961-c7d3-40be-a853-f4d5931ddf8a" &
	!="64905f6a-5218-4287-9ec9-7a81150c5ab3" &
	!="b565dbf7-39c5-4f4f-98e7-ce797ddea6c9" &
	!="c17624df-9e4d-4a3d-aebd-476c936f9c76" &
	!="b900739f-d99c-4700-9c04-b09c5e3b4633" &
	!="56d9507a-28c5-452d-9d0d-8f62482781ce" &
	!="43b6c40c-f055-4a86-9f98-5c5a58f95d4c" &
	!="870f8b92-c608-4799-a75e-a46de92da782" &
	!="8e23a4c6-284f-4f1b-b67b-88f1d56c5d31" &
	!="d8dd18d8-375e-4a44-a907-d37cc90fb936" &
	!="e009a671-5251-4e7d-8da3-679385441e62" &
	!="3515e1c0-99f6-48e8-a8bd-310c6c9392b5" &
	!="c7c8eb64-6072-44ab-9753-5e25f4bac7e2" &
	!="59fcfad2-ba13-441d-90db-c066abb7d93e" &
	!="62ed17d2-5585-4a99-9360-9bf3aab07573" &
	!="9268a9e2-d395-4f4d-adce-d015f2e52dae" &
	!="c5c4f84b-fbf3-4159-aa5d-2f7c4199d01d" &
	!="3a7d9db1-c553-487e-9166-22d25674ace7" &
	!="21252d11-0d48-484f-9ea0-0ea320b3b2aa"

#AnyCategoryRegistry:
    	or(#StandardCategoryRegistryEntries) |
    	#ExtensionCategoryRegistry

