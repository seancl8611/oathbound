extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanStability.gd"

## Blood Cavern passive training target.
##
## Reuses the current Hushiro Swordsman's real hurt/posture/deathblow plumbing so
## build testing exercises production combat semantics, while explicitly removing
## enemy AI, rewards, run statistics, and permanent progression side effects.

signal training_target_reset
signal training_deathblow_completed(attacker: Node)

var _training_reset_queued: bool = false
var _training_mode: String = "passive_target"


func _ready() -> void:
	# Initialize the production combat/hurtbox stack first, then freeze autonomous AI.
	super._ready()
	set_physics_process(false)
	auto_aggro_on_spawn = false
	can_block = false
	block_by_default = false
	enemy_damage = 0
	experience = 0
	death_anim = null
	exp_gem = null
	add_to_group("blood_cavern_training_target")
	reset_training_target()


func configure_training_mode(mode: String) -> void:
	_training_mode = mode if not mode.is_empty() else "passive_target"
	reset_training_target()


func get_training_mode() -> String:
	return _training_mode


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
	training_target_reset.emit()


func is_training_target() -> bool:
	return true
