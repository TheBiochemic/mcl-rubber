-- Helper stuff ----------------------------------------------------------------
local S = minetest.get_translator(minetest.get_current_modname())
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Main Part of the Mod --------------------------------------------------------

minetest.register_node("mcl_rubber:rubberblock", {
	description = S("Rubber Block"),
	_doc_items_longdesc = S("Rubber blocks are bouncy and prevent fall damage."),
	is_ground_content = false,
	tiles = {"mcl_rubber_block.png"},
	stack_max = 64,
	groups = {dig_immediate=3, bouncy=55,fall_damage_add_percent=-100,deco_block=1},
	sounds = mcl_sounds.node_sound_wood_defaults(),
	_mcl_blast_resistance = 1.5,
	_mcl_hardness = 1.5,
})

minetest.register_craftitem("mcl_rubber:rubber_raw", {
	description = S("Rubber Resin"),
	_doc_items_longdesc = S("Rubber Resin is the ingredient to make Rubber."),
	inventory_image = "mcl_rubber_raw.png",
	groups = { craftitem = 1 },
})

minetest.register_craftitem("mcl_rubber:rubber", {
	description = S("Rubber"),
	_doc_items_longdesc = S("Rubber is used in crafting. It is made from Rubber Resin"),
	inventory_image = "mcl_rubber.png",
	groups = { craftitem = 1, rubber = 1 },
})

minetest.register_craft({
	output = "mesecons_pistons:piston_sticky_off",
	recipe = {
		{"mcl_rubber:rubber_raw"},
		{"mesecons_pistons:piston_normal_off"},
	},
})

minetest.register_craft({
	output = "mcl_rubber:rubber 9",
	recipe = {{"mcl_rubber:rubberblock"}},
})

minetest.register_craft({
	output = "mcl_rubber:rubberblock",
	recipe = {{"group:rubber","group:rubber","group:rubber",},
		{"group:rubber","group:rubber","group:rubber",},
		{"group:rubber","group:rubber","group:rubber",}},
})

minetest.register_craft({
	type = "cooking",
	output = "mcl_rubber:rubber",
	recipe = "mcl_rubber:rubber_raw",
	cooktime = 10,
})


-- register rubber boots
minetest.register_tool("mcl_rubber:boots", {
	description = S("Rubber Boots"),
	_doc_items_longdesc = mcl_armor.longdesc,
	_doc_items_usagehelp = mcl_armor.usage,
	inventory_image = "mcl_rubber_boots_inv.png",
	groups = {
		armor = 1, 
		combat_armor = 1, 
		armor_boots = 1, 
		mcl_armor_uses = 80, 
		fall_damage_add_percent = -60,
		enchantability = 5,
	},
	sounds = {
		_mcl_armor_equip = "mcl_armor_equip_leather",
		_mcl_armor_unequip = "mcl_armor_unequip_leather",
	},
	on_place = mcl_armor.equip_on_use,
	on_secondary_use = mcl_armor.equip_on_use,
	_mcl_armor_element = "feet",
	_mcl_armor_texture = "mcl_rubber_boots.png"
})

minetest.register_craft({
	output = "mcl_rubber:boots",
	recipe = {
		{"group:rubber", "", "group:rubber"},
		{"group:rubber", "", "group:rubber"},
	},
})


-- register rubber tree stuff
biolib.register_tree_trunk(
	"mcl_rubber:rubbertree", 
	S("Rubber Wood"), 
	S("Rubber Bark"), 
	S("The trunk of a rubber tree."), 
	"mcl_rubber_tree_top.png", 
	"mcl_rubber_tree.png", 
	"mcl_rubber:stripped_rubbertree")

biolib.register_stripped_trunk(
	"mcl_rubber:stripped_rubbertree", 
	S("Stripped Rubber Wood Log"), 
	S("Stripped Rubber Wood"), 
	S("The stripped trunk of a rubber tree."), 
	S("The stripped wood of an rubber tree."), 
	"mcl_rubber_stripped_top.png", 
	"mcl_rubber_stripped.png")

biolib.register_planks(
	"mcl_rubber:rubberwood", 
	S("Rubber Wood Planks"), 
	{"mcl_rubber_planks.png"})

biolib.register_wooden_stairs(
	"rubberwood", 
	"mcl_rubber:rubberwood", 
	"mcl_rubber_planks.png", 
	S("Rubber Wood Stairs"), 
	S("Rubber Wood Slab"), 
	S("Double Rubber Wood Slab"))

