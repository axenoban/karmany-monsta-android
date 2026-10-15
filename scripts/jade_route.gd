extends RefCounted
const Legacy = preload("res://scripts/trial_encounter.gd")
const Rules = preload("res://scripts/progression_rules.gd")
static var _regions: Dictionary = {}
static var _definition: Dictionary = {}
static func points(region_id: String = "jade") -> Array:
	if region_id == "jade":
		if _definition.is_empty(): _definition = JSON.parse_string(FileAccess.get_file_as_string("res://data/jade_route.json"))
		return _definition.points.duplicate(true)
	var config := Rules.region(region_id)
	if not config.has("route_file"): return []
	if not _regions.has(region_id):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(config.route_file))
		if not parsed is Dictionary or not parsed.get("points") is Array: return []
		_regions[region_id] = parsed
	return _regions[region_id].points.duplicate(true)
static func region_for(id: String) -> String:
	for region in Rules.rules().regions:
		for entry in points(region.id):
			if entry.id == id: return region.id
	return ""
static func entry_cost(id: String) -> int:
	if point(id).has("cost"): return int(point(id).cost)
	var entries := points()
	for i in range(entries.size()):
		if entries[i].id == id: return int(preload("res://scripts/exploration_energy.gd").rules().entry_costs[i]) if i < preload("res://scripts/exploration_energy.gd").rules().entry_costs.size() else 0
	return 0
static func point(id: String) -> Dictionary:
	for entry in points(region_for(id)):
		if entry.id == id: return entry
	return {}
static func defaults() -> Dictionary:
	return {"schema": 1, "completed": [], "current": {}}
static func completions(data: Dictionary, region_id: String = "jade") -> Array:
	return data.completed if region_id == "jade" else data.get("regions",{}).get(region_id,{}).get("completed",[])
static func completed(data: Dictionary, id: String) -> bool:
	for entry in completions(data,region_for(id)):
		if entry.point_id == id: return true
	return false
static func unlocked(data: Dictionary, id: String) -> bool:
	for entry in points(region_for(id)):
		if entry.id == id: return true
		if not completed(data, entry.id): return false
	return false
static func next_point(data: Dictionary, region_id: String = "jade") -> String:
	for entry in points(region_id):
		if not completed(data, entry.id): return entry.id
	return ""
static func encounter_id_valid(id: Variant, sequence: int) -> bool:
	if not id is String or not id.begins_with("jade-"): return false
	var suffix: String = id.trim_prefix("jade-")
	return suffix.is_valid_int() and int(suffix) > 0 and int(suffix) <= sequence and id == "jade-%d" % int(suffix)
static func valid(data: Variant, campaign: Dictionary) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("completed") is Array or not data.get("current") is Dictionary: return false
	if data.has("regions"):
		if not data.regions is Dictionary: return false
		for key in data.regions:
			if key == "jade" or Rules.region(key).is_empty() or not data.regions[key] is Dictionary or not data.regions[key].get("completed") is Array: return false
	var ids := {}
	var total := 0
	for region in Rules.rules().regions:
		var entries := completions(data,region.id)
		if entries.size() > points(region.id).size(): return false
		total += entries.size()
		for i in range(entries.size()):
			var entry: Variant = entries[i]
			if not entry is Dictionary or entry.get("point_id") != points(region.id)[i].id or not encounter_id_valid(entry.get("encounter_id"), int(campaign.sequence)) or ids.has(entry.encounter_id): return false
			ids[entry.encounter_id] = true
	if total > campaign.victories: return false
	if data.current.is_empty(): return true
	var current: Dictionary = data.current
	if not current.get("point_id") is String or not unlocked(data, current.point_id) or point(current.point_id).is_empty(): return false
	var encounter: Dictionary = campaign.encounter
	if encounter.is_empty() or encounter.get("schema") != 2 or current.get("encounter_id") != encounter.get("id") : return false
	if encounter.has("regional"):
		if encounter.regional.point_id != current.point_id or encounter.regional.region != region_for(current.point_id): return false
		if encounter.regional.enemies[0].species_id != point(current.point_id).species: return false
	elif encounter.get("enemy_species") != point(current.point_id).species: return false
	var won: bool = encounter.get("phase") in ["capture", "captured", "escaped"]
	# A completed point may be replayed. Only the first winning encounter is its receipt.
	for entry in completions(data,region_for(current.point_id)):
		if entry.encounter_id == encounter.id and (not won or entry.point_id != current.point_id): return false
	if won and not completed(data, current.point_id): return false
	return true
static func record_victory(data: Dictionary, encounter_id: String) -> Dictionary:
	var result := data.duplicate(true)
	if result.current.get("encounter_id") != encounter_id: return result
	var id: String = result.current.point_id
	if not completed(result, id) and unlocked(result, id):
		var region_id := region_for(id)
		if region_id != "jade":
			if not result.has("regions"): result.regions = {}
			if not result.regions.has(region_id): result.regions[region_id] = {"completed":[]}
		completions(result,region_id).append({"point_id": id, "encounter_id": encounter_id})
	return result
