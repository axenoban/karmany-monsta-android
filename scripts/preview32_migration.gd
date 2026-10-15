extends RefCounted
# Read-only conversion. Caller validates the entire converted profile before use.
const Old = preload("res://scripts/preview32_contract.gd")
const Route = preload("res://scripts/jade_route.gd")
static func bonus(key: String) -> String:
	if key.ends_with("@1"):
		var id := key.trim_suffix("@1")
		var region := Route.region_for(id)
		if not region.is_empty(): return "%s/%s/v1" % [region, id]
	return key
static func needed(data: Dictionary) -> bool:
	if not data.get("campaign", {}) is Dictionary: return false
	var campaign: Dictionary = data.get("campaign", {})
	var encounter: Variant = campaign.get("encounter", {})
	if encounter is Dictionary and encounter.get("regional", {}) is Dictionary and encounter.get("regional", {}).has("version"): return true
	if not campaign.get("progression", {}) is Dictionary: return false
	var bonuses: Variant = campaign.get("progression", {}).get("bonuses", [])
	if not bonuses is Array: return false
	for key in bonuses:
		if key is String and key.ends_with("@1"): return true
	return false
static func convert(data: Dictionary) -> Dictionary:
	var result := data.duplicate(true)
	if not needed(result): return result
	var campaign: Dictionary = result.campaign
	var encounter: Dictionary = campaign.get("encounter", {})
	if encounter.get("regional", {}).has("version"):
		if not Old.valid(encounter): return data
		var frozen: Dictionary = encounter.regional
		var enemies := []
		for enemy in encounter.enemy_team:
			enemies.append({"species_id":enemy.species_id,"level":int(enemy.get("level",1))})
		encounter.regional = {"schema":1,"region":frozen.region,"point_id":frozen.point_id,"cap":int(frozen.cap),"bonus_key":bonus(frozen.bonus_key),"first":frozen.first,"reward":int(frozen.reward),"repeat_xp":int(frozen.repeat_xp),"enemies":enemies}
		# Preview32 changed enemy_index to the selected capture target. E2 preserves
		# the final battle index and uses capture_choice for the independent selection.
		if encounter.phase in ["capture","captured","escaped"]:
			encounter.enemy_index = encounter.enemy_team.size()-1
	var progress: Dictionary = campaign.get("progression", {})
	if progress.has("bonuses"):
		var converted := []
		for key in progress.bonuses:
			if not key is String: return data
			var mapped := bonus(key)
			if mapped == key and key.ends_with("@1"): return data
			if mapped not in converted: converted.append(mapped)
		progress.bonuses = converted
	return result
