extends RefCounted

const STEPS:= ["victory", "experience", "choose", "duplicate", "binding"]
static func valid(value: Variant) -> bool:
	return value is Dictionary and (value.is_empty() or (value.get("encounter_id") is String and not value.encounter_id.is_empty() and value.get("step") in STEPS))
static func owned_count(campaign: Dictionary, species: String) -> int:
	var count:= 0
	for entry in campaign.collection:
		if entry.species == species: count += 1
	return count
static func receipt(campaign: Dictionary) -> Dictionary:
	var value: Dictionary = campaign.get("progression", {}).get("last_reward", {})
	if value.get("encounter_id") != campaign.encounter.get("id") or value.get("region", "").is_empty(): return {}
	return value
static func decision(campaign: Dictionary) -> String:
	var encounter: Dictionary = campaign.encounter
	if encounter.has("enemy_team") and encounter.get("capture_choice", "").is_empty(): return "choose"
	if not encounter.capture.actions.is_empty(): return "binding"
	return "duplicate" if owned_count(campaign, encounter.get("enemy_species", "tanugami")) > 0 else "binding"
static func step(campaign: Dictionary) -> String:
	var encounter: Dictionary = campaign.encounter
	if encounter.get("phase") != "capture": return encounter.get("phase", "")
	var checkpoint: Dictionary = campaign.get("aftermath", {})
	if checkpoint.get("encounter_id") == encounter.id and valid(checkpoint): return checkpoint.step

	return decision(campaign)
static func next(campaign: Dictionary) -> String:
	match step(campaign):
		"victory": return "experience" if not receipt(campaign).is_empty() else decision(campaign)
		"experience": return decision(campaign)
		"duplicate": return "binding"
	return ""
static func checkpoint(campaign: Dictionary, stage: String) -> Dictionary:
	return {"encounter_id": campaign.encounter.id, "step": stage}
