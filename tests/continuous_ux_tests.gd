extends SceneTree
## Contrato UX sin cambios de canon: consultas, Atrás y resultado integrado.
const Store = preload("res://scripts/save_store.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Flow = preload("res://scripts/aftermath_flow.gd")
const PATH := "user://continuous-ux-test.json"
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("CONTINUOUS UX: " + message)

func _clear() -> void:
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix):
			DirAccess.remove_absolute(PATH + suffix)

func find_button(node: Node, caption: String) -> Button:
	if node is Button and node.text == caption: return node
	for child in node.get_children(true):
		var candidate := find_button(child, caption)
		if candidate != null: return candidate
	return null


func _run() -> void:
	_clear()
	root.size = Vector2i(1280, 720)
	var app := root.get_node("App")
	app.response_timer.stop()
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	app.pending_transition = {}
	app.pending_experience_id = ""
	check(app.start_journey(), "fresh profile")
	check(app.start_route("jade_point_1"), "enter first Jade location")
	var encounter_id: String = app.profile.campaign.encounter.id
	check(app.discover_location(encounter_id), "discover fight without further stamina")
	var main: Variant = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	main._show("battle")
	await process_frame
	var trial: Variant = main.get_node("Page").get_child(0).get_child(1)
	var before: Dictionary = app.profile.duplicate(true)
	# Player HUD is compact; canonical defense is still reachable from Táctica.
	check(find_button(trial, "Menú") != null and find_button(trial, "Táctica") != null, "single combat menu and tactical sub-menu visible")
	check(find_button(trial, "Detalles") == null, "details moved off primary battlefield")
	check(find_button(trial, "Entrenador") != null and find_button(trial, "Equipo") != null, "trainer/team choices remain visible")
	trial._guard_menu(app.profile.campaign.encounter, int(app.profile.campaign.encounter.revision))
	await process_frame
	check(trial.get_node_or_null("GuardMenu") != null, "defense remains accessible, not removed from canonical rules")
	var guard: String = str(preload("res://scripts/combat_catalog.gd").action(app.profile.campaign.encounter.ally_species, "guardia").name)
	check(find_button(trial.get_node("GuardMenu"), guard) != null, "the real guard technique is offered")
	main._back()
	await process_frame
	check(trial.get_node_or_null("GuardMenu") == null and app.profile == before, "Android Back dismisses tactics without playing a turn")
	# Android Back on an active battle opens a reversible menu, not the map.
	for help in get_nodes_in_group("context_help"):
		if help.is_visible_in_tree(): help.close_card()
	main._back()
	await process_frame
	check(trial.get_node_or_null("OptionsMenu") != null and main.page == "battle" and app.profile == before, "Back opens battle menu without exiting or spending resources")
	check(find_button(trial.get_node("OptionsMenu"), "Volver al combate") != null, "combat menu offers explicit resume")
	main._back()
	await process_frame
	check(trial.get_node_or_null("OptionsMenu") == null and main.page == "battle", "Back closes the menu and returns to battle")
	trial._details()
	await process_frame
	var panel: Variant = trial.get_node_or_null("CombatContextPanel")
	check(panel != null and panel.tabs != null and panel.tabs.get_tab_count() == 4, "details show four tabs over same fight")
	check(main.page == "battle" and before == app.profile, "read-only panel has no saved-game writes")
	main._back()
	await process_frame
	check(trial.get_node_or_null("CombatContextPanel") == null and main.page == "battle", "Android Back closes panel first")
	trial._trainer_menu()
	await process_frame
	panel = trial.get_node_or_null("CombatContextPanel")
	check(panel != null and app.profile == before, "trainer opens in same scene")
	trial._team_menu()
	await process_frame
	check(trial.find_children("CombatContextPanel", "Control", false, false).size() == 1, "only one panel after switching consultations")
	panel = trial.get_node_or_null("CombatContextPanel")
	panel.close_panel()
	await process_frame
	check(app.profile == before, "closing consultations has no cost")
	var model := Tactical.new()
	check(model.restore(app.profile.campaign.encounter), "restore canonical battle")
	model.state.enemy.hp = 1
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
	check(app.trial_action("karmany", "golpe"), "win saves result")
	check(Flow.step(app.profile.campaign) == "victory", "victory checkpoint persisted")
	var earned: Dictionary = app.profile.campaign.progression.last_reward.duplicate(true)
	var wins := int(app.profile.campaign.victories)
	# Aísla el avance de checkpoint de la cinematografía de entrada, que se prueba aparte.
	app.pending_transition = {}
	main._show("battle")
	await process_frame
	trial = main.get_node("Page").get_child(0).get_child(1)
	var after: Variant = trial.aftermath_screen
	check(after != null and after.stage == "victory", "single integrated result view")
	check(after.find_child("IntegratedExperience", true, false) != null, "XP shown on victory view")
	check(after.find_child("VictoryPortraits", true, false) != null, "combat context remains on result surface")
	after.advance()
	await process_frame
	check(Flow.step(app.profile.campaign) == "binding", "two checkpoints advance safely to Book decision")
	check(app.profile.campaign.progression.last_reward == earned and int(app.profile.campaign.victories) == wins, "no extra XP or victory from UI")
	trial = main.get_node("Page").get_child(0).get_child(1)
	check(trial.aftermath_screen != null and trial.aftermath_screen.stage == "binding", "Book maintains distinct focus")
	main.queue_free()
	await process_frame
	_clear()
	print("CONTINUOUS UX: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
