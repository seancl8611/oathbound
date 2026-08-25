extends Node

## Focused contract for PROGRESSION.md's persistent Strand architecture.
## Run last in CI because it deliberately mutates disposable campaign state while
## exercising real purchase/unlock APIs.

const HUB_SCENE = preload("res://World/HubScene.tscn")
const STRAND_SCRIPT = preload("res://Core/Progression/OathboundStrandProgressionManager.gd")
const PROSTHETIC_SCRIPT = preload("res://Core/Prosthetics/OathboundProstheticManager.gd")

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	await _run_contract()
	if _failures.is_empty():
		print("[StrandProgressionRuntimeSmoke] PASS - Bloodwell Mirror Forge 18+9 66-Scroll 4/2/4 contract")
		get_tree().quit(0)
	else:
		for failure in _failures:
			push_error("[StrandProgressionRuntimeSmoke] %s" % failure)
		print("[StrandProgressionRuntimeSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_contract() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT or typeof(MetaProgressionManager) != TYPE_OBJECT or typeof(ProstheticManager) != TYPE_OBJECT:
		_fail("required persistent progression autoloads missing")
		return

	_reset_campaign_memory()

	var bloodwell_nodes: Array = MetaProgressionManager.get_nodes_for_station("bloodwell")
	var mirror_nodes: Array = MetaProgressionManager.get_nodes_for_station("blood_mirror")
	_expect(bloodwell_nodes.size() == 18, "Bloodwell must expose exactly 18 permanent nodes")
	_expect(mirror_nodes.size() == 9, "Blood Mirror must expose exactly 9 nodes")

	var material_gated := 0
	for structural_value in MetaProgressionManager.get_structural_nodes(""):
		var structural: Dictionary = structural_value as Dictionary
		if not str(structural.get("boss_material", "")).is_empty():
			material_gated += 1
	_expect(material_gated == 6, "exactly six permanent nodes must require boss materials")

	_expect(not bool(MetaProgressionManager.is_strand_progression_unlocked()), "intro attempt must not expose permanent purchases")
	_expect(_available_ids("bloodwell").is_empty(), "intro attempt must have zero available Bloodwell nodes")
	_expect(not bool(MetaProgressionManager.is_blood_mirror_unlocked()), "Blood Mirror must be locked before Keeper")

	MetaProgress.returning_blood_awakened = true
	var first_return := _available_ids("bloodwell")
	var expected_first := ["vitality", "composure", "spirit_reserve", "field_rest", "expedition_preparation"]
	_expect(_same_id_set(first_return, expected_first), "first return must expose exactly the five approved opening Bloodwell nodes")

	MetaProgress.boss_clears[1] = true
	_expect(bool(MetaProgressionManager.is_blood_mirror_unlocked()), "first Keeper defeat must unlock Blood Mirror")
	var keeper_mirror := _available_ids("blood_mirror")
	_expect(_same_id_set(keeper_mirror, ["wolf_tier0_handling", "wraith_tier0_handling", "ronin_tier0_handling"]), "Keeper must unlock Mirror node 1 for all three Aspects")

	MetaProgress.boss_clears[2] = true
	var twin_mirror := _available_ids("blood_mirror")
	_expect(twin_mirror.has("wolf_signature_reliability") and twin_mirror.has("wraith_signature_reliability") and twin_mirror.has("ronin_signature_reliability"), "Twin Maws must unlock Mirror node 2 for all three Aspects")

	MetaProgress.boss_clears[3] = true
	var shogun_mirror := _available_ids("blood_mirror")
	_expect(shogun_mirror.size() == 9, "Shogun / first Binding clear must make all nine Mirror nodes structurally available")

	# Exercise a real Bloodwell purchase and its approved resource sink.
	MetaProgress.mist = 500
	MetaProgress.purchased_progression_nodes.clear()
	MetaProgress.boss_clears = {1: false, 2: false, 3: false}
	var mist_before := int(MetaProgress.mist)
	_expect(bool(MetaProgressionManager.purchase_node("vitality")), "available Bloodwell node must be purchasable")
	_expect(bool(MetaProgress.is_progression_node_owned("vitality")), "Bloodwell purchase must persist ownership")
	_expect(int(MetaProgress.mist) == mist_before - 50, "Vitality prototype purchase must spend 50 persistent Mist")

	# Prosthetic launch roster/rank economy is exact: eight tools, 19 ranks, 66 Scrolls.
	_expect(ProstheticManager.get_total_upgrade_count() == 19, "launch Prosthetics must expose exactly 19 upgrade ranks")
	var total_scrolls := 0
	var observed_costs: Dictionary = {}
	for prosthetic_id: String in PROSTHETIC_SCRIPT.CURRENT_IDS:
		var data: ProstheticData = ProstheticManager.get_prosthetic(prosthetic_id)
		_expect(data != null, "missing canonical Prosthetic %s" % prosthetic_id)
		if data == null:
			continue
		for upgrade_value in data.upgrade_nodes:
			var upgrade: Dictionary = upgrade_value as Dictionary
			var cost := int(upgrade.get("cost_scrolls", 0))
			total_scrolls += cost
			observed_costs[cost] = true
	_expect(total_scrolls == 66, "full Prosthetic upgrade roster must cost 66 Scrolls")
	_expect(_same_id_set(observed_costs.keys(), [2, 4, 6]), "Prosthetic rank costs must use only 2 / 4 / 6 Scrolls")

	# Relic acquisition ownership is exactly 4 campaign + 2 challenge + 4 run-discovered.
	var relic_ids: Array[String] = []
	for relic_id in STRAND_SCRIPT.CAMPAIGN_RELICS.values():
		relic_ids.append(str(relic_id))
	for relic_id in STRAND_SCRIPT.CHALLENGE_RELICS.values():
		relic_ids.append(str(relic_id))
	for relic_id in STRAND_SCRIPT.RUN_DISCOVERED_RELICS:
		relic_ids.append(str(relic_id))
	var unique_relic_ids: Dictionary = {}
	for relic_id in relic_ids:
		unique_relic_ids[relic_id] = true
	_expect(STRAND_SCRIPT.CAMPAIGN_RELICS.size() == 4, "Relic source split must contain four campaign/Strand Relics")
	_expect(STRAND_SCRIPT.CHALLENGE_RELICS.size() == 2, "Relic source split must contain two Blood Cavern/challenge Relics")
	_expect(STRAND_SCRIPT.RUN_DISCOVERED_RELICS.size() == 4, "Relic source split must contain four run-discovered Relics")
	_expect(unique_relic_ids.size() == 10, "4/2/4 Relic sources must cover ten unique launch Relics")

	MetaProgress.blood_cavern_trial_completions.clear()
	var first_claim: Dictionary = MetaProgressionManager.complete_blood_cavern_trial(STRAND_SCRIPT.TRIAL_EXECUTION)
	var repeat_claim: Dictionary = MetaProgressionManager.complete_blood_cavern_trial(STRAND_SCRIPT.TRIAL_EXECUTION)
	_expect(bool(first_claim.get("first_clear", false)), "Blood Cavern challenge must award its first-clear claim once")
	_expect(not bool(repeat_claim.get("first_clear", true)), "Blood Cavern challenge claim must not repeat")

	# The Strand scene must expose Bloodwell and Forge directly, while permanent
	# Blood Aspect progression lives deeper inside the authored Blood Cavern.
	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	_expect(hub.get_node_or_null("Bloodwell") != null, "Hub must expose Bloodwell station")
	_expect(hub.get_node_or_null("ForgeBench") != null, "Hub must expose Forge Bench station")
	var cavern: Node = hub.get_node_or_null("BloodCavern")
	_expect(cavern != null, "Hub must expose Blood Cavern training/trial station")
	_expect(hub.get_node_or_null("BloodMirror") == null, "Blood Mirror must not return as a standalone Strand root station")
	_expect(hub.get_node_or_null("BloodCavern/BloodMirror") != null, "Blood Cavern must contain the permanent Blood Mirror progression mechanism")
	hub.queue_free()
	await get_tree().process_frame


func _reset_campaign_memory() -> void:
	MetaProgress.returning_blood_awakened = false
	MetaProgress.boss_clears = {1: false, 2: false, 3: false}
	MetaProgress.mist = 0
	MetaProgress.scrolls = 0
	MetaProgress.boss_materials = {"keeper": 0, "twin_maws": 0, "eclipse_shogun": 0}
	MetaProgress.purchased_progression_nodes.clear()
	MetaProgress.progression_flags.clear()
	MetaProgress.blood_cavern_trial_completions.clear()


func _available_ids(station: String) -> Array:
	var out: Array = []
	for data_value in MetaProgressionManager.get_nodes_for_station(station):
		var data: Dictionary = data_value as Dictionary
		if bool(data.get("available", false)):
			out.append(str(data.get("id", "")))
	return out


func _same_id_set(actual: Array, expected: Array) -> bool:
	if actual.size() != expected.size():
		return false
	var actual_set: Dictionary = {}
	for value in actual:
		actual_set[value] = true
	for value in expected:
		if not actual_set.has(value):
			return false
	return true


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
