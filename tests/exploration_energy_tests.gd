extends SceneTree
const Energy = preload("res://scripts/exploration_energy.gd")
const Route = preload("res://scripts/jade_route.gd")
const Store = preload("res://scripts/save_store.gd")
const Router = preload("res://scripts/encounter_router.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
var checks := 0
var failures := 0
const PATH := "user://exploration-energy-tests.json"
func _initialize() -> void: call_deferred("_run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func find_button(node: Node, caption: String) -> Button:
	if node is Button and node.text.begins_with(caption): return node
	for child in node.get_children(true):
		var found := find_button(child, caption)
		if found != null: return found
	return null
func hp_bar(main: Node, id: String) -> ProgressBar:
	return main.find_child(id, true, false) as ProgressBar
func text_content(node: Node) -> String:
	var result := ""
	if node is Label or node is Button: result += node.text + "\n"
	for child in node.get_children(): result += text_content(child)
	return result
func winning_checkpoint(app: Node, roll: int) -> void:
	app.discover_location(app.profile.campaign.encounter.id)
	var model = Router.create(app.profile.campaign.encounter)
	model.restore(app.profile.campaign.encounter)
	model.state.enemy.hp = 1
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
	app.profile.campaign.exploration.drop.roll = roll
	check(app.commit_profile(app.profile), "pre-victory drop roll saved")
func _run() -> void:
	root.size = Vector2i(1280, 720)
	for i in range(4): check(Route.entry_cost(Route.points()[i].id) == (30 if i == 3 else 10), "approved per-location cost")
	var original := Energy.defaults()
	var energy := Energy.spend(original, 10, 1000)
	check(energy.value == 90 and energy.anchor == 1000 and original.value == 100, "spending uses a copy and starts recovery")
	check(Energy.refreshed(energy, 1059).value == 90, "no recovery before full minute")
	var next := Energy.refreshed(energy, 1060)
	check(next.value == 91 and next.anchor == 1060, "one point per minute")
	next = Energy.refreshed(energy, 1190)
	check(next.value == 93 and next.anchor == 1180, "fractional minute retained")
	check(Energy.refreshed(next, 1190) == next, "same recovery checkpoint cannot duplicate gain")
	check(Energy.refreshed(energy, 900) == energy, "clock rollback grants nothing")
	next = Energy.refreshed(energy, 1000000)
	check(next.value == 100 and next.anchor == 0, "offline recovery caps at maximum and clears excess time")
	energy.value = 29
	check(Energy.spend(energy, 30, 1000).is_empty(), "cannot enter final location below cost")
	energy.items = 1
	next = Energy.consume_item(energy, 1000)
	check(next.value == 59 and next.items == 0, "item gives thirty and consumes one")
	energy.value = 95
	next = Energy.consume_item(energy, 1000)
	check(next.value == 100 and next.anchor == 0 and next.items == 0, "item caps at maximum")
	energy = Energy.defaults()
	energy.items = 1
	check(Energy.consume_item(energy, 1000).is_empty(), "full stamina cannot waste item")
	for roll in [0, 1999, 2000, 9999]:
		energy = Energy.defaults()
		energy.drop = {"encounter_id": "jade-1", "roll": roll, "resolved": false, "received": false}
		next = Energy.resolve_drop(energy, "jade-1")
		check(next.items == (1 if roll < 2000 else 0), "exact twenty percent threshold")
		check(Energy.resolve_drop(next, "jade-1") == next, "same victory roll cannot award twice")
	var app := root.get_node("App")
	app.profile = Store.defaults()
	app.storage = Store.new(PATH)
	app.load_failed = false
	check(app.start_route("jade_point_1"), "enter first location")
	var saved: Dictionary = app.profile.duplicate(true)
	check(saved.campaign.exploration.value == 90 and saved.campaign.exploration.scouting, "entry pays ten and persists scouting before battle")
	check(app.start_route("jade_point_1") and app.profile == saved, "resume charges nothing and does not reroll drop")
	check(not app.trial_action("karmany", "golpe") and app.profile == saved, "cannot attack before searching location")
	app.profile = app.storage.load_profile()
	check(app.profile.campaign.exploration.scouting and app.profile.campaign.exploration.value == 90, "restart preserves paid location")
	check(not app.discover_location("wrong-id"), "stale search rejects wrong encounter")
	check(app.discover_location(app.profile.campaign.encounter.id) and not app.profile.campaign.exploration.scouting, "search opens encounter without spending stamina")
	check(not app.discover_location(app.profile.campaign.encounter.id), "search cannot execute twice")
	app.trial_action("retreat")
	check(app.profile.campaign.exploration.value == 90 and app.profile.campaign.route.completed.is_empty(), "withdrawal refunds nothing and grants no item or completion")
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-energy-directory/profile.json")
	check(not app.start_route("jade_point_1") and app.profile == before, "failed entry save neither charges nor creates encounter")
	app.storage = Store.new(PATH)
	app.profile.campaign.exploration.value = 9
	app.profile.campaign.exploration.anchor = int(Time.get_unix_time_from_system())
	before = app.profile.duplicate(true)
	check(not app.start_route("jade_point_1") and app.profile == before, "insufficient stamina rejected in model")
	app.profile = Store.defaults()
	app.profile.campaign.sequence = 3
	app.profile.campaign.victories = 3
	for i in range(3): app.profile.campaign.route.completed.append({"point_id": Route.points()[i].id, "encounter_id": "jade-%d" % (i + 1)})
	check(app.start_route("jade_point_4") and app.profile.campaign.exploration.value == 70, "final entry charges thirty")
	winning_checkpoint(app, 1999)
	before = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-energy-directory/profile.json")
	check(not app.trial_action("karmany", "golpe") and app.profile == before, "failed victory write grants neither item nor progress")
	app.storage = Store.new(PATH)
	check(app.trial_action("karmany", "golpe") and app.profile.campaign.exploration.items == 1 and app.profile.campaign.route.completed.size() == 4, "victory commits item and progress once")
	check(not app.trial_action("karmany", "golpe") and app.profile.campaign.exploration.items == 1, "duplicate winning callback cannot repeat item")
	check(app.storage.load_profile().campaign.exploration == app.profile.campaign.exploration, "drop resolution and inventory persist exactly")
	app.continue_route(app.profile.campaign.encounter.id, app.profile.campaign.encounter.revision)
	check(app.profile.campaign.exploration.drop.is_empty() and app.profile.campaign.exploration.items == 1, "continuing keeps item and clears reward receipt with encounter")
	var revision: int = app.profile.campaign.exploration.revision
	before = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-energy-directory/profile.json")
	check(not app.use_recovery_item(revision) and app.profile == before, "failed item use saves neither quantity nor stamina")
	app.storage = Store.new(PATH)
	check(app.use_recovery_item(revision) and app.profile.campaign.exploration.value == 100 and app.profile.campaign.exploration.items == 0, "item use restores thirty")
	check(not app.use_recovery_item(revision), "double item use rejected by revision")
	check(app.start_trial("kitsunibi") and app.profile.campaign.exploration.value == 100 and app.profile.campaign.exploration.drop.is_empty(), "training has no entry cost or reward roll")
	app.trial_action("retreat")
	app.profile.campaign.exploration.value = 70
	app.profile.campaign.exploration.anchor = 1000
	check(app.stamina_view(1125).value == 72 and app.profile.campaign.exploration.value == 70, "offline effective stamina is read-only until transaction")
	var bad: Dictionary = app.profile.duplicate(true)
	bad.campaign.exploration.value = -1
	check(not Store.valid(bad), "negative stamina rejected")
	bad = app.profile.duplicate(true)
	bad.campaign.exploration.drop = {"encounter_id": "wrong", "roll": 1, "resolved": false, "received": false}
	check(not Store.valid(bad), "wrong encounter reward receipt rejected")
	# Old profiles get full stamina and never pay retrospectively for an ongoing encounter.
	app.profile = Store.defaults()
	app.start_route("jade_point_1")
	app.discover_location(app.profile.campaign.encounter.id)
	var old: Dictionary = app.profile.duplicate(true)
	old.campaign.erase("exploration")
	check(app.storage.save_profile(old), "old route encounter save accepted")
	app.profile = app.storage.load_profile()
	check(app.profile.campaign.exploration.value == 100 and not app.profile.campaign.exploration.scouting and app.start_route("jade_point_1") and app.profile.campaign.exploration.value == 100, "migration preserves old encounter without charging or inventing drop")
	app.trial_action("retreat")
	# Real mobile flow: hidden species on map/scouting, then live HP and menus in battle.
	app.profile = Store.defaults()
	var tree := TreeModel.new()
	tree.gain_level()
	tree.purchase("proteccion")
	tree.equip("proteccion")
	app.profile.skill_tree = tree.snapshot()
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("jade_play")
		await process_frame
		await process_frame
		var text := text_content(main.get_node("Page"))
		for species in ["Tanugami", "Ushigane", "Kitsunibi", "Sakuromushi"]: check(not text.contains(species), "map does not reveal species")
		var marker := find_button(main.get_node("Page"), "● 1")
		check(marker.get_global_rect().end.y < 650 and marker.size.y >= 58, "overhead marker accessible large=%s" % large)
		check(find_button(main.get_node("Page"), "Usar recuperador").get_global_rect().end.x <= 1280, "energy controls fit viewport")
		check(find_button(main.get_node("Page"), "Usar recuperador").disabled, "empty inventory button disabled")
	find_button(main.get_node("Page"), "● 1").pressed.emit()
	await process_frame
	check(main.page == "jade_play" and app.profile.campaign.exploration.value == 100, "marker opens details without payment")
	find_button(main.get_node("Page"), "Entrar · 10 stamina").pressed.emit()
	await process_frame
	check(main.page == "exploration" and app.profile.campaign.exploration.value == 90, "marker enters exploration scene after payment")
	check(not text_content(main.get_node("Page")).contains("Tanugami"), "scouting does not reveal encounter species")
	find_button(main.get_node("Page"), "Buscar encuentro").pressed.emit()
	await process_frame
	check(main.page == "battle" and hp_bar(main, "AllyHP").value == 80 and hp_bar(main, "EnemyHP").value == 80, "search reveals battle with live PS bars")
	check(find_button(main.get_node("Page"), "Ezel: Escudo") == null and find_button(main.get_node("Page"), "Abandonar") == null and find_button(main.get_node("Page"), "Volver al mapa") == null, "secondary options hidden during fight")
	check(find_button(main.get_node("Page"), "Golpe") != null and find_button(main.get_node("Page"), "Entrenador") != null, "attacks and trainer toggle remain visible")
	find_button(main.get_node("Page"), "Entrenador").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Ezel: Escudo").pressed.emit()
	await process_frame
	check(not app.profile.campaign.encounter.enemy_pending and app.profile.campaign.exploration.value == 90, "trainer menu preserves turn and stamina")
	find_button(main.get_node("Page"), "Golpe").pressed.emit()
	await process_frame
	check(hp_bar(main, "EnemyHP").value == app.profile.campaign.encounter.enemy_hp and hp_bar(main, "EnemyHP").value == 68, "rival PS bar updates immediately on successful action")
	await app.response_timer.timeout
	await process_frame
	check(hp_bar(main, "EnemyHP").value == app.profile.campaign.encounter.enemy_hp and hp_bar(main, "AllyHP").value == app.profile.campaign.encounter.player_hp, "PS bars track enemy healing and response")
	find_button(main.get_node("Page"), "Golpe").pressed.emit()
	await app.response_timer.timeout
	await process_frame
	check(hp_bar(main, "AllyHP").value == 74 and app.profile.campaign.encounter.player_hp == 74, "player PS bar updates on incoming damage")
	find_button(main.get_node("Page"), "Opciones").pressed.emit()
	await process_frame
	check(find_button(main.get_node("Page"), "Volver al mapa") != null and find_button(main.get_node("Page"), "Abandonar pelea") != null, "options menu exposes navigation and withdrawal")
	find_button(main.get_node("Page"), "Volver al mapa").pressed.emit()
	await process_frame
	check(main.page == "jade_play" and app.profile.campaign.encounter.phase == "battle", "map navigation keeps encounter")
	find_button(main.get_node("Page"), "Retomar encuentro").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Opciones").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Abandonar pelea").pressed.emit()
	await process_frame
	var confirmations := main.find_children("*", "ConfirmationDialog", true, false).filter(func(window: Node): return window.visible)
	check(confirmations.size() == 1, "withdrawal uses one confirmation without competing modal windows")
	confirmations[0].get_cancel_button().pressed.emit()
	await process_frame
	check(app.profile.campaign.encounter.phase == "battle", "cancelled withdrawal preserves fight")
	find_button(main.get_node("Page"), "Opciones").pressed.emit()
	await process_frame
	find_button(main.get_node("Page"), "Abandonar pelea").pressed.emit()
	await process_frame
	confirmations = main.find_children("*", "ConfirmationDialog", true, false).filter(func(window: Node): return window.visible)
	confirmations[0].get_ok_button().pressed.emit()
	await process_frame
	check(app.profile.campaign.encounter.phase == "retreated" and app.profile.campaign.exploration.value == 90, "confirmed withdrawal preserves entry cost")
	app.profile.campaign.exploration.items = 1
	app.profile.campaign.exploration.value = 60
	app.profile.campaign.exploration.anchor = int(Time.get_unix_time_from_system())
	main._show("jade_play")
	await process_frame
	find_button(main.get_node("Page"), "Usar recuperador").pressed.emit()
	await process_frame
	check(app.profile.campaign.exploration.value == 90 and app.profile.campaign.exploration.items == 0, "real map item button spends one item and restores stamina")
	main.queue_free()
	await process_frame
	app.response_timer.stop()
	for suffix in ["", ".bak", ".tmp"]: DirAccess.remove_absolute(PATH + suffix)
	print("EXPLORATION ENERGY TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
