local modpath = minetest.get_modpath(minetest.get_current_modname())

function mcl_rubber.generate_rubber_tree(pos)

	local t = math.random(1, 3)

	local path = modpath .. "/schematics/mcl_rubber_tree_"..t..".mts"
	local offset
	
	if t == 1 or t == 3 then
		offset = { x = -1, y = -1, z = -1 }
	elseif t == 2 then
		offset = { x = -2, y = -1, z = -2 }
	end
	minetest.place_schematic(vector.add(pos, offset), path, "random", nil, false)
end

function mcl_rubber.rubber_sapling_grow_action(soil_needed, sapling, treelight)
	return function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get("grown") then return end
		-- Checks if the sapling at pos has enough light and the correct soil
		local light = minetest.get_node_light(pos)
		if not light then return end
		local low_light = (light < treelight)

		local delta = 1
		local current_game_time = minetest.get_day_count() + minetest.get_timeofday()

		local last_game_time = tonumber(meta:get_string("last_gametime"))
		meta:set_string("last_gametime", tostring(current_game_time))

		if last_game_time then
			delta = current_game_time - last_game_time
		elseif low_light then
			return
		end

		if low_light then
			if delta < 1.2 then return end
			if minetest.get_node_light(pos, 0.5) < treelight then return end
		end

		local soilnode = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
		local soiltype = minetest.get_item_group(soilnode.name, "soil_sapling")
		if soiltype < soil_needed then return end

		-- Increase and check growth stage
		local meta = minetest.get_meta(pos)
		local stage = meta:get_int("stage")
		if stage == nil then stage = 0 end
		stage = stage + math.max(1, math.floor(delta))
		if stage >= 3 then
			meta:set_string("grown", "true")
				-- If this sapling can grow alone
			if biolib.check_growth_width(pos, 5, 11) then
				-- Single sapling
				minetest.set_node(pos, {name="air"})
				mcl_rubber.generate_rubber_tree(pos)
				return
			end
		else
			meta:set_int("stage", stage)
		end
	end
end

function mcl_rubber.treetap_update_action(nodename)
	return function(pos)
	
		local node = minetest.get_node({x=pos.x, y=pos.y, z=pos.z})
		local back_offset = minetest.wallmounted_to_dir(node.param2)
		local right_offset = {x=-back_offset.z, y=back_offset.y, z=back_offset.x}
		
		local neighbors = 0
		
		-- opposite side
		local neighbor_pos = {
			x=pos.x+(2*back_offset.x), 
			y=pos.y+(2*back_offset.y), 
			z=pos.z+(2*back_offset.z)}
		local neighbor_node = minetest.get_node(neighbor_pos)
		local neighbor_group = minetest.get_item_group(neighbor_node.name, "treetap")
		if neighbor_group > 0 then neighbors = neighbors + 1 end
		
		-- right diagonal
		neighbor_pos = {
			x=pos.x+(1*back_offset.x)+(1*right_offset.x), 
			y=pos.y+(1*back_offset.y)+(1*right_offset.y), 
			z=pos.z+(1*back_offset.z)+(1*right_offset.z)}
		neighbor_node = minetest.get_node(neighbor_pos)
		neighbor_group = minetest.get_item_group(neighbor_node.name, "treetap")
		if neighbor_group > 0 then neighbors = neighbors + 1 end
		
		-- left diagonal
		neighbor_pos = {
			x=pos.x+(1*back_offset.x)-(1*right_offset.x), 
			y=pos.y+(1*back_offset.y)-(1*right_offset.y), 
			z=pos.z+(1*back_offset.z)-(1*right_offset.z)}
		neighbor_node = minetest.get_node(neighbor_pos)
		neighbor_group = minetest.get_item_group(neighbor_node.name, "treetap")
		if neighbor_group > 0 then neighbors = neighbors + 1 end
		
		-- above
		neighbor_pos = {
			x=pos.x, 
			y=pos.y+1, 
			z=pos.z}
		neighbor_node = minetest.get_node(neighbor_pos)
		neighbor_group = minetest.get_item_group(neighbor_node.name, "treetap")
		if neighbor_group > 0 then neighbors = neighbors + 1 end
		
		-- below
		neighbor_pos = {
			x=pos.x, 
			y=pos.y-1, 
			z=pos.z}
		neighbor_node = minetest.get_node(neighbor_pos)
		neighbor_group = minetest.get_item_group(neighbor_node.name, "treetap")
		if neighbor_group > 0 then neighbors = neighbors + 1 end
		
		local success = math.random(neighbors+1)
		
		if success == 1 then
			node_group = minetest.get_item_group(node.name, "resin_fill") + 1
			minetest.swap_node(pos, {name=nodename.."_"..node_group, param1=node.param1, param2=node.param2})
		end
	end
end



