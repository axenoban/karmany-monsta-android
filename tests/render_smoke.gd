extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var app := root.get_node("App")
	app.profile = SaveStore.defaults()
	app.profile.journey.started = true
	app.load_failed = false
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	await process_frame
	DirAccess.make_dir_recursive_absolute("res://build/screenshots")
	main.selected_species = "tanugami"
	for page in ["home", "map", "book", "settings", "diagnostics", "bestiary", "species", "trainers", "skill_tree", "loadout", "tree_lab"]:
		main._show(page)
		await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		if image.is_empty() or image.save_png("res://build/screenshots/%s.png" % page) != OK:
			push_error("Could not render " + page)
			quit(1)
			return
	app.profile.settings.large_text = true
	main._show("settings")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/screenshots/settings-large.png")
	app.profile.skill_tree.level = 5
	app.profile.skill_tree.ranks = {"curacion": 1, "proteccion": 1, "propia": 1, "potenciacion": 1, "control": 1}
	app.profile.skill_tree.equipped = ["curacion", "proteccion", "propia", "potenciacion"]
	main.selected_tree_node = "control"
	for page in ["skill_tree", "loadout"]:
		main._show(page)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/screenshots/%s-full-large.png" % page)
	app.profile = SaveStore.defaults()
	for page in ["intro", "jade_play"]:
		main._show(page)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/screenshots/%s.png" % page)
	app.profile.skill_tree.level = 5
	app.profile.skill_tree.ranks = {"curacion": 1, "proteccion": 1, "propia": 1, "potenciacion": 1}
	app.profile.skill_tree.equipped = ["curacion", "proteccion", "propia", "potenciacion"]
	app.start_trial()
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("battle")
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/screenshots/battle%s.png" % ("-large" if large else ""))
	app.trial_action("karmany", "golpe")
	app.trial_action("trainer", "proteccion")
	app.trial_action("end")
	main._show("battle")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/screenshots/battle-last-action.png")
	while app.profile.campaign.encounter.phase == "battle":
		var encounter := TrialEncounter.new()
		encounter.restore(app.profile.campaign.encounter)
		if encounter._turn().available("karmany"):
			app.trial_action("karmany", "insignia" if encounter.reason("karmany", "insignia").is_empty() else "golpe")
		else: app.trial_action("end")
	main._show("battle")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/screenshots/capture.png")
	app.profile.campaign.encounter.rolls = [0.1, 0.1, 0.1]
	app.trial_action("capture")
	for page in ["battle", "collection"]:
		main._show(page)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/screenshots/%s-result.png" % page)
	main.queue_free()
	await process_frame
	print("Rendered UI screens")
	quit(0)
