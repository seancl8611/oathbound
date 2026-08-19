# RouteGenerator.gd
# Autoload - Add to Project > Project Settings > Autoload as "RouteGenerator"
# MUST be loaded BEFORE GameFlow in the autoload list
extends Node

signal route_generated(route: Array)

const TREASURE_SYMBOLS = ["boon", "gold", "mist", "scroll", "maxhp", "maxposture"]

const AREA_CONFIGS = {
	1: {
		"total_rooms": 14,
		"fixed_slots": {
			0:  "shrine",
			7:  "treasure",
			8:  "rest",
			12: "shop",
			13: "boss"
		},
		"choice_slots": {
			1:  ["combat:boon", "combat:gold"],
			2:  ["combat:gold", "combat:maxhp"],
			3:  ["combat:boon", "shrine"],
			4:  ["combat:mist", "treasure:scroll"],
			5:  ["combat:gold", "shop"],
			6:  ["combat:boon", "combat:scroll"],
			9:  ["combat:boon", "combat:mist"],
			10: ["combat:maxposture", "shrine"],
			11: ["combat:gold", "combat:boon"]
		}
	},
	2: {
		"total_rooms": 10,
		"fixed_slots": {
			5:  "treasure",
			8:  "shop",
			9:  "boss"
		},
		"choice_slots": {
			0: ["combat:boon", "combat:gold"],
			1: ["combat:mist", "combat:scroll"],
			2: ["combat:gold", "treasure:boon"],
			3: ["combat:boon", "shrine"],
			4: ["combat:maxhp", "combat:maxposture"],
			6: ["combat:gold", "combat:mist"],
			7: ["combat:boon", "combat:scroll"]
		}
	},
	3: {
		"total_rooms": 12,
		"fixed_slots": {
			7:  "treasure",
			10: "shop",
			11: "boss"
		},
		"choice_slots": {
			0: ["combat:boon", "combat:scroll"],
			1: ["combat:gold", "treasure:mist"],
			2: ["combat:mist", "shrine"],
			3: ["combat:maxhp", "combat:maxposture"],
			4: ["combat:boon", "combat:gold"],
			5: ["combat:scroll", "treasure:gold"],
			6: ["combat:boon", "combat:mist"],
			8: ["combat:gold", "rest"],
			9: ["combat:boon", "combat:scroll"]
		}
	},
	4: {
		"total_rooms": 5,
		"fixed_slots": {
			0: "shop",
			4: "boss"
		},
		"choice_slots": {
			1: ["combat:gold", "combat:maxhp"],
			2: ["combat:boon", "combat:mist"],
			3: ["combat:boon", "combat:maxposture"]
		}
	}
}

var current_route: Array[String] = []
var pending_choices: Dictionary = {}  # slot_index -> [option1, option2]
var current_area: int = 1

var rng := RandomNumberGenerator.new()
var _seed: int = 0

func set_seed(seed: int) -> void:
	_seed = seed
	rng.seed = seed

