extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const PATH := "user://automatic_turn_test.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func _check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + description)
func _tree() -> Dictionary:
	var tree := TreeModel.new()
	for i in range(4): tree.gain_level()
	for id in ["proteccion", "potenciacion", "control", "curacion"]:
		tree.purchase(id)
		tree.equip(id)
	return tree.snapshot()
func _find(node: Node, text: String) -> Button:
	if node is Button and node.text.begins_with(text): return node
	for child in node.get_children():
		var result := _find(child, text)
		if result != null: return result
	return null
func _run() -> void:
	var e := Encounter.new()
	_check(e.begin("ordered", _tree(), [0.1, 0.2, 0.3]), "new ordered encounter begins")
	_check(e.act("trainer", "proteccion") and not e.state.enemy_pending, "trainer support does not advance enemy")
	_check(e.act("karmany", "golpe") and e.state.enemy_pending, "Karmany ability schedules enemy phase")
	_check(not e.act("trainer", "control") and not e.act("karmany", "golpe"), "all player actions lock after Karmany")
	_check(not e.retreat(), "cannot evade queued rival reply by retreat")
	_check(e.end_round() and not e.state.enemy_pending and e.state.player_hp == 74 and e.state.round == 2, "guarded response resolves once and starts next round")
	_check(not e.end_round(), "duplicate response rejected")
	var guard := Encounter.new()
	guard.begin("guard", TreeModel.defaults(), [0.1, 0.2, 0.3])
	_check(guard.act("karmany", "guardia") and guard.state.enemy_pending, "non-attack Karmany ability also ends player turn")
	guard.end_round()
	_check(guard.state.player_hp == 74, "protection response keeps original damage rules")
	var bad := guard.snapshot()
	bad.enemy_pending = true
	_check(not Encounter.valid(bad), "pending response without spent Karmany action rejected")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.profile.skill_tree = _tree()
	app.load_failed = false
	app.application_paused = false
	app.start_trial()
	var packed: PackedScene = load("res://scenes/main.tscn")
	var main := packed.instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	_check(_find(main.get_node("Page"), "Cerrar turno") == null, "no manual close button")
	_find(main.get_node("Page"), "Ezel: Escudo").pressed.emit()
	await process_frame
	_check(not app.profile.campaign.encounter.enemy_pending and app.response_timer.is_stopped(), "UI support preserves the Karmany action")
	_find(main.get_node("Page"), "Golpe").pressed.emit()
	await process_frame
	_check(app.profile.campaign.encounter.enemy_pending and not app.response_timer.is_stopped(), "real ability tap starts automatic response timer")
	var action: String = app.profile.campaign.encounter.last_action
	_check(action.begins_with("Zephyr"), "player action remains readable before rival response")
	_check(_find(main.get_node("Page"), "Ezel: Control").disabled, "trainer cannot act after Karmany")
	_check(not app.trial_action("karmany", "golpe", 0), "stale double tap cannot issue another action")
	app._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	_check(app.response_timer.is_stopped() and app.profile.campaign.encounter.enemy_pending, "pause preserves pending response and stops timer")
	var saved: Dictionary = app.storage.load_profile()
	_check(saved.campaign.encounter.enemy_pending and saved.campaign.encounter.player_hp == 80, "pending response is persisted before enemy damage")
	app.profile = saved
	app._notification(MainLoop.NOTIFICATION_APPLICATION_RESUMED)
	await app.response_timer.timeout
	await process_frame
	_check(app.profile.campaign.encounter.round == 2 and app.profile.campaign.encounter.player_hp == 74, "resume automatically resolves one guarded reply")
	_check(_find(main.get_node("Page"), "Golpe").disabled == false, "UI refreshes and enables next Karmany action")
	_check(app.profile.campaign.encounter.last_action.begins_with("Tanugami"), "latest action becomes rival action")
	app.trial_action("karmany", "golpe")
	main.queue_free()
	await process_frame
	await app.response_timer.timeout
	_check(app.profile.campaign.encounter.round == 3, "reply survives leaving or destroying combat UI")
	app.trial_action("karmany", "golpe")
	app.response_timer.stop()
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-auto-response-directory/profile.json")
	app._resolve_enemy_response()
	_check(app.profile == before and not app.response_error.is_empty(), "failed response write preserves pending checkpoint and reports error")
	main = packed.instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	await process_frame
	var retry := _find(main.get_node("Page"), "Reintentar respuesta")
	_check(retry != null and retry.get_global_rect().end.y < 690, "write-error retry control stays visible")
	app.storage = Store.new(PATH)
	retry.pressed.emit()
	await app.response_timer.timeout
	_check(app.profile.campaign.encounter.round == 4 and app.response_error.is_empty(), "retry resolves checkpoint once after storage recovery")
	main.queue_free()
	await process_frame
	while app.profile.campaign.encounter.phase == "battle":
		var current := Encounter.new()
		current.restore(app.profile.campaign.encounter)
		if current.state.enemy_pending: app.trial_action("enemy")
		else: app.trial_action("karmany", "insignia" if current.reason("karmany", "insignia").is_empty() else "golpe")
	_check(app.profile.campaign.encounter.phase == "capture" and app.response_timer.is_stopped(), "finishing hit goes directly to book with no defeated enemy response")
	app.profile.campaign.encounter.rolls = [0.1, 0.2, 0.3]
	_check(app.trial_action("capture") and app.profile.campaign.collection.size() == 1, "book still grants one captured individual")
	_check(app.profile.campaign.victories == 1, "automatic flow grants victory once")
	app.start_trial()
	app.trial_action("karmany", "golpe")
	app.response_timer.stop()
	var legacy: Dictionary = app.profile.duplicate(true)
	legacy.campaign.encounter.erase("enemy_pending")
	legacy.campaign.encounter.turn.state = "open"
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(legacy))
	file.close()
	app.profile = app.storage.load_profile()
	_check(app.profile.campaign.encounter.enemy_pending and app.profile.campaign.encounter.round == 1, "old manual-close save becomes pending without replaying player action")
	app._schedule_enemy_response()
	await app.response_timer.timeout
	_check(app.profile.campaign.encounter.round == 2 and app.profile.campaign.encounter.player_hp == 68, "old pending turn gets one automatic response")
	var revision: int = app.profile.campaign.encounter.revision
	app._resolve_enemy_response()
	_check(app.profile.campaign.encounter.revision == revision, "stale timeout cannot repeat enemy damage")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("AUTOMATIC TURN TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
