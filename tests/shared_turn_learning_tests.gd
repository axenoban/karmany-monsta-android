extends SceneTree

const Turn = preload("res://scripts/shared_combat_turn.gd")
const Learning = preload("res://scripts/resonance_learning.gd")
const Structure = preload("res://scripts/combat_structure.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)

func _run() -> void:
	for order in [["trainer", "karmany"], ["karmany", "trainer"]]:
		var turn := Turn.new()
		_check(turn.begin("fixture_turn_" + order[0]), "turn starts for " + order[0])
		for owner in order:
			var ticket := turn.reserve(owner, "action_" + owner)
			_check(not ticket.is_empty() and turn.commit_action(ticket), "free order action: " + owner)
		_check(turn.state == "closed" and turn.snapshot().history.size() == 2, "both actions close shared turn")
		_check(turn.reserve("trainer", "extra").is_empty(), "third action refused")
	var turn := Turn.new()
	_check(not turn.begin(""), "empty turn identity refused")
	_check(turn.begin("fixture_turn"), "turn identity accepted")
	_check(turn.reserve("other_actor", "action").is_empty(), "unknown actor refused")
	var first := turn.reserve("trainer", "first")
	_check(not first.is_empty(), "reservation created")
	_check(turn.reserve("karmany", "concurrent").is_empty(), "concurrent resolution refused")
	_check(turn.snapshot().is_empty(), "cannot save a partially resolved action")
	_check(not turn.close_turn(), "cannot close during resolution")
	_check(turn.cancel_action(first) and turn.available("trainer"), "invalidated action consumes no budget")
	var second := turn.reserve("trainer", "first")
	_check(not turn.commit_action(first), "old ticket cannot commit new reservation")
	_check(turn.commit_action(second), "current ticket commits once")
	_check(not turn.commit_action(second), "duplicate resolution refused")
	_check(not turn.available("trainer") and turn.available("karmany"), "one budget per actor")
	var saved: Variant = JSON.parse_string(JSON.stringify(turn.snapshot()))
	var resumed := Turn.new()
	_check(resumed.restore(saved), "turn restores between actions")
	_check(not resumed.available("trainer") and resumed.available("karmany"), "resume cannot reset consumed action")
	_check(not resumed.begin("reset"), "started turn cannot be reset")
	_check(resumed.reserve("karmany", "first").is_empty(), "action ID replay refused across actors")
	var last := resumed.reserve("karmany", "second")
	_check(resumed.commit_action(last), "remaining Karmany action resolves")
	var ended := Turn.new()
	_check(ended.restore(resumed.snapshot()) and not ended.available("trainer"), "closed turn stays closed after restore")
	var optional := Turn.new()
	optional.begin("fixture_optional")
	var solo := optional.reserve("karmany", "solo")
	optional.commit_action(solo)
	_check(optional.close_turn() and not optional.available("trainer"), "optional trainer action can be skipped")
	saved = resumed.snapshot()
	saved.state = "open"
	_check(not Turn.new().restore(saved), "two-action open snapshot refused")
	saved = resumed.snapshot()
	saved.history[1].owner = saved.history[0].owner
	_check(not Turn.new().restore(saved), "duplicate actor history refused")

	# Fixture identities and definitions are test-only, not approved game content.
	var identity := {"trainer_id": "fixture_person", "type_id": "fixture_type_a", "personality_id": "fixture_personality_a"}
	var definitions := [
		{"id": "fixture_general", "access": "general", "trainer_types": [], "personalities": []},
		{"id": "fixture_special", "access": "special", "trainer_types": ["fixture_type_a"], "personalities": ["fixture_personality_a"]},
		{"id": "fixture_explosive", "access": "explosive", "trainer_types": ["fixture_type_a"], "personalities": ["fixture_personality_a"]}
	]
	var learning := Learning.new()
	_check(learning.configure(identity, definitions), "learning registry configured")
	_check(learning.learned_ids().is_empty(), "no powers granted automatically")
	_check(learning.learn_general("fixture_general"), "tree teaches configured general resonance")
	_check(not learning.learn_general("fixture_general"), "learning cannot be duplicated")
	_check(not learning.learn_general("fixture_special"), "tree does not bypass personal requirements")
	_check(not learning.learn_general("unknown"), "unknown resonance is not invented")
	_check(learning.unlock_personal("fixture_special"), "matching type and personality unlock special")
	_check(learning.unlock_personal("fixture_explosive"), "explosive access respects same identity requirements")
	_check(not learning.unlock_personal("fixture_special"), "personal unlock cannot repeat")
	var other_identity := identity.duplicate()
	other_identity.type_id = "fixture_type_b"
	var other := Learning.new()
	other.configure(other_identity, definitions)
	_check(other.learn_general("fixture_general"), "general learning works for another trainer type")
	_check(not other.unlock_personal("fixture_special"), "wrong type cannot unlock special")
	other_identity = identity.duplicate()
	other_identity.personality_id = "fixture_personality_b"
	other = Learning.new()
	other.configure(other_identity, definitions)
	_check(other.learn_general("fixture_general"), "general learning works for another personality")
	_check(not other.unlock_personal("fixture_explosive"), "wrong personality cannot unlock explosive")
	other_identity = identity.duplicate()
	other_identity.type_id = ""
	other_identity.personality_id = ""
	other = Learning.new()
	other.configure(other_identity, definitions)
	_check(other.learn_general("fixture_general"), "undecided type does not block general learning")
	var snapshot: Variant = JSON.parse_string(JSON.stringify(learning.snapshot()))
	var restored := Learning.new()
	_check(restored.restore(snapshot, identity, definitions) and restored.learned_ids().size() == 3, "learned resonances survive JSON snapshot")
	_check(not restored.configure(identity, []), "cannot silently erase an existing repertoire")
	var copied := restored.learned_ids()
	copied.clear()
	_check(restored.learned_ids().size() == 3, "caller cannot erase internal learning")
	snapshot.learned.append(snapshot.learned[0])
	_check(not Learning.new().restore(snapshot, identity, definitions), "duplicate saved learning refused")
	snapshot = learning.snapshot()
	other_identity = identity.duplicate()
	other_identity.trainer_id = "another_person"
	_check(not Learning.new().restore(snapshot, other_identity, definitions), "learning belongs to the correct trainer")
	var invalid_definitions := definitions.duplicate(true)
	invalid_definitions[0].trainer_types = ["fixture_type_a"]
	_check(not Learning.new().configure(identity, invalid_definitions), "general tree resonance cannot become class restricted")
	var structure := Structure.new()
	_check(structure.load_file(), "approved shared-turn configuration loads")
	_check(structure.rules().shared_turn.order == "trainer_first", "trainer-first game order is recorded")
	_check(structure.rules().resonance_learning.general_access == "any_trainer_type", "tree access does not depend on type")
	print("SHARED TURN/LEARNING TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
