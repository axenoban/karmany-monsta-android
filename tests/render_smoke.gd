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
	for page in ["home", "map", "book", "settings", "diagnostics"]:
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
	main.queue_free()
	await process_frame
	print("Rendered UI screens")
	quit(0)
