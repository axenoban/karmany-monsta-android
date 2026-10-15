extends RefCounted
const Rules = preload("res://scripts/progression_rules.gd")
const Roster = preload("res://scripts/trial_roster.gd")
static func integer(value: Variant, low: int, high: int) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value == floor(value) and value >= low and value <= high
static func requirement(level: int) -> int: return int(Rules.rules().xp_per_level) * level
static func fresh() -> Dictionary: return {"level": 1, "xp": 0}
static func defaults() -> Dictionary: return {"schema": 1, "trainer_xp": 0, "units": {Roster.STARTER: fresh()}, "last_reward": {}}
static func valid_record(data: Variant) -> bool:
	return data is Dictionary and integer(data.get("level"), 1, 1000000) and integer(data.get("xp"), 0, requirement(int(data.level)) - 1)
static func valid(data: Variant, campaign: Dictionary) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not integer(data.get("trainer_xp"), 0, 100000000) or not data.get("units") is Dictionary or not data.get("last_reward") is Dictionary: return false
	var owned := {}
	for member in Roster.owned(campaign): owned[member.instance_id] = true
	for id in data.units:
		if not owned.has(id) or not valid_record(data.units[id]): return false
	var receipt: Dictionary = data.last_reward
	if not receipt.is_empty():
		if not receipt.get("encounter_id") is String or not receipt.get("rows") is Array or not receipt.get("region") is String: return false
		if receipt.rows.size() > 4: return false
		var seen := {}
		for row in receipt.rows:
			if not row is Dictionary or not row.get("id") is String or seen.has(row.id) or (row.id != "trainer" and not owned.has(row.id)): return false
			if not integer(row.get("gained"), 0, int(Rules.rules().victory_xp)) or not integer(row.get("level"), 1, 1000000) or not row.get("capped") is bool: return false
			if row.has("before") or row.has("after"):
				if not valid_record(row.get("before")) or not valid_record(row.get("after")): return false
				if int(row.after.level) != int(row.level) or int(row.after.level) < int(row.before.level) or gained(row.before, row.after) != int(row.gained): return false
				if int(row.after.level) == int(row.before.level) and int(row.after.xp) < int(row.before.xp): return false
				if row.id != "trainer" and (not row.get("species_id") is String or row.species_id not in preload("res://scripts/combat_catalog.gd").all_species()): return false
			seen[row.id] = true
	return true
static func normalized(campaign: Dictionary) -> Dictionary:
	var result: Dictionary = campaign.get("progression", defaults()).duplicate(true)
	result.schema = 1
	result.trainer_xp = int(result.trainer_xp)
	for member in Roster.owned(campaign):
		if not result.units.has(member.instance_id): result.units[member.instance_id] = fresh()
		var record: Dictionary = result.units[member.instance_id]
		record.level = int(record.level)
		record.xp = int(record.xp)
	if not result.last_reward.is_empty():
		for row in result.last_reward.rows:
			row.gained = int(row.gained)
			row.level = int(row.level)
			for key in ["before", "after"]:
				if row.has(key):
					row[key].level = int(row[key].level)
					row[key].xp = int(row[key].xp)
	return result
static func record_for(campaign: Dictionary, id: String) -> Dictionary:
	return normalized(campaign).units.get(id, fresh()).duplicate(true)
static func advance(record: Dictionary, amount: int, cap: int) -> Dictionary:
	var result := record.duplicate(true)
	if int(result.level) >= cap: return result
	result.xp = int(result.xp) + amount
	while result.level < cap and result.xp >= requirement(int(result.level)):
		result.xp -= requirement(int(result.level))
		result.level = int(result.level) + 1
	if result.level >= cap: result.xp = 0
	return result
static func gained(before: Dictionary, after: Dictionary) -> int:
	var value := int(after.xp) - int(before.xp)
	for level in range(int(before.level), int(after.level)): value += requirement(level)
	return maxi(0, value)
# Award only after the winning transition. Receipt and profile are saved atomically.
static func award(campaign: Dictionary, tree: Dictionary, encounter: Dictionary) -> Dictionary:
	var result := normalized(campaign)
	if result.last_reward.get("encounter_id") == encounter.id: return result
	var point: Dictionary = campaign.get("route", {}).get("current", {})
	var region_id := "jade" if point.get("encounter_id") == encounter.id and not point.get("point_id", "").is_empty() else ""
	var region := Rules.region(region_id)
	var cap: int = int(region.get("xp_cap", 0))
	var amount: int = int(Rules.rules().victory_xp) if cap > 0 else 0
	var rows := []
	var trainer := {"level": int(tree.level), "xp": int(result.trainer_xp)}
	var next_trainer := advance(trainer, amount, cap) if amount > 0 else trainer
	tree.level = next_trainer.level
	result.trainer_xp = next_trainer.xp
	rows.append({"id": "trainer", "gained": gained(trainer, next_trainer), "level": next_trainer.level, "capped": cap > 0 and next_trainer.level >= cap, "before": trainer.duplicate(true), "after": next_trainer.duplicate(true)})
	var members: Array = encounter.get("members", campaign.get("team", Roster.defaults()).members)
	for member in members:
		var id: String = member.instance_id
		var before: Dictionary = result.units[id]
		var after := advance(before, amount, cap) if amount > 0 else before.duplicate(true)
		result.units[id] = after
		rows.append({"id": id, "gained": gained(before, after), "level": after.level, "capped": cap > 0 and after.level >= cap, "species_id": member.species_id, "before": before.duplicate(true), "after": after.duplicate(true)})
	result.last_reward = {"encounter_id": encounter.id, "region": region_id, "rows": rows}
	return result
static func summary(campaign: Dictionary, id: String) -> String:
	var entry := record_for(campaign, id)
	return "Nv. %d · XP %d/%d%s" % [entry.level, entry.xp, requirement(entry.level), " · Límite de Jade" if entry.level >= int(Rules.region("jade").xp_cap) else ""]
