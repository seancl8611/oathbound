extends Node

## Post-import playtest-readiness guard for the current Yomori actor set.
## Godot can emit first-pass UID fallback noise while importing a fresh checkout;
## this smoke runs after import and proves the source textures and actor scenes are
## actually loadable by the runtime that a local playtest will use.

const TEXTURE_FOLDERS: Dictionary = {
	"res://Textures/Enemy/foot_soldier": 21,
	"res://Textures/Enemy/shield_captain": 47,
	"res://Textures/Enemy/spirit_monk": 1,
}

const ACTOR_SCENES: Array[String] = [
	"res://Enemy/Area 2/Encounter/lingering_wraith.tscn",
	"res://Enemy/Area 2/Encounter/lantern_wraith.tscn",
	"res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn",
	"res://Enemy/Area 2/Encounter/stalker_hound.tscn",
	"res://Enemy/Area 2/Minibosses/embered_pilgrim.tscn",
	"res://Enemy/Area 2/Minibosses/rotwood_host.tscn",
	"res://Enemy/Area 2/Boss/rootfang.tscn",
	"res://Enemy/Area 2/Boss/briarthorn.tscn",
]

var _failures: Array[String] = []
var _loaded_textures: int = 0
var _loaded_actors: int = 0


func _ready() -> void:
	_validate_texture_folders()
	_validate_actor_scenes()

	if _failures.is_empty():
		print("[YomoriVisualAssetSmoke] PASS - textures=%d actors=%d | post-import Yomori visuals loadable" % [_loaded_textures, _loaded_actors])
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[YomoriVisualAssetSmoke] %s" % failure)
		print("[YomoriVisualAssetSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_texture_folders() -> void:
	for folder_value: Variant in TEXTURE_FOLDERS.keys():
		var folder := str(folder_value)
		var expected_count := int(TEXTURE_FOLDERS[folder_value])
		var png_files: Array[String] = []
		for file_name: String in DirAccess.get_files_at(folder):
			if file_name.to_lower().ends_with(".png"):
				png_files.append(file_name)
		_expect(png_files.size() >= expected_count, "%s contains %d PNGs; expected at least %d" % [folder, png_files.size(), expected_count])
		for file_name: String in png_files:
			var path := "%s/%s" % [folder, file_name]
			_expect(ResourceLoader.exists(path, "Texture2D"), "Texture resource is not registered: %s" % path)
			var texture_value: Variant = ResourceLoader.load(path, "Texture2D")
			if not (texture_value is Texture2D):
				_fail("Texture failed runtime load: %s" % path)
				continue
			var texture: Texture2D = texture_value as Texture2D
			var size := texture.get_size()
			_expect(size.x > 0.0 and size.y > 0.0, "Texture has invalid dimensions: %s -> %s" % [path, str(size)])
			_loaded_textures += 1


func _validate_actor_scenes() -> void:
	for scene_path: String in ACTOR_SCENES:
		_expect(ResourceLoader.exists(scene_path, "PackedScene"), "Yomori actor scene is not registered: %s" % scene_path)
		var scene_value: Variant = ResourceLoader.load(scene_path, "PackedScene")
		if not (scene_value is PackedScene):
			_fail("Yomori actor scene failed runtime load: %s" % scene_path)
			continue
		var actor: Node = (scene_value as PackedScene).instantiate()
		_expect(actor != null, "Yomori actor scene failed instantiate: %s" % scene_path)
		if actor != null:
			_expect(_has_visible_sprite_resource(actor), "Yomori actor has no loadable sprite resource: %s" % scene_path)
			actor.free()
		_loaded_actors += 1


func _has_visible_sprite_resource(root: Node) -> bool:
	if root is Sprite2D:
		return (root as Sprite2D).texture != null
	if root is AnimatedSprite2D:
		var animated := root as AnimatedSprite2D
		return animated.sprite_frames != null and not animated.sprite_frames.get_animation_names().is_empty()
	for child: Node in root.get_children():
		if _has_visible_sprite_resource(child):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)