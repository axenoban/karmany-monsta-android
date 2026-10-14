extends SceneTree
const Roster = preload("res://scripts/trial_roster.gd")
const Campaign = preload("res://scripts/trial_campaign.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const Store = preload("res://scripts/save_store.gd")
const PATH := "user://roster_test.json"
var checks := 0
var failures := 0
func _initialize() -> void: call_deferred("_run")
func _check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(label)
func _campaign() -> Dictionary:
	var c := Campaign.defaults()
	c.sequence = 3
	c.victories = 3
	for i in range(1, 4): c.collection.append({"id": "jade-%d" % i, "species": "tanugami"})
	return c
func _run() -> void:
	var c := _campaign()
	var roster := Roster.new()
	_check(Campaign.valid(c) and c.team.active_id == Roster.STARTER, "starter team is valid and linked to owned Zephyr")
	_check(Roster.owned(c).size() == 4, "captured individuals remain distinct")
	c.team = roster.change(c, "add", "jade-1")
	_check(c.team.members.size() == 2, "captured creature joins roster")
	_check(roster.change(c, "add", "jade-1").is_empty(), "same individual cannot occupy two slots")
	c.team = roster.change(c, "add", "jade-2")
	_check(c.team.members.size() == 3 and roster.change(c, "add", "jade-3").is_empty(), "three-member capacity enforced")
	c.team = roster.change(c, "active", "jade-2")
	_check(c.team.active_id == "jade-2", "reserve can become active before battle")
	_check(roster.change(c, "active", "unknown").is_empty(), "unknown active rejected")
	c.team = roster.change(c, "remove", "jade-2")
	_check(c.team.active_id == Roster.STARTER and c.collection.size() == 3, "removing active selects valid remaining member without deleting capture")
	c.team = roster.change(c, "remove", "jade-1")
	_check(roster.change(c, "remove", Roster.STARTER).is_empty(), "last member cannot be removed")
	_check(roster.change(c, "add", "unknown").is_empty(), "nonowned creature cannot be added")
	var invalid := c.duplicate(true)
	invalid.team.members[0].species_id = "tanugami"
	_check(not Campaign.valid(invalid), "forged species identity rejected")
	var legacy := c.duplicate(true)
	legacy.erase("team")
	_check(Campaign.valid(legacy) and Campaign.normalized(legacy).team == Roster.defaults(), "older campaign adds starter team on migration")
	var app := root.get_node("App")
	app.storage = Store.new(PATH)
	app.profile = Store.defaults()
	app.profile.campaign = _campaign()
	app.load_failed = false
	_check(app.change_team("add", "jade-1") and app.change_team("active", "jade-1"), "app commits selection")
	_check(app.storage.load_profile().campaign.team == app.profile.campaign.team, "team persists across reopening")
	_check(app.start_trial() and app.profile.campaign.encounter.ally_species == "tanugami" and app.profile.campaign.encounter.ally_id == "jade-1", "new battle uses selected captured individual")
	var e := Encounter.new()
	e.restore(app.profile.campaign.encounter)
	e.act("karmany", "golpe")
	_check(e.last_action_text() == "Última acción: Tanugami aliado · Golpe · 12 de daño.", "latest action names the selected ally")
	var before: Dictionary = app.profile.duplicate(true)
	_check(not app.change_team("active", Roster.STARTER) and app.profile == before, "active encounter blocks roster mutation")
	app.trial_action("retreat")
	_check(app.change_team("active", Roster.STARTER), "roster unlocks after retreat")
	app.storage = Store.new("user://missing-roster-directory/profile.json")
	before = app.profile.duplicate(true)
	_check(not app.change_team("remove", "jade-1") and app.profile == before, "write failure preserves selected team")
	app.storage = Store.new(PATH)
	var packed: PackedScene = load("res://scenes/main.tscn")
	var main := packed.instantiate()
	root.add_child(main)
	main._show("team")
	await process_frame
	_check(main.get_node_or_null("Page") != null, "team screen builds with owned individuals")
	main._show("collection")
	await process_frame
	_check(main.get_node_or_null("Page") != null, "collection builds add-to-team controls")
	app.start_journey()
	_check(app.profile.campaign.team == Roster.defaults() and app.profile.campaign.collection.is_empty(), "confirmed new journey resets team and captures together")
	main.queue_free()
	await process_frame
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(PATH + suffix): DirAccess.remove_absolute(PATH + suffix)
	print("ROSTER TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
