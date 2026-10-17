extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const Preset = preload("res://scripts/qa_profile.gd")
const QAStore = preload("res://scripts/qa_store.gd")
const History = preload("res://scripts/navigation_history.gd")
const Route = preload("res://scripts/jade_route.gd")
const PATH := "user://r11-primary.json"
var app: Node
var main: Node
var checks := 0
var failures := 0
var saved_bytes := {}
func _initialize(): call_deferred("run")
func check(value: bool, message: String):
	checks += 1
	if not value:
		failures += 1
		push_error("R11 FAIL: " + message)
func intact():
	for path in saved_bytes:
		if saved_bytes[path] == null: check(not FileAccess.file_exists(path), "primary absence unchanged: " + path)
		else: check(FileAccess.get_file_as_bytes(path) == saved_bytes[path], "primary bytes unchanged: " + path)
func run():
	app = root.get_node("App")
	app.storage = Store.new(PATH); app.load_failed = false
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]:
		var file := FileAccess.open(PATH + suffix, FileAccess.WRITE)
		file.store_string(JSON.stringify(Store.defaults())); file.close()
		saved_bytes[PATH + suffix] = FileAccess.get_file_as_bytes(PATH + suffix)
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]:
		var path: String = "user://profile.json" + suffix
		saved_bytes[path] = FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else null
	app.profile = app.storage.load_profile()
	ProjectSettings.set_setting("karmany/qa/development", false)
	check(not app.qa_available() and not app.enter_qa(), "production entry disabled")
	check(not app.apply_qa(Store.defaults()) and not app.change_tree("level") and not app.change_tree("capture", "tanugami"), "production mutators disabled")
	intact()
	ProjectSettings.set_setting("karmany/qa/development", true)
	check(app.enter_qa(), "enter isolated QA")
	check(app.qa_active and app.storage.base_path == QAStore.PATH, "separate QA store")
	var safe_store: RefCounted = app.storage
	app.storage = Store.new(PATH)
	check(not app.commit_profile(Store.defaults()), "wrong store rejected before any write")
	app.storage = safe_store
	safe_store.base_path = PATH
	check(not safe_store.save_profile(Store.defaults()), "QA store cannot be redirected")
	safe_store.base_path = QAStore.PATH
	intact()
	for level in [1,5,10,15]:
		for amount in [1,2,3]:
			var members := [{"species":"zephyr", "level":level}]
			for i in range(amount - 1): members.append({"species":"tanugami","level":level})
			var candidate := Preset.preset(level, 50, members, amount-1, "jade", 1, 100)
			check(not candidate.is_empty() and Store.valid(candidate), "valid levels/team/duplicate owned instances")
			check(app.apply_qa(candidate), "apply preset")
	for id in Preset.species():
		var candidate := Preset.preset(15,0,[{"species":id,"level":15}],0,"jade",1,100)
		check(not candidate.is_empty(), "combat species " + id)
	for region in ["jade", "veil"]:
		for point in range(1,7):
			check(app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":10}],0,region,point,100)), "prepare direct stage")
			check(app.start_route(Route.points(region)[point-1].id), "launch direct " + region + str(point))
			check(Store.valid(app.profile), "stage respects strict validators")
			if point == 6: check(app.profile.campaign.encounter.regional.enemies.size() == 2, "two-enemy final")
	check(app.apply_qa(Preset.preset(1,0,[{"species":"zephyr","level":1}],0,"jade",1,0)), "zero stamina fixture")
	check(not app.start_route(Route.points()[0].id), "zero stamina still blocks normal cost")
	intact()
	# Win and defeat use the unchanged engine, rewards and persistence.
	for unit_level in [1,15]:
		var region: String = "veil" if unit_level == 1 else "jade"
		var point: int = 6 if unit_level == 1 else 1
		check(app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":unit_level}],0,region,point,100)), "prepare combat isolation")
		check(app.start_route(Route.points(region)[point-1].id), "start QA victory/defeat scenario")
		check(app.discover_location(app.profile.campaign.encounter.id), "discover QA encounter")
		var turns := 0
		while app.profile.campaign.encounter.phase == "battle" and turns < 300:
			var state: Dictionary = app.profile.campaign.encounter
			check(app.trial_action("enemy" if state.enemy_pending else "karmany", "" if state.enemy_pending else "golpe"), "QA combat action")
			app.response_timer.stop()
			turns += 1
		check(turns < 300 and app.profile.campaign.encounter.phase in ["capture","defeat"], "QA fight terminates")
		check(app.profile.campaign.encounter.phase == ("defeat" if unit_level == 1 else "capture"), "explicit defeat and victory paths")
		var receipt: Dictionary = app.profile.campaign.progression.duplicate(true)
		if app.profile.campaign.encounter.phase == "capture":
			app.profile.campaign.encounter.rolls = [0.0,0.0,0.0]
			check(app.trial_action("capture") and app.profile.campaign.encounter.phase == "captured", "deterministic QA capture succeeds")
			var after: Dictionary = app.profile.duplicate(true)
			check(not app.trial_action("capture") and app.profile == after, "QA capture/reward only once")
		check(app.profile.campaign.progression.trainer_xp == receipt.trainer_xp and app.profile.campaign.progression.last_reward == receipt.last_reward, "capture does not duplicate trainer XP or reward receipt")
		for id in receipt.units: check(app.profile.campaign.progression.units[id] == receipt.units[id], "capture does not duplicate existing unit XP")
		intact()
	# A timer from the old context cannot target the next synthetic encounter.
	check(app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":10}],0,"jade",1,100)), "timer fixture")
	app.start_route(Route.points()[0].id); app.discover_location(app.profile.campaign.encounter.id)
	app.trial_action("karmany","golpe")
	var old_timer: Timer = app.response_timer
	check(app.enter_qa() == false, "no nested QA session")
	check(app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":10}],0,"jade",1,100)), "replace pending QA profile")
	var no_callback: Dictionary = app.profile.duplicate(true)
	old_timer.timeout.emit()
	check(app.profile == no_callback, "stale timer generation rejected")
	intact()
	# Real UI chains, shared Android/button handler and immutable campaign.
	check(app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":10}],0,"jade",1,100)), "navigation fixture")
	main = load("res://scenes/main.tscn").instantiate(); root.add_child(main)
	for chain in [["jade_play","book"],["jade_play","team","collection"],["map","bestiary","species"],["jade_play","trainers","skill_tree"],["home","settings","diagnostics"]]:
		main.navigation.reset(); main._show(chain[0], false)
		var before: Dictionary = app.profile.campaign.duplicate(true)
		for i in range(1,chain.size()):
			if i == 1 and chain[0] == "jade_play":
				var trial = find_trial(main); check(trial != null, "real TrialUI origin")
				trial.navigate.emit(chain[i])
			else:
				if chain[i] == "species": main.selected_species = "zephyr"
				main._show(chain[i])
		for i in range(chain.size()-2,-1,-1):
			if i % 2 == 0: main._notification(Node.NOTIFICATION_WM_GO_BACK_REQUEST)
			else: main._back()
			check(main.page == chain[i], "contextual Back " + str(chain))
		check(app.profile.campaign == before, "navigation preserves campaign")
	# Navigation never executes a combat action or consumes stamina again.
	app.apply_qa(Preset.preset(10,0,[{"species":"zephyr","level":10}],0,"jade",1,100))
	app.start_route(Route.points()[0].id); app.discover_location(app.profile.campaign.encounter.id)
	app.trial_action("karmany","golpe"); app.response_timer.stop(); app.application_paused = true
	var encounter_before: Dictionary = app.profile.duplicate(true)
	main.navigation.reset(); main._show("battle",false)
	find_trial(main).navigate.emit("jade_play")
	find_trial(main).navigate.emit("battle")
	for i in range(20): main._refresh_combat()
	check(app.profile == encounter_before, "battle/map/resume and redraw preserve HP/revision/queue/XP/stamina")
	check(main.navigation.entries.size() <= 1, "battle/map return collapses cycles")
	main._show("settings"); var depth: int = main.navigation.entries.size()
	for i in range(20): main.refresh_current()
	check(main.navigation.entries.size() == depth, "redraw does not stack")
	var h := History.new()
	for i in range(100): h.visit("book" if i % 2 == 0 else "team", "settings")
	check(h.entries.size() <= History.LIMIT, "bounded history")
	var popup := ConfirmationDialog.new(); main.add_child(popup); popup.popup_centered()
	main._back(); check(not popup.visible and main.page == "settings", "modal closes before route")
	popup.queue_free()
	main.queue_free(); await process_frame
	# Preview42 fixtures are emitted by the exact approved 293ac5e engine.
	for file in DirAccess.get_files_at("res://tests/fixtures/preview42"):
		if not file.ends_with(".json"): continue
		var raw := FileAccess.get_file_as_string("res://tests/fixtures/preview42/" + file)
		var path := "user://r11-legacy.json"
		var handle := FileAccess.open(path,FileAccess.WRITE); handle.store_string(raw); handle.close()
		var legacy := Store.new(path)
		check(Store.valid(legacy.load_profile()) and legacy.last_error.is_empty(), "Preview42 loads " + file)
		check(FileAccess.get_file_as_string(path) == raw, "Preview42 read preserves bytes")
		DirAccess.remove_absolute(path)
	# Failure remains in QA; primary bytes unchanged even with corrupt QA and temp failure.
	var bad := FileAccess.open(QAStore.PATH, FileAccess.WRITE); bad.store_string("corrupt"); bad.close()
	var recovery := QAStore.new(); check(Store.valid(recovery.load_profile()) and recovery.recovered_backup, "QA backup recovery")
	DirAccess.remove_absolute(QAStore.PATH + ".tmp")
	DirAccess.make_dir_absolute(QAStore.PATH + ".tmp")
	check(not app.apply_qa(Preset.preset(1,0,[{"species":"zephyr","level":1}],0,"jade",1,100)), "temporary write failure")
	DirAccess.remove_absolute(QAStore.PATH + ".tmp")
	intact()
	var real_store: RefCounted = app.normal_storage
	var corrupt := FileAccess.open("user://r11-corrupt.json",FileAccess.WRITE); corrupt.store_string("bad"); corrupt.close()
	app.normal_storage = Store.new("user://r11-corrupt.json")
	check(not app.exit_qa() and app.qa_active, "failed real reload stays safely in QA")
	app.normal_storage = real_store
	DirAccess.remove_absolute("user://r11-corrupt.json")
	var restarted = load("res://scripts/app.gd").new()
	restarted.storage = Store.new(PATH); root.add_child(restarted)
	check(not restarted.qa_active and restarted.profile == Store.defaults(), "restarted app loads normal profile by default")
	restarted.queue_free()
	var leaving_timer: Timer = app.response_timer
	check(app.exit_qa() and not app.qa_active and app.profile == Store.defaults(), "exit reloads exact normal profile")
	intact()
	leaving_timer.timeout.emit()
	check(app.profile == Store.defaults(), "old QA timeout cannot affect restored real profile")
	check(app.storage.base_path == PATH, "normal storage restored")
	DirAccess.make_dir_absolute(QAStore.PATH + ".tmp")
	check(not app.enter_qa() and not app.qa_active and app.storage.base_path == PATH, "failed QA creation cannot partially activate")
	DirAccess.remove_absolute(QAStore.PATH + ".tmp")
	intact()
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]: DirAccess.remove_absolute(PATH + suffix)
	for suffix in ["", ".bak", ".tmp", ".pre-unification"]: DirAccess.remove_absolute(QAStore.PATH + suffix)
	print("R11: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
func find_trial(node: Node) -> Node:
	if node.get_script() != null and node.get_script().resource_path == "res://scripts/trial_ui.gd": return node
	for child in node.get_children():
		var result := find_trial(child)
		if result != null: return result
	return null
