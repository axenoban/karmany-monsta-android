extends SceneTree

const Hotspots = preload("res://scripts/location_hotspots.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Locations = preload("res://scripts/location_visuals.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, caption: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("JADE HOTSPOTS: " + caption)

func frames() -> void:
	for i in range(3):
		await process_frame

func run() -> void:
	var info: Dictionary = Locations.details("jade_point_1")
	var scene := Hotspots.new()
	scene.setup(Stage.texture(info.background), info)
	root.add_child(scene)
	var inspections: Array[String] = []
	var searches := 0
	scene.inspected.connect(func(text: String): inspections.append(text))
	scene.encounter_requested.connect(func(): searches += 1)

	for dimensions in [Vector2i(1280, 720), Vector2i(960, 540)]:
		root.size = dimensions
		scene.size = Vector2(dimensions.x - 100, 245)
		scene.position = Vector2(50, 70)
		await frames()
		for id in ["HotspotEnvironment", "HotspotTrail", "HotspotEncounter"]:
			var button := scene.get_node_or_null(id) as Button
			check(button != null, "missing touch hotspot: " + id)
			if button != null:
				var area := button.get_rect()
				check(area.position.x >= 0 and area.end.x <= scene.size.x, "hotspot fits width: " + id)
				check(area.position.y >= 0 and area.end.y <= scene.size.y, "hotspot fits height: " + id)
				check(button.focus_mode == Control.FOCUS_ALL and button.visible, "hotspot accessible: " + id)
		scene.get_node("HotspotEnvironment").pressed.emit()
		scene.get_node("HotspotTrail").pressed.emit()
		check(inspections.size() > 1 and inspections.back() == info.description, "inspection shows existing canonical description")

	scene.get_node("HotspotEncounter").pressed.emit()
	check(searches == 1, "single search signal without persistence")
	scene.queue_free()
	await frames()

	var app := root.get_node("App")
	ProjectSettings.set_setting("karmany/qa/development", true)
	check(app.enter_qa(), "isolated QA available")
	var main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	check(app.start_route("jade_point_1"), "pay existing entrance once")
	var after_entry: Dictionary = app.profile.duplicate(true)
	main._show("exploration")
	await frames()
	var habitat := main.find_child("HotspotEnvironment", true, false) as Button
	var search := main.find_child("HotspotEncounter", true, false) as Button
	var readout := main.find_child("LocationInspection", true, false) as Label
	check(habitat != null and search != null and readout != null, "prototype integrated in Jade point 1")
	if habitat != null:
		habitat.pressed.emit()
		check(readout.text.contains(info.environment), "touch reveals existing environment")
	check(app.profile == after_entry, "inspection does not touch scouting, stamina, encounter or rewards")
	var pending_id: String = str(app.profile.campaign.encounter.get("id", ""))
	if search != null:
		search.pressed.emit()
		await frames()
		check(main.page == "battle", "search enters existing combat")
		check(app.profile.campaign.encounter.get("id", "") == pending_id, "search retains encounter identity")
		check(int(app.profile.campaign.exploration.stamina) == int(after_entry.campaign.exploration.stamina), "search does not charge entrance twice")
	app.response_timer.stop()
	main.queue_free()
	await frames()
	check(app.exit_qa(), "normal profile restored without QA leakage")
	print("JADE HOTSPOTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
