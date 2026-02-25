-- =========================================================
-- Maschinen-Prototypen (aus assembling-machine-2 kopiert)
-- =========================================================
local portal_city = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])

portal_city.name = "Portal-City"
portal_city.icon = "__ricky_mod__/graphics/entity/Portal-City/portal-city.png"
portal_city.minable = {mining_time = 0.2, result = "Portal-City"}
portal_city.max_health = 700
portal_city.crafting_speed = 0.75
portal_city.energy_usage = "400kW"
portal_city.crafting_categories = {"portal-crafting"}
portal_city.fluid_boxes_off_when_no_fluid_recipe = true
portal_city.next_upgrade = nil
portal_city.fast_replaceable_group = nil
portal_city.collision_box = {{-6.2, -6.2}, {6.2, 6.2}}
portal_city.selection_box = {{-6.5, -6.5}, {6.5, 6.5}}
portal_city.tile_width = 13
portal_city.tile_height = 13
local fabrik_animation = {
	layers = {
		{
			filename = "__ricky_mod__/graphics/entity/Portal-City/portal-city.png",
			priority = "high",
			width = 400,
			height = 400,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			scale = 400 / 400,
			shift = {0, 0}
		},
		{
			filename = "__ricky_mod__/graphics/entity/Portal-City/portal-city-shadow.png",
			priority = "high",
			width = 402,
			height = 404,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			draw_as_shadow = true,
			scale = 400 / 402,
			shift = {0.3, 0.15}
		}
	}
}
portal_city.animation = fabrik_animation
portal_city.graphics_set = {
	animation = fabrik_animation
}
portal_city.working_visualisations = nil

local fabrikator = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])

fabrikator.name = "Fabrik"
fabrikator.icon = "__ricky_mod__/graphics/icons/fabrik.png"
fabrikator.minable = {mining_time = 0.2, result = "Fabrik"}
fabrikator.max_health = 350
fabrikator.crafting_speed = 0.75
fabrikator.energy_usage = "20kW"
fabrikator.crafting_categories = {"fabrik-crafting"}
fabrikator.fluid_boxes_off_when_no_fluid_recipe = true
local fabrik_animation = {
	layers = {
		{
			filename = "__ricky_mod__/graphics/entity/fabrik/fabrik.png",
			priority = "high",
			width = 214,
			height = 226,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			scale = 96 / 214,
			shift = {0, 0}
		},
		{
			filename = "__ricky_mod__/graphics/entity/fabrik/fabrik-shadow.png",
			priority = "high",
			width = 190,
			height = 165,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			draw_as_shadow = true,
			scale = 96 / 214,
			shift = {0.3, 0.15}
		}
	}
}
fabrikator.animation = fabrik_animation
fabrikator.graphics_set = {
	animation = fabrik_animation
}
fabrikator.working_visualisations = nil

local strammer_stamm = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])

strammer_stamm.name = "Stamm"
strammer_stamm.icon = "__ricky_mod__/graphics/icons/stamm.png"
strammer_stamm.minable = {mining_time = 0.6, result = "Stamm"}
strammer_stamm.max_health = 350
strammer_stamm.crafting_speed = 1
strammer_stamm.energy_usage = "50kW"
strammer_stamm.crafting_categories = {"tree-crafting"}
strammer_stamm.fluid_boxes_off_when_no_fluid_recipe = true
local strammer_stamm_animation = {
	layers = {
		{
			filename = "__ricky_mod__/graphics/entity/Stamm/stamm.png",
			priority = "high",
			width = 214,
			height = 226,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			scale = 96 / 214,
			shift = {0, 0}
		},
		{
			filename = "__ricky_mod__/graphics/entity/Stamm/stamm-shadow.png",
			priority = "high",
			width = 190,
			height = 165,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			draw_as_shadow = true,
			scale = 96 / 214,
			shift = {0.3, 0.15}
		}
	}
}
strammer_stamm.animation = strammer_stamm_animation
strammer_stamm.graphics_set = {
	animation = strammer_stamm_animation
}
strammer_stamm.working_visualisations = nil

-- =========================================================
-- Portal-Visuals und Portal-Entities (A/B)
-- =========================================================
local portal_picture_a = {
	layers = {
		{
			filename = "__ricky_mod__/graphics/entity/Portal/portal.png",
			priority = "high",
			width = 214,
			height = 226,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			scale = 96 / 214,
			shift = {0, 0},
			tint = {r = 0.35, g = 0.65, b = 1, a = 1}
		},
		{
			filename = "__ricky_mod__/graphics/entity/Portal/portal-shadow.png",
			priority = "high",
			width = 190,
			height = 165,
			frame_count = 32,
			line_length = 8,
			animation_speed = 0.2,
			draw_as_shadow = true,
			scale = 96 / 214,
			shift = {0.3, 0.15}
		}
	}
}

