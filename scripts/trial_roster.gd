class_name TrialRoster
extends RefCounted
const TeamModel = preload("res://scripts/karmany_team.gd")
const STARTER := "zephyr-start"
var last_error := ""

static func defaults() -> Dictionary:
	return {"schema": 1, "members": [{"instance_id": STARTER, "species_id": "zephyr"}], "active_id": STARTER}

static func owned(campaign: Dictionary) -> Array:
	var result := [{"instance_id": STARTER, "species_id": "zephyr"}]
	for entry in campaign.collection:
		result.append({"instance_id": entry.id, "species_id": entry.species})
	return result

static func member_name(member: Dictionary) -> String:
	return "Zephyr" if member.species_id == "zephyr" else "Tanugami · " + member.instance_id

static func valid(team_data: Variant, campaign: Dictionary) -> bool:
	var team := TeamModel.new()
	if not team.restore(team_data) or team_data.members.is_empty():
		return false
	var ownership := {}
	for member in owned(campaign): ownership[member.instance_id] = member.species_id
	for member in team_data.members:
		if ownership.get(member.instance_id) != member.species_id:
			return false
	return true

func change(campaign: Dictionary, operation: String, instance_id: String) -> Dictionary:
	last_error = ""
	if not campaign.encounter.is_empty() and campaign.encounter.phase in ["battle", "capture"]:
		last_error = "Termina o abandona el encuentro antes de cambiar el equipo."
		return {}
	var team := TeamModel.new()
	var data: Dictionary = campaign.get("team", defaults()).duplicate(true)
	if not valid(data, campaign):
		last_error = "Equipo guardado inválido."
		return {}
	match operation:
		"add":
			var selected := {}
			for entry in owned(campaign):
				if entry.instance_id == instance_id: selected = entry
			if selected.is_empty():
				last_error = "Este Karmany no pertenece a tu colección."
				return {}
			data.members.append(selected)
		"remove":
			var found := false
			for index in range(data.members.size()):
				if data.members[index].instance_id == instance_id:
					data.members.remove_at(index)
					found = true
					break
			if not found or data.members.is_empty():
				last_error = "El equipo debe conservar al menos un Karmany."
				return {}
			if data.active_id == instance_id: data.active_id = data.members[0].instance_id
		"active":
			data.active_id = instance_id
		_:
			last_error = "Operación de equipo desconocida."
			return {}
	if not team.restore(data):
		last_error = team.last_error
		return {}
	return team.snapshot()
