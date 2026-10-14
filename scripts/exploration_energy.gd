extends RefCounted
const Legacy = preload("res://scripts/trial_encounter.gd")
static var _rules: Dictionary = {}
static func rules() -> Dictionary:
	if _rules.is_empty(): _rules = JSON.parse_string(FileAccess.get_file_as_string("res://data/exploration_rules.json"))
	return _rules.duplicate(true)
static func defaults() -> Dictionary:
	return {"schema": 1, "value": 100, "anchor": 0, "items": 0, "revision": 0, "drop": {}, "scouting": false}
static func valid(data: Variant, campaign: Dictionary) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("scouting") is bool or not data.get("drop") is Dictionary: return false
	for key in ["value", "items", "revision", "anchor"]:
		if not Legacy.integer(data.get(key), 0, {"value": 100, "items": 1000000, "revision": 1000000000, "anchor": 253402300799}[key]): return false
	if (data.value < 100 and data.anchor == 0) or (data.value == 100 and data.anchor != 0): return false
	var encounter: Dictionary = campaign.encounter
	if data.scouting and (encounter.is_empty() or encounter.get("schema") != 2 or encounter.phase != "battle" or encounter.revision != 0 or encounter.get("enemy_pending", false) or campaign.get("route", {}).get("current", {}).get("encounter_id") != encounter.id): return false
	if data.drop.is_empty(): return not data.scouting
	var drop: Dictionary = data.drop
	if encounter.is_empty() or drop.get("encounter_id") != encounter.id or campaign.get("route", {}).get("current", {}).get("encounter_id") != encounter.id: return false
	if not Legacy.integer(drop.get("roll"), 0, 9999) or not drop.get("resolved") is bool or not drop.get("received") is bool: return false
	var won: bool = encounter.phase in ["capture", "captured", "escaped"]
	return drop.resolved == won and drop.received == (won and drop.roll < int(rules().drop_below))
static func refreshed(data: Dictionary, now: int) -> Dictionary:
	var result := data.duplicate(true)
	if result.value >= 100 or now <= int(result.anchor): return result
	var gained := int((now - int(result.anchor)) / 60)
	if gained <= 0: return result
	result.value = mini(100, int(result.value) + gained)
	result.anchor = 0 if result.value == 100 else int(result.anchor) + gained * 60
	result.revision = int(result.revision) + 1
	return result
static func spend(data: Dictionary, amount: int, now: int) -> Dictionary:
	var result := refreshed(data, now)
	if amount <= 0 or result.value < amount or now <= 0: return {}
	if result.value == 100: result.anchor = now
	result.value = int(result.value) - amount
	result.revision = int(result.revision) + 1
	return result
static func consume_item(data: Dictionary, now: int) -> Dictionary:
	var result := refreshed(data, now)
	if result.items <= 0 or result.value >= 100: return {}
	result.items = int(result.items) - 1
	result.value = mini(100, int(result.value) + int(rules().recovery_item_amount))
	if result.value == 100: result.anchor = 0
	result.revision = int(result.revision) + 1
	return result
static func resolve_drop(data: Dictionary, encounter_id: String) -> Dictionary:
	var result := data.duplicate(true)
	if result.drop.is_empty() or result.drop.encounter_id != encounter_id or result.drop.resolved: return result
	result.drop.resolved = true
	result.drop.received = result.drop.roll < int(rules().drop_below)
	if result.drop.received: result.items = int(result.items) + 1
	result.revision = int(result.revision) + 1
	return result
