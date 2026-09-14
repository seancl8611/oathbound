extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanStability.gd"

## Blood Cavern passive training target.
##
## The target inherits the production Swordsman combat stack but normally follows the
## standard-enemy no-Posture contract. Execution Trial is a deliberately-authored
## special moment, so that mode explicitly opts back into the reusable posture-break /
## execution helper without restoring universal Deathblow ownership to normal enemies.

signal training_target_reset
signal training_deathblow_completed(attacker: Node)

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const AUTHORED_POSTURE_BREAK_RUNTIME = preload("res://Utility/HushiroPostureBreakRuntime.gd")
const AUTHORED_POSTURE_READABILITY_RUNTIME = preload("res://Utility/HushiroPostureReadabilityRuntime.gd")

var _training_reset_queued: bool = false
var _training_mode: String = "passive_target"
var _training_mode_label: Label = null


func _ready() -> void:
	# Initialize the production combat/hurtbox stack first. Cavern targets are spawned
	# directly in the Strand, so install the same Health/compatibility baseline used by
	# Hushiro standards before applying any authored training-mode exception.
	super._ready()
	HushiroEnemyContract.apply(self, "swordsman")
	set_physics_process(false)
	auto_aggro_on_spawn = false
	can_block = false
	block_by_default = false
	enemy_damage = 0
	experience = 0
	death_anim = null
	exp_gem = null
	add_to_group("blood_cavern_training_target")
	_build_training_mode_label()
	_apply_training_mode_combat_contract()
	reset_training_target()


func configure_training_mode(mode: String) -> void:
	_training_mode = mode if not mode.is_empty() else "passive_target"
	_apply_training_mode_combat_contract()
	_refresh_training_mode_label()
	reset_training_target()


func get_training_mode() -> String:
	return _training_mode


func _apply_training_mode_combat_contract() -> void:
	if _training_mode == "execution_trial":
		_enable_authored_execution_posture()
		return

	# Returning to a non-execution training mode restores the same no-Posture boundary
	# used by ordinary standard enemies. force=true is intentional because this target
	# can be reused across authored modes without leaving execution state behind.
	HushiroEnemyContract.apply(self, "swordsman", true)
	set_meta("oathbound_authored_execution_target", false)


func _enable_authored_execution_posture() -> void:
	var shared_combat: Node = get_node_or_null("Combat")
	if shared_combat == null:
		return

	# The standard retirement bridge is event-driven. Disconnect it before removing the
	# node so its synchronous posture_changed callback cannot zero this authored trial's
	# meter during the rest of the frame.
	var no_posture: Node = get_node_or_null("HushiroStandardNoPostureRuntime")
	if no_posture != null:
		var neutralize_callback := Callable(no_posture, "_on_posture_changed")
		if shared_combat.has_signal("posture_changed") and shared_combat.is_connected("posture_changed", neutralize_callback):
			shared_combat.disconnect("posture_changed", neutralize_callback)
		no_posture.set_process(false)
		no_posture.set_physics_process(false)
		remove_child(no_posture)
		no_posture.queue_free()

	# HushiroEnemyContract already supplied the Swordsman compatibility posture_max and
	# break timing values. Clear any retired-state residue before opting this special
	# target back into the reusable execution helper.
	shared_combat.set("_posture", 0.0)
	shared_combat.set("_break_until_ts", -1.0)
	shared_combat.set("_recovery_suppressed_until", -1.0)
	_dbroken_active = false
	set_meta("oathbound_standard_posture_retired", false)
	set_meta("oathbound_authored_execution_target", true)
	set_meta("_oathbound_deathblow_ready", false)

	if get_node_or_null("HushiroPostureBreakRuntime") == null:
		var break_runtime: Node = AUTHORED_POSTURE_BREAK_RUNTIME.new()
		break_runtime.name = "HushiroPostureBreakRuntime"
		if break_runtime.has_method("configure"):
			break_runtime.call("configure", self, "blood_cavern_execution_target")
		add_child(break_runtime)

	if get_node_or_null("HushiroPostureReadabilityRuntime") == null:
		var readability_runtime: Node = AUTHORED_POSTURE_READABILITY_RUNTIME.new()
		readability_runtime.name = "HushiroPostureReadabilityRuntime"
		if readability_runtime.has_method("configure"):
			readability_runtime.call("configure", self)
		add_child(readability_runtime)


