extends SceneTree
var app: Node
var main: Node
var checks := 0
var failures := 0
var render := "--allow-ui-review" in OS.get_cmdline_user_args()
func _initialize(): call_deferred("run")
func check(value: bool, description: String):
	checks += 1
	if not value:
		failures += 1
		push_error("JADE: " + description)
func frames():
	for i in range(4): await process_frame
func button(node: Node, caption: String) -> Button:
	if node is Button and node.text == caption: return node
	for child in node.get_children():
		var found := button(child, caption)
		if found: return found
	return null
func shot(id: String):
	await frames()
	if render:
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/jade-review/" + id + ".png")
func run():
	DirAccess.make_dir_recursive_absolute("res://build/jade-review")
	app = root.get_node("App")
	ProjectSettings.set_setting("karmany/qa/development", true)
	check(app.enter_qa(), "isolated QA available")
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for large in [false,true]:
		app.set_preference("large_text",large)
		for dimensions in [Vector2i(1280,720),Vector2i(960,540)]:
			root.size = dimensions
			for page in ["home","map","book","bestiary","trainers","team","collection","settings","skill_tree"]:
				var before: Dictionary = app.profile.duplicate(true)
				main._show(page)
				await frames()
				check(app.profile == before, "view is read-only: " + page)
				check(main.body.size.x <= main.size.x - 40, "no horizontal overflow: %s %s large=%s" % [page,dimensions,large])
				if page == "team":
					var collection := button(main,"Añadir desde la colección")
					check(collection != null and collection.get_global_rect().end.y <= main.size.y, "team collection action stays on screen")
				if page == "map":
					var book := button(main,"Libro")
					check(book != null and book.get_global_rect().end.y <= main.size.y, "region navigation stays on screen")
					var art_frames := main.find_children("RegionArt", "Control", true, false)
					check(art_frames.size() == 2, "both region cards have scenic art")
					for region_art in art_frames:
						check(region_art.custom_minimum_size.y >= 110, "region image remains visible at %s large=%s" % [dimensions, large])
						var shade := region_art.get_node_or_null("RegionCaptionShade")
						check(shade != null and shade.mouse_filter == Control.MOUSE_FILTER_IGNORE, "region caption shade is noninteractive")
					if dimensions.x in [1280, 960]:
						var region_action := button(main, "Explorar región")
						var nav_top := INF
						for candidate in main.find_children("*", "GridContainer", true, false):
							var dock := candidate as GridContainer
							if dock != null and dock.columns == 3 and dock.get_child_count() == 6:
								nav_top = minf(nav_top, dock.global_position.y)
						check(nav_top < INF, "region navigation dock found")
						check(region_action != null and region_action.get_global_rect().end.y <= nav_top, "region main action stays visible above navigation dock")
				await shot("%s-%s-%s" % [page,dimensions.x,large])
	# Details and UI selection never consume combat turns or mutate progression.
	root.size = Vector2i(1280,720)
	main._show("jade_play")
	await shot("map-route")
	check(app.start_route("jade_point_1"), "enter first location")
	main._show("exploration")
	await shot("exploration")
	check(app.discover_location(app.profile.campaign.encounter.id), "discover")
	main._show("battle")
	await frames()
	var before: Dictionary = app.profile.duplicate(true)
	check(button(main, "Detalles") == null, "combat details are not a primary HUD control")
	var menu := button(main, "Menú")
	check(menu != null, "touch-readable combat menu directly available")
	if menu != null: menu.pressed.emit()
	var details := button(main, "Estado y técnicas")
	check(details != null, "details remain accessible in the combat menu")
	if details != null: details.pressed.emit()
	await shot("combat-details")
	check(app.profile == before, "opening details through menu never executes an action")
	main._back()
	check(main.page == "battle", "Back dismisses details before navigating")
	await shot("battle")
	main._show("settings")
	var sound := bool(app.profile.settings.sound)
	var toggle := button(main,"Efectos de sonido" + (" · Activado" if sound else " · Desactivado"))
	check(toggle != null,"custom sound control present")
	if toggle: toggle.pressed.emit()
	check(app.profile.settings.sound != sound,"sound toggle still persists through App")
	app.response_timer.stop()
	main.queue_free(); await frames()
	check(app.exit_qa(),"normal profile restored")
	print("JADE UI: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
