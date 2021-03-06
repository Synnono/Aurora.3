var/global/list/plant_seed_sprites = list()

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	w_class = ITEMSIZE_SMALL

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	update_seed()
	. = ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(SSplants.seeds) && SSplants.seeds[seed_type])
		seed = SSplants.seeds[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	cut_overlays()
	var/is_seeds = ((seed.seed_noun in list("seeds","pits","nodes")) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOUR) : "spores"]"
	if(plant_seed_sprites[seed_base_key])
		seed_mask = plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
	if(plant_seed_sprites[seed_overlay_key])
		seed_overlay = plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		plant_seed_sprites[seed_overlay_key] = seed_overlay

	add_overlay(seed_mask)
	add_overlay(seed_overlay)

	if(is_seeds)
		src.name = "packet of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It has a picture of [seed.display_name] on the front."
	else
		src.name = "sample of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It's labelled as coming from [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	..(user)
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/Initialize()
	seed = SSplants.create_random_seed()
	seed_type = seed.name
	. = ..()
