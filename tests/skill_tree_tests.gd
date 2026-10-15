extends SceneTree

const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Store = preload("res://scripts/save_store.gd")
const Catalog = preload("res://scripts/species_catalog.gd")
const PATH := "user://skill_tree_test_profile.json"
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)

func _clean() -> void:
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix):
			DirAccess.remove_absolute(PATH + suffix)

func _run() -> void:
	preload("res://tests/legacy_world_fixture.gd").activate()
	var tree := TreeModel.new()
	_check(TreeModel.valid(tree.snapshot()), "initial state is valid")
	_check(tree.points_available() == 1 and tree.state.level == 1, "one starting point")
	_check(not tree.purchase("unknown"), "unknown node refused")
	_check(not tree.purchase("control"), "locked child refused")
	_check(not tree.equip("curacion"), "cannot equip unlearned resonance")
	_check(tree.purchase("curacion") and tree.points_available() == 0, "learning spends one point")
	_check(not tree.purchase("curacion") and tree.state.ranks.curacion == 1, "level gate protects upgrade")
	_check(tree.equip("curacion"), "learned resonance can equip")
	_check(not tree.equip("curacion"), "duplicate equip refused")
	_check(tree.unequip("curacion") and not tree.unequip("curacion"), "unequip is not duplicated")
	_check(tree.gain_level() and tree.points_available() == 1, "level grants a point")
	_check(tree.purchase("potenciacion"), "learned parent unlocks child")
	var catalog := Catalog.new()
	catalog.load_file()
	var entries := catalog.all_entries()
	for i in range(4):
		_check(tree.record_capture(entries[i].id), "distinct capture recorded")
	_check(tree.points_available() == 0, "four species do not grant threshold reward")
	_check(tree.record_capture(entries[4].id) and tree.points_available() == 1, "fifth species grants one point")
	_check(not tree.record_capture(entries[4].id) and tree.points_available() == 1, "duplicate species cannot farm points")
	_check(not tree.record_capture("unknown_species"), "unknown species does not create capture reward")
	for i in range(5, 15):
		tree.record_capture(entries[i].id)
	_check(tree.points_available() == 3, "10 and 15 species thresholds grant one point each")
	for i in range(8):
		tree.gain_level()
	_check(tree.state.level == 10 and not tree.gain_level(), "prototype level cap respected")
	_check(tree.purchase("curacion") and is_equal_approx(tree.power_multiplier("curacion"), 1.1), "rank two improves multiplier")
	_check(tree.purchase("curacion") and is_equal_approx(tree.power_multiplier("curacion"), 1.2), "rank three improves multiplier")
	_check(not tree.purchase("curacion"), "maximum rank cannot spend another point")
	var snapshot: Variant = JSON.parse_string(JSON.stringify(tree.snapshot()))
	var resumed := TreeModel.new()
	_check(resumed.restore(snapshot) and resumed.snapshot() == tree.snapshot(), "JSON state normalizes numeric fields")
	snapshot.level = 1.5
	_check(not resumed.restore(snapshot), "fractional level refused")
	snapshot = tree.snapshot()
	snapshot.captured_species.append(snapshot.captured_species[0])
	_check(not TreeModel.valid(snapshot), "duplicate saved captures refused")
	var full := TreeModel.new()
	for i in range(4):
		full.gain_level()
	for node_id in ["curacion", "proteccion", "propia", "potenciacion", "control"]:
		_check(full.purchase(node_id), "five prototype nodes can learn")
	for node_id in ["curacion", "proteccion", "propia", "potenciacion"]:
		_check(full.equip(node_id), "equip slot filled")
	_check(not full.equip("control") and full.state.equipped.size() == 4, "fifth equip refused including exclusive slot")
	_check(full.unequip("propia") and full.equip("control"), "swap frees exactly one slot")
	snapshot = full.snapshot()
	snapshot.equipped.append("propia")
	_check(not TreeModel.valid(snapshot), "five-slot saved loadout refused")
	snapshot = full.snapshot()
	snapshot.equipped[1] = snapshot.equipped[0]
	_check(not TreeModel.valid(snapshot), "duplicate saved equip refused")
	full.reset_allocation()
	_check(full.points_available() == 5 and full.state.equipped.is_empty(), "test redistribution refunds allocation without removing level")
	snapshot = TreeModel.defaults()
	snapshot.ranks = {"curacion": 1, "proteccion": 1}
	_check(not TreeModel.valid(snapshot), "overspent save refused")
	_clean()
	var legacy := {"schema": 1, "settings": {"large_text": true, "haptics": false}, "journey": {"started": true, "visited_jade": true}}
	var handle := FileAccess.open(PATH, FileAccess.WRITE)
	handle.store_string(JSON.stringify(legacy))
	handle.close()
	var store := Store.new(PATH)
	var migrated := store.load_profile()
	_check(migrated.schema == 3 and migrated.journey.visited_jade and migrated.settings.large_text, "old APK save migrates without losing visit or settings")
	_check(migrated.skill_tree == TreeModel.defaults(), "migration adds a fresh tree only")
	_check(JSON.parse_string(FileAccess.get_file_as_string(PATH)).schema == 1, "read-only migration preserves original bytes")
	migrated.skill_tree = tree.snapshot()
	_check(store.save_profile(migrated), "migrated progress saves as current schema")
	_check(Store.new(PATH).load_profile() == migrated, "tree persists through reopening")
	_check(Store.valid(JSON.parse_string(JSON.stringify(migrated))), "JSON float schema versions are accepted")
	var invalid := migrated.duplicate(true)
	invalid.schema = 3.5
	_check(not Store.valid(invalid), "fractional schema version refused")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	_check(app.change_tree("purchase", "curacion", 0), "app commits initial learning")
	_check(not app.change_tree("purchase", "curacion", 0), "stale double click consumes no second point")
	_check(app.change_tree("equip", "curacion"), "app commits loadout")
	_check(app.storage.load_profile().skill_tree.equipped == ["curacion"], "equipped resonance persists")
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-directory-for-tree/profile.json")
	_check(not app.change_tree("level") and app.profile == before, "failed disk write rolls back visible progress")
	app.storage = Store.new(PATH)
	_check(app.start_journey() and app.profile.skill_tree == TreeModel.defaults(), "new journey resets tree and preserves existing settings")
	_clean()
	print("SKILL TREE TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
