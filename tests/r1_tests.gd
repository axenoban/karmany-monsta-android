extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const PATH := "user://r1-tests.json"
var checks := 0
var failures := 0
var app: Node
var main: Node
func _initialize(): call_deferred("run")
func check(value: bool, message: String):
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL R1: " + message)
func clean():
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]:
		if FileAccess.file_exists(PATH + suffix) or DirAccess.dir_exists_absolute(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
func text_of(node: Node) -> String:
	var result := str(node.text) + "\n" if node is Label or node is Button else ""
	for child in node.get_children(): result += text_of(child)
	return result
func touch(map: Control, pressed: bool, at: Vector2):
	var event := InputEventScreenTouch.new()
	event.index = 0; event.pressed = pressed
	event.position = map.get_global_transform_with_canvas() * at
	map._input(event)
func drag(map: Control, at: Vector2):
	var event := InputEventScreenDrag.new()
	event.index = 0; event.position = map.get_global_transform_with_canvas() * at
	map._input(event)
func frames():
	await process_frame
	await process_frame
func capture(name: String):
	await frames()
	if "--allow-ui-review" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		DirAccess.make_dir_recursive_absolute("res://build/r1-review")
		root.get_texture().get_image().save_png("res://build/r1-review/" + name + ".png")
func run():
	root.size = Vector2i(1280,720)
	app = root.get_node("App")
	app.storage = Store.new(PATH); app.load_failed = false
	clean()
	app.profile = Store.defaults()
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	check(not app.profile.has("r1_intro"), "old default has no automatic intro")
	for status in ["completed", "skipped"]:
		main._start()
		await frames()
		check(main.page == "prologue" and app.profile.r1_intro.status == "pending", "new journey offers prologue")
		var before: Dictionary = app.profile.duplicate(true)
		if status == "completed":
			for i in range(4): main.prologue.advance()
			check(main.prologue.index == 4, "five manual panels")
			main.prologue.advance()
		else: main.prologue.finish("skipped")
		check(main.page == "map", "both exits reach same regions")
		check(app.profile.r1_intro.status == status and app.profile.campaign.intro_seen, "transaction saves acknowledgment")
		before.r1_intro.status = status; before.campaign.intro_seen = true
		check(app.profile == before, "intro never changes game economy/E5")
		app.profile = app.storage.load_profile()
		main._continue_adventure()
		check(main.page == "map", "completed intro survives reload")
	# Optional field validation.
	for invalid in [null, {}, {"version":2,"status":"pending"}, {"version":1,"status":"other"}]:
		var bad: Dictionary = app.profile.duplicate(true); bad.r1_intro = invalid
		check(not Store.valid(bad), "malformed optional marker rejected")
	# Exact read-only legacy loads from all archived original engines.
	for folder in ["preview32", "e2", "preview38", "preview40"]:
		var path: String = "res://tests/fixtures/" + folder
		if not DirAccess.dir_exists_absolute(path):
			check(false, "fixture folder exists " + folder); continue
		for file in DirAccess.get_files_at(path):
			if not file.ends_with(".json"): continue
			var raw := FileAccess.get_file_as_string(path + "/" + file)
			if not JSON.parse_string(raw) is Dictionary: continue
			# Fixture manifest is not a saved profile.
			if not JSON.parse_string(raw).has("schema"): continue
			var handle := FileAccess.open(PATH, FileAccess.WRITE); handle.store_string(raw); handle.close()
			app.profile = app.storage.load_profile()
			check(app.storage.last_error.is_empty(), "legacy load " + folder + file)
			check(not app.profile.has("r1_intro"), "legacy has no opt-in")
			check(FileAccess.get_file_as_string(PATH) == raw, "load preserves legacy bytes")
	# Preview40 UX state and read-only replay.
	app.profile = Store.defaults(); app.profile.journey.started = true
	app.profile.first_session = {"version":1,"seen":["map"]}
	check(app.storage.save_profile(app.profile), "Preview40 compatible save")
	var before: Dictionary = app.profile.duplicate(true)
	var disk := FileAccess.get_file_as_string(PATH)
	main.intro_replay = true; main._show("prologue")
	await frames()
	main.prologue.advance(); main._back(); main._back()
	check(main.page == "settings" and app.profile == before, "replay/back no progress or E5 write")
	check(FileAccess.get_file_as_string(PATH) == disk, "replay leaves exact bytes")
	# Interrupted pending prologue resumes; failed acknowledgment is nonblocking.
	main._start(); await frames()
	app.profile = app.storage.load_profile()
	main._continue_adventure()
	check(main.page == "prologue", "pending resumes after reload")
	before = app.profile.duplicate(true); disk = FileAccess.get_file_as_string(PATH)
	var backup := FileAccess.get_file_as_string(PATH + ".bak")
	DirAccess.make_dir_absolute(PATH + ".tmp")
	main.prologue.finish("skipped")
	check(main.page == "map" and not main.toast.text.is_empty(), "failed save exits with visible warning")
	check(app.profile == before and FileAccess.get_file_as_string(PATH) == disk and FileAccess.get_file_as_string(PATH + ".bak") == backup, "failed intro preserves memory primary backup")
	main._continue_adventure()
	check(main.page == "map", "failed save does not loop in session")
	DirAccess.remove_absolute(PATH + ".tmp")
	# Resume actual encounters without entering/charging again.
	for file in ["jade_point_6_battle", "veil_point_6_choice"]:
		app.profile = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview38/" + file + ".json"))
		app.response_timer.stop(); app.pending_transition = {}
		before = app.profile.duplicate(true)
		main._continue_adventure()
		check(main.page == "battle" and app.profile == before, "resume frozen encounter unchanged " + file)
	app.profile = Store.defaults(); app.profile.journey.started = true
	before = app.profile.duplicate(true)
	main._open_region("jade", false)
	check(main.page == "jade_play" and app.profile.campaign.exploration == before.campaign.exploration, "opening region costs no stamina")
	main._show("map")
	check(not text_of(main.body).contains("Visitar") and not text_of(main.body).contains("Entrar al valle jugable"), "duplicate navigation removed")
	check(preload("res://scripts/jade_route.gd").points("jade").size() == 6 and preload("res://scripts/jade_route.gd").points("veil").size() == 6, "both complete routes")
	check(not preload("res://scripts/progression_rules.gd").region_reason(app.profile.skill_tree,"veil").is_empty(), "forest retains gate")
	check(main.catalog.all_entries().size() == 21 and main.catalog.find_species("zephyr").is_empty(), "21 canonical entries without starter")
	for entry in main.catalog.all_entries():
		main.selected_species = entry.id; main._show("species")
		check(text_of(main.body).contains("Vincula esta especie") and not text_of(main.body).contains("Base Nv."), "unowned silhouette hides stats")
		var art = main._portrait(entry.id); art.free()
	app.profile.skill_tree.captured_species = ["tanugami"]
	check(not main._species_owned("tanugami"), "tree simulation not collection")
	app.profile.campaign.collection = [{"species":"tanugami"}, {"species":"tanugami"}]
	check(main._species_owned("tanugami") and main.catalog.all_entries().size() == 21, "duplicate capture one species")
	main.selected_species = "tanugami"; main._show("species")
	check(text_of(main.body).contains("Base Nv. 1"), "owned real base stats")
	app.profile.campaign.collection = [{"species":"kirinari"}]
	# All missing-art/missing-stat canonical entries can open safely.
	for entry in main.catalog.all_entries():
		app.profile.campaign.collection = [{"species":entry.id}]
		main.selected_species = entry.id; main._show("species")
		check(text_of(main.body).contains("Base Nv. 1") or text_of(main.body).contains("Datos de combate aún no disponibles"), "truthful stats availability")
	app.profile = Store.defaults(); app.profile.journey.started = true
	main._show("trainers")
	check(text_of(main.body).contains("Ezel") and text_of(main.body).contains("Zephyr") and not text_of(main.body).contains("Axe"), "real protagonist and starter")
	# Profile uses each real instance's progression, even duplicate species.
	app.profile = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview38/jade_point_6_battle.json"))
	app.profile.campaign.encounter = {}
	var owned: Array = preload("res://scripts/trial_roster.gd").owned(app.profile.campaign)
	for count in [1,2,3]:
		app.profile.campaign.team.members = owned.slice(0,count)
		app.profile.campaign.team.active_id = owned[0].instance_id
		main._show("trainers")
		for member in app.profile.campaign.team.members:
			check(text_of(main.body).contains(preload("res://scripts/level_progression.gd").summary(app.profile.campaign,member.instance_id)), "profile all real team levels")
	app.profile = Store.defaults(); app.profile.journey.started = true
	# Actual ScreenTouch/ScreenDrag dispatch, all starting surfaces, no purchases.
	for large in [false,true]:
		app.profile.settings.large_text = large
		main._show("skill_tree"); await frames()
		var map: Control = main.body.get_child(3)
		check(map.has_signal("pan_changed"), "tree map available")
		before = app.profile.duplicate(true)
		var selected := [0]
		map.node_selected.connect(func(_id): selected[0] += 1)
		for i in range(20):
			map.pan = Vector2(-100,-100); map._place_buttons()
			var at := Vector2(20,20)
			if i % 3 == 0: at = map._buttons.curacion.position + Vector2(50,50)
			elif i % 3 == 1: at = Vector2(400,210)
			touch(map,true,at); drag(map,at + Vector2(-60,-50)); touch(map,false,at + Vector2(-60,-50))
			check(map.pan == Vector2(-160,-150), "touch drag pans from all surfaces")
		check(selected[0] == 0 and app.profile == before, "20 drags neither select nor spend")
		map.pan = Vector2.ZERO; map._place_buttons()
		var at: Vector2 = map._buttons.curacion.position + Vector2(60,50)
		touch(map,true,at); touch(map,false,at + Vector2(1,1))
		check(selected[0] == 1, "short tap selects")
		await frames()
		check(main.tree_pan == Vector2.ZERO, "selection preserves map offset")
	# Mouse shares the same gesture owner, cancel never selects, outer clipping respected.
	main._show("skill_tree"); await frames()
	var mouse_map: Control = main.body.get_child(3)
	var press := InputEventMouseButton.new(); press.button_index = MOUSE_BUTTON_LEFT; press.pressed = true
	press.position = mouse_map.get_global_transform_with_canvas() * Vector2(50,50)
	mouse_map._input(press)
	var motion := InputEventMouseMotion.new(); motion.position = press.position + Vector2(-65,-65)
	mouse_map._input(motion)
	press.pressed = false; press.position = motion.position; mouse_map._input(press)
	check(mouse_map._dragged, "mouse drag pans without selection")
	var cancel := InputEventScreenTouch.new(); cancel.canceled = true
	mouse_map._input(cancel)
	check(not mouse_map._pointer_down, "OS canceled touch releases gesture")
	# Render normal/large, narrow layout, each cinematic panel and key screens.
	for large in [false,true]:
		app.profile = Store.defaults(); app.profile.journey.started = true
		app.profile.settings.large_text = large; app.profile.settings.reduced_motion = true
		for page in ["home","map","bestiary","trainers","skill_tree"]:
			main._show(page); await capture(page + ("-large" if large else ""))
		main.intro_replay = true; main._show("prologue"); await frames()
		for i in range(5):
			await capture("prologue-%d-%s" % [i,str(large)])
			if i < 4: main.prologue.advance()
	root.size = Vector2i(960,540)
	for page in ["home","map","bestiary","trainers","skill_tree","prologue"]:
		main._show(page); await capture(page + "-small-large")
	main.free(); clean()
	print("R1: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
