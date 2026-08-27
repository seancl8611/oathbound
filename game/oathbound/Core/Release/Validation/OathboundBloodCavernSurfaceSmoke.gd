extends "res://Core/Release/Validation/BloodCavernSurfaceSmoke.gd"

## Release adapter for the live Blood Cavern ownership layer.
## All detailed target/menu/reward/Mirror assertions remain inherited from the base
## surface smoke; only the live script-ownership contract is updated to require the
## integrated Cavern that adds temporary fixed-loadout lifetime management.


func _run() -> void:
	var gold_before: int = int(RunData.gold) if typeof(RunData) == TYPE_OBJECT else 0
	var mist_before: int = int(MetaProgress.mist) if typeof(MetaProgress) == TYPE_OBJECT else 0
	var scrolls_before: int = int(MetaProgress.scrolls) if typeof(MetaProgress) == TYPE_OBJECT else 0

	await _validate_standalone_training_target()
	_expect(int(RunData.gold) == gold_before if typeof(RunData) == TYPE_OBJECT else true, "training target defeat changed run Gold")
	_expect(int(MetaProgress.mist) == mist_before if typeof(MetaProgress) == TYPE_OBJECT else true, "training target defeat changed persistent Mist")
	_expect(int(MetaProgress.scrolls) == scrolls_before if typeof(MetaProgress) == TYPE_OBJECT else true, "training target defeat changed persistent Scrolls")

	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	await get_tree().process_frame
	var cavern: Node = hub.get_node_or_null("BloodCavern")
	var prompt: Label = hub.get_node_or_null("BloodCavern/InteractPopup") as Label
	_expect(cavern != null, "canonical Blood Cavern node is missing from the live Strand")
	_expect(hub.get_node_or_null("PracticeGrounds") == null, "legacy Practice Grounds node is still authored into the live Strand")
	_expect(hub.get_node_or_null("BloodMirror") == null, "Blood Mirror is still authored as a standalone Strand root station")
	_expect(prompt != null and prompt.text == "Blood Cavern [E]", "Blood Cavern live prompt is not canonical")
	if cavern != null:
		var script_value: Variant = cavern.get_script()
		var script_path: String = (script_value as Script).resource_path if script_value is Script else ""
		_expect(
			script_path == "res://World/OathboundBloodCavern.gd",
			"live Strand Blood Cavern is not owned by the fixed-loadout lifecycle integration"
		)
		_expect(cavern.has_method("_menu_snapshot_for_playtest"), "Blood Cavern training/menu contract is missing")
		_expect(
			cavern.has_method("_stage_fixed_trial_loadout_for_playtest"),
			"live Blood Cavern is missing the temporary fixed-loadout staging seam"
		)
		var mirror: Node = cavern.get_node_or_null("BloodMirror")
		_expect(mirror != null, "deeper Blood Mirror is not nested inside Blood Cavern")
		if mirror != null:
			var mirror_script_value: Variant = mirror.get_script()
			var mirror_script_path: String = (mirror_script_value as Script).resource_path if mirror_script_value is Script else ""
			_expect(mirror_script_path == "res://World/BloodMirror.gd", "nested Blood Mirror lost canonical progression ownership")
		var snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
		_expect(str(snapshot.get("title", "")) == "BLOOD CAVERN", "Blood Cavern title fallback is not stable")
		_expect(str(snapshot.get("training_target", "")) == "Start Passive Combat Target", "Blood Cavern training action fallback is not stable")
		_expect(str(snapshot.get("trials", "")) == "BASIC TRIALS", "Blood Cavern trial heading fallback is not stable")
		_expect(str(snapshot.get("execution_trial", "")) == "Start Execution Trial", "Blood Cavern Execution Trial action fallback is not stable")
		_expect(str(snapshot.get("refreshers", "")) == "TUTORIAL REFRESHERS", "Blood Cavern refresher heading fallback is not stable")
		_expect(_same_string_set(snapshot.get("refresher_topics", []), EXPECTED_REFRESHERS), "Blood Cavern must expose exactly the seven approved refresher topics")
		_expect(str(snapshot.get("technique_demos", "")) == "TECHNIQUE DEMOS", "Blood Cavern Technique-demo heading fallback is not stable")
		_expect(str(snapshot.get("blood_mirror", "")) == "Enter Blood Mirror", "Blood Cavern does not expose the deeper Blood Mirror route")
		_validate_localized_snapshot(cavern)
		_validate_refresher_contract(cavern)
		await _validate_technique_demo_contract(cavern)
		await _validate_execution_trial_contract(cavern, gold_before, mist_before, scrolls_before)
		await _validate_trial_mirror_boundary(cavern)
		await _validate_actual_training_lifecycle(cavern, gold_before, mist_before, scrolls_before)
		await _validate_actual_menu_transition(cavern)
	hub.queue_free()
	await get_tree().process_frame
	get_tree().paused = false

	if _failed:
		get_tree().quit(1)
		return
	print("[BloodCavernSurfaceSmoke] PASS - live Blood Cavern | passive production-combat target | no enemy rewards | nested Blood Mirror | localized surface | tutorial refreshers | discovered Technique demos | real Execution Trial | training-state isolation")
	get_tree().quit(0)
