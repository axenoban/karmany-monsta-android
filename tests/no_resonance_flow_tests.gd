extends SceneTree
const LegacyFixture = preload("res://tests/legacy_fixture.gd")
const Store = preload("res://scripts/save_store.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const PATH := "user://no_resonance_ui_test.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func _check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + description)
func _trial(main: Node) -> Node:
	return main.get_node("Page").get_child(0).get_child(1)
func _button(main: Node, text: String) -> Button:
	return _find_button(_trial(main), text)
func _find_button(node: Node, text: String) -> Button:
	if node is Button and node.text.begins_with(text): return node
	for child in node.get_children(true):
		var result := _find_button(child, text)
		if result != null: return result
	return null
func _run() -> void:
	root.size = Vector2i(1280, 720)
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	LegacyFixture.start(app)
	app.profile.campaign.encounter.rolls = [0.1, 0.2, 0.3]
	var packed: PackedScene = load("res://scenes/main.tscn")
	var main := packed.instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("battle")
		await process_frame
		await process_frame
		var trial := _trial(main)
		_button(main, "Entrenador").pressed.emit()
		await process_frame
		var hint: Label = trial.find_child("TrainerHint", true, false)
		_check(hint.size.x > 500 and hint.size.y < 80, "empty-loadout menu hint wraps horizontally, large=%s" % large)
		trial.get_node("TrainerMenu").get_ok_button().pressed.emit()
		await process_frame
		_button(main, "Opciones").pressed.emit()
		await process_frame
		var finish := _button(main, "Abandonar")
		_check(finish.get_global_rect().end.y < 690 and finish.size.y >= 58, "retreat remains accessible inside options, large=%s" % large)
		trial.get_node("OptionsMenu").get_ok_button().pressed.emit()
		await process_frame
		_check(_button(main, "Cerrar turno") == null, "manual close control removed, large=%s" % large)
	app.profile.settings.large_text = false
	main._show("battle")
	await process_frame
	_button(main, "Golpe").pressed.emit()
	await process_frame
	await process_frame
	_check(app.profile.campaign.encounter.enemy_pending and _button(main, "Golpe").disabled, "attack immediately locks further actions while rival responds")
	await app.response_timer.timeout
	await process_frame
	_check(app.profile.campaign.encounter.round == 2 and app.profile.campaign.encounter.player_hp == 68, "automatic timer executes rival response without trainer resonance")
	_check(not _button(main, "Golpe").disabled, "next round accepts a Karmany action")
	while app.profile.campaign.encounter.phase == "battle":
		var encounter := Encounter.new()
		encounter.restore(app.profile.campaign.encounter)
		if encounter._turn().available("karmany"):
			_button(main, "Insignia" if encounter.reason("karmany", "insignia").is_empty() else "Golpe").pressed.emit()
		else:
			await app.response_timer.timeout
		await process_frame
	_check(app.profile.campaign.encounter.phase == "capture", "UI-only battle without resonances reaches book phase")
	var capture := _button(main, "Intentar vínculo")
	_check(capture != null and not capture.disabled, "book continuation available after victory")
	capture.pressed.emit()
	await process_frame
	_check(app.profile.campaign.encounter.phase == "captured" and app.profile.campaign.collection.size() == 1, "UI-only book attempt completes capture and collection")
	_check(app.storage.load_profile().campaign.encounter.phase == "captured", "resolved outcome persists")
	main.queue_free()
	await process_frame
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("NO RESONANCE UI TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
