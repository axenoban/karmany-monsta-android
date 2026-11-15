extends SceneTree
## Visual adapter contract, using isolated QA and existing gameplay actions.
const Kit = preload("res://scripts/combat_kit_theme.gd")
const Art = preload("res://scripts/trial_stage.gd")
var checks := 0
var failures := 0
var app: Node
var main: Node
var render := "--allow-ui-review" in OS.get_cmdline_user_args()

func _initialize() -> void: call_deferred("run")
func check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("COMBAT KIT: " + description)
func frames() -> void:
	for i in range(5): await process_frame
func button(node: Node, prefix: String) -> Button:
	if node is Button and node.text.begins_with(prefix): return node
	for child in node.get_children():
		var found := button(child, prefix)
		if found != null: return found
	return null
func shot(id: String) -> void:
	await frames()
	if render:
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/combat-kit-review/" + id + ".png")
func path_of(style: StyleBox) -> String:
	return style.texture.resource_path if style is StyleBoxTexture else ""

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://build/combat-kit-review")
	app = root.get_node("App")
	ProjectSettings.set_setting("karmany/qa/development", true)
	check(app.enter_qa(), "QA profile isolated")
	app.set_preference("reduced_motion", true)
	check(app.start_route("jade_point_1"), "existing route started")
	check(app.discover_location(app.profile.campaign.encounter.id), "existing battle discovered")
	app.pending_transition = {}
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for large in [false, true]:
		app.set_preference("large_text", large)
		for dimensions in [Vector2i(1280,720), Vector2i(960,540), Vector2i(1600,720)]:
			root.size = dimensions
			var before: Dictionary = app.profile.duplicate(true)
			main._show("battle")
			await frames()
			print("KIT VIEWPORT: physical=%s canvas=%s main=%s large=%s" % [root.size, root.get_visible_rect().size, main.size, large])
			var trial := main.find_child("PlayerBattleUI", true, false)
			check(trial != null, "battle uses existing screen")
			if trial == null: continue
			var golpe := button(trial, "Golpe")
			check(golpe != null, "existing attack available")
			if golpe == null: continue
			check(path_of(golpe.get_theme_stylebox("normal")).ends_with("combat_kit/button_normal.svg"), "kit applied to live action")
			check(path_of(golpe.get_theme_stylebox("pressed")).ends_with("combat_kit/button_pressed.svg"), "pressed state retains kit")
			check(path_of(golpe.get_theme_stylebox("disabled")).ends_with("combat_kit/button_disabled.svg"), "disabled state retains kit")
			check(golpe.icon.resource_path.ends_with("combat_kit/ico_golpe.svg"), "semantic icon bound")
			for id in ["AllyHP", "EnemyHP"]:
				var hp := trial.find_child(id, true, false) as ProgressBar
				check(hp != null and hp.value == before.campaign.encounter.get("player_hp" if id == "AllyHP" else "enemy_hp"), "real HP binding: " + id)
				var card := trial.find_child("Kit" + id + "Card", true, false) as Control
				check(card != null and root.get_visible_rect().grow(1).encloses(card.get_global_rect()), "HUD card stays in viewport")
				var portrait := card.find_child("KitPortrait", true, false) as TextureRect
				check(portrait != null and portrait.size.x < 110 and portrait.size.y < 110, "portrait respects bounds")
				var species: String = before.campaign.encounter.get("ally_species" if id == "AllyHP" else "enemy_species")
				check(portrait.texture == Art.texture(species), "portrait comes from encounter species")
			for caption in ["Golpe", "Insignia", "Entrenador", "Equipo", "Táctica", "Menú"]:
				var control := button(trial, caption)
				check(control != null and root.get_visible_rect().grow(1).encloses(control.get_global_rect()), "touch control visible: " + caption)
			check(app.profile == before, "building HUD cannot change save or encounter")
			await shot("battle-%d-large-%s" % [dimensions.x, large])
			trial._guard_menu(before.campaign.encounter, int(before.campaign.encounter.revision))
			await frames()
			var guard := button(trial.get_node("GuardMenu"), "Protección")
			check(guard != null and guard.icon.resource_path.ends_with("ico_proteccion.svg"), "canonical Protection remains inside Tactics")
			main._back()
			await frames()
			trial._details()
			await frames()
			var panel := trial.get_node("CombatContextPanel")
			check(path_of(panel.get_node("PanelSurface").get_theme_stylebox("panel")).ends_with("combat_kit/detail_panel.svg"), "detail panel uses kit")
			check(app.profile == before, "consultations do not consume actions")
			await shot("details-%d-large-%s" % [dimensions.x, large])
			main._back()
			await frames()
			check(trial.get_node_or_null("CombatContextPanel") == null, "Back dismisses existing panel")
	# Execute through the live button; existing transaction owns turn, lock and save.
	root.size = Vector2i(1280,720)
	main._show("battle")
	await frames()
	var trial := main.find_child("PlayerBattleUI", true, false)
	var revision: int = app.profile.campaign.encounter.revision
	button(trial, "Golpe").pressed.emit()
	app.response_timer.stop()
	await frames()
	check(app.profile.campaign.encounter.revision > revision, "live button calls existing combat transaction")
	check(app.profile.campaign.encounter.enemy_pending, "existing rival response pending")
	main._show("battle")
	await frames()
	trial = main.find_child("PlayerBattleUI", true, false)
	var blocked := button(trial, "Golpe")
	check(blocked != null and blocked.disabled, "pending response blocks input")
	check(blocked.icon.resource_path.ends_with("ico_lock.svg"), "disabled action has noncolor cue")
	await shot("battle-pending-response")
	main._show("map")
	await frames()
	var baseline := button(main, "Explorar región")
	check(baseline != null and not path_of(baseline.get_theme_stylebox("normal")).contains("combat_kit"), "map keeps baseline theme")
	app.response_timer.stop()
	main.queue_free()
	await frames()
	check(app.exit_qa(), "normal profile restored after test")
	print("COMBAT KIT: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
