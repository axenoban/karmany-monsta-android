extends RefCounted
# These regression suites freeze Preview 15 behavior for encounters already saved.
# New schema-2 battles are covered independently by tactical_tests.gd.
const Encounter = preload("res://scripts/trial_encounter.gd")
static func start(app: Node) -> bool:
	if not app.start_trial(): return false
	var data: Dictionary = app.profile.campaign.encounter
	if data.schema == 1: return true
	var encounter := Encounter.new()
	if not encounter.begin(data.id, app.profile.skill_tree, data.rolls, data.ally_species, data.ally_id): return false
	var profile: Dictionary = app.profile.duplicate(true)
	profile.campaign.encounter = encounter.snapshot()
	return app.commit_profile(profile)
