extends SceneTree
const Readout = preload("res://scripts/combat_readout.gd")
const Details = preload("res://scripts/combat_details.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Store = preload("res://scripts/save_store.gd")
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func find_button(node: Node, text: String) -> Button:
	if node is Button and node.text == text: return node
	for child in node.get_children(true):
		var found := find_button(child, text)
		if found != null: return found
	return null
func _run() -> void:
	root.size = Vector2i(1280, 720)
	check(Readout.build({}).is_empty(), "invalid encounter has no fabricated readout")
	var tree := TreeModel.new()
	for i in range(4): tree.gain_level()
	for id in ["curacion", "proteccion", "potenciacion", "control"]:
		tree.purchase(id)
		tree.equip(id)
	var team := {"schema": 1, "active_id": "first", "members": [{"instance_id": "first", "species_id": "sakuromushi"}, {"instance_id": "second", "species_id": "ushigane"}, {"instance_id": "third", "species_id": "ushigane"}]}
	var e := Tactical.new()
	check(e.begin("readout", tree.snapshot(), [0.1, 0.2, 0.3], team, "kitsunibi"), "tactical fixture begins")
	e.state.members[1].hp = 45
	e.state.members[1].guard = 0.5
	e.state.members[1].weaken = 0.3
	e.act("trainer", "potenciacion")
	e.act("karmany", "insignia", "third")
	var before := e.snapshot()
	var r := Readout.build(before)
	check(e.snapshot() == before, "readout does not mutate model")
	check(r.team[1].hp == 45 and r.team[1].max_hp == 96 and r.team[1].id == "second", "individual life and species maximum")
	check(r.team[2].effects.contains("+25%") and not r.team[1].effects.contains("+25%"), "duplicate species effects remain separate")
	check(r.team[1].effects.contains("Protección 50%") and r.team[1].effects.contains("Debilitamiento -30%"), "effects have correct owner and direction")
	check(r.active.signature_ready.contains("turno 4") and r.skills[2].ready_turn == 4, "individual cooldown deadline shown")
	check(r.skills[2].description.contains("compañero vivo elegido") and r.skills[2].description.contains("reserva"), "support beneficiary explained")
	check(r.skills[0].status.contains("respuesta") and r.phase.contains("pendiente"), "blocked action reason during rival phase")
	check(r.resonances[2].ready_turn == 4, "trainer cooldown deadline remains separate")
	var mutated: Dictionary = r.team[0]
	mutated.hp = 0
	check(e.state.player_hp > 0, "readout owns no live member dictionaries")
	check(Readout.describe({"heal": 18}, 1.2).contains("22 de Vida"), "healing rank uses game rounding")
	check(Readout.describe({"guard": 0.5}, 1.2).contains("60%"), "shield rank display")
	check(Readout.describe({"weaken": 0.4}, 1.2).contains("48%"), "control rank display")
	var legacy := Legacy.new()
	legacy.begin("legacy-readout", tree.snapshot(), [0.1, 0.2, 0.3])
	legacy.act("trainer", "control")
	r = Readout.build(legacy.snapshot())
	check(r.legacy and r.enemy.effects.contains("-30%") and not r.active.effects.contains("-30%"), "legacy debuff belongs to rival")
	check(r.enemy.signature_ready.contains("tercer turno") and r.team.size() == 1, "legacy schedule and roster explained")
	# Real UI opening, tab navigation, closing and teardown must not spend or save actions.
	var app := root.get_node("App")
	app.profile = Store.defaults()
	app.profile.campaign.sequence = 1
	app.profile.campaign.victories = 1
	app.profile.campaign.collection = [{"id": "jade-1", "species": "ushigane"}]
	app.profile.campaign.team.members.append({"instance_id": "jade-1", "species_id": "ushigane"})
	var battle := Tactical.new()
	battle.begin("jade-1", tree.snapshot(), [0.1, 0.2, 0.3], app.profile.campaign.team, "kitsunibi")
	app.profile.campaign.encounter = battle.snapshot()
	app.load_failed = false
	app.response_timer.stop()
	app.storage = Store.new("user://missing-readout-directory/profile.json")
	var profile_before: Dictionary = app.profile.duplicate(true)
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.profile.settings.large_text = large
		main._show("battle")
		await process_frame
		find_button(main.get_node("Page"), "Estado y técnicas").pressed.emit()
		await process_frame
		var dialogs := main.find_children("CombatDetails", "AcceptDialog", true, false)
		check(dialogs.size() == 1, "details opens once on mobile")
		var dialog = dialogs[0]
		check(dialog.size.x <= 1280 and dialog.size.y <= 650, "dialog fits landscape large=%s" % large)
		check(dialog.tabs.get_tab_count() == 4, "all four information tabs available")
		for tab in range(4):
			dialog.tabs.current_tab = tab
			await process_frame
			var scroll: ScrollContainer = dialog.tabs.get_child(tab)
			check(scroll.get_child(0).size.x <= scroll.size.x + 1, "content wraps without horizontal overflow")
		check(app.profile.campaign == profile_before.campaign and app.profile.skill_tree == profile_before.skill_tree, "viewing details spends no action and requires no writable storage")
		dialog.get_ok_button().pressed.emit()
		await process_frame
		check(main.find_children("CombatDetails", "AcceptDialog", true, false).is_empty(), "close releases dialog")
	# Response timer continues if the panel is open; screen refresh frees the stale snapshot.
	app.storage = Store.new("user://readout-test.json")
	app.profile.settings.large_text = false
	check(app.trial_action("karmany", "golpe"), "queued rival response for panel lifecycle")
	main._show("battle")
	await process_frame
	find_button(main.get_node("Page"), "Estado y técnicas").pressed.emit()
	await process_frame
	check(not app.response_timer.is_stopped(), "information panel does not pause or restart rival timer")
	await app.response_timer.timeout
	await process_frame
	check(app.profile.campaign.encounter.round == 2 and main.find_children("CombatDetails", "AcceptDialog", true, false).is_empty(), "rival responds once and outdated panel disappears")
	main.queue_free()
	await process_frame
	for suffix in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute("user://readout-test.json" + suffix)
	print("COMBAT READOUT TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
