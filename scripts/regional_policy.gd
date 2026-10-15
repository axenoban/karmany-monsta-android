extends RefCounted
# Entry-time contract. Old encounters without this object retain legacy rules.
const Rules = preload("res://scripts/progression_rules.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const MAX_REWARD := 750 # Largest approved Jade first-win award; extend only with approved data.
static func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 1: return false
	if not data.get("region") is String or Rules.region(data.region).is_empty(): return false
	if not data.get("point_id") is String or data.point_id.is_empty(): return false
	if not data.get("bonus_key") is String or data.bonus_key != "%s/%s/v1" % [data.region, data.point_id]: return false
	for key in ["cap", "reward", "repeat_xp"]:
		if not Legacy.integer(data.get(key), 1, 1000000 if key == "cap" else MAX_REWARD): return false
	if data.cap != Rules.region(data.region).xp_cap or data.reward < data.repeat_xp: return false
	if not data.get("first") is bool or (not data.first and data.reward != data.repeat_xp): return false
	if not data.get("enemies") is Array or data.enemies.is_empty() or data.enemies.size() > 2: return false
	for enemy in data.enemies:
		if not enemy is Dictionary or not enemy.get("species_id") is String or enemy.species_id == "zephyr" or Catalog.stats(enemy.species_id).is_empty(): return false
		if not Legacy.integer(enemy.get("level"), 1, int(data.cap)): return false
	return true
static func freeze(point: Dictionary, region: String, bonuses: Array) -> Dictionary:
	if not point.has("level"): return {} # Data is activated in E3; no reinterpretation of old entries.
	var key := "%s/%s/v1" % [region, point.id]
	var enemies: Array = point.get("enemies", [{"species_id": point.species, "level": point.level}]).duplicate(true)
	var first := key not in bonuses
	var result := {"schema":1,"region":region,"point_id":point.id,"cap":Rules.region(region).get("xp_cap",0),"bonus_key":key,"first":first,"reward":point.get("first_xp",0) if first else point.get("repeat_xp",0),"repeat_xp":point.get("repeat_xp",0),"enemies":enemies}
	return normalized(result) if valid(result) else {}

static func normalized(data: Dictionary) -> Dictionary:
	var result := data.duplicate(true)
	for key in ["schema","cap","reward","repeat_xp"]: result[key] = int(result[key])
	for enemy in result.enemies: enemy.level = int(enemy.level)
	return result
