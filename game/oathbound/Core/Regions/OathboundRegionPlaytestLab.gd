extends "res://Core/Corruption/OathboundCorruptionPlaytestLab.gd"

## Region-focused Playtest Lab controls.
##
## The normal run remains the authority for progression. These controls exist only
## to isolate one regional variable at a time so content development does not
## require replaying earlier regions for every manual check.

const YOMORI_TEST_ACTORS := [
	{"id": "lingering_wraith", "name": "Lingering Wraith", "scene": "res://Enemy/Area 2/Encounter/lingering_wraith.tscn"},
	{"id": "lantern_wraith", "name": "Lantern Wraith", "scene": "res://Enemy/Area 2/Encounter/lantern_wraith.tscn"},
	{"id": "mist_shepherd", "name": "Mist Shepherd", "scene": "res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"},
	{"id": "stalker_hound", "name": "Stalker Hound", "scene": "res://Enemy/Area 2/Encounter/stalker_hound.tscn"},
	{"id": "embered_pilgrim", "name": "Embered Pilgrim", "scene": "res://Enemy/Area 2/Minibosses/embered_pilgrim.tscn"},
	{"id": "rotwood_host", "name": "Rotwood Host", "scene": "res://Enemy/Area 2/Minibosses/rotwood_host.tscn"},
]

