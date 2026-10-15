extends SceneTree
const Motion = preload("res://scripts/motion_preferences.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Binding = preload("res://scripts/binding_stage.gd")
const Effects = preload("res://scripts/effect_audio.gd")
const Store = preload("res://scripts/save_store.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const PATH := "user://reduced-motion-tests.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func run() -> void:
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	check(not app.profile.settings.reduced_motion, "normal animation remains default")
	var previous: Dictionary = app.profile.duplicate(true)
	check(app.set_preference("reduced_motion", true), "setting persists")
	check(app.profile.campaign == previous.campaign and app.profile.skill_tree == previous.skill_tree and app.profile.settings.sound == previous.settings.sound, "toggle preserves gameplay and sound settings")
	check(app.storage.load_profile().settings.reduced_motion, "enabled after reload")
	var invalid := Store.defaults()
	invalid.settings.reduced_motion = 1
	check(not Store.valid(invalid), "invalid preference rejected")
	var legacy := Store.defaults()
	legacy.settings.erase("reduced_motion")
	check(app.storage.save_profile(legacy), "old audio preview saves accepted")
	check(not app.storage.load_profile().settings.reduced_motion, "old profile receives disabled default")
	app.profile.settings.reduced_motion = true
	var stage := Stage.new()
	root.add_child(stage)
	check(stage.reduced_motion, "combat stage reads preference")
	for species in Stage.RESTYLED.slice(0, 5):
		for t in [0.0, 0.12, 0.5, 0.7, 1.0]:
			var moving := Stage.pose(species, "golpe", t)
			check(Motion.actor_motion(moving, true).is_zero_approx(), "reduced actor and recoil displacement suppressed")
			check(Motion.actor_motion(moving, false) == moving, "normal movement preserved")
	stage.play({"species":"zephyr", "action":"golpe", "side":"ally"})
	stage._process(0.2)
	stage._process(0.15)
	check(stage.effect_audio.emitted == ["swing", "hit"], "reduced combat retains synchronized sounds")
	stage.free()
	for success in [false, true]:
		for t in [0.0, 1.0, 2.0, 2.2, 3.0, 3.6]:
			var pose := Motion.binding_pose(t, success)
			check(pose.position == Vector2(0.79, 0.39) and pose.scale == 1.0 and pose.rotation == 0, "reduced binding has no travel, spin or zoom")
	check(Motion.binding_pose(3.0, true).alpha == 0, "success completely disappears after gentle transition")
	check(Motion.binding_pose(3.0, false).alpha == 1, "failure keeps creature visible")
	for reduced in [false, true]:
		for succeeds in [false, true]:
			app.profile = Store.defaults()
			app.profile.settings.reduced_motion = reduced
			app.start_trial("kitsunibi")
			var e := Tactical.new()
			e.restore(app.profile.campaign.encounter)
			e.state.enemy.hp = 1
			e.state.rolls = [0.1 if succeeds else 0.9, 0.9, 0.9]
			e._sync()
			app.profile.campaign.encounter = e.snapshot()
			app.trial_action("karmany", "golpe")
			app.consume_transition()
			var ui: Control = load("res://scripts/trial_ui.gd").new()
			root.add_child(ui)
			ui._act("capture", "", app.profile.campaign.encounter.revision)
			var animation := ui.find_child("BindingAnimation", true, false)
			check(animation != null and animation.reduced_motion == reduced, "real capture uses selected mode")
			check(app.profile.campaign.encounter.phase == ("captured" if succeeds else "capture") and app.profile.campaign.encounter.capture.actions.size() == 1, "same outcome and one attempt in both modes")
			check(animation.effect_audio.cues == Effects.binding_cues(animation.outcome).slice(1), "same remaining sound timeline in both modes")
			animation.finish()
			check(not animation.running and animation.effect_audio.cues.is_empty(), "skip remains safe")
			ui.free()
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-motion-directory/profile.json")
	check(not app.set_preference("reduced_motion", true) and app.profile == before, "failed save preserves preference and progress")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("REDUCED MOTION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