local portal_picture_b = table.deepcopy(portal_picture_a)
portal_picture_b.layers[1].tint = {r = 1, g = 0.55, b = 0.2, a = 1}

local portal_a = {
	type = "simple-entity",
	name = "ricky-portal-a",
	icon = "__ricky_mod__/graphics/icons/portal.png",
	icon_size = 64,
	flags = {"placeable-off-grid", "not-on-map", "not-deconstructable", "not-blueprintable"},
	selectable_in_game = false,
	collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
	collision_mask = {layers = {}},
	render_layer = "object",
	picture = portal_picture_a
}

local portal_b = table.deepcopy(portal_a)
portal_b.name = "ricky-portal-b"
portal_b.picture = portal_picture_b


-- =========================================================
-- Registrierung aller Prototypen
-- =========================================================
data:extend({
	-- Kategorien (Crafting + Ammo)
	{
		type = "recipe-category",
		name = "fabrik-crafting"
	},
	{
		type = "recipe-category",
		name = "tree-crafting"
	},
	{
		type = "ammo-category",
		name = "portal"
	},
	{
		type = "recipe-category",
		name = "portal-crafting"
	},

	-- PortalGun Schusslogik (Projektil + Script-Trigger)
	{
		type = "projectile",
		name = "ricky-portal-projectile",
		flags = {"not-on-map"},
		acceleration = 0,
		piercing_damage = 0,
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "script",
						effect_id = "ricky-portal-hit"
					}
				}
			}
		},
		animation = {
			filename = "__ricky_mod__/graphics/icons/portal.png",
			priority = "high",
			width = 64,
			height = 64,
			frame_count = 1
		}
	},

	-- Munition für die PortalGun
	{
		type = "ammo",
		name = "PFC",
		icon = "__ricky_mod__/graphics/icons/ammo/portal_fluid_capsel.png",
		icon_size = 64,
		ammo_category = "portal",
		ammo_type = {
			target_type = "position",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "ricky-portal-projectile",
					starting_speed = 0.8
				}
			}
		},
		subgroup = "ammo",
		order = "z[PFC]",
		magazine_size = 2,
		stack_size = 200
	},
	{
		type = "recipe",
		name = "PFC",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Portalfluessigkeit", amount = 1},
			{type = "item", name = "iron-plate", amount = 1}
		},
		results = {
			{type = "item", name = "PFC", amount = 5}
		}
	},

	-- Maschinen + Kern-Items/Rezepte
	{
		type = "item",
		name = "Fabrik",
		icon = "__ricky_mod__/graphics/icons/fabrik.png",
		icon_size = 64,
		subgroup = "production-machine",
		order = "a[Fabrik]",
		place_result = "Fabrik",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "Fabrik",
		enabled = true,
		ingredients = {
			{type = "item", name = "iron-plate", amount = 8},
			{type = "item", name = "plastic-bar", amount = 5}
		},
		results = {
			{type = "item", name = "Fabrik", amount = 1}
		}
	},
	{
		type = "item",
		name = "Dimmensionsshard",
		icon = "__ricky_mod__/graphics/icons/dimmshard.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[Dimmensionsshard]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "Dimmensionsshard",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Holzplatte", amount = 5},
			{type = "item", name = "processing-unit", amount = 10},
			{type = "item", name = "promethium-asteroid-chunk", amount = 1}
		},
		results = {
			{type = "item", name = "Dimmensionsshard", amount = 1}
		}
	},
	{
		type = "item",
		name = "Portalfluessigkeit",
		icon = "__ricky_mod__/graphics/icons/fluid/portal_fluid.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[Portalfluessigkeit]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "Portalfluessigkeit",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Dimmensionsshard", amount = 5},
			{type = "item", name = "UniversumsBatterie", amount = 20},
			{type = "fluid", name = "sulfuric-acid", amount = 20}
		},
		results = {
			{type = "item", name = "Portalfluessigkeit", amount = 1}
		}
	},
	{
		type = "item",
		name = "Stamm",
		icon = "__ricky_mod__/graphics/icons/stamm.png",
		icon_size = 64,
		subgroup = "production-machine",
		order = "a[Stamm]",
		place_result = "Stamm",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "Stamm",
		category = "fabrik-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Holzplatte", amount = 8},
			{type = "item", name = "spoilage", amount = 20}
		},
		results = {
			{type = "item", name = "Stamm", amount = 1}
		}
	},
	{
		type = "item",
		name = "Holzplatte",
		icon = "__ricky_mod__/graphics/icons/platte_holz.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[Holzplatte]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "Holzplatte",
		category = "fabrik-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "wood", amount = 2}
		},
		results = {
			{type = "item", name = "Holzplatte", amount = 20}
		}
	},
	{
		type = "item",
		name = "Plumbus",
		icon = "__ricky_mod__/graphics/icons/plumbus.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[Plumbus]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "Plumbus",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Portalfluessigkeit", amount = 2},
			{type = "item", name = "Dimmensionsshard", amount = 2}
		},
		results = {
			{type = "item", name = "Plumbus", amount = 1}
		}
	},
	{
		type = "item",
		name = "MrMeeseeksBox",
		icon = "__ricky_mod__/graphics/icons/meesee.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[MrMeeseeksBox]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "MrMeeseeksBox",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Portalfluessigkeit", amount = 2},
			{type = "item", name = "Dimmensionsshard", amount = 2},
			{type = "item", name = "Holzplatte", amount = 2}
		},
		results = {
			{type = "item", name = "MrMeeseeksBox", amount = 1}
		}
	},
	{
		type = "gun",
		name = "PortalGun",
		icon = "__ricky_mod__/graphics/icons/gun.png",
		icon_size = 64,
		subgroup = "gun",
		order = "c[portal-gun]",
		stack_size = 1,
		attack_parameters = {
			type = "projectile",
			ammo_category = "portal",
			cooldown = 20,
			movement_slow_down_factor = 0.2,
			projectile_creation_distance = 0.9,
			range = 28
		}
	},
	{
		type = "recipe",
		name = "PortalGun",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Portalfluessigkeit", amount = 2},
			{type = "item", name = "Dimmensionsshard", amount = 2},
			{type = "item", name = "Holzplatte", amount = 2},
			{type = "item", name = "steel-plate", amount = 2}
		},
		results = {
			{type = "item", name = "PortalGun", amount = 1}
		}
	},
	{
		type = "item",
		name = "UniversumsBatterie",
		icon = "__ricky_mod__/graphics/icons/battery.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[UniversumsBatterie]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "UniversumsBatterie",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Dimmensionsshard", amount = 2},
			{type = "item", name = "holmium-ore", amount = 2},
			{type = "item", name = "steel-plate", amount = 2}
		},
		results = {
			{type = "item", name = "UniversumsBatterie", amount = 1}
		}
	},
	{
		type = "item",
		name = "IconicDefibulizer",
		icon = "__ricky_mod__/graphics/icons/ionic-defibulizer.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[IconicDefibulizer]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "IconicDefibulizer",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "Dimmensionsshard", amount = 2},
			{type = "item", name = "plastic-bar", amount = 2},
			{type = "item", name = "uranium-235", amount = 2}
		},
		results = {
			{type = "item", name = "IconicDefibulizer", amount = 1}
		}
	},
	{
		type = "item",
		name = "MrToots",
		icon = "__ricky_mod__/graphics/icons/mrtoots.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[MrToots]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "MrToots",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "spoilage", amount = 2},
			{type = "item", name = "plastic-bar", amount = 2},
			{type = "item", name = "calcite", amount = 2}
		},
		results = {
			{type = "item", name = "MrToots", amount = 1}
		}
	},
	{
		type = "item",
		name = "NeutrinoBombe",
		icon = "__ricky_mod__/graphics/icons/neutrino_Bomb.png",
		icon_size = 64,
		subgroup = "intermediate-product",
		order = "b[NeutrinoBombe]",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "NeutrinoBombe",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "spoilage", amount = 2},
			{type = "item", name = "plastic-bar", amount = 2},
			{type = "item", name = "calcite", amount = 2}
		},
		results = {
			{type = "item", name = "NeutrinoBombe", amount = 1}
		}
	},
	{
		type = "item",
		name = "Portal-City",
		icon = "__ricky_mod__/graphics/icons/portal-city.png",
		icon_size = 64,
		subgroup = "production-machine",
		order = "b[Portal-City]",
		place_result = "Portal-City",
		stack_size = 500
	},
	{
		type = "recipe",
		name = "Portal-City",
		category = "tree-crafting",
		enabled = true,
		ingredients = {
			{type = "item", name = "NeutrinoBombe", amount = 2},
			{type = "item", name = "plastic-bar", amount = 2},
			{type = "item", name = "calcite", amount = 2}
		},
		results = {
			{type = "item", name = "Portal-City", amount = 1}
		}
	},

	-- Runtime-Portal-Entities und Maschinen ins Spiel einfügen
	portal_a,
	portal_b,
	portal_city,
	fabrikator,
	strammer_stamm
})
