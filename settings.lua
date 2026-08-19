-- Settings
mcl_rubber.config={
	drop_chances=tonumber(minetest.settings:get("mcl_rubber.drop_chances") or "1"),
  tree_chances=tonumber(minetest.settings:get("mcl_rubber.tree_chances") or "1"),
	use_planks=minetest.settings:get_bool("mcl_rubber.use_planks",true),
  use_rubber_products=minetest.settings:get_bool("mcl_rubber.use_rubber_products",true)
}

-- precalculate some settings
mcl_rubber.config.drop_mult = 1.0 / mcl_rubber.config.drop_chances