const KAGUTSUCHI_TEST_ACTORS := [
	{"id": "court_guard", "name": "Court Guard", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.tscn"},
	{"id": "court_caster", "name": "Court Caster", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.tscn"},
	{"id": "elite_defender", "name": "Elite Defender", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.tscn"},
	{"id": "hollow_vessel", "name": "Hollow Vessel", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.tscn"},
	{"id": "court_sentinel", "name": "Court Sentinel", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.tscn"},
	{"id": "blood_lotus", "name": "Blood Lotus", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn"},
	{"id": "eternal_swordsman", "name": "Eternal Swordsman", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn"},
	{"id": "eclipse_shogun", "name": "Eclipse Shogun", "scene": "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.tscn"},
]

# Milestone tests are session-only. Keep normal gameplay as the default.
const FOCUSED_TEST_NORMAL: String = "normal"
const FOCUSED_TEST_AKIO_CHECKPOINT_B: String = "akio_checkpoint_b_quick_slash"
const QUICK_TIMING_PROTOTYPE: String = "prototype"
const QUICK_TIMING_HAMMER: String = "hammer_source_30fps"

# Presentation-only comparison presets. Baseline preserves the commissioned
# profile's exact existing filtering, scale and subpixel actor placement.
const AKIO_RENDER_BASELINE: String = "baseline"
const AKIO_RENDER_NEAREST: String = "nearest"
const AKIO_RENDER_LINEAR_SNAP: String = "linear_snap"
const AKIO_RENDER_NEAREST_SNAP: String = "nearest_snap"
const AKIO_RENDER_LINEAR_125: String = "linear_125"
const AKIO_RENDER_MIPMAPPED_RUN: String = "mipmapped_run"

# Owner confirmed PHYSICS+ON and IDLE+OFF both remove camera-induced Run
# jitter; IDLE+ON is the faulty legacy combination. The corrected default
# PHYSICS+ON is authoritative in CameraFollow.gd, not this diagnostic menu.
# Keep the two old configurations for a focused regression comparison.
const AKIO_SYNC_BASELINE: String = "baseline"
const AKIO_SYNC_POSE_LOCK: String = "pose_lock"
const AKIO_SYNC_LEGACY_IDLE_SMOOTHING: String = "legacy_idle_smoothing"
const AKIO_SYNC_LEGACY_IDLE_NO_SMOOTHING: String = "legacy_idle_no_smoothing"
const AKIO_SYNC_MODES: Array[String] = [
	AKIO_SYNC_BASELINE, AKIO_SYNC_POSE_LOCK,
	AKIO_SYNC_LEGACY_IDLE_SMOOTHING, AKIO_SYNC_LEGACY_IDLE_NO_SMOOTHING,
]
const AKIO_RENDER_PRESETS: Array[String] = [
	AKIO_RENDER_BASELINE, AKIO_RENDER_NEAREST,
	AKIO_RENDER_LINEAR_SNAP, AKIO_RENDER_NEAREST_SNAP,
	AKIO_RENDER_LINEAR_125, AKIO_RENDER_MIPMAPPED_RUN,
]
const AKIO_SOURCE_PROFILE = preload("res://Presentation/Profiles/AkioCheckpointBProfile.tres")
const AKIO_SOURCE_FPS: float = 30.0
const AKIO_SOURCE_DIRECTIONS: Array[String] = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
const AKIO_SOURCE_ANIMATIONS: Array[String] = ["attack_quick_slash", "move", "idle"]

var _focused_test_scenario: String = FOCUSED_TEST_NORMAL
var _focused_diagnostics_enabled: bool = true
var _focused_scenario_dropdown: OptionButton
var _quick_slash_timing_mode: String = QUICK_TIMING_HAMMER
var _quick_slash_timing_dropdown: OptionButton
var _akio_render_preset: String = AKIO_RENDER_BASELINE
var _akio_render_dropdown: OptionButton
var _akio_sync_test_mode: String = AKIO_SYNC_BASELINE
var _akio_sync_dropdown: OptionButton
# Session-only generated GPU mipmaps; no PNGs or other files are written.
var _akio_mipped_run_frames: SpriteFrames = null
var _akio_mipped_source_id: int = 0
var _run_trace_armed: bool = false
var _run_trace_start_ms: int = -1
var _run_trace_status: Label
const RUN_TRACE_DURATION_MS: int = 12000
const RUN_CONTACT_CROP := Rect2i(160, 88, 192, 192)
const RUN_CONTACT_DIRECTIONS: Array[String] = ["e", "w", "n", "s"]
var _focused_diagnostics_check: CheckButton
var _source_preview_enabled: bool = false
var _source_preview_frame: int = 0
var _source_preview_elapsed: float = 0.0
var _source_preview_animation: OptionButton
var _source_preview_direction: OptionButton
var _source_preview_sprite: Sprite2D
var _source_preview_status: Label
var _source_preview_toggle: CheckButton


const PLAYTEST_POWER_MULTIPLIERS: Array[float] = [1.0, 2.0, 3.0, 5.0, 10.0]
const RECOMMENDED_INTEGRATION_POWER: float = 5.0
const FAST_CLEAR_POWER: float = 10.0

var _yomori_actor_dropdown: OptionButton
var _kagutsuchi_actor_dropdown: OptionButton
var _region_status: Label
var _chamber_area_dropdown: OptionButton
var _power_health_dropdown: OptionButton
var _power_posture_dropdown: OptionButton
var _power_status: Label
var _playtest_health_damage_multiplier: float = 1.0
var _playtest_posture_damage_multiplier: float = 1.0


func _build_ui() -> void:
	super._build_ui()
	# The inherited lab used a fixed minimum-size panel. At the project's 640x360
	# authority viewport, taller inherited tabs can extend below the screen. Keep the
	# shell inside the viewport; each tab is independently scrollable via _make_tab().
	if _ui == null:
		return
	for child: Node in _ui.get_children():
		if child is PanelContainer:
			var panel := child as PanelContainer
			panel.anchor_left = 0.0
			panel.anchor_top = 0.0
			panel.anchor_right = 1.0
			panel.anchor_bottom = 1.0
			panel.offset_left = 12.0
			panel.offset_top = 12.0
			panel.offset_right = -12.0
			panel.offset_bottom = -12.0
			panel.custom_minimum_size = Vector2.ZERO
			break


func _make_tab(tabs: TabContainer, title: String) -> VBoxContainer:
	# Keep the public helper contract used by all inherited Playtest Lab layers while
	# putting every tab inside a real ScrollContainer. Mouse wheel and scrollbars now
	# reach controls that do not fit at small viewport/window sizes.
	var scroll := ScrollContainer.new()
	scroll.name = title
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.add_child(scroll)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)
	return vbox


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_power_tab(tabs)
	_build_region_tab(tabs)
	_build_focused_tests_tab(tabs)


func _build_power_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Power")

	var title := Label.new()
	title.text = "Playtest-only combat power"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)

	var intro := Label.new()
	intro.text = "Outgoing multipliers are debug-session controls only. 1x is canonical gameplay and remains the default."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.modulate = Color(0.72, 0.74, 0.82)
	vbox.add_child(intro)

	var health_label := Label.new()
	health_label.text = "Health damage multiplier"
	vbox.add_child(health_label)
	_power_health_dropdown = _make_power_dropdown()
	_power_health_dropdown.item_selected.connect(func(_index: int) -> void: _apply_custom_power())
	vbox.add_child(_power_health_dropdown)

	var posture_label := Label.new()
	posture_label.text = "Posture damage multiplier"
	vbox.add_child(posture_label)
	_power_posture_dropdown = _make_power_dropdown()
	_power_posture_dropdown.item_selected.connect(func(_index: int) -> void: _apply_custom_power())
	vbox.add_child(_power_posture_dropdown)

	var preset_row := HBoxContainer.new()
	vbox.add_child(preset_row)

	var normal := Button.new()
	normal.text = "Normal 1x"
	normal.pressed.connect(_set_power_preset.bind(1.0, false))
	preset_row.add_child(normal)

	var recommended := Button.new()
	recommended.text = "Recommended 5x + Invulnerable"
	recommended.pressed.connect(_set_power_preset.bind(RECOMMENDED_INTEGRATION_POWER, true))
	preset_row.add_child(recommended)

	var fast_clear := Button.new()
	fast_clear.text = "Fast Clear 10x + Invulnerable"
	fast_clear.pressed.connect(_set_power_preset.bind(FAST_CLEAR_POWER, true))
	preset_row.add_child(fast_clear)

	var restore := Button.new()
	restore.text = "Restore HP / Posture / Spirit"
	restore.pressed.connect(_restore_player)
	vbox.add_child(restore)

	_power_status = Label.new()
	_power_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_power_status.modulate = Color(0.78, 0.80, 0.88)
	vbox.add_child(_power_status)

	var note := Label.new()
	note.text = "Recommended integration setting: 5x Health + 5x Posture + Invulnerable. Use 10x only when you need to reach teardown, reward, or region-transition logic quickly; it is intentionally too strong for pacing/balance evaluation."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.66, 0.68, 0.76)
	vbox.add_child(note)

	_sync_power_dropdowns()
	_refresh_power_status()


func _make_power_dropdown() -> OptionButton:
	var dropdown := OptionButton.new()
	for multiplier: float in PLAYTEST_POWER_MULTIPLIERS:
		dropdown.add_item("%.0fx" % multiplier)
		dropdown.set_item_metadata(dropdown.item_count - 1, multiplier)
	return dropdown


func _selected_power_multiplier(dropdown: OptionButton) -> float:
	if dropdown == null or dropdown.item_count <= 0:
		return 1.0
	return clampf(float(dropdown.get_item_metadata(dropdown.selected)), 1.0, FAST_CLEAR_POWER)


func _apply_custom_power() -> void:
	_playtest_health_damage_multiplier = _selected_power_multiplier(_power_health_dropdown)
	_playtest_posture_damage_multiplier = _selected_power_multiplier(_power_posture_dropdown)
	_refresh_power_status()
	print("[PlaytestLab] Custom power: Health %.1fx | Posture %.1fx" % [
		_playtest_health_damage_multiplier,
		_playtest_posture_damage_multiplier,
	])


func _set_power_preset(multiplier: float, invulnerable: bool) -> void:
	var clamped := clampf(multiplier, 1.0, FAST_CLEAR_POWER)
	_playtest_health_damage_multiplier = clamped
	_playtest_posture_damage_multiplier = clamped
	_sync_power_dropdowns()
	var player: Node = _get_player()
	if player != null:
		if player.has_method("set_playtest_invulnerable"):
			player.call("set_playtest_invulnerable", invulnerable)
		if player.has_method("playtest_restore_full"):
			player.call("playtest_restore_full")
	_sync_player_controls()
	_refresh_status()
	_refresh_power_status()
	print("[PlaytestLab] Power preset: %.1fx Health/Posture | Invulnerable=%s" % [clamped, str(invulnerable)])


func _sync_power_dropdowns() -> void:
	_select_power_dropdown_value(_power_health_dropdown, _playtest_health_damage_multiplier)
	_select_power_dropdown_value(_power_posture_dropdown, _playtest_posture_damage_multiplier)


func _select_power_dropdown_value(dropdown: OptionButton, multiplier: float) -> void:
	if dropdown == null:
		return
	for index: int in range(dropdown.item_count):
		if is_equal_approx(float(dropdown.get_item_metadata(index)), multiplier):
			dropdown.select(index)
			return


func _refresh_power_status() -> void:
	if _power_status == null:
		return
	var player: Node = _get_player()
	var invulnerable := false
	if player != null and player.has_method("is_playtest_invulnerable"):
		invulnerable = bool(player.call("is_playtest_invulnerable"))
	_power_status.text = "Current: Health %.1fx | Posture %.1fx | Invulnerable: %s\nPower multipliers stay active across chamber/region warps until changed or the debug session ends." % [
		_playtest_health_damage_multiplier,
		_playtest_posture_damage_multiplier,
		str(invulnerable),
	]


func get_playtest_health_damage_multiplier() -> float:
	if not OS.is_debug_build():
		return 1.0
	return clampf(_playtest_health_damage_multiplier, 1.0, FAST_CLEAR_POWER)


func get_playtest_posture_damage_multiplier() -> float:
	if not OS.is_debug_build():
		return 1.0
	return clampf(_playtest_posture_damage_multiplier, 1.0, FAST_CLEAR_POWER)


func _build_room_tab(tabs: TabContainer) -> void:
	# Replace the imported Hushiro-only chamber warp with one obvious selector that
	# can jump directly into any current region. This is the primary manual-integration
	# path; the dedicated Regions tab below remains useful for one-click named targets.
	var vbox: VBoxContainer = _make_tab(tabs, "Chambers")

	var row := HBoxContainer.new()
	vbox.add_child(row)

	var reload_button := Button.new()
	reload_button.text = "Reload Current Chamber"
	reload_button.pressed.connect(_reload_current_room)
	row.add_child(reload_button)

	var hub_button := Button.new()
	hub_button.text = "Return to Hub"
	hub_button.pressed.connect(_return_to_hub)
	row.add_child(hub_button)

	var area_label := Label.new()
	area_label.text = "Target Region"
	vbox.add_child(area_label)

	_chamber_area_dropdown = OptionButton.new()
	for entry: Dictionary in [
		{"label": "Area 1 - Hushiro", "id": 1},
		{"label": "Area 2 - Yomori", "id": 2},
		{"label": "Area 3 - Kagutsuchi", "id": 3},
	]:
		_chamber_area_dropdown.add_item(str(entry.get("label", "")))
		_chamber_area_dropdown.set_item_metadata(_chamber_area_dropdown.item_count - 1, int(entry.get("id", 1)))
	vbox.add_child(_chamber_area_dropdown)

	var room_label := Label.new()
	room_label.text = "Target Chamber"
	vbox.add_child(room_label)

	_room_dropdown = OptionButton.new()
	for room_type: String in ["combat", "shrine", "merchant", "rest", "miniboss", "boss"]:
		_room_dropdown.add_item(room_type.capitalize())
	vbox.add_child(_room_dropdown)

	var warp_button := Button.new()
	warp_button.text = "Warp Directly to Selected Region / Chamber"
	warp_button.pressed.connect(_warp_selected_region_chamber)
	vbox.add_child(warp_button)

	var note := Label.new()
	note.text = "Debug warp resets run-scoped state for the selected region. You do not need to clear Hushiro or kill Keeper before testing Yomori or Kagutsuchi."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.70, 0.74, 0.82)
	vbox.add_child(note)


func _warp_selected_region_chamber() -> void:
	if _chamber_area_dropdown == null or _chamber_area_dropdown.item_count <= 0:
		return
	if _room_dropdown == null or _room_dropdown.item_count <= 0:
		return
	var area_id := int(_chamber_area_dropdown.get_item_metadata(_chamber_area_dropdown.selected))
	var room_token := _room_dropdown.get_item_text(_room_dropdown.selected).to_lower()
	_warp_region_room(area_id, room_token)


func _build_region_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Regions")

	var title := Label.new()
	title.text = "Targeted region tests"
	vbox.add_child(title)

	_add_region_heading(vbox, "Yomori Grove")
	_add_room_warp_row(vbox, 2, [
		{"label": "Yomori Combat", "token": "combat"},
		{"label": "Yomori Miniboss", "token": "miniboss"},
		{"label": "Twin Maws", "token": "boss"},
		{"label": "Treasure", "token": "treasure"},
	])
	_add_room_warp_row(vbox, 2, [
		{"label": "Shrine", "token": "shrine"},
		{"label": "Merchant", "token": "merchant"},
		{"label": "Rest", "token": "rest"},
	])

	_yomori_actor_dropdown = _make_actor_dropdown(YOMORI_TEST_ACTORS)
	vbox.add_child(_yomori_actor_dropdown)
	_add_actor_spawn_row(vbox, _yomori_actor_dropdown, "Yomori")

	vbox.add_child(HSeparator.new())
	_add_region_heading(vbox, "Kagutsuchi Court")
	_add_room_warp_row(vbox, 3, [
		{"label": "Court Combat", "token": "combat"},
		{"label": "Court Miniboss", "token": "miniboss"},
		{"label": "Eclipse Shogun", "token": "boss"},
		{"label": "Treasure", "token": "treasure"},
	])
	_add_room_warp_row(vbox, 3, [
		{"label": "Shrine", "token": "shrine"},
		{"label": "Merchant", "token": "merchant"},
		{"label": "Rest", "token": "rest"},
	])

	_kagutsuchi_actor_dropdown = _make_actor_dropdown(KAGUTSUCHI_TEST_ACTORS)
	vbox.add_child(_kagutsuchi_actor_dropdown)
	_add_actor_spawn_row(vbox, _kagutsuchi_actor_dropdown, "Kagutsuchi")

	_region_status = Label.new()
	_region_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_region_status.modulate = Color(0.70, 0.74, 0.82)
	_region_status.text = "Room warps reset run-scoped state and load the selected regional authority directly. Actor spawns isolate behavior only; use room warps to validate chamber rewards, miniboss resolution, Twin Maws, and Eclipse Shogun flow."
	vbox.add_child(_region_status)

	print("[OathboundPlaytestLab] Regions tab built with Yomori + Kagutsuchi targeted tests")


func _add_region_heading(vbox: VBoxContainer, text: String) -> void:
	var heading := Label.new()
	heading.text = text
	heading.add_theme_font_size_override("font_size", 18)
	vbox.add_child(heading)


func _add_room_warp_row(vbox: VBoxContainer, area_id: int, entries: Array) -> void:
	var row := HBoxContainer.new()
	vbox.add_child(row)
	for entry_value: Variant in entries:
		if not (entry_value is Dictionary):
			continue
		var entry: Dictionary = entry_value as Dictionary
		var button := Button.new()
		button.text = str(entry.get("label", ""))
		button.pressed.connect(_warp_region_room.bind(area_id, str(entry.get("token", "combat"))))
		row.add_child(button)


func _make_actor_dropdown(entries: Array) -> OptionButton:
	var dropdown := OptionButton.new()
	for entry_value: Variant in entries:
		if not (entry_value is Dictionary):
			continue
		var entry: Dictionary = entry_value as Dictionary
		dropdown.add_item(str(entry.get("name", entry.get("id", ""))))
		dropdown.set_item_metadata(dropdown.item_count - 1, entry)
	return dropdown


func _add_actor_spawn_row(vbox: VBoxContainer, dropdown: OptionButton, region_name: String) -> void:
	var row := HBoxContainer.new()
	vbox.add_child(row)
	var spawn_one := Button.new()
	spawn_one.text = "Spawn Selected"
	spawn_one.pressed.connect(_spawn_selected_region_actor.bind(dropdown, region_name))
	row.add_child(spawn_one)
	var clear := Button.new()
	clear.text = "Clear Enemies"
	clear.pressed.connect(_clear_enemies)
	row.add_child(clear)


func _warp_yomori_room(room_token: String) -> void:
	_warp_region_room(2, room_token)


func _warp_region_room(area_id: int, room_token: String) -> void:
	_close_lab()
	if typeof(GameFlow) == TYPE_OBJECT and GameFlow.has_method("debug_warp"):
		GameFlow.call("debug_warp", area_id, room_token)
		print("[PlaytestLab] Targeted warp: Area %d -> %s" % [area_id, room_token])
	else:
		push_warning("[PlaytestLab] GameFlow.debug_warp is unavailable.")


func _spawn_selected_yomori_actor() -> void:
	_spawn_selected_region_actor(_yomori_actor_dropdown, "Yomori")


func _spawn_selected_region_actor(dropdown: OptionButton, region_name: String) -> void:
	var player := _get_player()
	if player == null or not (player is Node2D):
		push_warning("[PlaytestLab] %s actor spawn requires an active Player." % region_name)
		return
	if dropdown == null or dropdown.item_count <= 0:
		return

	var metadata: Variant = dropdown.get_item_metadata(dropdown.selected)
	if not (metadata is Dictionary):
		return
	var entry: Dictionary = metadata as Dictionary
	var scene_path := str(entry.get("scene", ""))
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		push_warning("[PlaytestLab] Missing %s actor scene: %s" % [region_name, scene_path])
		return
	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_warning("[PlaytestLab] Could not load %s actor scene: %s" % [region_name, scene_path])
		return

	var parent := _get_active_room()
	if parent == null:
		parent = get_tree().current_scene
	if parent == null:
		return

	var actor := packed.instantiate()
	parent.add_child(actor)
	if actor is Node2D:
		(actor as Node2D).global_position = (player as Node2D).global_position + Vector2(110.0, 0.0)
	if not actor.is_in_group("enemy") and not actor.is_in_group("miniboss") and not actor.is_in_group("boss"):
		actor.add_to_group("enemy")
	print("[PlaytestLab] Spawned targeted %s actor: %s" % [region_name, str(entry.get("name", actor.name))])
	_refresh_status()


# =============================================================================
# FOCUSED TESTS - REUSABLE DEBUG-SCENARIO SHELL / HAMMER CHECKPOINT B
# =============================================================================

func _process(delta: float) -> void:
	super._process(delta)
	_advance_akio_run_trace()
	if _ui == null or not _ui.visible or not _source_preview_enabled:
		return
	# PlaytestLab runs PROCESS_MODE_ALWAYS while gameplay is paused. Source playback
	# therefore cannot modify CombatActionRunner, gameplay hitboxes or combo timing.
	_source_preview_elapsed += maxf(0.0, delta)
	if _source_preview_elapsed >= 1.0 / AKIO_SOURCE_FPS:
		var steps := int(floor(_source_preview_elapsed * AKIO_SOURCE_FPS))
		_source_preview_elapsed -= float(steps) / AKIO_SOURCE_FPS
		_source_preview_frame += steps
	_refresh_source_preview()


func is_akio_quick_slash_focus_active() -> bool:
	return (
		OS.is_debug_build()
		and _focused_test_scenario == FOCUSED_TEST_AKIO_CHECKPOINT_B
		and typeof(AspectRuntime) == TYPE_OBJECT
		and str(AspectRuntime.selected_aspect).is_empty()
	)


func get_akio_quick_slash_timing_mode() -> String:
	return _quick_slash_timing_mode if OS.is_debug_build() else QUICK_TIMING_PROTOTYPE


func is_akio_source_gameplay_active() -> bool:
	# Animation cadence and combo isolation are independent experiments.
	# With Hammer selected, even a normal base-katana Quick Slash uses its
	# original cadence. Debug-only: release builds retain authored timings.
	return (
		OS.is_debug_build()
		and get_akio_quick_slash_timing_mode() == QUICK_TIMING_HAMMER
		and typeof(AspectRuntime) == TYPE_OBJECT
		and str(AspectRuntime.selected_aspect).is_empty()
	)


func set_akio_quick_slash_timing_mode(mode: String) -> void:
	if not OS.is_debug_build():
		return
	var next_mode := QUICK_TIMING_HAMMER if mode == QUICK_TIMING_HAMMER else QUICK_TIMING_PROTOTYPE
	if next_mode == _quick_slash_timing_mode:
		return
	_quick_slash_timing_mode = next_mode
	# An in-flight action retains the timing values copied into its own profile.
	# This option only affects subsequently started attacks.
	if _quick_slash_timing_dropdown != null:
		_quick_slash_timing_dropdown.select(1 if next_mode == QUICK_TIMING_HAMMER else 0)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("akio_focus_timing_mode_changed", {"mode": next_mode})
	print("[FocusedTests] Quick Slash gameplay timing=", next_mode)


# Debug-only comparison affects only Akio's Checkpoint B directional presenter.
# Not the source animation, camera, player motor, enemy visuals or attack FPS.
func get_akio_render_test_preset() -> String:
	return _akio_render_preset if OS.is_debug_build() else AKIO_RENDER_BASELINE


func set_akio_render_test_preset(preset: String) -> void:
	if not OS.is_debug_build():
		return
	var next_preset: String = preset if preset in AKIO_RENDER_PRESETS else AKIO_RENDER_BASELINE
	if _akio_render_preset == next_preset:
		return
	_akio_render_preset = next_preset
	if _akio_render_dropdown != null:
		_akio_render_dropdown.select(AKIO_RENDER_PRESETS.find(next_preset))
	print("[AkioRenderTest] preset=%s; visual-only; no changes to combat or source PNGs" % next_preset)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("akio_render_test_preset", {"preset": next_preset})


# Source Run frame images receive real mipmap levels, not just a filter flag.
# All 128 Run frames must exist. Non-Run frames retain their original texture
# references and cadence. Cache the in-memory variant for this debug session.
func get_akio_mipmapped_run_frames(original: SpriteFrames) -> SpriteFrames:
	if not OS.is_debug_build() or original == null:
		return null
	if _akio_mipped_run_frames != null and _akio_mipped_source_id == original.get_instance_id():
		return _akio_mipped_run_frames
	for direction: String in AKIO_SOURCE_DIRECTIONS:
		var name := StringName("move_%s" % direction)
		if not original.has_animation(name) or original.get_frame_count(name) != 16:
			push_warning("[AkioRenderTest] mipmap Run test requires 16 loaded frames in each direction")
			return null

	var result := SpriteFrames.new()
	if result.has_animation(&"default"):
		result.remove_animation(&"default")
	var run_count: int = 0
	for animation_text: String in original.get_animation_names():
		var animation := StringName(animation_text)
		result.add_animation(animation)
		result.set_animation_speed(animation, original.get_animation_speed(animation))
		result.set_animation_loop(animation, original.get_animation_loop(animation))
		for index: int in range(original.get_frame_count(animation)):
			var texture: Texture2D = original.get_frame_texture(animation, index)
			if texture == null:
				push_warning("[AkioRenderTest] null source frame; mipmap test unavailable")
				return null
			var output_texture: Texture2D = texture
			if animation_text.begins_with("move_"):
				var source_pixels: Image = texture.get_image()
				var pixels: Image = source_pixels.duplicate() if source_pixels != null else null
				if pixels == null or pixels.is_empty():
					push_warning("[AkioRenderTest] Run texture cannot be read; mipmap test unavailable")
					return null
				if pixels.get_format() != Image.FORMAT_RGBA8:
					pixels.convert(Image.FORMAT_RGBA8)
				var generation_error: Error = pixels.generate_mipmaps()
				if generation_error != OK or not pixels.has_mipmaps():
					push_warning("[AkioRenderTest] mipmap generation failed; baseline retained")
					return null
				output_texture = ImageTexture.create_from_image(pixels)
				if output_texture == null or output_texture.get_size() != texture.get_size():
					push_warning("[AkioRenderTest] generated Run texture invalid; baseline retained")
					return null
				run_count += 1
			result.add_frame(animation, output_texture, original.get_frame_duration(animation, index))
	if run_count != 128:
		push_warning("[AkioRenderTest] expected 128 mipmapped Run frames; baseline retained")
		return null
	_akio_mipped_run_frames = result
	_akio_mipped_source_id = original.get_instance_id()
	print("[AkioRenderTest] mipmaps READY generated=128 Run frames (all directions); original unchanged")
	return result


# Camera/animation synchronization experiment is independent of old filter tests.
func get_akio_run_sync_test_mode() -> String:
	return _akio_sync_test_mode if OS.is_debug_build() else AKIO_SYNC_BASELINE


func set_akio_run_sync_test_mode(mode: String) -> void:
	if not OS.is_debug_build():
		return
	var selected: String = mode if mode in AKIO_SYNC_MODES else AKIO_SYNC_BASELINE
	if _akio_sync_test_mode == selected:
		return
	_akio_sync_test_mode = selected
	if _akio_sync_dropdown != null:
		_akio_sync_dropdown.select(AKIO_SYNC_MODES.find(selected))
	print("[AkioSyncTest] mode=%s; Run pose/camera only; player physics and source PNGs unchanged" % selected)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("akio_run_sync_test_mode", {"mode": selected})


# Starts only after closing the paused lab; never runs during its source preview.
func arm_akio_run_trace() -> void:
	if not OS.is_debug_build():
		return
	_run_trace_start_ms = -1
	_run_trace_armed = true
	if _run_trace_status != null:
		_run_trace_status.text = "Armed: close the lab, then run E/W and N/S for 12 seconds."
	print("[AkioRunTrace] armed; close the lab to start")


func is_akio_run_trace_active() -> bool:
	return OS.is_debug_build() and _run_trace_start_ms >= 0


func _advance_akio_run_trace() -> void:
	if not OS.is_debug_build():
		return
	if _run_trace_armed and (_ui == null or not _ui.visible):
		_run_trace_armed = false
		_run_trace_start_ms = Time.get_ticks_msec()
		print("[AkioRunTrace] START 12s; move in E/W, N/S; data=akio_run_frame_sample")
		if CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("akio_run_trace_begin", {"duration_ms": RUN_TRACE_DURATION_MS})
	if _run_trace_start_ms < 0:
		return
	var elapsed_ms := Time.get_ticks_msec() - _run_trace_start_ms
	if elapsed_ms >= RUN_TRACE_DURATION_MS:
		_run_trace_start_ms = -1
		print("[AkioRunTrace] COMPLETE; send combat_*.jsonl and the four PNG contact sheets")
		if CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("akio_run_trace_end", {"elapsed_ms": elapsed_ms})
		if _run_trace_status != null:
			_run_trace_status.text = "Capture complete. Send combat_*.jsonl and the four PNG sheets from playtest_logs."


# Source-frame contact sheets, not rendered gameplay images. A constant crop
# makes foot/torso displacement and missing/duplicated poses visible at once.
func export_akio_run_contact_sheets() -> bool:
	if not OS.is_debug_build():
		return false
	var value: Variant = AKIO_SOURCE_PROFILE.get("sprite_frames")
	if not (value is SpriteFrames):
		print("[AkioRunTrace] atlas not available yet; retry after loading completes")
		return false
	var atlas := value as SpriteFrames
	var folder := ProjectSettings.globalize_path("res://playtest_logs")
	if DirAccess.make_dir_recursive_absolute(folder) != OK:
		push_warning("[AkioRunTrace] cannot create contact sheet directory: %s" % folder)
		return false
	for direction: String in RUN_CONTACT_DIRECTIONS:
		var animation := StringName("move_%s" % direction)
		if not atlas.has_animation(animation) or atlas.get_frame_count(animation) != 16:
			print("[AkioRunTrace] move_%s not ready (need 16 frames); retry once atlas is ready" % direction)
			return false
		if not is_equal_approx(atlas.get_animation_speed(animation), 30.0):
			push_warning("[AkioRunTrace] unexpected move FPS %s = %s" % [direction, atlas.get_animation_speed(animation)])
	var ok := true
	for direction: String in RUN_CONTACT_DIRECTIONS:
		var animation := StringName("move_%s" % direction)
		var sheet := Image.create(768, 768, false, Image.FORMAT_RGBA8)
		sheet.fill(Color(0.13, 0.15, 0.18, 1.0))
		for frame: int in range(16):
			var texture := atlas.get_frame_texture(animation, frame)
			if texture == null:
				ok = false
				continue
			var image := texture.get_image()
			if image == null or image.is_empty() or not Rect2i(Vector2i.ZERO, image.get_size()).encloses(RUN_CONTACT_CROP):
				ok = false
				continue
			if image.get_format() != Image.FORMAT_RGBA8:
				image.convert(Image.FORMAT_RGBA8)
			var destination := Vector2i((frame % 4) * 192, (frame / 4) * 192)
			sheet.blend_rect(image, RUN_CONTACT_CROP, destination)
		var output := folder.path_join("akio_run_source_frames_%s.png" % direction)
		var result := sheet.save_png(output)
		if result != OK:
			ok = false
			push_warning("[AkioRunTrace] save failed %s code=%s" % [output, result])
		else:
			print("[AkioRunTrace] source frame sheet saved: %s (tiles left-to-right, top-to-bottom = 0..15)" % output)
	if _run_trace_status != null:
		_run_trace_status.text = "Sheets saved in playtest_logs: E / W / N / S" if ok else "Some sheet images failed; see Godot log."
	return ok


func is_akio_focus_diagnostics_active() -> bool:
	return is_akio_quick_slash_focus_active() and _focused_diagnostics_enabled


func get_focused_test_scenario() -> String:
	return _focused_test_scenario if OS.is_debug_build() else FOCUSED_TEST_NORMAL


func set_focused_test_scenario(scenario: String) -> void:
	if not OS.is_debug_build():
		return
	var next_scenario := scenario if scenario == FOCUSED_TEST_AKIO_CHECKPOINT_B else FOCUSED_TEST_NORMAL
	if next_scenario == _focused_test_scenario:
		return
	_focused_test_scenario = next_scenario
	# Reset only the transient combo/queue state when explicitly switching test modes.
	# Nothing in the authored attack profiles, hitboxes or action durations is changed.
	var player := _get_player()
	if player != null and player.has_method("_drop_combo"):
		player.call("_drop_combo")
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("focused_test_scenario_changed", {"scenario": _focused_test_scenario})
	print("[FocusedTests] scenario=", _focused_test_scenario)
	if _focused_scenario_dropdown != null:
		_focused_scenario_dropdown.select(1 if next_scenario == FOCUSED_TEST_AKIO_CHECKPOINT_B else 0)


func _build_focused_tests_tab(tabs: TabContainer) -> void:
	var vbox := _make_tab(tabs, "Focused Tests")
	var title := Label.new()
	title.text = "Milestone / isolated tests"
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)

	_focused_scenario_dropdown = OptionButton.new()
	_focused_scenario_dropdown.add_item("Normal combat")
	_focused_scenario_dropdown.set_item_metadata(0, FOCUSED_TEST_NORMAL)
	_focused_scenario_dropdown.add_item("Akio Checkpoint B - Quick Slash only")
	_focused_scenario_dropdown.set_item_metadata(1, FOCUSED_TEST_AKIO_CHECKPOINT_B)
	_focused_scenario_dropdown.select(0)
	_focused_scenario_dropdown.item_selected.connect(func(index: int) -> void:
		set_focused_test_scenario(str(_focused_scenario_dropdown.get_item_metadata(index)))
	)
	vbox.add_child(_focused_scenario_dropdown)

	var explanation := Label.new()
	explanation.text = "Combo isolation: Quick Slash only bypasses Cross Cut / Heavy Cleave. Animation speed is selected independently below and applies to every base-katana Quick Slash, even in Normal combat."
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(explanation)

	var timing_label := Label.new()
	timing_label.text = "Quick Slash timing in live gameplay (independent of combo isolation)"
	vbox.add_child(timing_label)
	_quick_slash_timing_dropdown = OptionButton.new()
	_quick_slash_timing_dropdown.add_item("Original prototype (fast)")
	_quick_slash_timing_dropdown.set_item_metadata(0, QUICK_TIMING_PROTOTYPE)
	_quick_slash_timing_dropdown.add_item("Hammer V2 (40 frames / 30 FPS)")
	_quick_slash_timing_dropdown.set_item_metadata(1, QUICK_TIMING_HAMMER)
	_quick_slash_timing_dropdown.select(1 if _quick_slash_timing_mode == QUICK_TIMING_HAMMER else 0)
	_quick_slash_timing_dropdown.item_selected.connect(func(index: int) -> void:
		set_akio_quick_slash_timing_mode(str(_quick_slash_timing_dropdown.get_item_metadata(index)))
	)
	vbox.add_child(_quick_slash_timing_dropdown)

	var timing_info := Label.new()
	timing_info.text = "Hammer is the default debug-test timing: all base-katana Quick Slashes play 40 frames at 30 FPS, whether isolation is ON or OFF. Cross Cut / Heavy Cleave retain their original timing. Dash/parry may cancel during recovery. Switch to Original prototype to compare."
	timing_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(timing_info)

	var render_separator := HSeparator.new()
	vbox.add_child(render_separator)
	var render_title := Label.new()
	render_title.text = "Akio Run sharpness test (LIVE GAMEPLAY ONLY)"
	render_title.add_theme_font_size_override("font_size", 15)
	vbox.add_child(render_title)
	var render_info := Label.new()
	render_info.text = "Filtering tests already evaluated: mipmaps worsened the visible Run. Keep this section on 1. Baseline, and use the new Run movement/camera isolation controls below."
	render_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(render_info)
	_akio_render_dropdown = OptionButton.new()
	_akio_render_dropdown.add_item("1. Baseline - linear / subpixel / normal size")
	_akio_render_dropdown.add_item("2. Nearest filter only - normal size")
	_akio_render_dropdown.add_item("3. Linear + world-pixel snap")
	_akio_render_dropdown.add_item("4. Nearest + world-pixel snap")
	_akio_render_dropdown.add_item("5. Linear + 125% Akio size (diagnostic)")
	_akio_render_dropdown.add_item("6. Run-only generated mipmaps (linear; normal scale)")
	_akio_render_dropdown.select(AKIO_RENDER_PRESETS.find(_akio_render_preset))
	_akio_render_dropdown.item_selected.connect(func(index: int) -> void:
		set_akio_render_test_preset(AKIO_RENDER_PRESETS[index])
	)
	vbox.add_child(_akio_render_dropdown)
	var render_note := Label.new()
	render_note.text = "Preset 6 generates true Run mipmaps once in memory. The first switch may briefly pause; judge steady motion, not startup. Restore Baseline when finished."
	render_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(render_note)

	var sync_separator := HSeparator.new()
	vbox.add_child(sync_separator)
	var sync_title := Label.new()
	sync_title.text = "Akio camera jitter fix / legacy regression"
	sync_title.add_theme_font_size_override("font_size", 15)
	vbox.add_child(sync_title)
	var sync_info := Label.new()
	sync_info.text = "FIXED DEFAULT: camera PHYSICS callback + smoothing ON. Owner confirmed this is smooth. Old IDLE callback + smoothing ON was jittery; IDLE with smoothing OFF was also smooth. Keep Run sharpness on 1. Baseline. Test A in normal gameplay; only use C/D briefly to reproduce the prior bug."
	sync_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(sync_info)
	_akio_sync_dropdown = OptionButton.new()
	_akio_sync_dropdown.add_item("A. FIXED baseline - PHYSICS callback + smoothing ON")
	_akio_sync_dropdown.add_item("B. Freeze Run frame 4 (fixed physics camera unchanged)")
	_akio_sync_dropdown.add_item("C. OLD BUG - IDLE callback + smoothing ON")
	_akio_sync_dropdown.add_item("D. OLD workaround - IDLE callback + smoothing OFF")
	_akio_sync_dropdown.select(AKIO_SYNC_MODES.find(_akio_sync_test_mode))
	_akio_sync_dropdown.item_selected.connect(func(index: int) -> void:
		set_akio_run_sync_test_mode(AKIO_SYNC_MODES[index])
	)
	vbox.add_child(_akio_sync_dropdown)
	var sync_note := Label.new()
	sync_note.text = "Results from the previous build: frozen Run still jittered with the legacy camera; changing to PHYSICS+ON or IDLE+OFF cleared the issue. A now applies the permanent physics-camera fix. C deliberately reenables the old bug, D restores the old workaround. Restore A after comparing."
	sync_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(sync_note)

	var trace_separator := HSeparator.new()
	vbox.add_child(trace_separator)
	var trace_header := Label.new()
	trace_header.text = "Akio Run frame-order / camera diagnostics"
	trace_header.add_theme_font_size_override("font_size", 15)
	vbox.add_child(trace_header)
	var trace_info := Label.new()
	trace_info.text = "Arm a 12-second per-render-frame trace, close the lab and run sideways then vertically. The JSONL reports displayed frame indices, transitions, timing, player/sprite positions and actual camera center. Use Baseline first."
	trace_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(trace_info)
	var trace_button := Button.new()
	trace_button.text = "Arm 12-second Run trace (starts when lab closes)"
	trace_button.pressed.connect(arm_akio_run_trace)
	vbox.add_child(trace_button)
	var sheet_button := Button.new()
	sheet_button.text = "Export 4 Run frame contact sheets (E/W/N/S)"
	sheet_button.pressed.connect(func() -> void:
		export_akio_run_contact_sheets()
	)
	vbox.add_child(sheet_button)
	_run_trace_status = Label.new()
	_run_trace_status.text = "Not recording. Exports go to game/oathbound/playtest_logs."
	_run_trace_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_run_trace_status)

	_focused_diagnostics_check = CheckButton.new()
	_focused_diagnostics_check.text = "Record focused animation frames in combat telemetry"
	_focused_diagnostics_check.button_pressed = _focused_diagnostics_enabled
	_focused_diagnostics_check.toggled.connect(func(checked: bool) -> void:
		_focused_diagnostics_enabled = checked
	)
	vbox.add_child(_focused_diagnostics_check)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	var preview_label := Label.new()
	preview_label.text = "Hammer V2 PNG preview - independent of gameplay"
	preview_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(preview_label)

	_source_preview_toggle = CheckButton.new()
	_source_preview_toggle.text = "Play source animation at 30 FPS (while lab is open)"
	_source_preview_toggle.toggled.connect(func(enabled: bool) -> void:
		_source_preview_enabled = enabled
		_source_preview_frame = 0
		_source_preview_elapsed = 0.0
		if _source_preview_sprite != null and not enabled:
			_source_preview_sprite.texture = null
		_refresh_source_preview()
	)
	vbox.add_child(_source_preview_toggle)

	var controls := HBoxContainer.new()
	vbox.add_child(controls)
	_source_preview_animation = OptionButton.new()
	for animation: String in AKIO_SOURCE_ANIMATIONS:
		_source_preview_animation.add_item(animation)
	_source_preview_animation.item_selected.connect(func(_index: int) -> void: _restart_source_preview())
	controls.add_child(_source_preview_animation)

	_source_preview_direction = OptionButton.new()
	for direction: String in AKIO_SOURCE_DIRECTIONS:
		_source_preview_direction.add_item(direction.to_upper())
	_source_preview_direction.select(0)
	_source_preview_direction.item_selected.connect(func(_index: int) -> void: _restart_source_preview())
	controls.add_child(_source_preview_direction)

	# Use a cropped render viewport rather than displaying the entire 512px PNG.
	# The source is not rewritten, cropped on disk, or routed through gameplay.
	var preview_panel := SubViewportContainer.new()
	preview_panel.custom_minimum_size = Vector2(240, 182)
	preview_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(preview_panel)
	var viewport := SubViewport.new()
	viewport.size = Vector2i(240, 182)
	viewport.transparent_bg = true
	viewport.disable_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.process_mode = Node.PROCESS_MODE_ALWAYS
	preview_panel.add_child(viewport)
	_source_preview_sprite = Sprite2D.new()
	_source_preview_sprite.position = Vector2(120, 91)
	_source_preview_sprite.scale = Vector2(1.35, 1.35)
	_source_preview_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	viewport.add_child(_source_preview_sprite)

	_source_preview_status = Label.new()
	_source_preview_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_source_preview_status)
	_refresh_source_preview()


