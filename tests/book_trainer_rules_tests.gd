extends SceneTree

const Books = preload("res://scripts/book_progression.gd")
const Structure = preload("res://scripts/combat_structure.gd")
const Team = preload("res://scripts/karmany_team.gd")
const Session = preload("res://scripts/capture_session.gd")
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
	var books := Books.new()
	_check(books.load_file(), "approved book levels load")
	var initial := books.policy_for("book_initial")
	var middle := books.policy_for("book_upgrade_1")
	var highest := books.policy_for("book_upgrade_2")
	_check(initial.chance_for("Común") == 0.45, "initial common 45 percent")
	_check(not initial.permits("Raro") and not initial.permits("Épico"), "initial rarities locked")
	_check(middle.chance_for("Común") == 0.60 and middle.chance_for("Raro") == 0.30, "first upgrade 60 and 30 percent")
	_check(not middle.permits("Épico"), "first upgrade epic locked")
	_check(highest.chance_for("Común") == 0.75 and highest.chance_for("Raro") == 0.45 and highest.chance_for("Épico") == 0.20, "second upgrade 75 45 20 percent")
	_check(not highest.permits("Legendario"), "no invented legendary rule")
	_check(books.policy_for("missing") == null, "unknown book has no fallback")
	var levels := books.all_levels()
	levels[1].chances["Común"] = 0.1
	_check(not books.load_data({"schema": 1, "levels": levels}), "decreasing book upgrade refused")
	_check(books.policy_for("book_upgrade_1").chance_for("Común") == 0.60, "bad upgrade keeps valid configuration")
	levels = books.all_levels()
	levels[1].id = levels[0].id
	_check(not books.load_data({"schema": 1, "levels": levels}), "duplicate book identity rejected")
	var session := Session.new()
	_check(not session.begin("actual_rates_test", true, true, "Raro", initial), "approved initial book blocks rare capture")
	_check(session.begin("actual_rates_test", true, true, "Común", initial), "approved common capture opens")
	_check(session.attempt("boundary", 0.45) and session.state == "offered", "exact probability boundary fails")
	_check(session.attempt("below_boundary", 0.449) and session.state == "captured", "below probability boundary succeeds")
	var structure := Structure.new()
	_check(structure.load_file(), "approved combat structure loads")
	_check(structure.rules().resonance_owner == "trainer", "trainer owns resonances")
	_check(structure.role_definition("healer").name == "Curador", "confirmed healer role exists")
	_check(not structure.trainer_skills_ready("healer"), "no unapproved healer ability silently supplied")
	_check(structure.role_definition("unapproved_role").is_empty(), "no invented trainer class")
	var wrong := structure.rules()
	wrong.resonance_owner = "karmany"
	_check(not structure.load_data(wrong), "Karmany resonance ownership rejected")
	_check(structure.rules().resonance_owner == "trainer", "bad structure preserves approved one")
	wrong = structure.rules()
	wrong.team_capacity = 4
	_check(not structure.load_data(wrong), "unapproved fourth party slot rejected")
	var team := Team.new()
	# Individuals below are isolated test records, not creatures granted to Ezel.
	var members := [{"instance_id": "test_1", "species_id": "tanugami"}, {"instance_id": "test_2", "species_id": "ushigane"}, {"instance_id": "test_3", "species_id": "kitsunibi"}]
	_check(team.configure(members, "test_1"), "three members and one active accepted")
	members.append({"instance_id": "test_4", "species_id": "inubari"})
	_check(not team.configure(members, "test_4"), "fourth member refused")
	_check(team.snapshot().active_id == "test_1", "invalid team preserves active individual")
	_check(not team.select_active("outsider"), "cannot activate outsider")
	_check(team.select_active("test_3") and team.snapshot().active_id == "test_3", "selecting member leaves exactly one active")
	var saved: Variant = JSON.parse_string(JSON.stringify(team.snapshot()))
	var restored := Team.new()
	_check(restored.restore(saved) and restored.snapshot().active_id == "test_3", "team survives JSON round trip")
	saved.members.append(saved.members[0])
	_check(not restored.restore(saved), "invalid restored team rejected")
	var copy := team.snapshot()
	copy.members[0].instance_id = "external mutation"
	_check(team.snapshot().members[0].instance_id == "test_1", "snapshot does not mutate internal team")
	_check(team.configure([], ""), "empty pre-collection team is representable")
	_check(not team.configure([], "ghost"), "empty team cannot have active member")
	print("BOOK/TRAINER RULES TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
