extends SceneTree
const Summary = preload("res://scripts/experience_summary.gd")
const Progress = preload("res://scripts/level_progression.gd")
const Store = preload("res://scripts/save_store.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const PATH := "user://experience-summary-tests.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, caption: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + caption)
func run() -> void:
	preload("res://tests/legacy_world_fixture.gd").activate()
	var app := root.get_node("App")
	app.response_timer.stop()
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.profile.settings.sound = false
	app.pending_experience_id = ""
	app.load_failed = false
	app.profile.campaign.progression.trainer_xp = 90
	app.profile.campaign.progression.units[Roster.STARTER] = {"level": 1, "xp": 90}
	check(app.start_route("jade_point_1"), "start test location")
	app.discover_location(app.profile.campaign.encounter.id)
	var encounter := Tactical.new()
	encounter.restore(app.profile.campaign.encounter)
	encounter.state.enemy.hp = 1
	encounter._sync()
	app.profile.campaign.encounter = encounter.snapshot()
	var saved: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-summary-directory/profile.json")
	check(not app.trial_action("karmany", "golpe"), "failed save does not show a reward")
	check(app.pending_experience_id.is_empty() and app.profile == saved, "no presentation or XP after failed transaction")
	app.storage = Store.new(PATH)
	check(app.trial_action("karmany", "golpe"), "successful win")
	var receipt: Dictionary = app.profile.campaign.progression.last_reward.duplicate(true)
	var id: String = receipt.encounter_id
	check(receipt.rows[1].before == {"level":1,"xp":90} and receipt.rows[1].after == {"level":2,"xp":15}, "atomic receipt preserves before/after XP")
	check(receipt.rows[1].species_id == "zephyr", "receipt freezes recipient species")
	var loaded: Dictionary = app.storage.load_profile()
	check(loaded.campaign.progression.last_reward == receipt, "receipt survives save/load exactly")
	var invalid := loaded.duplicate(true)
	invalid.campaign.progression.last_reward.rows[1].after.xp = -1
	check(not Store.valid(invalid), "invalid snapshot rejected")
	invalid = loaded.duplicate(true)
	invalid.campaign.progression.last_reward.rows[1].gained = 24
	check(not Store.valid(invalid), "inconsistent applied XP rejected")
	invalid = loaded.duplicate(true)
	invalid.campaign.progression.last_reward.rows[1].species_id = "unknown"
	check(not Store.valid(invalid), "unknown portrait species rejected")
	var legacy := loaded.duplicate(true)
	for row in legacy.campaign.progression.last_reward.rows:
		row.erase("before")
		row.erase("after")
		row.erase("species_id")
	check(Store.valid(legacy), "Preview28 receipt remains compatible")
	check(app.consume_experience("another").is_empty(), "wrong encounter cannot consume presentation")
	check(app.consume_experience(id) == receipt, "new victory presents once")
	check(app.consume_experience(id).is_empty(), "menu rebuild cannot replay reward")
	app.profile = loaded
	check(app.consume_experience(id).is_empty(), "loading stored receipt cannot replay reward")
	var row: Dictionary = receipt.rows[1]
	var start := Summary.frame(row, 0.0)
	check(start.level == 1 and start.xp == 90, "bar starts at pre-victory XP")
	var full := Summary.frame(row, 0.70)
	check(full.level == 1 and full.xp == 100 and full.maximum == 100, "old level bar reaches full before rollover")
	var rollover := Summary.frame(row, 0.85)
	check(rollover.level == 2 and rollover.xp > 0 and rollover.xp < 15, "remainder fills after level-up")
	var end := Summary.frame(row, 1.0)
	check(end.level == 2 and end.xp == 15 and end.maximum == 200 and end.done, "final bar matches saved progress")
	var normal := row.duplicate(true)
	normal.before = {"level":2,"xp":25}
	normal.after = {"level":2,"xp":50}
	normal.level = 2
	check(Summary.frame(normal, .5).xp == 37.5, "non-leveling bar fills smoothly")
	check(Summary.stat_changes(normal).is_empty(), "no invented stat growth without level-up")
	var capped := row.duplicate(true)
	capped.before = {"level":9,"xp":895}
	capped.after = {"level":10,"xp":0}
	capped.level = 10
	capped.gained = 5
	capped.capped = true
	check(Summary.frame(capped, 1.0).full and Summary.frame(capped, 1.0).level == 10, "regional cap ends with full bar")
	capped.before = capped.after.duplicate(true)
	capped.gained = 0
	check(Summary.frame(capped, 0.0).full and Summary.stat_changes(capped).is_empty(), "already capped does not fake a level-up")
	var delta := Summary.stat_changes(row)
	check(delta.contains("Vida") and delta.contains("Ataque") and delta.contains("Defensa") and delta.contains("Velocidad"), "all stat labels included")
	check(delta == "Vida  80 → 84  (+4)\nAtaque  20 → 21  (+1)\nDefensa  8 → 8  (+0)\nVelocidad  10 → 10", "displayed stats match approved level-one to two growth")
	check(delta.contains("→") and delta.contains("(+"), "before, after and growth are explicit")
	for reduced in [false,true]:
		app.profile.settings.reduced_motion = reduced
		var dialog := Summary.new()
		dialog.receipt = receipt.duplicate(true)
		root.add_child(dialog)
		dialog.present()
		dialog.set_process(false)
		check(dialog.visible and dialog.exclusive and dialog.get_ok_button().text == "Continuar", "modal continuation available")
		check(dialog.cards.size() == 2, "trainer and main-team member displayed")
		if reduced:
			check(dialog.cards[1].bar.value == 15 and dialog.cards[1].stats.text == delta, "reduced motion presents final stats instantly")
		else:
			check(dialog.cards[1].bar.value == 90 and dialog.cards[1].stats.text.is_empty(), "normal mode begins at old XP")
			dialog._process(Summary.DURATION)
			check(dialog.cards[1].bar.value == 15 and dialog.cards[1].stats.text == delta, "animation finishes with actual stat delta")
		check(app.profile.campaign.progression == loaded.campaign.progression, "presentation never changes earned progress")
		dialog.free()
	# The actual battle-page rebuild consumes pending UI presentation exactly once.
	app.pending_experience_id = id
	var ui: Control = load("res://scripts/trial_ui.gd").new()
	root.add_child(ui)
	await process_frame
	check(ui.get_node_or_null("ExperienceSummary") != null, "winning battle page opens XP window")
	ui.free()
	ui = load("res://scripts/trial_ui.gd").new()
	root.add_child(ui)
	await process_frame
	check(ui.get_node_or_null("ExperienceSummary") == null, "rebuilt battle page does not reopen XP window")
	ui.free()
	app.pending_experience_id = id
	app.profile.settings.reduced_motion = false
	var main: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	check(main.find_child("ExperienceSummary", true, false) != null, "main battle shows pending summary")
	main._back()
	await process_frame
	check(main.page == "battle" and main.find_child("ExperienceSummary", true, false) == null, "Android back dismisses summary and keeps binding page")
	check(app.profile.campaign.progression == loaded.campaign.progression, "early close keeps all committed XP")
	main.free()
	var training := receipt.duplicate(true)
	training.region = ""
	app.profile.campaign.progression.last_reward = training
	app.pending_experience_id = id
	check(app.consume_experience(id).is_empty() and app.pending_experience_id.is_empty(), "training never announces earned XP")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("Experience summary: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
