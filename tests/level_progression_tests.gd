extends SceneTree
const Progress = preload("res://scripts/level_progression.gd")
const Rules = preload("res://scripts/progression_rules.gd")
const Store = preload("res://scripts/save_store.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Campaign = preload("res://scripts/trial_campaign.gd")
const Readout = preload("res://scripts/combat_readout.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const PATH := "user://level-progression-tests.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + label)
func profile(app: Node, level: int = 1) -> void:
	app.response_timer.stop()
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.profile.skill_tree.level = level
	app.load_failed = false
func winning_state(app: Node) -> void:
	app.discover_location(app.profile.campaign.encounter.id)
	var e := Tactical.new()
	e.restore(app.profile.campaign.encounter)
	e.state.enemy.hp = 1
	e.state.rolls = [0.5, 0.1, 0.1]
	e._sync()
	app.profile.campaign.encounter = e.snapshot()
func button(node: Node, prefix: String) -> Button:
	if node is Button and node.text.begins_with(prefix): return node
	for child in node.get_children():
		var found := button(child, prefix)
		if found != null: return found
	return null
func run() -> void:
	preload("res://tests/legacy_world_fixture.gd").activate()
	var app := root.get_node("App")
	check(Progress.advance({"level": 1, "xp": 75}, 25, 10) == {"level": 2, "xp": 0}, "100 XP times current level")
	check(Progress.advance({"level": 9, "xp": 895}, 25, 10) == {"level": 10, "xp": 0}, "regional cap discards surplus")
	check(Progress.advance({"level": 11, "xp": 20}, 25, 10) == {"level": 11, "xp": 20}, "above-cap individuals unchanged")
	check(Progress.gained({"level":9,"xp":895},{"level":10,"xp":0}) == 5, "reward displays applied XP at cap")
	for species in Catalog.all_species():
		for level in [1,2,5,10]:
			var base := Catalog.stats(species)
			var stats := Catalog.stats_at_level(species, level)
			for key in ["life", "attack", "defense"]: check(stats[key] == roundi(base[key] * (1.0 + .05 * (level - 1))), "approved stat growth " + species + key)
			check(stats.speed == base.speed and stats.signature == base.signature, "speed and skill definitions unchanged")
	profile(app, 10)
	app.profile.campaign.sequence = 3
	app.profile.campaign.victories = 3
	for i in range(1,4): app.profile.campaign.collection.append({"id":"jade-%d" % i,"species":"tanugami"})
	app.profile.campaign.team.members.append({"instance_id":"jade-1","species_id":"tanugami"})
	app.profile.campaign.team.members.append({"instance_id":"jade-2","species_id":"tanugami"})
	app.profile.campaign.progression = Progress.normalized(app.profile.campaign)
	var units: Dictionary = app.profile.campaign.progression.units
	units[Roster.STARTER] = {"level":9,"xp":895}
	units["jade-2"] = {"level":10,"xp":0}
	units["jade-3"].xp = 18
	check(app.start_route("jade_point_1"), "paid route starts with persistent individual levels")
	var original: Dictionary = app.profile.campaign.encounter.duplicate(true)
	check(original.members[0].level == 9 and original.members[2].level == 10, "encounter snapshots levels at entry")
	winning_state(app)
	app.profile.campaign.encounter.members[1].hp = 0
	var rev: int = app.profile.campaign.encounter.revision
	var before: Dictionary = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-level-directory/profile.json")
	check(not app.trial_action("karmany", "golpe", rev) and app.profile == before, "failed win write grants neither XP nor reward")
	app.storage = Store.new(PATH)
	check(app.trial_action("karmany", "golpe", rev), "victory grants transactional XP")
	var progress: Dictionary = app.profile.campaign.progression
	check(app.profile.skill_tree.level == 10 and progress.trainer_xp == 0, "capped trainer gains no XP")
	check(progress.units[Roster.STARTER] == {"level":10,"xp":0}, "eligible starter reaches cap")
	check(progress.units["jade-1"].xp == 25, "team member earns XP even if no longer active")
	check(progress.units["jade-2"].xp == 0 and progress.units["jade-3"].xp == 18, "capped and non-team duplicate individuals gain none")
	check(progress.last_reward.rows[1].gained == 5 and progress.last_reward.rows[0].gained == 0, "reward receipt states actual gains")
	check(not app.trial_action("karmany", "golpe", rev) and app.profile.campaign.progression == progress, "stale winning callback cannot duplicate XP")
	check(app.storage.load_profile() == app.profile, "complete progression roundtrips through JSON")
	app.trial_action("capture") # .5 fails initial
	check(app.profile.campaign.encounter.phase == "capture", "initial book still uses 45 percent")
	check(not app.purchase_unlock("book_upgrade_1"), "no book upgrades during active capture")
	app.trial_action("capture") # .1 succeeds
	check(app.profile.campaign.progression.units["jade-4"] == {"level":1,"xp":0}, "new capture starts level one without victory XP")
	check(app.profile.campaign.progression.units["jade-1"].xp == 25, "capture itself does not re-award victory XP")
	check(app.purchase_unlock("book_upgrade_1") and app.purchase_unlock("book_upgrade_2"), "level gates and sequential book purchases")
	var tree := TreeModel.new()
	tree.restore(app.profile.skill_tree)
	check(tree.points_available() == 7 and Rules.current_book(tree.state) == "book_upgrade_2", "book costs share skill points")
	check(not app.purchase_unlock("book_upgrade_2") and tree.points_available() == 7, "duplicate purchase refused")
	app.change_tree("purchase", "curacion")
	check(app.redistribute_resonances(), "normal UI redistribution supported")
	tree.restore(app.profile.skill_tree)
	check(tree.points_available() == 7 and tree.state.ranks.is_empty() and tree.state.unlocks.size() == 2, "redistribution retains permanent unlock spending")
	check(app.start_trial("tanugami"), "new training encounter starts")
	var upgraded: Dictionary = app.profile.campaign.encounter
	check(upgraded.book_id == "book_upgrade_2" and upgraded.members[0].level == 10, "new encounter uses upgraded book and scaled stats")
	var readout := Readout.build(upgraded)
	check(readout.active.max_hp == 116 and readout.active.attack == 29, "combat readout uses frozen level stats")
	winning_state(app)
	check(app.trial_action("karmany", "golpe") and app.profile.campaign.progression.last_reward.region == "", "free training records no XP source")
	check(app.profile.campaign.progression.units["jade-1"].xp == 25, "free training grants no unit XP")
	check(app.trial_action("capture") and app.profile.campaign.encounter.phase == "captured", "upgraded book uses approved 75 percent with same .5 roll")
	profile(app)
	check(not app.purchase_unlock("book_upgrade_1"), "trainer level gate enforced")
	app.profile.skill_tree.level = 4
	app.profile.skill_tree.ranks = {"curacion":2, "proteccion":2}
	check(not app.purchase_unlock("book_upgrade_1"), "shared points insufficient after resonance purchases")
	check(app.redistribute_resonances() and app.purchase_unlock("book_upgrade_1"), "redistribution prevents progression deadlock")
	app.profile.skill_tree.level = 8
	before = app.profile.duplicate(true)
	app.storage = Store.new("user://missing-book-directory/profile.json")
	check(not app.purchase_unlock("book_upgrade_2") and app.profile == before, "failed book write consumes no points")
	app.storage = Store.new(PATH)
	profile(app, 8)
	app.profile.campaign.progression.trainer_xp = 75
	check(app.start_route("jade_point_1"), "old-policy checkpoint starts")
	winning_state(app)
	app.trial_action("karmany", "golpe")
	var old_capture: Dictionary = app.profile.campaign.encounter.duplicate(true)
	old_capture.erase("book_id")
	for member in old_capture.members: member.erase("level")
	var restored := Tactical.new()
	check(restored.restore(JSON.parse_string(JSON.stringify(old_capture))), "pre-progression capture restores with original policy")
	check(restored.attempt_capture() and restored.state.phase == "capture", "legacy .5 roll still fails original policy")
	var old_profile := Store.defaults()
	old_profile.skill_tree.level = 8
	old_profile.skill_tree.erase("unlocks")
	old_profile.campaign.erase("progression")
	check(app.storage.save_profile(old_profile), "previous APK profile remains valid")
	var migrated: Dictionary = app.storage.load_profile()
	check(migrated.skill_tree.level == 8 and migrated.campaign.progression.trainer_xp == 0 and migrated.campaign.progression.units[Roster.STARTER].level == 1, "migration retains trainer level and creates honest unit history")
	var invalid := migrated.duplicate(true)
	invalid.campaign.progression.units[Roster.STARTER].level = 1.5
	check(not Store.valid(invalid), "fractional unit level rejected")
	invalid = migrated.duplicate(true)
	invalid.campaign.progression.trainer_xp = 800
	check(not Store.valid(invalid), "unresolved trainer XP threshold rejected")
	invalid = migrated.duplicate(true)
	invalid.skill_tree.unlocks = ["book_upgrade_2"]
	check(not Store.valid(invalid), "forged unlock order rejected")
	profile(app)
	app.profile.campaign.progression.trainer_xp = 75
	app.profile.campaign.progression.units[Roster.STARTER] = {"level":1,"xp":75}
	check(app.start_route("jade_point_1"), "threshold award route begins")
	winning_state(app)
	check(app.trial_action("karmany", "golpe"), "threshold award persists")
	check(app.profile.skill_tree.level == 2 and app.profile.campaign.progression.trainer_xp == 0, "trainer gains level from XP threshold")
	check(app.profile.campaign.progression.units[Roster.STARTER] == {"level":2,"xp":0}, "unit gains level independently")
	check(app.profile.campaign.encounter.members[0].level == 1, "level-up does not rewrite active encounter stats")
	tree.restore(app.profile.skill_tree)
	check(tree.points_available() == 2, "new trainer level adds exactly one skill point")
	app.trial_action("capture")
	app.trial_action("capture")
	check(app.start_trial("tanugami") and app.profile.campaign.encounter.player_hp == 84, "next encounter applies increased maximum HP")
	var reloaded: Dictionary = app.storage.load_profile()
	check(reloaded.campaign.progression == app.profile.campaign.progression and reloaded.skill_tree == app.profile.skill_tree and reloaded.campaign.encounter.members == app.profile.campaign.encounter.members, "leveled records and frozen stats roundtrip exactly")
	for i in range(3):
		var original_roll: float = app.profile.campaign.encounter.rolls[i]
		var saved_roll: float = reloaded.campaign.encounter.rolls[i]
		check(is_equal_approx(original_roll, saved_roll), "JSON reload retains random draw without reroll")
		for chance in [.45, .60, .75]: check((original_roll < chance) == (saved_roll < chance), "reloaded draw preserves every approved book outcome")
	profile(app)
	app.profile.campaign.progression.units[Roster.STARTER] = {"level":11,"xp":20}
	app.start_route("jade_point_1")
	winning_state(app)
	app.trial_action("karmany", "golpe")
	check(app.profile.campaign.progression.units[Roster.STARTER] == {"level":11,"xp":20} and app.profile.campaign.progression.trainer_xp == 25, "above-cap unit gains no XP while trainer below cap does")
	check(not Rules.region_reason(app.profile.skill_tree, "unknown").is_empty(), "undefined region has no invented access")
	var tier1 := Tactical.new()
	tier1.begin("tier-one", TreeModel.defaults(), [0.5,0.9,0.9], Roster.defaults(), "tanugami", "book_upgrade_1")
	tier1.state.enemy.hp = 1
	tier1._sync()
	tier1.act("karmany", "golpe")
	check(tier1.state.capture.chance == 0.6 and tier1.attempt_capture() and tier1.state.phase == "captured", "first book upgrade actually resolves at sixty percent")
	profile(app, 4)
	check(app.purchase_unlock("book_upgrade_1") and app.start_route("jade_point_1"), "first tier starts a persistent paid encounter")
	winning_state(app)
	check(app.trial_action("karmany", "golpe") and app.storage.load_profile().campaign.encounter.capture.chance == 0.6, "sixty-percent capture policy persists with full float precision")
	check(app.trial_action("capture") and app.storage.load_profile().campaign.encounter.phase == "captured", "first tier capture success persists through JSON")
	# Deterministic battles across approved levels: scaled HP/damage remain valid.
	for level in [1,5,10]:
		for species in ["tanugami", "ushigane", "kitsunibi", "sakuromushi"]:
			var e := Tactical.new()
			var team := {"members":[{"instance_id":Roster.STARTER,"species_id":"zephyr","level":level}],"active_id":Roster.STARTER}
			check(e.begin("simulation", TreeModel.defaults(), [0.1,0.2,0.3], team, species), "scaled simulation begins")
			var steps := 0
			while e.state.phase == "battle" and steps < 100:
				e.act("karmany", "insignia" if e.reason("karmany", "insignia").is_empty() else "golpe")
				if e.state.phase == "battle": e.end_round()
				steps += 1
			check(e.state.phase == "capture" and Tactical.valid(e.snapshot()), "scaled simulation terminates in a valid victory")
	# UI checks exercise real purchase confirmations and level text.
	profile(app, 4)
	root.size = Vector2i(1280,720)
	var main: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	main._show("book")
	await process_frame
	check(button(main,"Adquirir Mejora 1") != null and not button(main,"Adquirir Mejora 1").disabled, "book UI exposes eligible upgrade")
	main._show("team")
	await process_frame
	check(main.get_node_or_null("Page") != null, "team XP layout builds")
	main.queue_free()
	await process_frame
	app.response_timer.stop()
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH+suffix): DirAccess.remove_absolute(PATH+suffix)
	print("LEVEL PROGRESSION: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
