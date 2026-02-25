---@diagnostic disable: undefined-global

local PORTAL_CITY_NAME = "Portal-City"
local PORTAL_CITY_NAME_ALT = "Portal-city"
local DIMENSION_SURFACE_NAME = "rick_and_morty_dimension"
local HOME_SURFACE_NAME = "nauvis"
local PORTAL_GUI_FRAME = "ricky_portal_city_frame"
local PORTAL_GUI_BUTTON = "ricky_portal_city_button"

local function ensure_runtime_storage()
  ---@diagnostic disable-next-line: undefined-global
  storage.portal_state = storage.portal_state or {}
  storage.portal_cooldown = storage.portal_cooldown or {}
  storage.portal_gui_players = storage.portal_gui_players or {}
end

local function on_init()
  ensure_runtime_storage()
  game.print({"ricky-mod.hello"})
end

script.on_init(on_init)
script.on_configuration_changed(ensure_runtime_storage)

local function get_surface_state(surface_index)
  ensure_runtime_storage()
  local state = storage.portal_state[surface_index]

  if not state then
    state = {next = "a", a = nil, b = nil}
    storage.portal_state[surface_index] = state
  end

  return state
end

local function destroy_if_valid(entity)
  if entity and entity.valid then
    entity.destroy()
  end
end

local function place_portal(surface, position, portal_name)
  return surface.create_entity({
    name = portal_name,
    position = position,
    force = "neutral"
  })
end

local function is_portal_city(entity)
  return entity
    and entity.valid
    and (entity.name == PORTAL_CITY_NAME or entity.name == PORTAL_CITY_NAME_ALT)
end

local function close_portal_city_gui(player)
  if not (player and player.valid) then
    return
  end

  ensure_runtime_storage()

  local frame = player.gui.screen[PORTAL_GUI_FRAME]
  if frame and frame.valid then
    frame.destroy()
  end

  storage.portal_gui_players[player.index] = nil
end

local function open_portal_city_gui(player, entity)
  ensure_runtime_storage()
  close_portal_city_gui(player)

  local frame = player.gui.screen.add({
    type = "frame",
    name = PORTAL_GUI_FRAME,
    direction = "vertical",
    caption = "Portal-City"
  })

  frame.add({
    type = "label",
    caption = "Dimension wechseln"
  })

  local button_caption = "Ioutofhere"
  if player.surface and player.surface.name == DIMENSION_SURFACE_NAME then
    button_caption = "BringMeBack"
  end

  frame.add({
    type = "button",
    name = PORTAL_GUI_BUTTON,
    caption = button_caption
  })

  frame.auto_center = true
  player.opened = frame
  storage.portal_gui_players[player.index] = entity.unit_number
end

local function get_or_create_dimension_surface()
  local surface = game.surfaces[DIMENSION_SURFACE_NAME]
  if surface then
    return surface
  end

  local map_gen_settings = {
    width = 0,
    height = 0,
    peaceful_mode = true,
    starting_area = "none",
    cliff_settings = {
      name = "cliff",
      cliff_elevation_interval = 0,
      cliff_elevation_0 = 0,
      richness = 0
    },
    autoplace_controls = {
      ["enemy-base"] = {frequency = "none", size = "none", richness = "none"},
      ["trees"] = {frequency = "very-high", size = "high", richness = "good"},
      ["coal"] = {frequency = "low", size = "normal", richness = "normal"},
      ["stone"] = {frequency = "low", size = "normal", richness = "normal"},
      ["copper-ore"] = {frequency = "high", size = "normal", richness = "good"},
      ["iron-ore"] = {frequency = "high", size = "normal", richness = "good"},
      ["crude-oil"] = {frequency = "low", size = "small", richness = "normal"}
    },
    default_enable_all_autoplace_controls = true
  }

  surface = game.create_surface(DIMENSION_SURFACE_NAME, map_gen_settings)
  surface.request_to_generate_chunks({0, 0}, 12)
  surface.force_generate_chunk_requests()
  return surface
end

local function ensure_dimension_portal_city(surface, force)
  if not (surface and surface.valid) then
    return nil
  end

  local existing = surface.find_entities_filtered({name = PORTAL_CITY_NAME})
  if existing and existing[1] and existing[1].valid then
    return existing[1]
  end

  local spawn_position = surface.find_non_colliding_position(PORTAL_CITY_NAME, {0, 0}, 96, 1, true)
    or surface.find_non_colliding_position("character", {0, 0}, 96, 1, true)

  if not spawn_position then
    return nil
  end

  return surface.create_entity({
    name = PORTAL_CITY_NAME,
    position = spawn_position,
    force = force and force.name or "player",
    create_build_effect_smoke = false
  })
