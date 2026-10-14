class_name TrialCampaign
extends RefCounted
const Roster = preload("res://scripts/trial_roster.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")

static func defaults() -> Dictionary:
	return {"schema": 1, "intro_seen": false, "sequence": 0, "victories": 0, "collection": [], "encounter": {}, "team": Roster.defaults()}

static func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("intro_seen") is bool:
		return false
	if not Encounter.integer(data.get("sequence"), 0, 1000000) or not Encounter.integer(data.get("victories"), 0, int(data.sequence)):
		return false
	if not data.get("collection") is Array or data.collection.size() > data.victories or not data.get("encounter") is Dictionary:
		return false
	var ids := {}
	for entry in data.collection:
		if not entry is Dictionary or entry.get("species") != "tanugami" or not entry.get("id") is String or entry.id.is_empty() or ids.has(entry.id):
			return false
		ids[entry.id] = true
	if data.has("team") and not Roster.valid(data.team, data):
		return false
	if not data.encounter.is_empty():
		if not Encounter.valid(data.encounter) or data.encounter.id != "jade-%d" % int(data.sequence):
			return false
		var ownership := {}
		for member in Roster.owned(data): ownership[member.instance_id] = member.species_id
		var ally_id: String = data.encounter.get("ally_id", Roster.STARTER)
		if ownership.get(ally_id) != data.encounter.get("ally_species", "zephyr"):
			return false
		if data.encounter.phase in ["battle", "capture"] and data.get("team", Roster.defaults()).active_id != ally_id:
			return false
		if data.encounter.phase == "captured" and not ids.has(data.encounter.id):
			return false
	return true

static func normalized(data: Dictionary) -> Dictionary:
	var result := data.duplicate(true)
	if not result.has("team"):
		result.team = Roster.defaults()
	result.team.schema = 1
	for key in ["schema", "sequence", "victories"]:
		result[key] = int(result[key])
	if not result.encounter.is_empty():
		result.encounter.enemy_pending = Encounter.enemy_pending_from(result.encounter)
		result.encounter.ally_species = result.encounter.get("ally_species", "zephyr")
		result.encounter.ally_id = result.encounter.get("ally_id", Roster.STARTER)
		result.encounter.last_action = Encounter.last_action_from(result.encounter)
		result.encounter.log = [] if result.encounter.last_action.is_empty() else [result.encounter.last_action]
		for key in ["schema", "round", "revision", "player_hp", "enemy_hp"]:
			result.encounter[key] = int(result.encounter[key])
		for key in ["schema", "sequence"]:
			result.encounter.turn[key] = int(result.encounter.turn[key])
		for id in result.encounter.loadout:
			result.encounter.loadout[id] = int(result.encounter.loadout[id])
		for id in result.encounter.ready:
			result.encounter.ready[id] = int(result.encounter.ready[id])
		if not result.encounter.capture.is_empty():
			result.encounter.capture.schema = 1
	return result
