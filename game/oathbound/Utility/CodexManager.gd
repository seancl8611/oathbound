extends Node

## CodexManager — Autoload tracking discovery state for the Codex Board.
## Add as autoload: Project > Project Settings > Autoload > CodexManager
##
## Depends on: ProstheticManager (autoload) for prosthetic/relic data.
##             SceneRegistry (autoload) for auto-detecting enemy types.
##
## Enemy entries are registered here with weakness hints.
## Any enemies in SceneRegistry that aren't manually defined get auto-registered
## with placeholder data, so you never have to edit this file when adding enemies.
##
## Call CodexManager.discover_enemy(id) after combat encounters to unlock pages.

signal enemy_discovered(enemy_id: String)

# =====================
# ENEMY DEFINITIONS
# =====================

## Manually authored entries with full descriptions and hints.
## Keys MUST match SceneRegistry enemy keys (e.g. "shade", "dog", "archer").
## Bosses aren't in SceneRegistry so they use their own IDs.
var enemy_defs = {}

# =====================
# DISCOVERY STATE
# =====================

## { enemy_id: encounter_count }
var discovered_enemies = {}


# =====================
# INIT
# =====================

func _ready():
	_register_manual_entries()
	_auto_register_from_scene_registry()


# =====================
# MANUAL ENTRIES — edit descriptions and hints here
# =====================

func _register_manual_entries():
	## Add your hand-authored enemy data here.
	## Keys for regular enemies should match SceneRegistry keys.

	# --- Regular Enemies (keys match SceneRegistry) ---
	enemy_defs["shade"] = {
		"display_name": "Lost Shade",
		"category": "regular",
		"description": "Restless spirits trapped between realms. They attack in groups with reckless aggression.",
		"weakness_hints": [
			"Vulnerable during their slow overhead swing.",
			"Parrying staggers them longer than most enemies.",
			"Fire-based prosthetics deal bonus damage.",
		],
		"encounters_for_hints": [1, 3, 6],
	}

	enemy_defs["dog"] = {
		"display_name": "Wild Dog",
		"category": "regular",
		"description": "Feral beasts that hunt in pairs. Quick lunges and relentless pressure.",
		"weakness_hints": [
			"Their lunge has a brief telegraph before they leap.",
			"Shuriken interrupts their charge attack.",
			"Low posture — aggressive deflection breaks them fast.",
		],
		"encounters_for_hints": [1, 3, 6],
	}

	enemy_defs["archer"] = {
		"display_name": "Archer",
		"category": "regular",
		"description": "Ranged attackers who prefer distance. They reposition when pressured.",
		"weakness_hints": [
			"Close the gap quickly — they panic up close.",
			"Projectiles can be deflected with proper timing.",
			"The Iron Fortress prosthetic reflects their arrows.",
		],
		"encounters_for_hints": [1, 2, 5],
	}

	enemy_defs["warden"] = {
		"display_name": "Warden",
		"category": "regular",
		"description": "Heavily armored shield-bearers. Slow but extremely durable.",
		"weakness_hints": [
			"Don't bother attacking while their shield is raised.",
			"Wait for their heavy slam — the recovery window is long.",
			"Posture damage is key; their HP pool is massive.",
		],
		"encounters_for_hints": [1, 3, 5],
	}

	enemy_defs["soldier"] = {
		"display_name": "Foot Soldier",
		"category": "regular",
		"description": "Rank-and-file warriors with basic combat training. Predictable but dangerous in numbers.",
		"weakness_hints": [
			"Their attacks follow a simple pattern — learn the rhythm.",
			"They telegraph heavily before swinging.",
			"Easily staggered by prosthetic tools.",
		],
		"encounters_for_hints": [1, 3, 5],
	}

	enemy_defs["brute"] = {
		"display_name": "Brute",
		"category": "regular",
		"description": "Massive, slow-moving enforcers. Their hits are devastating but their recovery is punishable.",
		"weakness_hints": [
			"Never trade blows — their damage is too high.",
			"Dodge their overhead slam, then counter during recovery.",
			"Ranged prosthetics can chip them safely from a distance.",
		],
		"encounters_for_hints": [1, 3, 5],
	}

	# --- Mini-Bosses ---
	enemy_defs["akaname"] = {
		"display_name": "Akaname",
		"category": "mini_boss",
		"description": "A grotesque yokai that lurks in dark places. Its tongue strikes with terrifying range.",
		"weakness_hints": [
			"Its tongue lash is unblockable — dodge sideways.",
			"Fire stuns it briefly, creating an opening.",
			"After three attacks it pauses to catch breath.",
		],
		"encounters_for_hints": [1, 2, 3],
	}

	# --- Bosses (not in SceneRegistry — manual IDs) ---
	enemy_defs["shield_captain"] = {
		"display_name": "Shield Captain",
		"category": "boss",
		"description": "A fallen warrior who still commands the battlefield. Combines defense with devastating combos.",
		"weakness_hints": [
			"His shield bash is perilous — jump or dodge, don't block.",
			"The cannon blast leaves him open for a full combo.",
			"Breaking his posture requires patience and perfect deflects.",
		],
		"encounters_for_hints": [1, 2, 3],
	}

	enemy_defs["chain_collector"] = {
		"display_name": "Chain Collector",
		"category": "boss",
		"description": "A spectral entity bound by cursed chains. It ensnares victims and vanishes into shadow.",
		"weakness_hints": [
			"When it turns invisible, watch for dust footsteps.",
			"The snare grab is telegraphed — side-step immediately.",
			"Ground masses can be avoided by staying mobile.",
		],
		"encounters_for_hints": [1, 2, 3],
	}

	enemy_defs["ashen_boss"] = {
		"display_name": "The Ashen One",
		"category": "boss",
		"description": "A warrior consumed by ash and flame. Relentless aggression across multiple phases.",
		"weakness_hints": [
			"Red flashes signal perilous attacks — do not block.",
			"Phase transitions create brief windows to heal.",
			"Aggressive posture pressure is rewarded in the final phase.",
		],
		"encounters_for_hints": [1, 2, 3],
	}


