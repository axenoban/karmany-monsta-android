extends SceneTree
const Encounter = preload("res://scripts/trial_encounter.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Store = preload("res://scripts/save_store.gd")
const TouchMap = preload("res://scripts/skill_tree_map.gd")
const PATH := "user://playable_trial_test.json"
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + description)

func _tree() -> Dictionary:
	var tree := TreeModel.new()
	for i in range(4): tree.gain_level()
	for id in ["curacion", "proteccion", "potenciacion", "control"]:
		tree.purchase(id)
		tree.equip(id)
	return tree.snapshot()

func _win(encounter: TrialEncounter) -> void:
	while encounter.state.phase == "battle":
		encounter.act("karmany", "insignia" if encounter.reason("karmany", "insignia").is_empty() else "golpe")
		if encounter.state.phase == "battle": encounter.end_round()

func _clean() -> void:
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)

func _run() -> void:
	_clean()
	var e := Encounter.new()
	_check(e.begin("test", _tree(), [0.9, 0.8, 0.1]), "encounter begins with equipped ranks and fixed capture rolls")
	_check(not e.end_round(), "enemy cannot act before Karmany action")
	_check(not e.attempt_capture(), "cannot capture before defeat")
	_check(not e.act("trainer", "curacion"), "healing full HP does not spend trainer action")
	_check(e.act("trainer", "potenciacion") and e.act("karmany", "golpe") and e.state.enemy_hp == 63, "trainer-first boosts damage")
	_check(not e.act("karmany", "golpe") and not e.act("trainer", "proteccion"), "one action per owner")
	_check(e.end_round() and e.state.player_hp == 68, "enemy damage after closing shared turn")
	_check(e.act("karmany", "golpe") and e.act("trainer", "proteccion") and e.end_round() and e.state.player_hp == 62, "Karmany-first then shield reduces enemy damage")
	_check(e.reason("trainer", "proteccion") != "", "resonance cooldown enforced")
	var resumed := Encounter.new()
	_check(resumed.restore(JSON.parse_string(JSON.stringify(e.snapshot()))) and resumed.state.player_hp == 62, "JSON restore preserves HP, turn and cooldown")
	var buff := Encounter.new()
	buff.begin("buff", _tree(), [0.1, 0.2, 0.3])
	buff.act("karmany", "golpe")
	buff.act("trainer", "potenciacion")
	buff.end_round()
	buff.act("karmany", "golpe")
	_check(buff.state.enemy_hp == 51, "buff used after Karmany persists into next turn")
	var special := Encounter.new()
	special.begin("special", TreeModel.defaults(), [0.1, 0.2, 0.3])
	_check(special.act("karmany", "insignia") and special.state.enemy_hp == 58, "signature uses approved 150 percent formula")
	special.end_round()
	_check(not special.act("karmany", "insignia"), "signature waits through two full cooldown turns")
	_win(special)
	_check(special.state.phase == "capture" and special.state.player_hp > 0, "tactical signature strategy reaches capture")
	_check(special.attempt_capture() and special.state.phase == "captured", "successful book capture ends session")
	_check(not special.attempt_capture() and not special.act("karmany", "golpe"), "no extra action after capture")
	var escape := Encounter.new()
	escape.begin("escape", TreeModel.defaults(), [0.99, 0.99, 0.99])
	_win(escape)
	_check(escape.attempt_capture() and escape.state.capture.actions.size() == 1, "first failure uses one attempt")
	var retry := Encounter.new()
	retry.restore(JSON.parse_string(JSON.stringify(escape.snapshot())))
	_check(retry.state.rolls == escape.state.rolls and retry.state.capture.actions.size() == 1, "resume cannot reroll or reset capture attempts")
	retry.attempt_capture()
	retry.attempt_capture()
	_check(retry.state.phase == "escaped" and not retry.attempt_capture(), "three failures escape; fourth forbidden")
	var defeat := Encounter.new()
	defeat.begin("defeat", TreeModel.defaults(), [0.1, 0.2, 0.3])
	while defeat.state.phase == "battle":
		defeat.act("karmany", "golpe")
		if defeat.state.phase == "battle": defeat.end_round()
	_check(defeat.state.phase == "defeat" and not defeat.attempt_capture(), "poor strategy can lose; defeat cannot capture")
	var invalid := e.snapshot()
	invalid.player_hp = -1
	_check(not Encounter.valid(invalid), "negative saved HP rejected")
	invalid = e.snapshot()
	invalid.loadout["unknown"] = 1
	_check(not Encounter.valid(invalid), "unknown equipped effect rejected")
	invalid = e.snapshot()
	invalid.rolls[0] = 1.0
	_check(not Encounter.valid(invalid), "invalid saved capture roll rejected")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	_check(app.start_trial(), "app starts and saves new encounter")
	var starting: Dictionary = app.profile.campaign.encounter.duplicate(true)
	_check(app.start_trial() and app.profile.campaign.encounter == starting, "map resume does not replace active encounter")
	_check(app.trial_action("karmany", "insignia", 0), "app saves action transaction")
	_check(not app.trial_action("karmany", "insignia", 0), "stale double tap rejected")
	_check(app.storage.load_profile().campaign.encounter.player_hp == 80, "saved app action reopens")
	while app.profile.campaign.encounter.phase == "battle":
		var current := Encounter.new()
		current.restore(app.profile.campaign.encounter)
		if current._turn().available("karmany"):
			app.trial_action("karmany", "insignia" if current.reason("karmany", "insignia").is_empty() else "golpe")
		else: app.trial_action("end")
	_check(app.profile.campaign.victories == 1 and app.profile.skill_tree.level == 2, "victory awards one trainer level exactly once")
	var capture_scene: PackedScene = load("res://scenes/main.tscn")
	var capture_ui := capture_scene.instantiate()
	root.add_child(capture_ui)
	capture_ui._show("battle")
	await process_frame
	_check(capture_ui.get_node_or_null("Page") != null, "capture UI formats the literal percent sign")
	capture_ui.queue_free()
	await process_frame
	app.profile.campaign.encounter.rolls = [0.1, 0.1, 0.1]
	_check(app.trial_action("capture") and app.profile.campaign.collection.size() == 1, "capture adds one persistent individual")
	_check(not app.trial_action("capture") and app.profile.campaign.collection.size() == 1, "terminal capture cannot duplicate rewards")
	_check(app.storage.load_profile().campaign == app.profile.campaign, "collection, result and victory persist through JSON")
	_check(app.profile.skill_tree.captured_species == ["tanugami"], "real capture advances unique species tally")
	var previous: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-playable-directory/profile.json")
	_check(not app.start_trial() and app.profile == previous, "failed new encounter save does not replace result")
	app.storage = Store.new(PATH)
	var v2 := Store.defaults()
	v2.erase("campaign")
	v2.schema = 2
	v2.skill_tree = _tree()
	var handle := FileAccess.open(PATH, FileAccess.WRITE)
	handle.store_string(JSON.stringify(v2))
	handle.close()
	var migrated: Dictionary = app.storage.load_profile()
	_check(migrated.schema == 3 and migrated.skill_tree == v2.skill_tree and migrated.campaign.collection.is_empty(), "0.4 save migrates without losing tree")
	var touch := TouchMap.new()
	touch.pointer_event(true, Vector2(10, 10))
	touch.pointer_move(Vector2(50, 60))
	touch.pointer_event(false, Vector2(50, 60))
	_check(touch._dragged, "scroll gesture does not select a tree node")
	touch.pointer_event(true, Vector2(10, 10))
	touch.pointer_event(false, Vector2(12, 13))
	_check(not touch._dragged, "small finger movement remains a tap")
	touch.free()
	app.profile = Store.defaults()
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	for page in ["intro", "jade_play", "collection"]:
		main._show(page)
		await process_frame
		_check(main.get_node_or_null("Page") != null, "playable screen builds: " + page)
	app.start_trial()
	main._show("battle")
	await process_frame
	_check(main.get_node_or_null("Page") != null, "battle UI builds from persisted encounter")
	main.queue_free()
	await process_frame
	_clean()
	print("PLAYABLE TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