end

local function teleport_player_to_dimension(player)
  local surface = get_or_create_dimension_surface()
  ensure_dimension_portal_city(surface, player.force)
  local target_position = surface.find_non_colliding_position("character", {0, 0}, 64, 0.5, true)

  if not target_position then
    player.print("Keine freie Position in der Dimension gefunden.")
    return
  end

  player.teleport(target_position, surface)
  player.print("Willkommen im Rick-and-Morty Universum.")
end

local function teleport_player_to_home(player)
  local home_surface = game.surfaces[HOME_SURFACE_NAME] or game.surfaces[1]
  if not (home_surface and home_surface.valid) then
    player.print("Keine Heimatwelt gefunden.")
    return
  end

  local spawn = player.force and player.force.get_spawn_position(home_surface) or {0, 0}
  local target_position = home_surface.find_non_colliding_position("character", spawn, 64, 0.5, true)
    or home_surface.find_non_colliding_position("character", {0, 0}, 128, 0.5, true)

  if not target_position then
    player.print("Keine freie Position auf der Heimatwelt gefunden.")
    return
  end

  player.teleport(target_position, home_surface)
  player.print("Zurück auf Nauvis.")
end

---@diagnostic disable-next-line: undefined-global
script.on_event(defines.events.on_script_trigger_effect, function(event)
  if event.effect_id ~= "ricky-portal-hit" then
    return
  end

  local surface = game.surfaces[event.surface_index]
  if not surface then
    return
  end

  local target = event.target_position
  if not target then
    return
  end

  local state = get_surface_state(surface.index)

  if state.next == "a" then
    destroy_if_valid(state.a)
    state.a = place_portal(surface, target, "ricky-portal-a")
    state.next = "b"
  else
    destroy_if_valid(state.b)
    state.b = place_portal(surface, target, "ricky-portal-b")
    state.next = "a"
  end
end)

local function teleport_player(player, destination_entity)
  if not (destination_entity and destination_entity.valid) then
    return
  end

  local destination = destination_entity.surface.find_non_colliding_position(
    "character",
    destination_entity.position,
    2,
    0.1,
    true
  )

  if destination then
    player.teleport(destination, destination_entity.surface)
    storage.portal_cooldown[player.index] = game.tick + 30
  end
end

script.on_event(defines.events.on_tick, function(event)
  ensure_runtime_storage()

  for _, player in pairs(game.connected_players) do
    local character = player.character
    if character and character.valid then
      local cooldown_tick = storage.portal_cooldown[player.index] or 0
      if event.tick >= cooldown_tick then
        local state = storage.portal_state[player.surface.index]
        if state and state.a and state.b and state.a.valid and state.b.valid then
          local position = character.position
          local dx_a = position.x - state.a.position.x
          local dy_a = position.y - state.a.position.y
          local dx_b = position.x - state.b.position.x
          local dy_b = position.y - state.b.position.y
          local range_sq = 0.7 * 0.7

          if (dx_a * dx_a + dy_a * dy_a) <= range_sq then
            teleport_player(player, state.b)
          elseif (dx_b * dx_b + dy_b * dy_b) <= range_sq then
            teleport_player(player, state.a)
          end
        end
      end
    end
  end
end)

script.on_event(defines.events.on_gui_opened, function(event)
  if event.gui_type ~= defines.gui_type.entity then
    return
  end

  local player = game.get_player(event.player_index)
  if not player then
    return
  end

  local entity = event.entity
  if not is_portal_city(entity) then
    return
  end

  player.opened = nil
  open_portal_city_gui(player, entity)
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local player = game.get_player(event.player_index)
  if not player then
    return
  end

  if event.element and event.element.valid and event.element.name == PORTAL_GUI_FRAME then
    close_portal_city_gui(player)
    return
  end

  if event.gui_type ~= defines.gui_type.entity then
    return
  end

  close_portal_city_gui(player)
end)

script.on_event(defines.events.on_gui_click, function(event)
  local element = event.element
  if not (element and element.valid and element.name == PORTAL_GUI_BUTTON) then
    return
  end

  local player = game.get_player(event.player_index)
  if not player then
    return
  end

  if player.surface and player.surface.name == DIMENSION_SURFACE_NAME then
    teleport_player_to_home(player)
  else
    teleport_player_to_dimension(player)
  end

  close_portal_city_gui(player)
end)

commands.add_command("ricky_hello", {"ricky-mod.command_description"}, function()
  game.print({"ricky-mod.hello"})
end)
