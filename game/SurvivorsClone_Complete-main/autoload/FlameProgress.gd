extends Node
# FlameProgress.gd — Persistent Prayer Flame progression (across runs)
# Autoload: "FlameProgress"

signal cinder_changed(total: int)
signal tier_advanced(new_tier: int)

var cinder_total: int = 0
var flame_tier: int = 0        # 0 = base, 1-4 = unlocked tiers
var trial_pending: bool = false # true when a milestone is crossed but trial not yet cleared

const TIER_THRESHOLDS = [0, 150, 350, 650, 1000]
const TIER_NAMES = ["Dim Ember", "Ember Awakens", "Violet Flame", "Blue-White Flame", "Gold Flame"]
const TIER_COLORS = [
	Color(0.9, 0.4, 0.1),   # 0: orange ember
	Color(0.8, 0.2, 0.5),   # 1: magenta
	Color(0.5, 0.2, 0.8),   # 2: violet
	Color(0.4, 0.6, 1.0),   # 3: blue-white
	Color(1.0, 0.85, 0.2),  # 4: gold
]

func add_cinder(amount: int) -> void:
	cinder_total += amount
	cinder_changed.emit(cinder_total)
	_check_milestone()
	print("[FlameProgress] Cinder: %d (+%d) | Tier: %d" % [cinder_total, amount, flame_tier])

func _check_milestone() -> void:
	var next_tier = flame_tier + 1
	if next_tier >= TIER_THRESHOLDS.size():
		return
	if cinder_total >= TIER_THRESHOLDS[next_tier]:
		trial_pending = true
		print("[FlameProgress] Milestone reached! Trial available for Tier %d" % next_tier)

func claim_tier() -> void:
	# Called after winning a hub trial
	if not trial_pending:
		return
	flame_tier += 1
	trial_pending = false
	tier_advanced.emit(flame_tier)
	print("[FlameProgress] Tier advanced to %d: %s" % [flame_tier, get_tier_name()])

func get_tier_name() -> String:
	return TIER_NAMES[clampi(flame_tier, 0, TIER_NAMES.size() - 1)]

func get_tier_color() -> Color:
	return TIER_COLORS[clampi(flame_tier, 0, TIER_COLORS.size() - 1)]

func get_next_threshold() -> int:
	var next = flame_tier + 1
	if next >= TIER_THRESHOLDS.size():
		return TIER_THRESHOLDS[-1]
	return TIER_THRESHOLDS[next]

func get_cinder_toward_next() -> float:
	# Returns 0.0-1.0 progress toward next tier
	var current_floor = TIER_THRESHOLDS[clampi(flame_tier, 0, TIER_THRESHOLDS.size() - 1)]
	var next_ceil = get_next_threshold()
	if next_ceil <= current_floor:
		return 1.0
	return clampf(float(cinder_total - current_floor) / float(next_ceil - current_floor), 0.0, 1.0)

func is_max_tier() -> bool:
	return flame_tier >= TIER_THRESHOLDS.size() - 1

# TODO: Wire into your save/load system
func save_data() -> Dictionary:
	return {"cinder_total": cinder_total, "flame_tier": flame_tier, "trial_pending": trial_pending}

func load_data(data: Dictionary) -> void:
	cinder_total = int(data.get("cinder_total", 0))
	flame_tier = int(data.get("flame_tier", 0))
	trial_pending = bool(data.get("trial_pending", false))
