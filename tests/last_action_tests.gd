extends SceneTree
const LegacyFixture = preload("res://tests/legacy_fixture.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const Store = preload("res://scripts/save_store.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const PATH := "user://last_action_test.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func _check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(label)
func _find(node: Node, caption: String) -> Button:
	if node is Button and node.text.begins_with(caption): return node
	for child in node.get_children(true):
		var found := _find(child, caption)
		if found != null: return found
	return null
func _run() -> void:
	var tree := TreeModel.new()
	for i in range(4): tree.gain_level()
	for id in ["curacion", "proteccion", "potenciacion", "control"]:
		tree.purchase(id)
		tree.equip(id)
	var e := Encounter.new()
	e.begin("latest", tree.snapshot(), [0.1, 0.2, 0.3])
	_check(not e.last_action_text().begins_with("Última"), "no fabricated action before first move")
	e.act("karmany", "golpe")
	_check(e.last_action_text() == "Última acción: Zephyr · Golpe · 12 de daño.", "attack actor name and actual result")
	e.end_round()
	e.act("trainer", "proteccion")
	_check(e.last_action_text().contains("Ezel · Escudo · 50%"), "shield identified instead of generic protection")
	_check(e.state.log.size() == 1 and not e.last_action_text().contains("Zephyr"), "only most recent action retained")
	var last: String = e.last_action_text()
	_check(not e.act("trainer", "control") and e.last_action_text() == last, "rejected command does not replace executed action")
	e.act("karmany", "golpe")
	e.end_round()
	_check(e.last_action_text() == "Última acción: Tanugami · Golpe · 6 de daño.", "enemy action replaces player action")
	e.act("trainer", "curacion")
	_check(e.last_action_text().contains("Curación · +18 de Vida"), "healing shows actual capped recovery")
	e.act("karmany", "insignia")
	var restored := Encounter.new()
	restored.restore(JSON.parse_string(JSON.stringify(e.snapshot())))
	_check(restored.last_action_text() == e.last_action_text(), "last action survives JSON restore")
	while e.state.phase == "battle":
		if e._turn().available("karmany"):
			e.act("karmany", "insignia" if e.reason("karmany", "insignia").is_empty() else "golpe")
		else: e.end_round()
	_check(e.state.phase == "capture" and e.last_action_text().begins_with("Última acción: Zephyr"), "defeat announcement cannot replace finishing move")
	e.attempt_capture()
	_check(e.last_action_text().contains("Ezel · Libro · vínculo logrado"), "book action becomes latest on capture")
	var legacy := e.snapshot()
	legacy.erase("last_action")
	legacy.log = ["Zephyr: Insignia · 22 de daño.", "Tanugami está fuera de combate. El Libro permite hasta tres intentos."]
	_check(Encounter.last_action_from(legacy) == "Zephyr: Insignia · 22 de daño.", "legacy save recovers action rather than phase announcement")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.profile.skill_tree = tree.snapshot()
	app.load_failed = false
	LegacyFixture.start(app)
	var packed: PackedScene = load("res://scenes/main.tscn")
	var main := packed.instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	# Exercise the actual UI callback and rebuilt screen, not just the model.
	var trial := main.get_node("Page").get_child(0).get_child(1)
	_find(trial, "Entrenador").pressed.emit()
	await process_frame
	_find(trial, "Ezel: Escudo").pressed.emit()
	await process_frame
	trial = main.get_node("Page").get_child(0).get_child(1)
	_find(trial, "Golpe").pressed.emit()
	await process_frame
	trial = main.get_node("Page").get_child(0).get_child(1)
	var label: Label = trial.column.get_node("LastAction")
	_check(label.text == "Última acción: Zephyr · Golpe · 12 de daño.", "tapping real Golpe button refreshes latest-action label")
	_find(trial, "Entrenador").pressed.emit()
	await process_frame
	_check(_find(trial, "Ezel: Escudo").disabled, "trainer button locks during automatic rival response")
	_check(app.storage.load_profile().campaign.encounter.last_action == app.profile.campaign.encounter.last_action, "displayed action matches persisted action")
	main.queue_free()
	await process_frame
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("LAST ACTION TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
