extends SceneTree
const Session = preload("res://scripts/first_session.gd")
const Store = preload("res://scripts/save_store.gd")
const Campaign = preload("res://scripts/trial_campaign.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const PATH := "user://first-session-tests.json"
var checks := 0
var failures := 0
var app: Node
var main: Node
func _initialize(): call_deferred("run")
func check(value: bool, message: String):
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL E5: " + message)
func clean():
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
func original(file: String):
	var raw: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview32/" + file + ".json"))
	app.profile = preload("res://scripts/preview32_migration.gd").convert(raw)
	app.profile.skill_tree = TreeModel.normalized(app.profile.skill_tree)
	app.profile.campaign = Campaign.normalized(app.profile.campaign)
	app.profile.settings.sound = false
	app.pending_transition = {}
	app.response_timer.stop()
func topic(context: String, id: String, point: String = "") -> String:
	for entry in Session.topics(app.profile, context, point):
		if entry.id == id: return entry.text
	return ""
func strip() -> Node:
	for node in get_nodes_in_group("context_help"):
		if node.is_visible_in_tree(): return node
	return null
func bounds(node: Node):
	if node is Button and node.is_visible_in_tree():
		# Scroll contents may legitimately lie beyond the clip rect.
		var parent := node.get_parent()
		var clipped := false
		while parent != null:
			if parent is ScrollContainer: clipped = true
			parent = parent.get_parent()
		if not clipped:
			var rect: Rect2 = node.get_global_rect()
			check(rect.position.x >= -1 and rect.end.x <= root.size.x + 1 and rect.position.y >= -1 and rect.end.y <= root.size.y + 1, "accessible button: " + node.text)
		check(node.size.y >= 47, "touch target: " + node.text)
	for child in node.get_children(): bounds(child)
func run():
	app = root.get_node("App")
	app.storage = Store.new(PATH)
	app.load_failed = false
	clean()
	app.profile = app.storage.load_profile()
	check(not app.profile.has("first_session"), "storage default remains compatible; App owns explicit journey opt-in")
	check(not Session.automatic(Store.defaults(), "map"), "absent field never infers new journey")
	check(not Session.automatic(app.profile, "unknown"), "unknown topic refused")
	var fresh_app: Node = load("res://scripts/app.gd").new()
	fresh_app.storage = Store.new(PATH)
	root.add_child(fresh_app)
	check(Session.automatic(fresh_app.profile, "map"), "App explicitly identifies absent primary and backup as new install")
	fresh_app.free()
	check(app.start_journey() and Session.automatic(app.profile, "map"), "explicit new journey opts in")
	var before: Dictionary = app.profile.duplicate(true)
	check(app.dismiss_first_session("map"), "dismiss persisted")
	check(app.profile.campaign == before.campaign and app.profile.skill_tree == before.skill_tree and app.profile.journey == before.journey, "dismiss has no game side effects")
	check(not Session.automatic(app.storage.load_profile(), "map"), "dismiss survives restart")
	check(Session.automatic(app.storage.load_profile(), "health"), "other topics retain their own state")
	check(not app.dismiss_first_session("map"), "dismiss idempotent")
	var invalid: Dictionary = app.profile.duplicate(true)
	invalid.first_session.seen.append("map")
	check(not Store.valid(invalid), "duplicate seen data rejected")
	invalid.first_session = {"version": 1, "seen": ["unknown"]}
	check(not Store.valid(invalid), "invalid optional extension rejected")
	app.profile = Store.defaults()
	check(app.storage.save_profile(app.profile), "Preview38 profile saved without extension")
	check(not app.storage.load_profile().has("first_session"), "Preview38 loading never adds tutorial")
	original("jade_point_6_battle")
	check(not Session.automatic(app.profile, "health"), "Preview32 no automatic tutorial")
	before = app.profile.duplicate(true)
	check(topic("map", "map") == Session.COPY.map, "E5-01 map approved copy")
	check(topic("entry", "entry", "jade_6").is_empty(), "invalid point never fabricates entry cost")
	var point: String = app.profile.campaign.route.current.point_id
	check(topic("entry", "entry", point).contains(str(preload("res://scripts/jade_route.gd").entry_cost(point))), "E5-02 actual point cost")
	check(topic("exploration", "search") == Session.COPY.search, "E5-03 search copy")
	check(topic("battle", "health") == Session.COPY.health and topic("battle", "turn") == Session.COPY.turn, "E5-04 health and turn")
	var skills := topic("battle", "skills")
	check(skills.contains(preload("res://scripts/combat_catalog.gd").action(app.profile.campaign.encounter.ally_species, "insignia").description), "E5-05 actual current Insignia description")
	check(topic("trainer", "trainer") == Session.COPY.trainer, "E5-06 optional resonances")
	check(topic("team", "team") == Session.COPY.team, "E5-07 voluntary switch")
	check(topic("battle", "resume") == Session.COPY.resume, "E5-12 pending encounter continuity")
	check(app.profile == before, "all presentation topics read-only")
	original("original_replacement")
	check(topic("battle", "replacement") == Session.COPY.replacement and topic("team", "team").is_empty(), "E5-08 forced replacement distinguished from voluntary")
	original("original_defeat")
	check(topic("defeat", "defeat") == Session.COPY.defeat and topic("experience", "xp").is_empty(), "E5-09 no XP promised on defeat")
	original("veil_point_6_victory")
	check(not topic("experience", "xp").is_empty(), "E5-10 real XP receipt")
	check(topic("binding", "binding").contains(str(preload("res://scripts/capture_session.gd").MAX_ATTEMPTS - app.profile.campaign.encounter.capture.actions.size())), "E5-11 attempts from actual capture state")
	check(topic("binding", "skip_binding") == Session.COPY.skip_binding, "E5-11 optional binding conserves rewards")
	for file in ["veil_point_6_captured", "original_defeat"]:
		original(file)
		check(topic("binding", "binding").is_empty() and topic("battle", "resume").is_empty(), "no pending/capture promises on terminal state")
	# All original fixtures remain read-only and never opt into a first session.
	for folder in ["preview32", "e2", "preview38"]:
		for file in DirAccess.get_files_at("res://tests/fixtures/" + folder):
			if not file.ends_with(".json"): continue
			var bytes := FileAccess.get_file_as_string("res://tests/fixtures/" + folder + "/" + file)
			clean()
			var handle := FileAccess.open(PATH, FileAccess.WRITE)
			handle.store_string(bytes)
			handle.close()
			var loaded: Dictionary = app.storage.load_profile()
			check(app.storage.last_error.is_empty() and Store.valid(loaded), "legacy accepted " + folder + "/" + file)
			check(not loaded.has("first_session"), "no forced help " + folder + "/" + file)
			check(FileAccess.get_file_as_string(PATH) == bytes, "loading preserves original bytes " + file)
			app.profile = loaded
			var snapshot: Dictionary = app.profile.duplicate(true)
			for context in ["map", "entry", "exploration", "battle", "experience", "binding", "defeat"]: Session.topics(app.profile, context)
			check(app.profile == snapshot, "help evaluation read-only on " + file)
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	var render := "--allow-ui-review" in OS.get_cmdline_user_args()
	if render: DirAccess.make_dir_recursive_absolute("res://build/e5-ui")
	for large in [false, true]:
		for screen in [["jade_point_6_map", "jade_play", ""], ["jade_point_6_battle", "battle", ""], ["original_replacement", "battle", ""], ["original_defeat", "battle", ""], ["veil_point_6_victory", "battle", "experience"], ["veil_point_6_choice", "battle", "binding"]]:
			original(screen[0])
			app.profile.first_session = Session.fresh()
			app.profile.settings.large_text = large
			app.profile.settings.reduced_motion = true
			if not screen[2].is_empty(): app.profile.campaign.aftermath = {"encounter_id": app.profile.campaign.encounter.id, "step": screen[2]}
			main._show(screen[1])
			await process_frame
			await process_frame
			var help := strip()
			check(help != null, "help available in " + screen[0])
			if help != null:
				before = app.profile.duplicate(true)
				help.open_help()
				await process_frame
				check(help.card.visible, "manual help opens")
				check(app.profile == before, "opening help never writes")
				bounds(main)
				if render:
					await RenderingServer.frame_post_draw
					root.get_texture().get_image().save_png("res://build/e5-ui/%s-%s.png" % [screen[0], "large" if large else "normal"])
				main._back()
				check(help.index == -1 and main.page == screen[1], "Android Back dismisses card before leaving")
	# Exercise entry, search and optional menus through the real UI.
	original("jade_point_6_map")
	app.profile.first_session = Session.fresh()
	main._show("jade_play")
	await process_frame
	await process_frame
	var trial: Node = main.get_node("Page").get_child(0).get_child(1)
	before = app.profile.duplicate(true)
	trial._location_details("jade_point_1")
	await process_frame
	await process_frame
	var entry_help: Node = trial.get_node("LocationDetails").find_child("ContextHelp", true, false)
	check(entry_help != null and entry_help.index >= 0, "E5-02 real entry has contextual automatic card")
	check(app.profile == before, "entry help does not spend stamina")
	var shown := 0
	for candidate in get_nodes_in_group("context_help"):
		if candidate.card != null and candidate.card.is_visible_in_tree(): shown += 1
	check(shown == 1, "only one card across popup and underlying map")
	trial._dismiss("LocationDetails")
	original("jade_point_1_map")
	app.profile.first_session = Session.fresh()
	check(app.start_route("jade_point_1"), "new entry succeeds unchanged")
	var paid: Dictionary = app.profile.duplicate(true)
	main._show("exploration")
	await process_frame
	await process_frame
	check(strip().entries[0].id == "search", "E5-03 actual search screen has guidance")
	check(app.start_route("jade_point_1") and app.profile == paid, "help and resume never repeat entry spend")
	check(app.discover_location(app.profile.campaign.encounter.id), "search continues with help present")
	main._show("battle")
	await process_frame
	await process_frame
	trial = main.get_node("Page").get_child(0).get_child(1)
	before = app.profile.duplicate(true)
	trial._trainer_menu()
	await process_frame
	var trainer_help: Node = trial.get_node("TrainerMenu").find_child("ContextHelp", true, false)
	check(trainer_help.entries[0].id == "trainer" and app.profile == before, "E5-06 actual optional trainer menu read-only")
	trial._dismiss("TrainerMenu")
	trial._team_menu()
	await process_frame
	var team_help: Node = trial.get_node("TeamMenu").find_child("ContextHelp", true, false)
	check(team_help.entries[0].id == "team" and app.profile == before, "E5-07 actual voluntary team menu read-only")
	trial._dismiss("TeamMenu")
	# No contextual card overlays a progression animation, pending attack or binding.
	original("veil_point_6_victory")
	app.profile.first_session = Session.fresh()
	app.profile.settings.reduced_motion = false
	app.profile.campaign.aftermath = {"encounter_id": app.profile.campaign.encounter.id, "step": "experience"}
	main._show("battle")
	await process_frame
	await process_frame
	var xp_help := strip()
	check(xp_help.index == -1 and not xp_help.card.visible, "XP animation has no help overlay")
	trial = main.get_node("Page").get_child(0).get_child(1)
	trial.aftermath_screen.elapsed = 4.0
	xp_help._process(0)
	check(xp_help.card.visible, "XP help deferred until animation completes")
	trial.combat_busy = true
	xp_help._process(0)
	check(not xp_help.card.visible, "attack transition hides card")
	trial.combat_busy = false
	trial.binding_busy = true
	xp_help._process(0)
	check(not xp_help.card.visible, "binding transition hides card")
	trial.binding_busy = false
	original("original_pending_true")
	app.profile.first_session = Session.fresh()
	main._show("battle")
	await process_frame
	await process_frame
	check(strip().index == -1, "pending enemy response never covered by automatic help")
	# Pause/resume only hides a card; it does not advance or repeat gameplay.
	original("jade_point_6_battle")
	app.profile.first_session = Session.fresh()
	main._show("battle")
	await process_frame
	await process_frame
	var help := strip()
	help.open_help()
	before = app.profile.duplicate(true)
	app._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	help._process(0)
	check(not help.card.visible, "pause hides help")
	app._notification(Node.NOTIFICATION_APPLICATION_RESUMED)
	help._process(0)
	check(help.card.visible and app.profile == before, "resume restores card without changing encounter")
	app.storage = Store.new("user://missing-e5-directory/profile.json")
	before = app.profile.duplicate(true)
	help.dismiss()
	check(app.profile == before and help.card.visible, "failed tutorial save preserves progress and card")
	main.free()
	clean()
	print("FIRST SESSION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
