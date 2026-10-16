extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const Session = preload("res://scripts/first_session.gd")
const PATH := "user://help-persistence-tests.json"
var checks := 0
var failures := 0
var app: Node
var main: Node
func _initialize(): call_deferred("run")
func check(value: bool, text: String):
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL HELP PERSISTENCE: " + text)
func clean():
	for suffix in ["", ".bak", ".tmp", ".bak-preserved"]:
		var path: String = PATH + suffix
		if FileAccess.file_exists(path) or DirAccess.dir_exists_absolute(path): DirAccess.remove_absolute(path)
func button(node: Node, caption: String) -> Button:
	if node is Button and node.text == caption: return node
	for child in node.get_children():
		var found := button(child, caption)
		if found != null: return found
	return null
func help_node() -> Node:
	for node in get_nodes_in_group("context_help"):
		if node.is_visible_in_tree() and not node.entries.is_empty(): return node
	return null
func prepare(with_tutorial: bool = true):
	clean()
	app.storage = Store.new(PATH)
	app.profile = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview38/veil_point_6_choice.json"))
	if with_tutorial: app.profile.first_session = Session.fresh()
	app.profile.settings.large_text = true
	app.profile.settings.reduced_motion = true
	app.profile.settings.sound = false
	app.load_failed = false
	app.notice = ""
	app.pending_transition = {}
	app.response_timer.stop()
	check(app.storage.save_profile(app.profile), "isolated profile and backup prepared")
	app.profile = app.storage.load_profile()
	main._show("battle")
func block(mode: String):
	if mode == "destination":
		app.storage = Store.new("user://missing-help-persistence-directory/profile.json")
	else:
		check(DirAccess.make_dir_absolute(PATH + ".tmp") == OK, "test blocks temporary save")
func unblock(mode: String):
	if mode == "destination": app.storage = Store.new(PATH)
	else: DirAccess.remove_absolute(PATH + ".tmp")
func run():
	root.size = Vector2i(1280, 720)
	app = root.get_node("App")
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for mode in ["temporary", "destination"]:
		for operation in ["close", "back", "next"]:
			prepare()
			await process_frame
			await process_frame
			var help := help_node()
			check(help != null and help.index >= 0, "automatic card visible")
			var id: String = help.entries[help.index].id
			var before: Dictionary = app.profile.duplicate(true)
			var primary := FileAccess.get_file_as_string(PATH)
			var backup := FileAccess.get_file_as_string(PATH + ".bak")
			block(mode)
			if operation == "back": main._back()
			else: button(help, "Cerrar ayuda" if operation == "close" else "Otra explicación").pressed.emit()
			check(app.profile == before, "failed acknowledgement leaves entire profile unchanged: " + operation)
			check(FileAccess.get_file_as_string(PATH) == primary, "primary bytes untouched on failed write")
			check(FileAccess.get_file_as_string(PATH + ".bak") == backup, "prior backup bytes preserved")
			check(Session.automatic(app.profile, id), "unsaved topic stays unseen")
			check(help.save_warning.visible and not help.save_warning.text.is_empty(), "storage error remains visible without modal")
			if operation == "next":
				check(help.index >= 0 and help.entries[help.index].id != id, "next explanation works despite save failure")
				button(help, "Cerrar ayuda").pressed.emit()
			else: check(help.index == -1 and not help.card.visible, "close/back always dismisses on save failure")
			for i in range(3): await process_frame
			if mode == "temporary" and operation == "close":
				var trial: Node = main.get_node("Page").get_child(0).get_child(1)
				for control in [help.help_button, button(trial, "Abrir el Libro"), button(trial, "Dejarlo partir")]:
					if control != null:
						var rect: Rect2 = control.get_global_rect()
						check(rect.position.x >= 0 and rect.end.x <= 1280 and rect.position.y >= 0 and rect.end.y <= 720, "save warning never clips real controls with large text")
				if "--allow-ui-review" in OS.get_cmdline_user_args():
					DirAccess.make_dir_recursive_absolute("res://build/e5-ui")
					await RenderingServer.frame_post_draw
					root.get_texture().get_image().save_png("res://build/e5-ui/help-save-failure-large.png")
			check(help.index == -1 and not help.card.visible, "no automatic reopen loop after failure")
			main._back()
			check(main.page == "jade_play" and app.profile == before, "second Android Back returns to map without writing or losing encounter")
			unblock(mode)
			app.profile = app.storage.load_profile()
			check(app.profile == before and Session.automatic(app.profile, id), "restart retains exact game state and unsaved topic")
			main._show("battle")
			await process_frame
			await process_frame
			help = help_node()
			check(help.entries[help.index].id == id, "unsaved explanation can be offered again")
			button(help, "Cerrar ayuda").pressed.emit()
			check(help.index == -1 and not help.save_warning.visible, "successful retry closes normally")
			var loaded: Dictionary = app.storage.load_profile()
			check(not Session.automatic(loaded, id), "successful retry acknowledgement persists after restart")
			loaded.erase("first_session")
			before.erase("first_session")
			check(loaded == before, "retry changes tutorial only, never XP/reward/capture/team")
	# A deferred callback must not reopen another topic after a synchronous dismissal.
	prepare()
	var early := help_node()
	early.open_help()
	button(early, "Cerrar ayuda").pressed.emit()
	for i in range(3): await process_frame
	check(early.index == -1 and not early.card.visible, "deferred automatic offer cannot undo close")
	# Legacy help is read-only even if saving would fail.
	prepare(false)
	await process_frame
	await process_frame
	var legacy := help_node()
	check(legacy.index == -1, "legacy profile still has no automatic card")
	var bytes := FileAccess.get_file_as_string(PATH)
	var before: Dictionary = app.profile.duplicate(true)
	block("temporary")
	button(legacy, "Ayuda").pressed.emit()
	button(legacy, "Cerrar ayuda").pressed.emit()
	check(legacy.index == -1 and not legacy.save_warning.visible, "manual legacy close never attempts optional save")
	check(app.profile == before and FileAccess.get_file_as_string(PATH) == bytes, "legacy profile and bytes unchanged")
	unblock("temporary")
	main.free()
	clean()
	print("HELP PERSISTENCE: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
