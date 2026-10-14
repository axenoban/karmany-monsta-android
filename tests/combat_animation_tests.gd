extends SceneTree
const Stage = preload("res://scripts/trial_stage.gd")
var checks := 0
var failures := 0
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(label)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	check(Stage.DURATION < root.get_node("App").RESPONSE_DELAY, "animation finishes before response")
	for species in ["zephyr", "tanugami", "ushigane", "kitsunibi", "sakuromushi"]:
		for action in ["golpe", "insignia", "guardia", "curacion", "proteccion", "switch"]:
			check(Stage.pose(species, action, 0).is_zero_approx() and Stage.pose(species, action, 1).is_zero_approx(), "starts and ends at rest")
			check(Stage.pose(species, action, 0.5).is_finite(), "finite motion")
		check(Stage.pose(species, "golpe", 0.12).x < 0 and Stage.pose(species, "golpe", 0.5).x > 0, "anticipation before attack")
	check(not Stage.offensive("tanugami", "insignia"), "healing signature does not hit")
	for action in ["guardia", "curacion", "proteccion", "switch"]:
		check(not Stage.offensive("zephyr", action), "support does not hit")
	check(is_zero_approx(Stage.impact(0.2)) and is_zero_approx(Stage.impact(1.0)) and Stage.impact(0.57) > 0.99, "impact only on contact")
	var stage := Stage.new()
	root.add_child(stage)
	var event := {"species": "zephyr", "action": "golpe", "side": "ally"}
	stage.play(event)
	stage.event.action = "guardia"
	check(event.action == "golpe", "event copied without mutating combat")
	stage._process(2.0)
	check(not stage.is_processing() and stage.elapsed == Stage.DURATION, "long frame safely ends animation")
	stage.free()
	print("COMBAT_ANIMATION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
