-- | Waypoints are created with rarer crystals
-- | The teleporters, since they are used each teleport, are made with easier to obtain crystals
-- | TODO
--[[
	|Create crafting recipe
	|teleporting animation? Particles?
	|Maybe debuff after teleporting?
	|What happens in the nether?
	|Make chunk preloaded
	|Sounds
--]]

local storage = core.get_mod_storage()

local position

if storage then
	position = core.deserialize(storage:get_string("pos"))
end

core.register_node("waypoints:waypoint", {
	description = "Teleporter waypoint",
	paramtype = "light",
	tiles = {"wool_violet.png"},
	is_ground_content = true,
	groups = { handy=1 },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if position then
			core.set_node(position, { name = "waypoints:waypoint"})
		end
		position = pos
		core.set_node(pos, { name = "waypoints:active_waypoint"})
		storage:set_string("pos", core.serialize(position))
	end,
	stack_max = 1
})

core.register_node("waypoints:active_waypoint", {
	description = "Active waypoint",
	paramtype = "light",
	tiles = {"wool_pink.png"},
	is_ground_content = true,
	groups = { handy=1 },
	light_source = 5,
	drop = "waypoints:waypoint",
	on_destruct = function(pos)
		if pos == position then
			position = nil
			storage:set_string("pos", nil)
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		core.set_node(pos, { name = "waypoints:waypoint" })
		position = nil
		storage:set_string("pos", nil)
	end,
	stack_max = 1
})

core.register_craftitem("waypoints:teleporter", {
	description = "Use to teleport to waypoint",
	inventory_image = "gem.png",
--[[on_use = function(itemstack, user)
		if position then
			core.sound_play(mcl_sounds.node_sound_glass_defaults().dug)
			local posi = { x = position.x, y = position.y + 1, z = position.z }
			user:set_pos(posi)
			itemstack:take_item(1)
		end
		return itemstack
	end,
--]]
	on_place = function(itemstack, user, pointed_thing)
		print("Tried to place")
		print(dump(itemstack))
		print(dump(pointed_thing))
		if core.get_node(pointed_thing.under).name == "waypoints:active_waypoint" then
			print(dump(itemstack))
			itemstack:set_name("waypoints:active_teleporter")
			return itemstack
		else
			return core.item_place(itemstack)
		end
	end,
	stack_max = 1
})

core.register_craftitem("waypoints:active_teleporter", {
	description = "Use to teleport to active waypoint",
	inventory_image = "active_gem.png",
	on_use = function(itemstack, user)
		if position then
			core.sound_play(mcl_sounds.node_sound_glass_defaults().dug)
			local posi = { x = position.x, y = position.y + 1, z = position.z }
			user:set_pos(posi)
			itemstack:take_item(1)
		end
		return itemstack
	end,
	stack_max = 1
})

core.register_craft({
	output = "waypoints:waypoint",
	recipe = {
		{"mcl_core:sugar"},
		{"mcl_core:obsidian"},
		}

})

core.register_craft({
	type = "shapeless",
	output = "waypoints:teleporter",
	recipe = {"mcl_core:sugar"},
})

--[[ Testing recipes
core.register_craft({
	type = "shapeless",
	output = "waypoints:waypoint",
	recipe = { "mcl_core:dirt" },
})
---[[
core.register_craft({
	type = "shapeless",
	output = "waypoints:teleporter",
	recipe = { "mcl_core:dirt" },
})
--]]
