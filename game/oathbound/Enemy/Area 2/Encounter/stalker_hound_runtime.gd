extends "res://Enemy/Area 2/Encounter/stalker_hound.gd"

## Runtime lifetime hardening for Stalker Hound's mist-pounce hitbox timer.
## EnemyBase already provides node-owned delayed callbacks. Use that authority rather
## than a SceneTreeTimer lambda that can resume after this enemy has left the tree.


func _execute_mist_pounce(now: float) -> void:
	if debug_mist_pounce:
		print("[StalkerHound] Mist pounce executed")

	var gen := _bump_attack_gen()
	_goto(State.LUNGE, mist_pounce_active_time + mist_pounce_end_lag)
	_arm_hitbox(mist_pounce_damage, mist_pounce_hitbox_size, mist_pounce_block_posture, true)
	_apply_mist_pounce_hitbox_meta()
	_do_after(mist_pounce_active_time, Callable(self, "_on_stalker_runtime_pounce_active_timeout").bind(gen))


func _on_stalker_runtime_pounce_active_timeout(gen: int) -> void:
	if has_died or gen != _attack_gen:
		return
	_set_hitbox_active(false)
