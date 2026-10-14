class_name SharedCombatTurn
extends RefCounted

var state := "dormant"
var last_error := ""
var _turn_id := ""
var _history: Array = []
var _pending: Dictionary = {}
var _sequence := 0

func begin(turn_id: String) -> bool:
	last_error = ""
	if state != "dormant" or turn_id.is_empty():
		last_error = "El turno requiere una identidad nueva."
		return false
	_turn_id = turn_id
	state = "open"
	return true

func available(owner: String) -> bool:
	if state != "open" or owner not in ["karmany", "trainer"] or not _pending.is_empty():
		return false
	for action in _history:
		if action.owner == owner:
			return false
	return true

func reserve(owner: String, action_id: String) -> Dictionary:
	last_error = ""
	if not available(owner) or action_id.is_empty():
		last_error = "La acción no está disponible en este turno."
		return {}
	for action in _history:
		if action.id == action_id:
			last_error = "La acción ya fue resuelta."
			return {}
	_sequence += 1
	_pending = {"turn_id": _turn_id, "sequence": _sequence, "owner": owner, "id": action_id}
	return _pending.duplicate(true)

func commit_action(ticket: Dictionary) -> bool:
	last_error = ""
	if state != "open" or _pending.is_empty() or ticket != _pending:
		last_error = "La reserva de acción no es válida."
		return false
	_history.append({"owner": _pending.owner, "id": _pending.id})
	_pending.clear()
	if _history.size() == 2:
		state = "closed"
	return true

func cancel_action(ticket: Dictionary) -> bool:
	last_error = ""
	if _pending.is_empty() or ticket != _pending:
		last_error = "No existe esta reserva de acción."
		return false
	_pending.clear()
	return true

func close_turn() -> bool:
	last_error = ""
	if state != "open" or not _pending.is_empty():
		last_error = "No se puede cerrar un turno con una acción pendiente."
		return false
	state = "closed"
	return true

func snapshot() -> Dictionary:
	last_error = ""
	if state == "dormant" or not _pending.is_empty():
		last_error = "Solo se conserva el turno entre acciones resueltas."
		return {}
	return {"schema": 1, "turn_id": _turn_id, "state": state, "sequence": _sequence, "history": _history.duplicate(true)}

func restore(data: Variant) -> bool:
	last_error = ""
	if state != "dormant" or not data is Dictionary or data.get("schema") != 1:
		last_error = "Turno guardado inválido."
		return false
	if not data.get("turn_id") is String or data.turn_id.is_empty() or data.get("state") not in ["open", "closed"] or not data.get("history") is Array or data.history.size() > 2:
		last_error = "Identidad o historial de turno inválido."
		return false
	if not (data.get("sequence") is int or data.get("sequence") is float) or not is_finite(float(data.sequence)) or data.sequence < data.history.size() or data.sequence != floor(data.sequence):
		last_error = "Secuencia de turno inválida."
		return false
	var owners := {}
	var ids := {}
	for action in data.history:
		if not action is Dictionary or action.get("owner") not in ["trainer", "karmany"] or not action.get("id") is String or action.id.is_empty() or owners.has(action.owner) or ids.has(action.id):
			last_error = "Acciones repetidas o inválidas en el turno."
			return false
		owners[action.owner] = true
		ids[action.id] = true
	if data.state == "open" and data.history.size() == 2:
		last_error = "El turno con ambas acciones resueltas debe estar cerrado."
		return false
	_turn_id = data.turn_id
	_history = data.history.duplicate(true)
	_sequence = int(data.sequence)
	state = data.state
	return true
