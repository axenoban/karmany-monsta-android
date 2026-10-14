extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const Visuals = preload("res://scripts/location_visuals.gd")
const Stage = preload("res://scripts/trial_stage.gd")
var checks := 0
var failures := 0
const PATH := "user://location-presentation-tests.json"
func _initialize() -> void: call_deferred("_run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func button(node: Node, prefix: String) -> Button:
	if node is Button and node.text.begins_with(prefix): return node
	for child in node.get_children():
		var found := button(child, prefix)
		if found != null: return found
	return null
func stage_in(node: Node) -> Control:
	if node.get_script() == Stage: return node
	for child in node.get_children():
		var found := stage_in(child)
		if found != null: return found
	return null
func _run() -> void:
	root.size = Vector2i(1280, 720)
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.load_failed = false
	var main: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.profile = Store.defaults()
		app.profile.settings.large_text = large
		main._show("jade_play")
		await process_frame
		await process_frame
		var before: Dictionary = app.profile.duplicate(true)
		button(main, "● 2").pressed.emit()
		await process_frame
		var entry := main.find_child("LocationEnter", true, false) as Button
		check(entry != null and entry.disabled, "locked point inspectable but entry blocked")
		check(app.profile == before, "locked selection is read-only")
		var popup := main.find_child("LocationDetails", true, false) as Window
		check(popup.size.x <= root.size.x and popup.size.y <= root.size.y, "details popup fits viewport")
		popup.get_ok_button().pressed.emit()
		await process_frame
		button(main, "● 1").pressed.emit()
		await process_frame
		await process_frame
		entry = main.find_child("LocationEnter", true, false) as Button
		var scroll := entry.get_parent().get_parent() as ScrollContainer
		check(entry.get_global_rect().end.y <= scroll.get_global_rect().end.y, "entry action fully visible before scrolling, large=%s" % large)
		check(not entry.disabled and entry.text.contains("10 stamina"), "cost shown before entry")
		check(app.profile == before and main.page == "jade_play", "opening details does not create encounter, roll or charge")
		var label := main.find_child("LocationEnergy", true, false) as Label
		check(label.text.contains("100/100"), "current stamina shown in selected location")
		entry.pressed.emit()
		await process_frame
		check(main.page == "exploration" and app.profile.campaign.exploration.value == 90, "confirmed entry charges exactly once")
		var view := main.find_child("LocationBackdrop", true, false) as TextureRect
		check(view != null and view.texture == Stage.texture("jade_point_1"), "exploration uses location backdrop")
		button(main, "Buscar encuentro").pressed.emit()
		await process_frame
		check(stage_in(main).background_id == "jade_point_1", "battle keeps explored terrain")
		app.profile = app.storage.load_profile()
		main._show("jade_play")
		await process_frame
		button(main, "● 1").pressed.emit()
		await process_frame
		entry = main.find_child("LocationEnter", true, false) as Button
		check(entry.text == "Retomar localización" and not entry.disabled, "paid location can resume")
		entry.pressed.emit()
		await process_frame
		check(app.profile.campaign.exploration.value == 90 and stage_in(main).background_id == "jade_point_1", "reloaded encounter resumes without new cost and with same backdrop")
		app.trial_action("retreat")
	app.profile = Store.defaults()
	app.profile.campaign.exploration.value = 9
	app.profile.campaign.exploration.anchor = int(Time.get_unix_time_from_system())
	main._show("jade_play")
	await process_frame
	button(main, "● 1").pressed.emit()
	await process_frame
	check((main.find_child("LocationEnter", true, false) as Button).disabled, "insufficient stamina still allows inspection, prevents entry")
	for i in range(1, 5):
		var id := "jade_point_%d" % i
		check(Visuals.details(id).background == id and Stage.texture(id) != null, "each point has a dedicated loaded backdrop")
		var campaign := {"route": {"current": {"point_id": id, "encounter_id": "same"}}, "encounter": {"id": "same"}}
		check(Visuals.background_for(campaign) == id, "background depends on route source, not enemy species")
		campaign.encounter.id = "other"
		check(Visuals.background_for(campaign) == "jade", "unrelated training never inherits old terrain")
	check(Visuals.details("unknown").is_empty(), "unknown location not invented")
	for id in Stage.RESTYLED:
		check(Stage.texture(id).resource_path.ends_with(id + "_v2.png"), "all characters and creatures consume renewed art")
	for id in ["zephyr", "tanugami", "kitsunibi"]:
		check(not Stage.mirror_for(id, true), "right-facing ally keeps sprite orientation")
		check(Stage.mirror_for(id, false), "right-facing enemy faces center after mirror")
	main.queue_free()
	await process_frame
	app.response_timer.stop()
	for suffix in ["", ".bak", ".tmp"]: DirAccess.remove_absolute(PATH + suffix)
	print("LOCATION PRESENTATION TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
