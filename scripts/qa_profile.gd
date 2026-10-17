extends RefCounted
const Store = preload("res://scripts/save_store.gd")
const Route = preload("res://scripts/jade_route.gd")
const Progress = preload("res://scripts/level_progression.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const Combat = preload("res://scripts/tactical_encounter.gd")
static func species() -> Array:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/tactical_combat.json"))
	return data.species.keys()
static func preset(level: int, xp: int, members: Array, active: int, region: String, point: int, stamina: int) -> Dictionary:
	if level < 1 or level > 15 or xp < 0 or xp >= Progress.requirement(level) or members.size() < 1 or members.size() > 3 or active < 0 or active >= members.size() or region not in ["jade", "veil"] or point < 1 or point > 6 or stamina < 0 or stamina > 100: return {}
	var result := Store.defaults()
	result.journey = {"started":true, "visited_jade":true}
	result.skill_tree.level = level
	var campaign: Dictionary = result.campaign
	campaign.intro_seen = true
	campaign.progression.trainer_xp = xp
	campaign.team.members = []
	for i in range(members.size()):
		var member: Dictionary = members[i]
		if member.get("species", "") not in species() or member.get("level", 0) < 1 or member.get("level", 0) > 15: return {}
		var id: String = Roster.STARTER if member.species == "zephyr" else "qa-unit-%d" % i
		for existing in campaign.team.members:
			if existing.instance_id == id: return {}
		if member.species != "zephyr":
			campaign.collection.append({"id":id, "species":member.species})
			if member.species not in result.skill_tree.captured_species: result.skill_tree.captured_species.append(member.species)
		campaign.team.members.append({"instance_id":id, "species_id":member.species})
		campaign.progression.units[id] = {"level":int(member.level), "xp":0}
	campaign.team.active_id = campaign.team.members[active].instance_id
	campaign.route.selected = region
	var completions: Array = []
	for i in range(point - 1):
		completions.append({"point_id":Route.points(region)[i].id,"encounter_id":"jade-%d" % (i + 1)})
	if region == "jade": campaign.route.completed = completions
	else: campaign.route.regions[region] = {"completed":completions}
	campaign.victories = maxi(completions.size(), campaign.collection.size())
	campaign.sequence = campaign.victories
	campaign.exploration.value = stamina
	campaign.exploration.anchor = 0 if stamina == 100 else int(Time.get_unix_time_from_system())
	return result if Store.valid(result) else {}