func _shuffle_in_place(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp

func get_base_room_type(token: String) -> String:
	if token == null:
		return ""
	var s := str(token).to_lower()
	if s.begins_with("choice_"):
		return s
	var parts := s.split(":", false)
	return parts[0] if parts.size() > 0 else s

func get_reward_key(token: String) -> String:
	if token == null:
		return ""
	var s := str(token).to_lower()
	var parts := s.split(":", false)
	return parts[1] if parts.size() > 1 else ""

func generate_area_route(area_id: int = 1) -> Array[String]:
	current_area = area_id
	var config = AREA_CONFIGS.get(area_id)
	if config == null:
		push_error("[RouteGenerator] Unknown area: %d" % area_id)
		return []

	current_route.clear()
	pending_choices.clear()

	if _seed == 0:
		set_seed(int(Time.get_unix_time_from_system()) ^ (area_id * 1337))

	for slot in range(int(config.total_rooms)):
		if config.fixed_slots.has(slot):
			var fixed_token = str(config.fixed_slots[slot]).to_lower()
			
			# Fixed treasure rooms get a random reward symbol
			if fixed_token == "treasure":
				var sym = TREASURE_SYMBOLS[rng.randi_range(0, TREASURE_SYMBOLS.size() - 1)]
				current_route.append("treasure:" + sym)
			else:
				current_route.append(fixed_token)
		elif config.choice_slots.has(slot):
			var options: Array = config.choice_slots[slot].duplicate(true)
			for k in range(options.size()):
				options[k] = str(options[k]).to_lower()

			_shuffle_in_place(options)

			if options.size() >= 2 and options[0] == options[1]:
				options[1] = "combat:gold" if options[0] != "combat:gold" else "combat:boon"

			pending_choices[slot] = options
			current_route.append("CHOICE_%d" % slot)
		else:
			current_route.append("combat:gold")

	_print_route()
	emit_signal("route_generated", current_route)
	return current_route
	
func resolve_choice(slot_index: int, chosen_type: String) -> void:
	if not pending_choices.has(slot_index):
		push_warning("[RouteGenerator] No pending choice at slot %d" % slot_index)
		return

	var chosen := str(chosen_type).to_lower()
	var options: Array = pending_choices[slot_index]

	if not (chosen in options):
		push_error("[RouteGenerator] Invalid choice '%s'. Options were: %s" % [chosen, options])
		return

	current_route[slot_index] = chosen
	pending_choices.erase(slot_index)
	print("[RouteGenerator] Resolved slot %d -> %s" % [slot_index, chosen])

	# ---- Early shop conversion rule (per-area) ----
	# If player takes an optional early shop, convert the late fixed shop into a rest room.
	# (Keeps "one shop per area" pacing.) :contentReference[oaicite:8]{index=8}
	if get_base_room_type(chosen) == "shop":
		var config = AREA_CONFIGS.get(current_area, null)
		if config != null:
			var fixed: Dictionary = config.fixed_slots
			for k in fixed.keys():
				if int(k) != int(slot_index) and str(fixed[k]).to_lower() == "shop":
					var late_shop_idx := int(k)
					# Only convert if it's still in the future and still a shop in the current route.
					if late_shop_idx >= 0 and late_shop_idx < current_route.size():
						var cur := current_route[late_shop_idx]
						if get_base_room_type(cur) == "shop":
							current_route[late_shop_idx] = "rest"
							print("[RouteGenerator] Early shop taken; converted late shop at %d -> rest" % late_shop_idx)
					break

func get_choice_options(slot_index: int) -> Array:
	return pending_choices.get(slot_index, [])


func is_pending_choice(slot_index: int) -> bool:
	return pending_choices.has(slot_index)


func get_room_at(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= current_route.size():
		return ""
	return current_route[slot_index]

func get_room_display_info(room_type: String) -> Dictionary:
	var token = str(room_type).to_lower()
	var base = get_base_room_type(token)
	var reward = get_reward_key(token)

	var info = {
		"combat":   {"icon": "⚔", "color": Color(0.9, 0.2, 0.2), "desc": "Battle awaits"},
		"shrine":   {"icon": "✨", "color": Color(1.0, 0.84, 0.0), "desc": "Receive a blessing"},
		"shop":     {"icon": "🛒", "color": Color(0.9, 0.8, 0.2), "desc": "Spend your gold"},
		"treasure": {"icon": "💎", "color": Color(0.2, 0.8, 0.9), "desc": "Claim riches"},
		"rest":     {"icon": "🔥", "color": Color(1.0, 0.5, 0.2), "desc": "Restore health"},
		"boss":     {"icon": "💀", "color": Color(0.6, 0.1, 0.1), "desc": "Face the guardian"},
		"end":      {"icon": "🏆", "color": Color(0.3, 0.9, 0.3), "desc": "Victory"}
	}

	var out = info.get(base, {"icon": "?", "color": Color.WHITE, "desc": "Unknown"})

	match reward:
		"boon":
			out["icon"] = "✨"
			out["desc"] = "Fight for a blessing" if base == "combat" else "Claim a blessing"
		"gold":
			out["icon"] = "🪙"
			out["desc"] = "Fight for gold" if base == "combat" else "Claim gold"
		"mist":
			out["icon"] = "💠"
			out["desc"] = "Fight for mist shards" if base == "combat" else "Claim mist shards"
		"scroll":
			out["icon"] = "📜"
			out["desc"] = "Fight for scrolls" if base == "combat" else "Claim scrolls"
		"maxhp":
			out["icon"] = "❤️"
			out["desc"] = "Fight for vitality" if base == "combat" else "Claim vitality"
		"maxposture":
			out["icon"] = "🛡"
			out["desc"] = "Fight for resilience" if base == "combat" else "Claim resilience"

	return out
	
func _print_route() -> void:
	print("\n[RouteGenerator] === AREA %d ROUTE ===" % current_area)
	for i in range(current_route.size()):
		var room = current_route[i]
		var extra = ""
		if room.begins_with("CHOICE_"):
			var slot = int(room.split("_")[1])
			extra = " -> %s" % str(pending_choices.get(slot, []))
		print("  [%d] %s%s" % [i, room, extra])
	print("================================\n")
