extends Resource
class_name CombatActionDefinition

## Data-only Combat V2 action contract.
##
## This resource deliberately does not own damage or hitboxes. Those remain on the
## canonical actor/contact path while migration is in progress. The action definition
## describes timing and motion permissions so Player and Enemy action selection can
## eventually share one lifecycle without sharing decision logic.

@export var action_id: StringName = &"action"
@export_range(0.01, 5.0, 0.01) var startup_duration: float = 0.40
@export_range(0.05, 0.95, 0.01) var commit_fraction: float = 0.60
@export_range(0.01, 5.0, 0.01) var active_duration: float = 0.20
@export_range(0.0, 5.0, 0.01) var recovery_duration: float = 0.20

@export_group("Locomotion Contribution")
@export_range(0.0, 1.0, 0.01) var startup_locomotion_weight: float = 0.65
@export_range(0.0, 1.0, 0.01) var committed_locomotion_weight: float = 0.18
@export_range(0.0, 1.0, 0.01) var active_locomotion_weight: float = 0.08
@export_range(0.0, 1.0, 0.01) var recovery_locomotion_weight: float = 0.45


func sanitized_commit_time() -> float:
	return maxf(0.0, startup_duration * clampf(commit_fraction, 0.05, 0.95))