biolib.register_wooden_fence(
	"rubberwood", 
	"mcl_rubber:rubberwood", 
	S("Rubber Wood Fence"), 
	S("Rubber Wood Fence Gate"), 
	"mcl_rubber_fence.png")

biolib.register_sapling(
	"mcl_rubber:rubbersapling", 
	S("Rubber Tree Sapling"),
	S("When placed on soil (such as dirt) and exposed to light, an rubber tree "
		.."sapling will grow into a rubber tree after some time."),
	S("Needs soil and light to grow"),
	"mcl_rubber_sapling.png", 
	{-4/16, -0.5, -4/16, 4/16, 0.5, 4/16})

biolib.register_leaves(
	"mcl_rubber:rubberleaves", 
	S("Rubber Tree Leaves"), 
	S("Rubber Tree leaves are grown from rubber trees."), 
	{"mcl_rubber_leaves.png"}, 
	"mcl_rubber:rubbersapling", 
	{40, 26, 32, 24, 10}, 
	{"mcl_rubber:rubber_raw", {200, 180, 160, 120, 40}})

-- treetap stuff
for i=0,4 do
	biolib.register_treetap_variant(
		"mcl_rubber:treetap", 
		S("Treetap"), 
		S("Collects Rubber Resin, when attached to rubber trees."), 
		S("The treetap is a block, that gets attached to Rubber Trees to collect "
			.."their resin, for creating Rubber."), 
		S("Place the treetap next to the log of a rubber tree. This will attach "
			.."the treetap, and allow it to collect resin over time. Make sure to "
			.."not attach too many on it, because that will reduce the "
			.."effectiveness. Rightclick for dropping the resin, when done."), 
		"mcl_rubber_treetap", 
		"mcl_rubber:rubbertree",
		"mcl_rubber:rubber_raw",
		i)
	if minetest.get_modpath("doc") and i>0 then
		doc.add_entry_alias("nodes", "mcl_rubber:treetap", "nodes", "mcl_rubber:treetap_"..i)
	end
end

local treetap_update_action = mcl_rubber.treetap_update_action("mcl_rubber:treetap")
biolib.register_world_updates(
	{"mcl_rubber:treetap", 
		"mcl_rubber:treetap_1", 
		"mcl_rubber:treetap_2", 
		"mcl_rubber:treetap_3"}, 
	{"mcl_rubber:rubbertree"}, 
	"Treetap update", 
	"Fills treetap in unloaded areas", 
	"mcl_rubber:lbm_treetap", 
	20, 15,
	treetap_update_action)
	
minetest.register_craft({
	output = "mcl_rubber:treetap",
	recipe = {
		{"", "mcl_core:iron_ingot", ""},
		{"group:wood", "", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

-- generation stuff
local rubber_sapling_grow = mcl_rubber.rubber_sapling_grow_action(1, "mcl_rubber:rubbersapling", 11)
biolib.register_bonemeal_sapling("mcl_rubber:rubbersapling", rubber_sapling_grow)
biolib.register_world_updates(
	{"mcl_rubber:rubbersapling"}, 
	{"group:soil_sapling"}, 
	"Rubber tree growth", 
	"Add growth for unloaded rubber tree", 
	"mcl_rubber:lbm_rubber", 
	25, 2, 
	rubber_sapling_grow)
	
for i=1,3 do

	minetest.register_decoration({
	    deco_type = "schematic",
	    place_on = {"group:soil_sapling"},
	    sidelen = 16,
	    fill_ratio = 0.00007,
	    biomes = {"Forest", "Jungle", "JungleM", "JungleEdge"},
	    y_max = 200,
	    y_min = 1,
	    schematic = modpath .. "/schematics/mcl_rubber_tree_"..i..".mts",
	    flags = "place_center_x, place_center_z",
	    rotation = "random",
	})

	minetest.register_decoration({
	    deco_type = "schematic",
	    place_on = {"group:soil_sapling"},
	    sidelen = 16,
	    fill_ratio = 0.0000003,
	    biomes = {"Plains"},
	    y_max = 200,
	    y_min = 1,
	    schematic = modpath .. "/schematics/mcl_rubber_tree_"..i..".mts",
	    flags = "place_center_x, place_center_z",
	    rotation = "random",
	})
end
	
	
-- register event based stuff
minetest.register_on_player_hpchange(biolib.do_modify_falldamage_with_boots, true)
	
	
