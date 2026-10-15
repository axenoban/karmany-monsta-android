extends RefCounted
const Books = preload("res://scripts/book_progression.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const Turn = preload("res://scripts/shared_combat_turn.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Capture = preload("res://scripts/capture_session.gd")
var state: Dictionary = {}
var last_error:= ""

static func unit(member: Dictionary) -> Dictionary:
	var result:= {"instance_id": member.instance_id, "species_id": member.species_id, "hp": int(Catalog.stats_at_level(member.species_id, int(member.get("level", 1))).life), "guard": 0.0, "boost": 0.0, "weaken": 0.0, "ready": {}}
	if member.has("level"): result.level = int(member.level)
	return result
static func stats_for(member: Dictionary) -> Dictionary:
	return Catalog.stats_at_level(member.species_id, int(member.get("level", 1)))
static func capture_policy(data: Dictionary) -> BookCapturePolicy:
	var books:= Books.new()
	books.load_file()
	var id: Variant = data.get("book_id", "book_initial")
	return books.policy_for(id) if id is String else null
static func unit_valid(data: Variant) -> bool:
	if not data is Dictionary or not data.get("instance_id") is String or data.instance_id.is_empty() or not data.get("species_id") is String or Catalog.stats(data.species_id).is_empty(): return false
	if data.has("level") and not Legacy.integer(data.level, 1, 1000000): return false
	if not Legacy.integer(data.get("hp"), 0, int(stats_for(data).life)) or not data.get("ready") is Dictionary: return false
	for key in ["guard", "boost", "weaken"]:
		var value: Variant = data.get(key)
		if not (value is float or value is int) or not is_finite(value) or value < 0 or value > 0.8: return false
	for key in data.ready:
		if key not in ["golpe", "guardia", "insignia"] or not Legacy.integer(data.ready[key], 0, 1000000): return false
	return true
static func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 2 or not data.get("id") is String or data.id.is_empty(): return false
	if capture_policy(data) == null: return false
	if data.get("phase") not in ["battle", "replacement", "capture", "captured", "escaped", "defeat", "retreated"] or not data.get("enemy_pending") is bool: return false
	for key in ["round", "revision"]:
		if not Legacy.integer(data.get(key), 1 if key == "round" else 0, 1000000): return false
	if not data.get("members") is Array or data.members.is_empty() or data.members.size() > 3 or not unit_valid(data.get("enemy")): return false
	var ids:= {}
	var active:= {}
	var living:= 0
	for member in data.members:
		if not unit_valid(member) or ids.has(member.instance_id): return false
		ids[member.instance_id] = true
		if member.hp > 0: living += 1
		if member.instance_id == data.get("ally_id"): active = member
	if active.is_empty() or active.species_id != data.get("ally_species") or active.hp != data.get("player_hp") or data.enemy.hp != data.get("enemy_hp") or data.enemy.species_id != data.get("enemy_species"): return false
	if data.has("enemy_team"):
		if not data.enemy_team is Array or data.enemy_team.is_empty() or data.enemy_team.size() > 3 or not Legacy.integer(data.get("enemy_index"), 0, data.enemy_team.size() - 1): return false
		var enemy_ids:= {}
		for i in range(data.enemy_team.size()):
			var rival: Variant = data.enemy_team[i]
			if not unit_valid(rival) or rival.species_id == "zephyr" or ids.has(rival.instance_id) or enemy_ids.has(rival.instance_id): return false
			enemy_ids[rival.instance_id] = true
			if data.phase in ["capture", "captured", "escaped"]:
				if rival.hp != 0: return false
			elif i < int(data.enemy_index) and rival.hp != 0: return false
			elif i > int(data.enemy_index) and rival.hp != int(stats_for(rival).life): return false
		if data.enemy_team[int(data.enemy_index)] != data.enemy: return false
		if not data.get("capture_choice") is String: return false
		if not data.capture_choice.is_empty() and ( not enemy_ids.has(data.capture_choice) or data.capture_choice != data.enemy.instance_id): return false
		if data.phase in ["captured", "escaped"] and data.capture_choice.is_empty(): return false
		if data.phase == "capture" and not data.capture.get("actions", []).is_empty() and data.capture_choice.is_empty(): return false
	if data.has("regional"):
		if not data.has("enemy_team") or not regional_valid(data.regional): return false
	if data.enemy.species_id == "zephyr" or ids.has(data.enemy.instance_id): return false
	if not data.get("loadout") is Dictionary or data.loadout.size() > 4 or not data.get("trainer_ready") is Dictionary: return false
	for key in data.loadout:
		if not Legacy.rules().resonances.has(key) or not Legacy.integer(data.loadout[key], 1, 3): return false
	for key in data.trainer_ready:
		if not data.loadout.has(key) or not Legacy.integer(data.trainer_ready[key], 0, 1000000): return false
	if not data.get("capture") is Dictionary or not data.get("last_action") is String or data.last_action.length() > 500 or not data.get("event") is Dictionary: return false
	if not data.get("rolls") is Array or data.rolls.size() != 3: return false
	for roll in data.rolls:
		if not (roll is float or roll is int) or not is_finite(roll) or roll < 0 or roll >= 1: return false
	var turn:= Turn.new()
	if not turn.restore(data.get("turn")) or data.turn.turn_id != "%s:%d" % [data.id, int(data.round)]: return false
	if data.phase == "battle":
		return active.hp > 0 and data.enemy.hp > 0 and data.capture == {} and data.enemy_pending != turn.available("karmany")
	if data.enemy_pending: return false
	if data.phase == "replacement": return active.hp == 0 and living > 0 and data.enemy.hp > 0 and data.capture == {} and not turn.available("karmany")
	if data.phase == "defeat": return living == 0 and data.enemy.hp > 0 and data.capture == {}
	if data.phase == "retreated": return active.hp > 0 and data.enemy.hp > 0 and data.capture == {}
	var capture:= Capture.new()
	return active.hp > 0 and data.enemy.hp == 0 and capture.restore(data.get("capture"), capture_policy(data)) and data.capture.encounter_id == data.id and capture.state == ("offered" if data.phase == "capture" else data.phase)

static func regional_valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("version") != 1 or data.get("region") not in ["jade", "veil"] or not data.get("point_id") is String: return false
	var route = preload("res://scripts/jade_route.gd")
	if route.region_for(data.point_id) != data.region or data.get("bonus_key") != data.point_id + "@1" or not data.get("first") is bool: return false
	for field in ["reward", "first_xp", "repeat_xp", "cap", "cost"]:
		if not Legacy.integer(data.get(field), 0 if field == "cost" else 1, 1000000): return false
	return data.reward == (data.first_xp if data.first else data.repeat_xp) and data.first_xp >= data.repeat_xp and data.cost <= 100
