extends Node

## Canonical runtime scene registry.
##
## Shared service chambers remain common across regions. Region-specific combat/boss
## ownership is selected explicitly before GameFlow loads a chamber so Hushiro no
## longer acts as the implementation authority for later regions.

var _shared_rooms := {
	"combat": preload("res://Regions/Hushiro/Chambers/CombatChamber.tscn"),
	"shrine": preload("res://Core/Chambers/Types/ShrineChamber.tscn"),
	"merchant": preload("res://Core/Chambers/Types/MerchantChamber.tscn"),
	"miniboss": preload("res://Core/Chambers/Types/MinibossChamber.tscn"),
	"rest": preload("res://Core/Chambers/Types/RestChamber.tscn"),
	"boss": preload("res://Core/Chambers/Types/BossChamber.tscn"),
	"treasure": preload("res://Core/Chambers/Types/TreasureChamber.tscn"),

	# Kagutsuchi still uses the imported `shop` token until its own reconciliation.
	"shop": preload("res://Core/Chambers/Types/MerchantChamber.tscn"),
}

var _rooms_by_area := {
	1: {
		"combat": preload("res://Regions/Hushiro/Chambers/CombatChamber.tscn"),
	},
	2: {
		"combat": preload("res://Regions/Yomori/Chambers/CombatChamber.tscn"),
		"boss": preload("res://Regions/Yomori/Chambers/TwinMawsChamber.tscn"),
	},
}

var rooms: Dictionary = _shared_rooms.duplicate()
var active_area_id: int = 1


func activate_area(area_id: int) -> void:
	active_area_id = area_id
	rooms = _shared_rooms.duplicate()
	var overrides_value: Variant = _rooms_by_area.get(area_id, {})
	if overrides_value is Dictionary:
		for key_value: Variant in (overrides_value as Dictionary).keys():
			rooms[key_value] = (overrides_value as Dictionary)[key_value]
	print("[SceneRegistry] active area=%d combat=%s boss=%s" % [area_id, _scene_path(rooms.get("combat")), _scene_path(rooms.get("boss"))])


func get_room_scene(area_id: int, room_key: String) -> PackedScene:
	activate_area(area_id)
	var value: Variant = rooms.get(room_key.to_lower(), null)
	return value as PackedScene if value is PackedScene else null


func _scene_path(value: Variant) -> String:
	if value is PackedScene:
		return (value as PackedScene).resource_path
	return ""


var enemies_by_area := {
	1: {
		# Canonical Hushiro keys used by HushiroEncounterCatalog.
		"swordsman": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn"),
		"archer": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcher.tscn"),
		"hound": preload("res://Regions/Hushiro/Enemies/Standard/BlightedHound.tscn"),
		"bilemass": preload("res://Regions/Hushiro/Enemies/Standard/CellarBilemass.tscn"),
		"hollow": preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn"),
		"warden": preload("res://Regions/Hushiro/Enemies/Standard/Warden.tscn"),
	},
	2: {
		# Approved native Yomori roster only. These mature enemy implementations are
		# retained in their imported physical paths during this migration, but Hushiro
		# enemies are no longer valid Area 2 encounter keys.
		"lingering_wraith": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"lantern_wraith": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"mist_shepherd": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"stalker_hound": preload("res://Enemy/Area 2/Encounter/stalker_hound.tscn"),
	},
	3: {
		# Area 3 remains legacy until the Kagutsuchi reconciliation package.
		"soldier2": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"archer2": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"shade": preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn"),
		"healer": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"soldier3": preload("res://Enemy/Area 3/Encounter/court_guard.tscn"),
		"archer3": preload("res://Enemy/Area 3/Encounter/court_caster.tscn"),
		"vessel": preload("res://Enemy/Area 3/Encounter/hollow_vessel.tscn"),
		"brute": preload("res://Enemy/Area 3/Encounter/court_sentinel.tscn"),
		"shield": preload("res://Enemy/Area 3/Encounter/elite_defender.tscn")
	}
}
