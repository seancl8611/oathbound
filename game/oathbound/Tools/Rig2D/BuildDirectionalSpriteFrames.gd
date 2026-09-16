extends SceneTree

## Headless builder for offline rig -> PNG sequence -> SpriteFrames integration.
##
## Example:
## godot --headless --path game/oathbound --import
## godot --headless --path game/oathbound --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
##   --profile=res://Presentation/Profiles/AkioRigRendered2DProfile.tres \
##   --source=res://Art2D/RigRendered/Akio/Frames \
##   --output=res://Art2D/RigRendered/Akio/AkioDirectionalSpriteFrames.tres
##
## Expected flat frame names:
##   <animation_name>_<frame>.png
## Examples:
##   move_ne_000.png
##   attack_quick_slash_w_007.png


func _init() -> void:
	var options := _parse_options(OS.get_cmdline_user_args())
	var profile_path := str(options.get("profile", ""))
	var source_dir := str(options.get("source", ""))
	var output_path := str(options.get("output", ""))

	if profile_path.is_empty() or source_dir.is_empty() or output_path.is_empty():
		_fail("required arguments: --profile=... --source=... --output=...")
		return
	if not profile_path.begins_with("res://") or not source_dir.begins_with("res://") or not output_path.begins_with("res://"):
		_fail("profile/source/output must be res:// paths")
		return

	var profile_value := load(profile_path)
	if profile_value == null or not (profile_value is Resource):
		_fail("could not load profile: %s" % profile_path)
		return
	var profile := profile_value as Resource
	if not profile.has_method("expected_animation_names") or not profile.has_method("validate_contract"):
		_fail("resource is not a DirectionalSpriteProfile: %s" % profile_path)
		return

	var source := DirAccess.open(source_dir)
	if source == null:
		_fail("could not open frame directory: %s" % source_dir)
		return
	var files := source.get_files()
	files.sort()

	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	var expected_value: Variant = profile.call("expected_animation_names")
	if not (expected_value is PackedStringArray):
		_fail("profile returned invalid expected_animation_names")
		return
	var expected := expected_value as PackedStringArray
	var fps := maxf(1.0, float(profile.get("default_fps")))
	var missing := PackedStringArray()
	var total_frames := 0

	for animation_text: String in expected:
		var animation_name := StringName(animation_text)
		var matching := PackedStringArray()
		var prefix := "%s_" % animation_text
		for file_name: String in files:
			var lower := file_name.to_lower()
			if lower.begins_with(prefix.to_lower()) and lower.ends_with(".png"):
				matching.append(file_name)
		matching.sort()
		if matching.is_empty():
			missing.append(animation_text)
			continue

		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, fps)
		var animation_base := animation_text
		if profile.has_method("animation_base_from_name"):
			animation_base = str(profile.call("animation_base_from_name", animation_text))
		var should_loop := false
		if profile.has_method("is_looping_animation_base"):
			should_loop = bool(profile.call("is_looping_animation_base", animation_base))
		frames.set_animation_loop(animation_name, should_loop)

		for file_name: String in matching:
			var texture_value := load(source_dir.path_join(file_name))
			if texture_value == null or not (texture_value is Texture2D):
				_fail("could not load imported texture: %s" % source_dir.path_join(file_name))
				return
			frames.add_frame(animation_name, texture_value as Texture2D)
			total_frames += 1

	if not missing.is_empty():
		_fail("missing required animation renders: %s" % ", ".join(missing))
		return

	var output_abs := ProjectSettings.globalize_path(output_path)
	var mkdir_error := DirAccess.make_dir_recursive_absolute(output_abs.get_base_dir())
	if mkdir_error != OK and mkdir_error != ERR_ALREADY_EXISTS:
		_fail("could not create output directory: %s" % output_path.get_base_dir())
		return
	var save_error := ResourceSaver.save(frames, output_path)
	if save_error != OK:
		_fail("could not save SpriteFrames: %s error=%d" % [output_path, save_error])
		return

	profile.set("sprite_frames", frames)
	profile.set("asset_ready", true)
	var validation_value: Variant = profile.call("validate_contract", true)
	var errors := validation_value as PackedStringArray if validation_value is PackedStringArray else PackedStringArray(["profile validation returned invalid value"])
	if not errors.is_empty():
		profile.set("asset_ready", false)
		_fail("built atlas failed profile validation: %s" % " | ".join(errors))
		return

	var profile_save_error := ResourceSaver.save(profile, profile_path)
	if profile_save_error != OK:
		_fail("could not update profile with built SpriteFrames: error=%d" % profile_save_error)
		return

	print(
		"[Rig2DBuilder] PASS profile=%s animations=%d frames=%d output=%s"
		% [str(profile.get("profile_id")), expected.size(), total_frames, output_path]
	)
	quit(0)


func _parse_options(arguments: PackedStringArray) -> Dictionary:
	var result: Dictionary = {}
	for argument: String in arguments:
		if not argument.begins_with("--") or not argument.contains("="):
			continue
		var split_index := argument.find("=")
		var key := argument.substr(2, split_index - 2).strip_edges()
		var value := argument.substr(split_index + 1).strip_edges()
		if not key.is_empty():
			result[key] = value
	return result


func _fail(message: String) -> void:
	push_error("[Rig2DBuilder] %s" % message)
	quit(1)