# =====================
# AUTO-REGISTRATION FROM SCENE REGISTRY
# =====================

func _auto_register_from_scene_registry():
	## Scans all areas in SceneRegistry.enemies_by_area and registers
	## any enemy types not already manually defined.
	## This means you only need to add enemies to SceneRegistry —
	## they'll appear in the Codex automatically.

	if not is_instance_valid(SceneRegistry):
		push_warning("[CodexManager] SceneRegistry not found — skipping auto-register.")
		return

	if not "enemies_by_area" in SceneRegistry:
		push_warning("[CodexManager] SceneRegistry has no enemies_by_area — skipping auto-register.")
		return

	var registered_count = 0
	for area_id in SceneRegistry.enemies_by_area:
		var area_enemies = SceneRegistry.enemies_by_area[area_id]
		for enemy_key in area_enemies:
			if enemy_defs.has(enemy_key):
				continue  # Already manually defined

			# Auto-register with placeholder data
			var display_name = enemy_key.replace("_", " ").capitalize()
			enemy_defs[enemy_key] = {
				"display_name": display_name,
				"category": "regular",
				"description": "A mysterious foe. Not much is known yet.",
				"weakness_hints": [
					"Study its attack patterns carefully.",
				],
				"encounters_for_hints": [1],
			}
			registered_count += 1
			print("[CodexManager] Auto-registered enemy from SceneRegistry: ", enemy_key)

	print("[CodexManager] %d manual entries, %d auto-registered from SceneRegistry" % [enemy_defs.size() - registered_count, registered_count])


# =====================
# ENEMY DISCOVERY
# =====================

func discover_enemy(enemy_id: String):
	## Call this after a combat encounter with an enemy type.
	## The enemy_id should match the SceneRegistry key (e.g. "shade", "dog").
	## First call unlocks the codex entry. Subsequent calls unlock more hints.
	if not enemy_defs.has(enemy_id):
		push_warning("[CodexManager] Unknown enemy ID: " + enemy_id + " — auto-registering.")
		# Auto-register on the fly so discovery still works
		enemy_defs[enemy_id] = {
			"display_name": enemy_id.replace("_", " ").capitalize(),
			"category": "regular",
			"description": "A mysterious foe. Not much is known yet.",
			"weakness_hints": ["Study its attack patterns carefully."],
			"encounters_for_hints": [1],
		}

	if discovered_enemies.has(enemy_id):
		discovered_enemies[enemy_id] += 1
	else:
		discovered_enemies[enemy_id] = 1
		enemy_discovered.emit(enemy_id)
		print("[CodexManager] Enemy discovered: ", enemy_id)

func is_enemy_discovered(enemy_id: String) -> bool:
	return discovered_enemies.has(enemy_id)

func get_enemy_encounter_count(enemy_id: String) -> int:
	return discovered_enemies.get(enemy_id, 0)

func get_revealed_hints(enemy_id: String) -> Array:
	## Returns only the hints the player has earned based on encounter count.
	var def = enemy_defs.get(enemy_id, {})
	if def.is_empty():
		return []

	var count = get_enemy_encounter_count(enemy_id)
	var hints = def.get("weakness_hints", [])
	var thresholds = def.get("encounters_for_hints", [])
	var revealed = []

	for i in range(hints.size()):
		if i < thresholds.size() and count >= thresholds[i]:
			revealed.append(hints[i])
		elif i >= thresholds.size() and count > 0:
			revealed.append(hints[i])

	return revealed

func get_total_hint_count(enemy_id: String) -> int:
	var def = enemy_defs.get(enemy_id, {})
	return def.get("weakness_hints", []).size()


# =====================
# GETTERS (for CodexMenu)
# =====================

func get_all_enemy_ids() -> Array:
	return enemy_defs.keys()

func get_enemy_data(enemy_id: String) -> Dictionary:
	return enemy_defs.get(enemy_id, {})

func get_enemies_by_category(category: String) -> Array:
	## Returns enemy IDs filtered by category: "regular", "mini_boss", "boss"
	var result = []
	for eid in enemy_defs:
		if enemy_defs[eid].get("category", "") == category:
			result.append(eid)
	return result


# =====================
# SAVE / LOAD
# =====================

func get_save_data() -> Dictionary:
	return {
		"discovered_enemies": discovered_enemies.duplicate(),
	}

func load_save_data(data: Dictionary):
	discovered_enemies = data.get("discovered_enemies", {})
