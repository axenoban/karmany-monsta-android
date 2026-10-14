class_name KarmanyTeam
extends RefCounted

const CAPACITY := 3
var _members: Array = []
var _active_id := ""
var last_error := ""

func configure(members: Array, active_id: String) -> bool:
	last_error = ""
	if members.size() > CAPACITY:
		last_error = "El equipo admite hasta tres Karmany."
		return false
	var ids := {}
	for member in members:
		if not member is Dictionary or not member.get("instance_id") is String or member.instance_id.is_empty() or not member.get("species_id") is String or member.species_id.is_empty():
			last_error = "Identidad de Karmany incompleta."
			return false
		if ids.has(member.instance_id):
			last_error = "El mismo individuo aparece dos veces en el equipo."
			return false
		ids[member.instance_id] = true
	if (members.is_empty() and not active_id.is_empty()) or (not members.is_empty() and not ids.has(active_id)):
		last_error = "El Karmany activo no pertenece al equipo."
		return false
	_members = members.duplicate(true)
	_active_id = active_id
	return true

func select_active(instance_id: String) -> bool:
	last_error = ""
	for member in _members:
		if member.instance_id == instance_id:
			_active_id = instance_id
			return true
	last_error = "No se puede activar un Karmany ajeno al equipo."
	return false

func snapshot() -> Dictionary:
	return {"schema": 1, "members": _members.duplicate(true), "active_id": _active_id}

func restore(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("members") is Array or not data.get("active_id") is String:
		last_error = "Equipo guardado inválido."
		return false
	return configure(data.members, data.active_id)
