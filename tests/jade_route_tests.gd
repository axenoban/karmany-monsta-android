extends SceneTree
const Route = preload("res://scripts/jade_route.gd")
const Router = preload("res://scripts/encounter_router.gd")
const Store = preload("res://scripts/save_store.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Campaign = preload("res://scripts/trial_campaign.gd")
const PATH := "user://jade-route-tests.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func win(app: Node) -> void:
	var actions := 0
	while app.profile.campaign.encounter.phase == "battle" and actions < 80:
		var model = Router.create(app.profile.campaign.encounter)
		model.restore(app.profile.campaign.encounter)
		if model.state.enemy_pending: check(app.trial_action("enemy"), "resolve rival")
		else: check(app.trial_action("karmany", "insignia" if model.reason("karmany", "insignia").is_empty() else "golpe"), "resolve ability")
		app.response_timer.stop()
		actions += 1
	check(app.profile.campaign.encounter.phase == "capture", "win reaches optional capture")
func find_button(node: Node, text: String) -> Button:
	if node is Button and node.text.begins_with(text): return node
	for child in node.get_children(true):
		var found := find_button(child, text)
		if found != null: return found
	return null
func _run() -> void:
	root.size = Vector2i(1280, 720)
	var defaults := Route.defaults()
	check(Route.next_point(defaults) == "jade_point_1" and Route.unlocked(defaults, "jade_point_1"), "first point unlocked")
	check(not Route.unlocked(defaults, "jade_point_2") and not Route.unlocked(defaults, "unknown"), "later and unknown points locked")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	check(not app.start_route("jade_point_4") and app.profile.campaign.sequence == 0, "model rejects out-of-order start")
	check(app.start_trial("tanugami"), "training remains available")
	win(app)
	check(app.profile.campaign.route == defaults, "training win never advances route")
	app.profile.campaign.encounter.rolls = [0.99, 0.99, 0.99]
	for i in range(3): app.trial_action("capture")
	check(app.profile.campaign.encounter.phase == "escaped", "training escape unchanged")
	# Each point records victory exactly once; capture is not the progress gate.
	for point in Route.points():
		var index: int = app.profile.campaign.route.completed.size()
		check(app.start_route(point.id), "start unlocked route point")
		check(app.profile.campaign.encounter.enemy_species == point.species, "point uses actual species")
		# Fixed random fixtures make exact JSON equality reproducible; JSON numbers
		# otherwise round arbitrary random doubles at the serializer boundary.
		app.profile.campaign.encounter.rolls = [0.9, 0.8, 0.7]
		check(app.commit_profile(app.profile), "fixed route checkpoint saved")
		var starting: Dictionary = app.profile.duplicate(true)
		check(app.start_route(point.id) and app.profile == starting, "same point resumes without rerolling or new encounter")
		check(not app.start_route("unknown") and app.profile == starting, "unknown point cannot replace live encounter")
		var v: int = app.profile.campaign.victories
		win(app)
		var encounter: Dictionary = app.profile.campaign.encounter
		check(app.profile.campaign.route.completed.size() == index + 1 and app.profile.campaign.victories == v + 1, "victory atomically advances point and normal reward")
		check(Campaign.valid(app.profile.campaign), "winning checkpoint validates")
		check(app.storage.load_profile() == app.profile, "route persists through JSON")
		check(not app.trial_action("karmany", "golpe", encounter.revision) and app.profile.campaign.victories == v + 1, "finishing action cannot duplicate rewards")
		if index == 0:
			app.profile.campaign.encounter.rolls = [0.99, 0.99, 0.99]
			for i in range(3): app.trial_action("capture")
			check(app.profile.campaign.encounter.phase == "escaped" and app.profile.campaign.route.completed.size() == 1, "three capture failures do not remove progress")
		elif index == 1:
			app.profile.campaign.encounter.rolls = [0.1, 0.1, 0.1]
			check(app.trial_action("capture") and app.profile.campaign.collection.back().species == point.species, "optional capture delivers actual species")
		var saved: Dictionary = app.profile.duplicate(true)
		var current: Dictionary = saved.campaign.encounter
		app.storage = Store.new("user://missing-route-directory/profile.json")
		check(not app.continue_route(current.id, current.revision) and app.profile == saved, "failed continuation save keeps capture and progress")
		app.storage = Store.new(PATH)
		check(not app.continue_route(current.id, current.revision - 1) and app.profile == saved, "stale continuation rejected")
		check(app.continue_route(current.id, current.revision) and app.profile.campaign.encounter.is_empty(), "continue without requiring capture")
		check(not app.continue_route(current.id, current.revision), "duplicate continuation rejected")
	check(Route.next_point(app.profile.campaign.route).is_empty(), "four-point completion")
	var receipt: Array = app.profile.campaign.route.completed.duplicate(true)
	check(app.start_route("jade_point_1"), "completed point can be replayed for capture")
	win(app)
	check(app.profile.campaign.route.completed == receipt, "replay preserves first completion receipts")
	app.continue_route(app.profile.campaign.encounter.id, app.profile.campaign.encounter.revision)
	check(app.start_trial("kitsunibi") and app.profile.campaign.route.current.is_empty() and app.profile.campaign.route.completed == receipt, "training remains separate after completion")
	app.trial_action("retreat")
	var previous: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-route-directory/profile.json")
	check(not app.start_route("jade_point_2") and app.profile == previous, "failed start does not create a route encounter")
	app.storage = Store.new(PATH)
	# Migration adds empty progress while preserving old encounter and capture state.
	var old := Store.defaults()
	old.campaign.erase("route")
	old.campaign.sequence = 1
	var legacy := Legacy.new()
	legacy.begin("jade-1", TreeModel.defaults(), [0.1, 0.2, 0.3])
	legacy.act("karmany", "golpe")
	old.campaign.encounter = legacy.snapshot()
	check(Store.valid(old) and app.storage.save_profile(old), "old profile accepted without route")
	var migrated: Dictionary = app.storage.load_profile()
	check(migrated.campaign.route == defaults and migrated.campaign.encounter == Campaign.normalized(old.campaign).encounter, "migration does not infer route completion from old training")
	# Defeat, withdrawal, pending rival and replacement must not grant route completion.
	app.profile = Store.defaults()
	app.start_route("jade_point_1")
	check(not app.continue_route(app.profile.campaign.encounter.id, 0), "cannot continue live encounter")
	app.trial_action("retreat")
	check(app.profile.campaign.route.completed.is_empty(), "retreat never advances")
	app.start_route("jade_point_1")
	app.trial_action("karmany", "golpe")
	app._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	app.profile = app.storage.load_profile()
	check(app.profile.campaign.route.current.point_id == "jade_point_1" and app.profile.campaign.encounter.enemy_pending, "pause saves route source and pending response")
	app._notification(MainLoop.NOTIFICATION_APPLICATION_RESUMED)
	await app.response_timer.timeout
	check(app.profile.campaign.encounter.round == 2 and app.profile.campaign.route.completed.is_empty(), "resume responds once without progress")
	# Force only the fixture's HP to exercise the persisted replacement path.
	app.profile = Store.defaults()
	app.profile.campaign.sequence = 1
	app.profile.campaign.victories = 1
	app.profile.campaign.collection = [{"id": "jade-1", "species": "ushigane"}]
	app.change_team("add", "jade-1")
	app.start_route("jade_point_1")
	var model = Router.create(app.profile.campaign.encounter)
	model.restore(app.profile.campaign.encounter)
	model.active().hp = 1
	model.state.enemy.ready.insignia = 4
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
	app.trial_action("karmany", "golpe")
	app.trial_action("enemy")
	app.response_timer.stop()
	check(app.profile.campaign.encounter.phase == "replacement" and app.storage.load_profile().campaign.route.current.point_id == "jade_point_1", "replacement keeps route identity across reload")
	app.trial_action("replace", "jade-1")
	app.trial_action("retreat")
	app.profile = Store.defaults()
	app.start_route("jade_point_1")
	model = Router.create(app.profile.campaign.encounter)
	model.restore(app.profile.campaign.encounter)
	model.active().hp = 1
	model.state.enemy.ready.insignia = 4
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
	app.trial_action("karmany", "golpe")
	app.trial_action("enemy")
	app.response_timer.stop()
	check(app.profile.campaign.encounter.phase == "defeat" and app.profile.campaign.route.completed.is_empty(), "total defeat does not advance route")
	check(app.start_route("jade_point_1") and app.profile.campaign.encounter.round == 1, "defeated point can be retried with recovered team")
	app.trial_action("retreat")
	# A winning action and its route receipt must commit together or neither does.
	app.start_route("jade_point_1")
	model = Router.create(app.profile.campaign.encounter)
	model.restore(app.profile.campaign.encounter)
	model.state.enemy.hp = 1
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
	check(app.commit_profile(app.profile), "pre-victory checkpoint saved")
	var pre_win: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-route-directory/profile.json")
	check(not app.trial_action("karmany", "golpe") and app.profile == pre_win, "failed victory save grants neither victory nor route receipt")
	app.storage = Store.new(PATH)
	check(app.trial_action("karmany", "golpe") and app.profile.campaign.route.completed.size() == 1, "winning action retries once after storage recovery")
	app.continue_route(app.profile.campaign.encounter.id, app.profile.campaign.encounter.revision)
	# Reject forged/out-of-order progress and mismatched source before touching backups.
	var bad: Dictionary = app.profile.duplicate(true)
	bad.campaign.route.completed = [{"point_id": "jade_point_2", "encounter_id": "jade-1"}]
	check(not Store.valid(bad), "out-of-order receipt rejected")
	bad = app.profile.duplicate(true)
	bad.campaign.route.current = {"point_id": "jade_point_2", "encounter_id": "jade-1"}
	check(not Store.valid(bad), "wrong route source rejected")
	# UI points, confirmation to leave capture, victory result, and large-text geometry.
	app.profile = Store.defaults()
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("jade_play")
		await process_frame
		await process_frame
		var maps := main.find_children("*", "Control", true, false)
		var map_node: Node = null
		for node in maps:
			if node.get_script() == load("res://scripts/jade_route_map.gd"): map_node = node
		check(map_node != null and map_node.buttons.size() == 4, "four real map points")
		check(not map_node.buttons[0].disabled and map_node.buttons[1].disabled, "UI mirrors ordered access")
		for button in map_node.buttons:
			check(button.get_global_rect().end.x <= 1280 and button.get_global_rect().end.y < 600 and button.size.y >= 58, "map point fits viewport")
	find_button(main.get_node("Page"), "Iniciar").pressed.emit()
	await process_frame
	check(app.profile.campaign.route.current.point_id == "jade_point_1", "real map button starts correct route")
	win(app)
	main._show("battle")
	await process_frame
	var snapshot: Dictionary = app.profile.duplicate(true)
	var continue_button := find_button(main.get_node("Page"), "Continuar recorrido sin vínculo")
	check(continue_button.get_global_rect().end.y < 690, "optional capture continuation stays visible")
	continue_button.pressed.emit()
	await process_frame
	check(app.profile == snapshot, "opening continuation confirmation spends no attempts")
	find_button(main.get_node("Page"), "Continuar sin vínculo").pressed.emit()
	await process_frame
	check(app.profile.campaign.encounter.is_empty() and app.profile.campaign.route.completed.size() == 1, "confirmed optional capture exit returns to map")
	main.queue_free()
	await process_frame
	app.response_timer.stop()
	for suffix in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute(PATH + suffix)
	print("JADE ROUTE TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
