extends Node

## Structural contract for the adopted game-wide three-quarter presentation.
## Validates room routing/presentation ownership, not visual art quality.

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

const CROSS_REGION_SERVICE_PATHS: Dictionary = {
	"shrine": "res://Core/Chambers/ThreeQuarter/ShrineChamber.tscn",
	"merchant": "res://Core/Chambers/ThreeQuarter/MerchantChamber.tscn",
	"shop": "res://Core/Chambers/ThreeQuarter/MerchantChamber.tscn",
	"miniboss": "res://Core/Chambers/ThreeQuarter/MinibossChamber.tscn",
	"rest": "res://Core/Chambers/ThreeQuarter/RestChamber.tscn",
	"treasure": "res://Core/Chambers/ThreeQuarter/TreasureChamber.tscn",
}

const YOMORI_ROOM_PATHS: Dictionary = {
	"combat": "res://Regions/Yomori/Chambers/CombatChamber.tscn",
	"boss": "res://Regions/Yomori/Chambers/TwinMawsChamber.tscn",
}

const KAGUTSUCHI_ROOM_PATHS: Dictionary = {
	"combat": "res://Regions/Kagutsuchi/Chambers/CombatChamber.tscn",
	"boss": "res://Regions/Kagutsuchi/Chambers/EclipseShogunChamber.tscn",
}

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	_validate_region(1, HUSHIRO_ROOM_PATHS)
	_validate_later_region(2, YOMORI_ROOM_PATHS)
	_validate_later_region(3, KAGUTSUCHI_ROOM_PATHS)

	if _failures.is_empty():
		print("[ThreeQuarterPresentationSmoke] PASS - Areas 1/2/3 route through adopted three-quarter presentation")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[ThreeQuarterPresentationSmoke] %s" % failure)
		print("[ThreeQuarterPresentationSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_region(area_id: int, expected_paths: Dictionary) -> void:
	for role_value: Variant in expected_paths.keys():
		var role := str(role_value)
		_validate_room(area_id, role, str(expected_paths[role]))


func _validate_later_region(area_id: int, native_paths: Dictionary) -> void:
	for role_value: Variant in CROSS_REGION_SERVICE_PATHS.keys():
		var role := str(role_value)
		_validate_room(area_id, role, str(CROSS_REGION_SERVICE_PATHS[role]))
	for role_value: Variant in native_paths.keys():
		var role := str(role_value)
		_validate_room(area_id, role, str(native_paths[role]))


func _validate_room(area_id: int, role: String, expected_path: String) -> void:
	var packed := SceneRegistry.get_room_scene(area_id, role)
	_expect(packed != null, "Area %d role '%s' returned no PackedScene" % [area_id, role])
	if packed == null:
		return
	_expect(packed.resource_path == expected_path, "Area %d role '%s' resolved %s, expected %s" % [area_id, role, packed.resource_path, expected_path])

	var room := packed.instantiate()
	_expect(room != null, "Area %d role '%s' failed to instantiate" % [area_id, role])
	if room == null:
		return
	var presentation := room.get_node_or_null("ThreeQuarterPresentation")
	_expect(presentation != null, "Area %d role '%s' lacks ThreeQuarterPresentation" % [area_id, role])
	if presentation != null:
		_expect(presentation.get_node_or_null("Scenery") != null, "Area %d role '%s' lacks three-quarter Scenery" % [area_id, role])
		if role in ["combat", "boss"]:
			_expect(presentation.get_node_or_null("CombatFX") != null or area_id == 1 and role == "boss", "Area %d role '%s' lacks projected combat FX" % [area_id, role])
		if area_id > 1:
			_expect(bool(presentation.get("hide_background_when_active")), "Area %d role '%s' must replace legacy dirt while three-quarter presentation is active" % [area_id, role])
	room.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
