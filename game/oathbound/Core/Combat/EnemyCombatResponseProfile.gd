extends Resource
class_name EnemyCombatResponseProfile

## Authored Combat V2 response data for one enemy family/archetype.
## Health, posture/stagger, guard, and poise remain independent axes. This resource
## intentionally does not own AI decisions, movement, attack execution, or HP mutation.

@export var profile_id: String = "default"

@export_group("Guard Response")
@export_range(0.0, 1.0, 0.01) var guard_health_multiplier: float = 0.0
@export_range(0.0, 4.0, 0.05) var guard_posture_multiplier: float = 1.0
@export var guard_duration: float = 0.35
@export var guard_cooldown: float = 1.0
@export var guard_break_cooldown: float = 1.5
@export var guard_range: float = 90.0

@export_group("Poise / Interruption")
## Minimum incoming poise power required to interrupt while not committed.
@export var neutral_poise_required: int = 1
## Minimum incoming poise power required once an attack has committed.
@export var committed_poise_required: int = 2
## Incoming poise power that immediately collapses an active guard action.
@export var guard_break_poise_required: int = 2


static func corrupted_swordsman_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "corrupted_swordsman_v2"

	# Short sword guards mitigate most Health damage, but never erase the player's
	# offensive progress. Canonical attack profiles already author exact block-Posture
	# pressure, so this first migration slice preserves that value 1:1.
	profile.guard_health_multiplier = 0.35
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.34
	profile.guard_cooldown = 1.15
	profile.guard_break_cooldown = 1.65
	profile.guard_range = 95.0

	# Ordinary direct hits can interrupt neutral Swordsman behavior. Once the enemy
	# has committed an attack, a stronger impact is required; Health damage still lands.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 2
	profile.guard_break_poise_required = 2
	return profile


static func blighted_hound_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "blighted_hound_v2"

	# Hounds do not guard. These values are intentionally neutral so the shared response
	# runtime can still own Poise/interruption without inventing a beast guard mechanic.
	profile.guard_health_multiplier = 1.0
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.05
	profile.guard_cooldown = 0.0
	profile.guard_break_cooldown = 0.0
	profile.guard_range = 0.0

	# The beast is deliberately easy to knock off neutral movement, but once a pounce or
	# bite has committed, Akio needs a stronger impact to stop the action. Health damage
	# and canonical Posture still apply even when the committed attack survives.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 2
	profile.guard_break_poise_required = 2
	return profile
