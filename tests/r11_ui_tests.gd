extends SceneTree
var app: Node
var main: Node
var checks := 0
var failures := 0
func _initialize(): call_deferred("run")
func check(value: bool, message: String):
	checks += 1
	if not value:
		failures += 1; push_error("R11 UI: " + message)
func frames():
	await process_frame; await process_frame
func shot(name: String):
	await frames()
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://build/r11-review/" + name + ".png")
func run():
	DirAccess.make_dir_recursive_absolute("res://build/r11-review")
	root.size = Vector2i(1280,720)
	app = root.get_node("App")
	ProjectSettings.set_setting("karmany/qa/development",true)
	check(app.enter_qa(), "enter preview QA")
	main = load("res://scenes/main.tscn").instantiate(); root.add_child(main)
	for large in [false,true]:
		app.set_preference("large_text",large)
		main._show("tree_lab")
		await frames()
		var lab = main.body.get_child(main.body.get_child_count()-1)
		check(lab.has_method("candidate") and not lab.candidate().is_empty(), "lab controls generate valid preset")
		check(main.body.size.x <= 1200, "lab width bounded")
		await shot("lab-top-" + str(large))
		main.body.get_parent().scroll_vertical = 10000
		await shot("lab-bottom-" + str(large))
		lab.trainer.value = 10; lab.count.value = 3; lab.region.selected = 1; lab.point.value = 6
		lab.apply(true)
		await frames()
		check(main.page == "exploration", "UI launches Velo6")
		await shot("exploration-" + str(large))
		app.discover_location(app.profile.campaign.encounter.id)
		main._show("battle")
		await shot("battle-" + str(large))
		check(main.get_node("Page").get_rect().end.y <= 720, "QA page fits viewport")
		main._show("tree_lab")
		await frames()
		var returned = main.body.get_child(main.body.get_child_count()-1)
		check(returned.candidate() == app.qa_preset, "return to QA retains exact repeatable configuration")
	app.response_timer.stop()
	main.queue_free(); await process_frame
	await create_timer(0.8).timeout
	check(app.exit_qa(), "exit QA after UI")
	var report := FileAccess.open("res://build/r11-ui-result.json",FileAccess.WRITE)
	report.store_string(JSON.stringify({"checks":checks,"failures":failures})); report.close()
	print("R11 UI: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
