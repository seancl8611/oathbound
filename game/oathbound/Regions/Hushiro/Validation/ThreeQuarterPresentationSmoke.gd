extends Node

## Structural contract for the adopted Hushiro three-quarter presentation.
##
## This smoke deliberately validates presentation routing rather than visual quality. It
## proves that every Area 1 room role reaches the Hushiro wrapper/content layer while
## later regions continue using their shared/native room authority.

const HUSHIRO_ROOM_PATHS: Dictionary = {
	"combat": "res://Regions/Hushiro/Chambers/CombatChamber.tscn",
	"shrine": "res://Regions/Hushiro/Chambers/ShrineChamber.tscn",
	"merchant": "res://Regions/Hushiro/Chambers/MerchantChamber.tscn",
	"shop": "res://Regions/Hushiro/Chambers/MerchantChamber.tscn",
	"miniboss": "res://Regions/Hushiro/Chambers/MinibossChamber.tscn",
	"rest": "res://Regions/Hushiro/Chambers/RestChamber.tscn",
	"boss": "res://Regions/Hushiro/Chambers/BossChamber.tscn",
	"treasure": "res://Regions/Hushiro/Chambers/TreasureChamber.tscn",
}

const SHARED_SERVICE_PATHS: Dictionary = {
	"shrine": "res://Core/Chambers/Types/ShrineChamber.tscn",
	"merchant": "res://Core/Chambers/Types/MerchantChamber.tscn",
	"shop": "res://Core/Chambers/Types/MerchantChamber.tscn",
	"miniboss": "res://Core/Chambers/Types/MinibossChamber.tscn",
	"rest": "res://Core/Chambers/Types/RestChamber.tscn",
	"treasure": "res://Core/Chambers/Types/TreasureChamber.tscn",
}

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	_validate_hushiro_routing()
	_validate_later_region_isolation(2)
	_validate_later_region_isolation(3)

	if _failures.is_empty():
		print("[ThreeQuarterPresentationSmoke] PASS - Area 1 route wrappers + later-region isolation")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[ThreeQuarterPresentationSmoke] %s" % failure)
		print("[ThreeQuarterPresentationSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_hushiro_routing() -> void:
	for role_value: Variant in HUSHIRO_ROOM_PATHS.keys():
		var role := str(role_value)
		var expected_path := str(HUSHIRO_ROOM_PATHS[role])
		var packed := SceneRegistry.get_room_scene(1, role)
		_expect(packed != null, "Area 1 role '%s' returned no PackedScene" % role)
		if packed == null:
			continue
		_expect(packed.resource_path == expected_path, "Area 1 role '%s' resolved %s, expected %s" % [role, packed.resource_path, expected_path])

		var room := packed.instantiate()
		_expect(room != null, "Area 1 role '%s' failed to instantiate" % role)
		if room == null:
			continue
		var presentation := room.get_node_or_null("ThreeQuarterPresentation")
		_expect(presentation != null, "Area 1 role '%s' lacks ThreeQuarterPresentation" % role)
		if presentation != null:
			_expect(presentation.get_node_or_null("Scenery") != null, "Area 1 role '%s' lacks three-quarter Scenery" % role)
			if role != "combat":
				_expect(bool(presentation.get("hide_background_when_active")), "Area 1 service role '%s' must replace its legacy background in V2" % role)
		room.free()


func _validate_later_region_isolation(area_id: int) -> void:
	for role_value: Variant in SHARED_SERVICE_PATHS.keys():
		var role := str(role_value)
		var expected_path := str(SHARED_SERVICE_PATHS[role])
		var packed := SceneRegistry.get_room_scene(area_id, role)
		_expect(packed != null, "Area %d role '%s' returned no PackedScene" % [area_id, role])
		if packed != null:
			_expect(packed.resource_path == expected_path, "Area %d role '%s' leaked Hushiro presentation: %s" % [area_id, role, packed.resource_path])

	var combat := SceneRegistry.get_room_scene(area_id, "combat")
	_expect(combat != null, "Area %d combat scene missing" % area_id)
	if combat != null:
		_expect(not combat.resource_path.begins_with("res://Regions/Hushiro/"), "Area %d combat leaked Hushiro scene %s" % [area_id, combat.resource_path])

	var boss := SceneRegistry.get_room_scene(area_id, "boss")
	_expect(boss != null, "Area %d boss scene missing" % area_id)
	if boss != null:
		_expect(not boss.resource_path.begins_with("res://Regions/Hushiro/"), "Area %d boss leaked Hushiro scene %s" % [area_id, boss.resource_path])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
