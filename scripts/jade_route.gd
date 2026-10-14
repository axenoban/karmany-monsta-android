extends RefCounted
const Legacy = preload("res://scripts/trial_encounter.gd")
static var _definition: Dictionary = {}
static func points() -> Array:
	if _definition.is_empty(): _definition = JSON.parse_string(FileAccess.get_file_as_string("res://data/jade_route.json"))
	return _definition.points.duplicate(true)
static func entry_cost(id: String) -> int:
	var entries := points()
	for i in range(entries.size()):
		if entries[i].id == id: return int(preload("res://scripts/exploration_energy.gd").rules().entry_costs[i])
	return 0
static func point(id: String) -> Dictionary:
	for entry in points():
		if entry.id == id: return entry
	return {}
static func defaults() -> Dictionary:
	return {"schema": 1, "completed": [], "current": {}}
static func completed(data: Dictionary, id: String) -> bool:
	for entry in data.completed:
		if entry.point_id == id: return true
	return false
static func unlocked(data: Dictionary, id: String) -> bool:
	for entry in points():
		if entry.id == id: return true
		if not completed(data, entry.id): return false
	return false
static func next_point(data: Dictionary) -> String:
	for entry in points():
		if not completed(data, entry.id): return entry.id
	return ""
static func encounter_id_valid(id: Variant, sequence: int) -> bool:
	if not id is String or not id.begins_with("jade-"): return false
	var suffix: String = id.trim_prefix("jade-")
	return suffix.is_valid_int() and int(suffix) > 0 and int(suffix) <= sequence and id == "jade-%d" % int(suffix)
static func valid(data: Variant, campaign: Dictionary) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("completed") is Array or not data.get("current") is Dictionary: return false
	if data.completed.size() > points().size() or data.completed.size() > campaign.victories: return false
	var ids := {}
	for i in range(data.completed.size()):
		var entry: Variant = data.completed[i]
		if not entry is Dictionary or entry.get("point_id") != points()[i].id or not encounter_id_valid(entry.get("encounter_id"), int(campaign.sequence)) or ids.has(entry.encounter_id): return false
		ids[entry.encounter_id] = true
	if data.current.is_empty(): return true
	var current: Dictionary = data.current
	if not current.get("point_id") is String or not unlocked(data, current.point_id) or point(current.point_id).is_empty(): return false
	var encounter: Dictionary = campaign.encounter
	if encounter.is_empty() or encounter.get("schema") != 2 or current.get("encounter_id") != encounter.get("id") or encounter.get("enemy_species") != point(current.point_id).species: return false
	var won: bool = encounter.get("phase") in ["capture", "captured", "escaped"]
	# A completed point may be replayed. Only the first winning encounter is its receipt.
	for entry in data.completed:
		if entry.encounter_id == encounter.id and (not won or entry.point_id != current.point_id): return false
	if won and not completed(data, current.point_id): return false
	return true
static func record_victory(data: Dictionary, encounter_id: String) -> Dictionary:
	var result := data.duplicate(true)
	if result.current.get("encounter_id") != encounter_id: return result
	var id: String = result.current.point_id
	if not completed(result, id) and unlocked(result, id):
		result.completed.append({"point_id": id, "encounter_id": encounter_id})
	return result
