extends RefCounted
const Legacy = preload("res://scripts/trial_encounter.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
static func create(data: Dictionary):
	return Tactical.new() if data.get("schema") == 2 else Legacy.new()
static func valid(data: Variant) -> bool:
	return Tactical.valid(data) if data is Dictionary and data.get("schema") == 2 else Legacy.valid(data)
static func pending(data: Dictionary) -> bool:
	return data.get("enemy_pending", false) if data.get("schema") == 2 else Legacy.enemy_pending_from(data)
