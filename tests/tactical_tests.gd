extends SceneTree
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const Router = preload("res://scripts/encounter_router.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Store = preload("res://scripts/save_store.gd")
const Stage = preload("res://scripts/trial_stage.gd")
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func team(species: Array = ["zephyr", "ushigane", "sakuromushi"]) -> Dictionary:
	var members := []
	for i in range(species.size()): members.append({"instance_id": "unit-%d" % i, "species_id": species[i]})
	return {"schema": 1, "members": members, "active_id": "unit-0"}
func fresh(species: Array = ["zephyr", "ushigane", "sakuromushi"], rival: String = "ushigane") -> TacticalEncounter:
	var e := Tactical.new()
	check(e.begin("trial", TreeModel.defaults(), [0.1, 0.7, 0.9], team(species), rival), "begin valid tactical encounter")
	return e
func find_button(node: Node, text: String) -> Button:
	if node is Button and node.text.begins_with(text): return node
	for child in node.get_children(true):
		var result := find_button(child, text)
		if result != null: return result
	return null
func _run() -> void:
	root.size = Vector2i(1280, 720)
	for species in Catalog.all_species():
		var e := fresh([species], "kitsunibi")
		check(e.state.player_hp == Catalog.stats(species).life, "species life " + species)
		check(e.act("karmany", "golpe") and e.state.enemy_pending, "attack schedules response " + species)
		var saved := e.snapshot()
		var restored := Tactical.new()
		check(restored.restore(JSON.parse_string(JSON.stringify(saved))), "JSON checkpoint " + species)
		check(restored.end_round() and not restored.end_round() and Tactical.valid(restored.snapshot()), "single response " + species)
		for action in ["golpe", "insignia"]:
			check(Stage.pose(species, action, 0).is_zero_approx() and Stage.pose(species, action, 1).is_zero_approx(), "motion returns to origin")
		check(Stage.pose(species, "golpe", 0.5) != Stage.pose(species, "insignia", 0.5), "normal and signature motion differ")
	var e := fresh(["sakuromushi", "ushigane", "ushigane"])
	var original_hp: int = e.state.enemy_hp
	check(not e.act("karmany", "insignia", "unit-0") and e.state.round == 1, "relay forbids choosing active")
	check(not e.act("karmany", "insignia", "unknown"), "relay rejects unknown recipient")
	check(e.act("karmany", "insignia", "unit-2") and e.state.ally_id == "unit-2" and e.state.enemy_pending, "one action attacks and switches before enemy response")
	check(e.state.enemy_hp < original_hp and e.state.members[2].relay_boost == 0.2 and e.state.members[2].relay_until == 3, "relay causes damage and schedules two buffed rounds")
	check(e.state.members[1].relay_boost == 0.0 and not e.switch_to("unit-1"), "similar species receive no bonus and extra switch is blocked")
	check(e.state.members[0].ready.insignia == 4, "relay leaves cooldown on its caster")
	var before_hp: int = e.state.members[2].hp
	check(e.end_round() and e.state.members[2].hp < before_hp and e.state.round == 2, "single rival response hits new active")
	var saved := e.snapshot()
	var restored := Tactical.new()
	check(restored.restore(JSON.parse_string(JSON.stringify(saved))) and restored.active().relay_until == 3, "relay resumes across JSON checkpoints")
	var before_enemy_hp: int = e.state.enemy_hp
	check(e.act("karmany", "golpe") and e.state.enemy_hp < before_enemy_hp, "boosted entrant can attack next round")
	check(e.end_round() and e.state.round == 3 and e.active().relay_boost == 0.2, "relay bonus continues into second following round")
	check(e.act("karmany", "guardia") and e.end_round() and e.state.round == 4 and e.active().relay_boost == 0.0, "relay expires on schedule even if ally guards")
	check(e.state.members[0].ready.insignia == 4, "cooldown remains on swapped-out caster")
	e.active().hp = 1
	e._sync()
	e.act("karmany", "guardia")
	e.end_round()
	check(e.state.phase == "replacement" and not e.state.enemy_pending and Tactical.valid(e.snapshot()), "defeat after relay requires replacement")
	var checkpoint := Tactical.new()
	check(checkpoint.restore(e.snapshot()) and not checkpoint.end_round() and not checkpoint.act("trainer", "curacion"), "replacement survives restore and disallows actions")
	var old_round: int = checkpoint.state.round
	check(checkpoint.replace_with("unit-1") and checkpoint.state.round == old_round + 1 and checkpoint.state.player_hp == 96 and not checkpoint.state.enemy_pending, "replacement starts without extra enemy attack")
	check(not checkpoint.replace_with("unit-0") and Tactical.valid(checkpoint.snapshot()), "replacement cannot happen twice")
	var alone := fresh(["sakuromushi"], "kitsunibi")
	check(not alone.reason("karmany", "insignia").is_empty() and not alone.act("karmany", "insignia", "unit-0"), "solo Sakuromushi cannot relay")
	var previous := fresh(["sakuromushi", "ushigane"], "kitsunibi")
	for member in previous.state.members:
		member.erase("relay_boost")
		member.erase("relay_until")
	previous.state.enemy.erase("relay_boost")
	previous.state.enemy.erase("relay_until")
	var compatible := Tactical.new()
	check(Tactical.valid(previous.snapshot()) and compatible.restore(previous.snapshot()), "older snapshots without relay data continue to work")
	e = fresh(["tanugami"])
	check(not e.act("karmany", "insignia"), "full life healing blocked")
	e.active().hp = 75
	e._sync()
	check(e.act("karmany", "insignia") and e.state.player_hp == 80 and e.active().guard == 0.25 and e.state.ready.insignia == 5, "healing cap plus protection and cooldown three")
	e = fresh(["ushigane"])
	e.active().guard = 0.5
	e.act("karmany", "insignia")
	check(e.active().guard == 0.5, "protection uses strongest source")
	e.end_round()
	check(e.active().guard == 0, "protection consumed")
	e = fresh(["zephyr"], "kitsunibi")
	e.active().hp = 1
	e._sync()
	e.act("karmany", "golpe")
	e.end_round()
	check(e.state.phase == "defeat" and Tactical.valid(e.snapshot()), "total defeat")
	# Every rival captures its actual species once, with a fresh encounter each time.
	var app := root.get_node("App")
	app.storage = Store.new("user://tactical-tests.json")
	app.profile = Store.defaults()
	app.load_failed = false
	for rival in ["tanugami", "ushigane", "kitsunibi", "sakuromushi"]:
		check(app.start_trial(rival), "app starts " + rival)
		var revision: int = app.profile.campaign.encounter.revision
		app.trial_action("karmany", "insignia", revision)
		check(not app.trial_action("karmany", "insignia", revision), "stale action rejected")
		app.response_timer.stop()
		while app.profile.campaign.encounter.phase == "battle":
			var current: Dictionary = app.profile.campaign.encounter
			if current.enemy_pending: app.trial_action("enemy")
			else:
				var model = Router.create(current)
				model.restore(current)
				app.trial_action("karmany", "insignia" if model.reason("karmany", "insignia").is_empty() else "golpe")
			app.response_timer.stop()
		check(app.profile.campaign.encounter.phase == "capture", "Zephyr beats " + rival)
		app.profile.campaign.encounter.rolls = [0.1, 0.1, 0.1]
		check(app.trial_action("capture") and app.profile.campaign.collection.back().species == rival, "actual species captured " + rival)
		check(not app.trial_action("capture"), "capture cannot duplicate")
		check(app.storage.load_profile() == app.profile, "full profile roundtrip")
	check(app.change_team("add", "jade-1") and app.change_team("add", "jade-2"), "team editable after terminal encounter")
	check(app.start_trial("kitsunibi"), "team battle begins")
	app.trial_action("karmany", "golpe")
	app._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	var saved: Dictionary = app.storage.load_profile()
	check(saved.campaign.encounter.enemy_pending and app.response_timer.is_stopped(), "pause retains pending response")
	app.profile = saved
	app._notification(MainLoop.NOTIFICATION_APPLICATION_RESUMED)
	await app.response_timer.timeout
	check(app.profile.campaign.encounter.round == 2, "resume resolves once")
	var snapshot: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-tactical-directory/profile.json")
	check(not app.trial_action("switch", "jade-2") and app.profile == snapshot, "failed switch save leaves state unchanged")
	app.storage = Store.new("user://tactical-tests.json")
	# Legacy encounters keep the legacy engine even in an upgraded profile.
	var legacy := Legacy.new()
	legacy.begin("jade-5", TreeModel.defaults(), [0.1, 0.2, 0.3])
	legacy.act("karmany", "golpe")
	app.profile = Store.defaults()
	app.profile.campaign.sequence = 5
	app.profile.campaign.encounter = legacy.snapshot()
	check(app.commit_profile(app.profile) and Router.create(app.profile.campaign.encounter) is Legacy, "legacy encounter routes unchanged")
	app.response_timer.stop()
	check(app.trial_action("enemy") and app.profile.campaign.encounter.player_hp == 68, "legacy queued response preserves damage")
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	check(main.get_node_or_null("Page") != null, "legacy UI builds")
	app.profile.campaign.encounter = {}
	app.start_trial("sakuromushi")
	for page in ["battle", "jade_play", "collection", "team"]:
		main._show(page)
		await process_frame
		check(main.get_node_or_null("Page") != null, "tactical UI " + page)
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("battle")
		await process_frame
		await process_frame
		var finish := find_button(main.get_node("Page"), "Entrenador")
		check(finish != null and finish.get_global_rect().end.y < 690, "tactical controls fit viewport large=%s" % large)
	# Exercise confirmation and recipient selection through actual UI callbacks.
	app.profile = Store.defaults()
	app.profile.campaign.sequence = 2
	app.profile.campaign.victories = 2
	app.profile.campaign.collection = [{"id": "jade-1", "species": "sakuromushi"}, {"id": "jade-2", "species": "ushigane"}]
	app.change_team("add", "jade-1")
	app.change_team("add", "jade-2")
	app.change_team("active", "jade-1")
	app.start_trial("kitsunibi")
	main._show("battle")
	await process_frame
	find_button(main.get_node("Page"), "Insignia").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Ushigane · jade-2").pressed.emit()
	await process_frame
	app.response_timer.stop()
	check(app.profile.campaign.encounter.ally_id == "jade-2" and app.profile.campaign.encounter.members[2].relay_boost == 0.2, "UI selects reserve and automatically relays")
	app.trial_action("enemy")
	main._show("battle")
	await process_frame
	find_button(main.get_node("Page"), "Equipo").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Sakuromushi 76/76").pressed.emit()
	await process_frame
	check(not app.profile.campaign.encounter.enemy_pending and app.profile.campaign.team.active_id == "jade-2", "opening switch dialog does not spend action")
	find_button(main.get_node("Page"), "Confirmar cambio").pressed.emit()
	await process_frame
	app.response_timer.stop()
	check(app.profile.campaign.team.active_id == "jade-1" and app.profile.campaign.encounter.enemy_pending, "UI confirms standard switch with one rival response")
	main.queue_free()
	await process_frame
	app.response_timer.stop()
	for suffix in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute("user://tactical-tests.json" + suffix)
	print("TACTICAL TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