func _build_training_mode_label() -> void:
	if _training_mode_label != null and is_instance_valid(_training_mode_label):
		return
	_training_mode_label = Label.new()
	_training_mode_label.name = "TrainingModeLabel"
	_training_mode_label.position = Vector2(-88.0, -66.0)
	_training_mode_label.size = Vector2(176.0, 44.0)
	_training_mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_training_mode_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_training_mode_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_training_mode_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_training_mode_label.z_index = 110
	_training_mode_label.add_theme_font_size_override("font_size", 11)
	_training_mode_label.add_theme_constant_override("outline_size", 4)
	add_child(_training_mode_label)
	_refresh_training_mode_label()


func _refresh_training_mode_label() -> void:
	if _training_mode_label == null or not is_instance_valid(_training_mode_label):
		return
	match _training_mode:
		"execution_trial":
			_training_mode_label.text = LOCALIZATION.ui(
				"blood_cavern.target.execution_trial",
				"EXECUTION TRIAL\nBREAK POSTURE → EXECUTE"
			)
		"technique_demo":
			_training_mode_label.text = LOCALIZATION.ui(
				"blood_cavern.target.technique_demo",
				"TECHNIQUE DEMO"
			)
		_:
			_training_mode_label.text = LOCALIZATION.ui(
				"blood_cavern.target.passive",
				"TRAINING TARGET"
			)


func _training_label_text_for_playtest() -> String:
	return _training_mode_label.text if _training_mode_label != null else ""


func death() -> void:
	# Never call the humanoid death path here: it notifies stance death effects,
	# spawns experience, awards area Gold, and frees the enemy. A training reset is
	# presentation/sandbox state only and must not look like a run kill.
	_queue_training_reset()


func receive_deathblow(attacker: Node) -> void:
	# This override is reached only through the production Player deathblow path.
	# Structured trials may observe that real execution event, but the target still
	# never emits enemy_died or enters the normal reward/free path.
	if _training_mode == "execution_trial":
		training_deathblow_completed.emit(attacker)
	_queue_training_reset()


func _queue_training_reset() -> void:
	if _training_reset_queued:
		return
	_training_reset_queued = true
	has_died = true
	hp = 0
	call_deferred("reset_training_target")


func reset_training_target() -> void:
	_training_reset_queued = false
	has_died = false
	hp = get_max_hp()
	set_posture_value(0.0)
	# Execution Trial owns the authored break runtime; ordinary training targets own the
	# standard no-Posture bridge. Clear whichever state is active before reuse.
	var break_runtime: Node = get_node_or_null("HushiroPostureBreakRuntime")
	if break_runtime != null and break_runtime.has_method("reset_posture_break_state"):
		break_runtime.call("reset_posture_break_state")
	else:
		var shared_combat: Node = get_node_or_null("Combat")
		if shared_combat != null and shared_combat.has_method("reset_posture"):
			shared_combat.call("reset_posture")
	clear_hitstop_state()
	knockback = Vector2.ZERO
	velocity = Vector2.ZERO
	_dbroken_active = false
	_dbreak_until = 0.0
	_dbreak_immunity_until = 0.0
	stunned_until = 0.0
	set_meta("_post_break_decay_active", false)
	set_meta("_oathbound_deathblow_ready", false)
	_cancel_attack()
	_set_blocking(false)
	if anim:
		anim.stop()
		if anim.has_animation("walk"):
			anim.play("walk")
	_refresh_training_mode_label()
	training_target_reset.emit()


func is_training_target() -> bool:
	return true