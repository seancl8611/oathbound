extends "res://Regions/Hushiro/Enemies/Bosses/Keeper.gd"

## Evidence-driven Keeper readability layer from the Aug 31 integration playtest.
## This preserves the two-life/Deathblow rules in Keeper.gd and only reconciles
## anticipation pacing plus perilous collision geometry with the floor telegraphs.

const SECTOR_SEGMENTS := 18


func _ready() -> void:
	super._ready()

	# Preserve Keeper's authored move identities and faster Phase 2, but raise the
	# shortest tells to a consistent playtest-readable floor. The larger telegraphed
	# moves already have long anticipation and are intentionally left alone.
	discipline_windup = maxf(discipline_windup, 0.38)
	blade_dance_hit1_anticipation = maxf(blade_dance_hit1_anticipation, 0.32)
	blade_dance_hit2_anticipation = maxf(blade_dance_hit2_anticipation, 0.32)
	blade_dance_hit4_anticipation = maxf(blade_dance_hit4_anticipation, 0.34)
	sweep_telegraph_time = maxf(sweep_telegraph_time, 0.60)

	feral_windup = maxf(feral_windup, 0.42)
	feral_hit1_anticipation = maxf(feral_hit1_anticipation, 0.30)
	feral_hit2_anticipation = maxf(feral_hit2_anticipation, 0.28)
	feral_hit3_anticipation = maxf(feral_hit3_anticipation, 0.30)
	feral_hit4_anticipation = maxf(feral_hit4_anticipation, 0.28)
	feral_hit5_anticipation = maxf(feral_hit5_anticipation, 0.26)
	feral_inter_hit_recovery = maxf(feral_inter_hit_recovery, 0.15)
	savage_telegraph_time = maxf(savage_telegraph_time, 0.68)
	phase2_min_cooldown = maxf(phase2_min_cooldown, 0.65)
	phase2_max_cooldown = maxf(phase2_max_cooldown, 1.10)

	print("[Keeper] playtest readability timing + telegraph-matched collision active")


func _spawn_ring_hitbox(inner: float, outer: float, damage: int) -> void:
	# The imported implementation used a filled circle at each 30/60/90/120 step.
	# That let one player near the landing point be contacted by all four expanding
	# shockwave steps in ~0.2s. Each step is now the annular band its metadata claimed.
	_cleanup_hitbox()
	var hitbox := _new_perilous_area("keeper_shockwave", damage)
	hitbox.set_meta("inner_radius", inner)
	hitbox.set_meta("outer_radius", outer)
	hitbox.set_meta("collision_kind", "annular_ring")
	_add_annular_sector_shapes(hitbox, inner, outer, 0.0, 360.0, SECTOR_SEGMENTS)
	add_child(hitbox)
	_current_hitbox = hitbox


func _spawn_sweep_hitbox(inner: float, outer: float, arc_deg: float, damage: int) -> void:
	# The floor tell is a facing-oriented 270-degree annular sector, but the imported
	# collision was a full disk. Match the telegraph: inner safe radius and rear safe
	# sector are both real collision space now.
	_cleanup_hitbox()
	var hitbox := _new_perilous_area("keeper_sweep", damage)
	var facing_angle := _get_facing_direction().angle()
	hitbox.set_meta("inner_radius", inner)
	hitbox.set_meta("outer_radius", outer)
	hitbox.set_meta("arc_degrees", arc_deg)
	hitbox.set_meta("collision_kind", "annular_sector")
	_add_annular_sector_shapes(hitbox, inner, outer, facing_angle, arc_deg, SECTOR_SEGMENTS)
	add_child(hitbox)
	_current_hitbox = hitbox


func _new_perilous_area(damage_type: String, damage: int) -> Area2D:
	var hitbox := Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", damage_type)
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)
	hitbox.set_meta("telegraphed", true)
	return hitbox


func _add_annular_sector_shapes(hitbox: Area2D, inner: float, outer: float, center_angle: float, arc_deg: float, segments: int) -> void:
	var safe_outer := maxf(1.0, outer)
	var safe_inner := clampf(inner, 0.0, safe_outer - 0.5)
	var segment_count := maxi(3, segments)
	var arc_radians := deg_to_rad(clampf(arc_deg, 1.0, 360.0))
	var start_angle := center_angle - arc_radians * 0.5

	for index: int in range(segment_count):
		var t0 := float(index) / float(segment_count)
		var t1 := float(index + 1) / float(segment_count)
		var angle0 := start_angle + arc_radians * t0
		var angle1 := start_angle + arc_radians * t1
		var outer0 := Vector2.from_angle(angle0) * safe_outer
		var outer1 := Vector2.from_angle(angle1) * safe_outer
		var polygon := CollisionPolygon2D.new()
		if safe_inner <= 0.1:
			polygon.polygon = PackedVector2Array([Vector2.ZERO, outer0, outer1])
		else:
			var inner0 := Vector2.from_angle(angle0) * safe_inner
			var inner1 := Vector2.from_angle(angle1) * safe_inner
			polygon.polygon = PackedVector2Array([inner0, outer0, outer1, inner1])
		hitbox.add_child(polygon)
