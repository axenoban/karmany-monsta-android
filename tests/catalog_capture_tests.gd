extends SceneTree

const Catalog = preload("res://scripts/species_catalog.gd")
const Policy = preload("res://scripts/book_capture_policy.gd")
const Session = preload("res://scripts/capture_session.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + label)

func _run() -> void:
	var catalog := Catalog.new()
	_check(catalog.load_file(), "canonical catalog loads")
	_check(catalog.all_entries().size() == 21, "21 recovered Jade and Veil entries")
	_check(catalog.all_entries("Común").size() == 15, "source has 15 common species")
	_check(catalog.all_entries("Raro").size() == 5, "source has 5 rare species")
	_check(catalog.all_entries("Épico").size() == 1, "source has one epic species")
	_check(catalog.find_species("kirin_chigo").rarity == "Épico", "canonical Kirin-Chigo rarity")
	var tanugami := catalog.find_species("tanugami")
	tanugami.name = "mutated outside catalog"
	_check(catalog.find_species("tanugami").name == "Tanugami", "catalog callers cannot mutate source")
	var entries := catalog.all_entries()
	entries.append(entries[0])
	_check(not catalog.load_data({"schema": 1, "species": entries}), "duplicate IDs rejected")
	_check(catalog.all_entries().size() == 21, "bad reload preserves valid catalog")
	entries = catalog.all_entries()
	entries[0].resonance.erase("shadow")
	_check(not catalog.load_data({"schema": 1, "species": entries}), "missing canonical field rejected")
	# Synthetic values below are test fixtures, not approved probabilities or rarity names.
	var policy := Policy.new()
	_check(not policy.configure({"id": "test", "chances": {}}), "empty table is not silently balanced")
	_check(not policy.configure({"id": "test", "chances": {"fixture_a": NAN}}), "NaN probability rejected")
	_check(not policy.configure({"id": "test", "chances": {"fixture_a": 1.01}}), "out of range probability rejected")
	_check(policy.configure({"id": "fixture_v1", "chances": {"fixture_a": 0.25}}), "test-only policy accepted")
	_check(not policy.permits("fixture_b"), "missing rarity is locked")
	var upgraded := Policy.new()
	upgraded.configure({"id": "fixture_v2", "chances": {"fixture_a": 0.5, "fixture_b": 0.1}})
	_check(upgraded.upgrade_preserves_access(policy), "upgrade supports improved chance and newly allowed rarity")
	var downgrade := Policy.new()
	downgrade.configure({"id": "fixture_bad", "chances": {"fixture_a": 0.1}})
	_check(not downgrade.upgrade_preserves_access(policy), "upgrade cannot silently lower old chance")
	var session := Session.new()
	_check(not session.begin("encounter_1", false, true, "fixture_a", policy), "capture requires defeat")
	_check(not session.begin("encounter_1", true, false, "fixture_a", policy), "canonical sealing restriction respected")
	_check(not session.begin("encounter_1", true, true, "fixture_b", policy), "locked rarity does not consume attempt")
	_check(not session.begin("encounter_1", true, true, "fixture_a", Policy.new()), "missing book table blocks capture explicitly")
	_check(session.begin("encounter_1", true, true, "fixture_a", policy), "eligible defeated encounter opens capture")
	_check(not session.attempt("bad", NAN) and session.attempts_used() == 0, "invalid roll consumes no attempt")
	_check(session.attempt("action_1", 0.75) and session.remaining_attempts() == 2, "first failed attempt consumes exactly one")
	_check(not session.attempt("action_1", 0.0) and session.attempts_used() == 1, "double tap cannot retry same action")
	var snapshot: Variant = JSON.parse_string(JSON.stringify(session.snapshot()))
	var resumed := Session.new()
	_check(resumed.restore(snapshot, policy) and resumed.remaining_attempts() == 2, "JSON snapshot preserves attempts after resume")
	_check(not resumed.begin("encounter_1", true, true, "fixture_a", policy), "resume cannot reset same session")
	_check(not resumed.attempt("action_1", 0.0), "replayed action after restore is rejected")
	_check(resumed.attempt("action_2", 0.75) and resumed.remaining_attempts() == 1, "second failed attempt")
	_check(resumed.attempt("action_3", 0.75) and resumed.state == "escaped", "third failure ends encounter with escape")
	_check(not resumed.attempt("action_4", 0.0) and resumed.attempts_used() == 3, "fourth attempt impossible")
	var ended := Session.new()
	_check(ended.restore(resumed.snapshot(), policy) and not ended.attempt("action_4", 0.0), "escaped snapshot stays terminal")
	var reencounter := Session.new()
	_check(reencounter.begin("encounter_2", true, true, "fixture_a", policy), "later encounter can offer same species again")
	_check(reencounter.attempt("new_action", 0.0) and reencounter.state == "captured", "successful capture ends session")
	_check(not reencounter.attempt("duplicate_reward", 0.0), "captured session cannot produce another capture")
	var incompatible := Session.new()
	_check(not incompatible.restore(snapshot, upgraded), "changed policy is explicit, not a reset")
	snapshot.actions = ["same", "same"]
	_check(not Session.new().restore(snapshot, policy), "duplicate action history rejected")
	snapshot = session.snapshot()
	snapshot.state = "escaped"
	_check(not Session.new().restore(snapshot, policy), "escape with fewer than 3 attempts rejected")
	print("CATALOG/CAPTURE TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
