extends Node

const LIVE_RUNTIME_SCENES: Array[PackedScene] = [
	preload("res://Enemy/Area 2/Boss/rootfang_runtime.tscn"),
	preload("res://Enemy/Area 2/Boss/briarthorn_runtime.tscn"),
	preload("res://Enemy/Area 2/Minibosses/rotwood_host_runtime.tscn"),
	preload("res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.tscn"),
	preload("res://Enemy/Area 2/Encounter/stalker_hound_runtime.tscn"),
	preload("res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.tscn"),
]

const EXPECTED_RUNTIME_SCRIPTS: Array[String] = [
	"res://Enemy/Area 2/Boss/rootfang_runtime.gd",
	"res://Enemy/Area 2/Boss/briarthorn_runtime.gd",
	"res://Enemy/Area 2/Minibosses/rotwood_host_runtime.gd",
	"res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.gd",
	"res://Enemy/Area 2/Encounter/stalker_hound_runtime.gd",
	"res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.gd",
]

const FORBIDDEN_DELAYED_CAPTURE_TOKENS: Array[String] = [
	"timeout.connect(func",
	"tween_callback(func",
]

const PASS_LINE := "[EnemyTemporaryLifetimeSmoke] PASS - live enemy runtime scenes own temporary-object lifetimes"

var _failures: Array[String] = []


func _ready() -> void:
	_validate_live_runtime_scene_authorities()
	_validate_runtime_sources_have_no_object_capture_lambdas()

	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return

	for failure: String in _failures:
		push_error("[EnemyTemporaryLifetimeSmoke] " + failure)
	get_tree().quit(1)


func _validate_live_runtime_scene_authorities() -> void:
	for i in range(LIVE_RUNTIME_SCENES.size()):
		var scene := LIVE_RUNTIME_SCENES[i]
		var expected_script := EXPECTED_RUNTIME_SCRIPTS[i]
		var instance_value: Variant = scene.instantiate()
		if not (instance_value is Node):
			_failures.append("could not instantiate %s" % scene.resource_path)
			continue
		var instance := instance_value as Node
		var script_value: Variant = instance.get_script()
		if not (script_value is Script):
			_failures.append("runtime scene has no root script: %s" % scene.resource_path)
		else:
			var actual_path := (script_value as Script).resource_path
			if actual_path != expected_script:
				_failures.append("runtime scene authority mismatch: %s -> %s (expected %s)" % [scene.resource_path, actual_path, expected_script])
		instance.free()


func _validate_runtime_sources_have_no_object_capture_lambdas() -> void:
	for path in EXPECTED_RUNTIME_SCRIPTS:
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			_failures.append("could not read runtime source: %s" % path)
			continue
		var source := file.get_as_text()
		for token in FORBIDDEN_DELAYED_CAPTURE_TOKENS:
			if source.contains(token):
				_failures.append("runtime source reintroduced orphanable delayed lambda '%s': %s" % [token, path])