func _restart_source_preview() -> void:
	_source_preview_elapsed = 0.0
	_source_preview_frame = 0
	_refresh_source_preview()


func _refresh_source_preview() -> void:
	if _source_preview_status == null:
		return
	if not _source_preview_enabled:
		_source_preview_status.text = "Source preview off. Select a direction and enable 30 FPS playback; no game/combat timing changes."
		return
	if _source_preview_animation == null or _source_preview_direction == null or _source_preview_sprite == null:
		return
	var animation_name := "%s_%s" % [
		AKIO_SOURCE_ANIMATIONS[_source_preview_animation.selected],
		AKIO_SOURCE_DIRECTIONS[_source_preview_direction.selected],
	]
	var sprite_frames_value: Variant = AKIO_SOURCE_PROFILE.get("sprite_frames")
	if not (sprite_frames_value is SpriteFrames):
		_source_preview_status.text = "Akio frames not loaded yet. Enter Hushiro gameplay, allow the atlas to prepare, then reopen the lab."
		return
	var frames := sprite_frames_value as SpriteFrames
	if not frames.has_animation(StringName(animation_name)):
		_source_preview_status.text = "Waiting for %s to become available." % animation_name
		return
	var expected_count := 40 if animation_name.begins_with("attack_") else (16 if animation_name.begins_with("move_") else 40)
	var count := frames.get_frame_count(StringName(animation_name))
	if count != expected_count:
		_source_preview_status.text = "Waiting for full animation %s (%d/%d frames)." % [animation_name, count, expected_count]
		return
	_source_preview_frame = posmod(_source_preview_frame, count)
	_source_preview_sprite.texture = frames.get_frame_texture(StringName(animation_name), _source_preview_frame)
	_source_preview_status.text = "%s | frame %02d/%02d | source 30 FPS | combat paused" % [animation_name, _source_preview_frame, count - 1]
