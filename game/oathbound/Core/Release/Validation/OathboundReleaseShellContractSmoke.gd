extends Node

var failures: Array[String] = []


func _ready() -> void:
	_expect(SaveSlots.SLOT_COUNT == 3, "release requires exactly three save slots")
	_expect(SettingsRuntime.REBIND_ACTIONS.size() >= 10, "release settings must expose core control rebinding")
	for setting_key in ["master_volume", "music_volume", "sfx_volume", "ambience_volume", "vibration_enabled", "vibration_strength", "screen_shake", "reduced_flashing", "reduced_vfx", "high_contrast", "damage_numbers", "ui_scale", "text_scale", "dialogue_text_speed", "instant_text", "hold_to_toggle"]:
		_expect(SettingsRuntime.get_setting(setting_key, null) != null, "missing release setting: %s" % setting_key)
	_expect(CompletionRuntime.TOTAL_BLOODWELL == 18, "Bloodwell completion contract drifted")
	_expect(CompletionRuntime.TOTAL_MIRROR == 9, "Blood Mirror completion contract drifted")
	_expect(CompletionRuntime.TOTAL_PROSTHETICS == 8, "Prosthetic completion contract drifted")
	_expect(CompletionRuntime.TOTAL_PROSTHETIC_UPGRADES == 19, "Prosthetic upgrade completion contract drifted")
	_expect(CompletionRuntime.TOTAL_RELICS == 10, "Relic completion contract drifted")
	_expect(CompletionRuntime.TOTAL_RELIC_MASTERIES == 20, "Relic mastery completion contract drifted")
	_expect(CompletionRuntime.TOTAL_TECHNIQUE_RECORDS == 60, "Technique/refinement completion contract drifted")
	_expect(CompletionRuntime.TOTAL_RECORDS == 24, "Discovery Board record contract drifted")
	_expect(CompletionRuntime.TOTAL_HEART_ASPECTS == 3, "Heart Aspect completion contract drifted")
	_check_source_boundaries()
	if failures.is_empty():
		print("[OathboundReleaseShellContractSmoke] PASS - 3 slots settings completion title postgame")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("[OathboundReleaseShellContractSmoke] " + failure)
	get_tree().quit(1)


func _check_source_boundaries() -> void:
	var title_source := _read("res://TitleScreen/menu.gd") + _read("res://TitleScreen/menu.tscn")
	_expect(title_source.contains("OATHBOUND"), "title screen must use canonical Oathbound identity")
	_expect(not title_source.contains("Samurai Beast Hunter"), "retired prototype title returned")
	for required in ["Continue", "New Game", "Settings", "Credits", "Quit"]:
		_expect(title_source.contains(required), "title screen missing %s" % required)
	var well_source := _read("res://World/TheWell.gd")
	_expect(well_source.contains("Standard Expedition"), "completed-save Standard Expedition selection missing")
	_expect(well_source.contains("Heart Suppression"), "completed-save Heart Suppression selection missing")
	var credits_source := _read("res://GUI/CreditsMenu.gd")
	_expect(credits_source.contains("Godot Engine 4.7.2"), "credits must identify the engine")
	_expect(credits_source.contains("verified release asset manifest"), "credits must refuse invented dependency attribution")


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		failures.append("could not read " + path)
		return ""
	var content := file.get_as_text()
	file.close()
	return content


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
