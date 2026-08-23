extends RoomBase

## Canonical high-value Treasure chamber.
##
## The first current implementation intentionally limits random Treasure outcomes to
## premium Technique, Mist, and Scroll rewards because those paths already have durable
## runtime ownership. Recovery/capacity/Relic Treasure outcomes can join this pool when
## their shared reward bridge is canonical rather than through legacy chest scripts.

const REWARD_PICKUP_SCRIPT = preload("res://Objects/RewardPickup.gd")

const MIST_PAYOUTS: Dictionary = {1: 50, 2: 60, 3: 75}
const SCROLL_PAYOUTS: Dictionary = {1: 2, 2: 2, 3: 3}
const REWARD_WEIGHTS: Dictionary = {
	"technique": 50.0,
	"mist": 30.0,
	"scroll": 20.0,
}

var _pickup: Node = null
var _resolved := false


func _ready() -> void:
	name = "TreasureChamber"
	lock_all_gates()
	call_deferred("_spawn_reward")
	print("[TreasureChamber] current premium Technique/Mist/Scroll reward authority")


func _spawn_reward() -> void:
	if _pickup != null:
		return
	var area_id := _get_area_id()
	var reward_key := _roll_reward_key()
	var runtime_key := "boon" if reward_key == "technique" else reward_key
	var amount := 0
	if reward_key == "mist":
		amount = int(MIST_PAYOUTS.get(area_id, MIST_PAYOUTS[1]))
	elif reward_key == "scroll":
		amount = int(SCROLL_PAYOUTS.get(area_id, SCROLL_PAYOUTS[1]))

	_pickup = REWARD_PICKUP_SCRIPT.new()
	_pickup.setup(runtime_key, amount, area_id)
	if reward_key == "technique":
		_pickup.set_meta("technique_source", UpgradeService.SOURCE_TREASURE)
	var marker := get_node_or_null("RewardSpawn")
	if _pickup is Node2D:
		(_pickup as Node2D).global_position = (marker as Node2D).global_position if marker is Node2D else global_position
	add_child(_pickup)
	await _pickup.collected
	_resolved = true
	unlock_all_gates()
	print("[TreasureChamber] reward resolved: %s x%d" % [reward_key, amount])


func _get_area_id() -> int:
	if has_meta("area_id"):
		return clampi(int(get_meta("area_id")), 1, 3)
	if typeof(RunData) == TYPE_OBJECT:
		return clampi(int(RunData.current_area_id), 1, 3)
	return 1


func _roll_reward_key() -> String:
	var rng := RandomNumberGenerator.new()
	var seed_value := int(Time.get_unix_time_from_system())
	if typeof(RunData) == TYPE_OBJECT:
		seed_value ^= int(RunData.depth + 1) * 7919
	rng.seed = seed_value
	var total := 0.0
	for weight_value: Variant in REWARD_WEIGHTS.values():
		total += float(weight_value)
	var roll := rng.randf_range(0.0, total)
	var cumulative := 0.0
	for key_value: Variant in REWARD_WEIGHTS.keys():
		cumulative += float(REWARD_WEIGHTS[key_value])
		if roll <= cumulative:
			return str(key_value)
	return "technique"
