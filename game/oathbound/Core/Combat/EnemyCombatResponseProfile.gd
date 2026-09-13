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
	profile.guard_health_multiplier = 0.35
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.34
	profile.guard_cooldown = 1.15
	profile.guard_break_cooldown = 1.65
	profile.guard_range = 95.0
	# Standard martial body: easy to flinch while neutral, but a committed attack
	# needs a heavier impact. This keeps authored commitment meaningful without making
	# ordinary Swordsmen behave like brutes.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 2
	profile.guard_break_poise_required = 2
	return profile


static func blighted_hound_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "blighted_hound_v2"
	profile.guard_health_multiplier = 1.0
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.05
	profile.guard_cooldown = 0.0
	profile.guard_break_cooldown = 0.0
	profile.guard_range = 0.0
	# Light predator: baseline sword pressure should be able to knock it out of a bite
	# or lunge commitment. Its danger comes from pack pressure, speed, and timing rather
	# than armor-like interruption resistance.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 1
	profile.guard_break_poise_required = 2
	return profile


static func hollow_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "hollow_v2"
	profile.guard_health_multiplier = 1.0
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.05
	profile.guard_cooldown = 0.0
	profile.guard_break_cooldown = 0.0
	profile.guard_range = 0.0
	# Fodder body: any clean baseline sword contact may flinch or cancel an attack.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 1
	profile.guard_break_poise_required = 1
	return profile


static func corrupted_archer_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "corrupted_archer_v2"
	profile.guard_health_multiplier = 0.55
	profile.guard_posture_multiplier = 1.25
	profile.guard_duration = 0.22
	profile.guard_cooldown = 1.35
	profile.guard_break_cooldown = 1.65
	profile.guard_range = 56.0
	# Fragile ranged body: closing distance should let Akio suppress its committed shot
	# with ordinary offense rather than entering a miniature duel.
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 1
	profile.guard_break_poise_required = 1
	return profile


static func cellar_bilemass_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "cellar_bilemass_v2"

	# Bilemass never guards. Its defensive distinction is action Poise: neutral skitter
	# is easy to disrupt, while the committed vomit portion of a spit needs a stronger
	# impact to cancel. Health/Posture still apply even when the hazard launch survives.
	profile.guard_health_multiplier = 1.0
	profile.guard_posture_multiplier = 1.0
	profile.guard_duration = 0.05
	profile.guard_cooldown = 0.0
	profile.guard_break_cooldown = 0.0
	profile.guard_range = 0.0
	profile.neutral_poise_required = 1
	profile.committed_poise_required = 2
	profile.guard_break_poise_required = 2
	return profile


static func warden_v2() -> EnemyCombatResponseProfile:
	var profile := EnemyCombatResponseProfile.new()
	profile.profile_id = "warden_v2"

	# The Warden is a hulking restraint/support threat, not a shield wall. Preserve the
	# current full-Health reactive block when it happens, but make guard a short tactical
	# punctuation mark with meaningful Posture pressure and a long cooldown instead of
	# inheriting HumanoidEnemyBase's permanent proximity block.
	profile.guard_health_multiplier = 0.0
	profile.guard_posture_multiplier = 1.25
	profile.guard_duration = 0.22
	profile.guard_cooldown = 1.55
	profile.guard_break_cooldown = 1.85
	profile.guard_range = 68.0

	# Heavy/control exception: light baseline sword contacts still deal full authored
	# Health/Posture, but do not flinch a neutral Warden. A heavy baseline impact can
	# interrupt neutral movement, while committed Warden attacks require explicit power 3
	# or stronger. Guard-break resistance remains separately authored at power 2.
	profile.neutral_poise_required = 2
	profile.committed_poise_required = 3
	profile.guard_break_poise_required = 2
	return profile
