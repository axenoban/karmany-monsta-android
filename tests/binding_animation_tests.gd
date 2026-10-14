extends SceneTree
const Binding = preload("res://scripts/binding_stage.gd")
const Store = preload("res://scripts/save_store.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const PATH := "user://binding-animation-tests.json"
var checks := 0
var failures := 0
var signals_received := 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func fixture(app: Node, rolls: Array) -> void:
	app.profile = Store.defaults()
	app.storage = Store.new(PATH)
	app.load_failed = false
	app.start_trial("kitsunibi")
	var e := Tactical.new()
	e.restore(app.profile.campaign.encounter)
	e.state.rolls = rolls
	e.state.enemy.hp = 1
	e._sync()
	app.profile.campaign.encounter = e.snapshot()
	check(app.trial_action("karmany", "golpe") and app.profile.campaign.encounter.phase == "capture", "prepare real capture transaction")
func ui_node() -> Control:
	var node := load("res://scripts/trial_ui.gd").new() as Control
	root.add_child(node)
	node.size = Vector2(1280, 720)
	return node
func run() -> void:
	root.size = Vector2i(1280, 720)
	for success in [false, true]:
		for step in range(73):
			var pose := Binding.sample(step * 0.05, success)
			check(pose.position.is_finite() and pose.scale >= 0 and pose.scale <= 1 and pose.alpha >= 0 and pose.alpha <= 1, "bounded deterministic trajectory")
	var absorbed := Binding.sample(2.1, true)
	check(absorbed.scale == 0 and absorbed.alpha == 0, "success completely enters book")
	var bounce := Binding.sample(2.05, false)
	var restored := Binding.sample(3.0, false)
	check(bounce.scale > 0 and bounce.scale < 0.3 and restored.scale == 1, "failure recoils and regains full size")
	check(restored.position.is_equal_approx(Vector2(0.79, 0.39)), "failure returns to origin")
	for area in [Vector2(1176, 410), Vector2(1176, 210), Vector2(800, 240)]:
		var unit := Binding.art_scale(area, false)
		var creature_bounds := Rect2(Vector2(0.79, 0.39) * area - Vector2(140, 150) * unit, Vector2(280, 300) * unit)
		check(Rect2(Vector2.ZERO, area).encloses(creature_bounds), "entire creature fits compact capture preview")
	var app := root.get_node("App")
	fixture(app, [0.1, 0.9, 0.9])
	var ui := ui_node()
	var revision: int = app.profile.campaign.encounter.revision
	ui._act("capture", "", revision)
	var animation := ui.find_child("BindingAnimation", true, false)
	check(animation != null and animation.outcome == "captured", "success cinematic uses committed outcome")
	check(app.storage.load_profile().campaign.collection.size() == 1, "capture persisted before animation completes")
	ui._act("capture", "", revision)
	check(app.profile.campaign.encounter.capture.actions.size() == 1 and app.profile.campaign.collection.size() == 1, "double tap cannot duplicate attempt or creature")
	animation.finished.connect(func(): signals_received += 1)
	animation.finish()
	animation.finish()
	check(signals_received == 1, "skip completes once")
	ui.free()
	check(app.storage.load_profile().campaign.encounter.phase == "captured", "teardown preserves result")
	fixture(app, [0.9, 0.9, 0.9])
	for attempt in range(3):
		ui = ui_node()
		ui._act("capture", "", app.profile.campaign.encounter.revision)
		animation = ui.find_child("BindingAnimation", true, false)
		check(animation != null and animation.outcome == ("escaped" if attempt == 2 else "capture"), "failure and final escape use rebound")
		check(app.profile.campaign.encounter.capture.actions.size() == attempt + 1 and app.profile.campaign.collection.is_empty(), "one attempt per animation")
		animation._process(9.0)
		check(not animation.running and not animation.is_processing(), "long frame completes without orphan timer")
		ui.free()
		app.profile = app.storage.load_profile()
	check(not app.trial_action("capture"), "no fourth attempt")
	fixture(app, [0.1, 0.9, 0.9])
	ui = ui_node()
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-binding-directory/profile.json")
	ui._act("capture", "", app.profile.campaign.encounter.revision)
	check(ui.find_child("BindingAnimation", true, false) == null and not ui.binding_busy and app.profile == before, "failed save does not animate or spend")
	ui.free()
	app.storage = Store.new(PATH)
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("BINDING ANIMATION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
