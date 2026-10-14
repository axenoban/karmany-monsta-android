class_name CaptureSession
extends RefCounted

const MAX_ATTEMPTS := 3
const SNAPSHOT_VERSION := 1
var state := "dormant"
var last_error := ""
var _encounter_id := ""
var _rarity := ""
var _policy_id := ""
var _chance := -1.0
var _actions: Array = []

func begin(encounter_id: String, defeated: bool, seal_allowed: bool, rarity: String, policy: BookCapturePolicy) -> bool:
	last_error = ""
	if state != "dormant":
		last_error = "Este encuentro ya inició su fase de captura."
		return false
	if encounter_id.is_empty() or not defeated:
		last_error = "La captura requiere un encuentro identificado y un Karmany derrotado."
		return false
	if not seal_allowed:
		last_error = "Este Karmany no admite sellado en el Libro."
		return false
	if not policy.is_configured():
		last_error = "Faltan las reglas aprobadas del Libro."
		return false
	if not policy.permits(rarity):
		last_error = "El Libro no permite esta rareza."
		return false
	_encounter_id = encounter_id
	_rarity = rarity
	_policy_id = policy.identifier()
	_chance = policy.chance_for(rarity)
	state = "offered"
	return true

func attempts_used() -> int:
	return _actions.size()

func remaining_attempts() -> int:
	return MAX_ATTEMPTS - attempts_used() if state == "offered" else 0

func attempt(action_id: String, roll: float) -> bool:
	last_error = ""
	if state != "offered":
		last_error = "La fase de captura no está activa."
		return false
	if action_id.is_empty() or _actions.has(action_id):
		last_error = "Acción de captura vacía o repetida."
		return false
	if not is_finite(roll) or roll < 0 or roll >= 1:
		last_error = "Resultado aleatorio inválido."
		return false
	_actions.append(action_id)
	if roll < _chance:
		state = "captured"
	elif attempts_used() == MAX_ATTEMPTS:
		state = "escaped"
	return true

func snapshot() -> Dictionary:
	return {"schema": SNAPSHOT_VERSION, "encounter_id": _encounter_id, "rarity": _rarity, "policy_id": _policy_id, "chance": _chance, "actions": _actions.duplicate(), "state": state}

func restore(data: Variant, policy: BookCapturePolicy) -> bool:
	last_error = ""
	if state != "dormant":
		last_error = "No se puede reemplazar una sesión iniciada."
		return false
	if not data is Dictionary or data.get("schema") != SNAPSHOT_VERSION:
		last_error = "Versión de sesión inválida."
		return false
	for key in ["encounter_id", "rarity", "policy_id", "state"]:
		if not data.get(key) is String or data[key].is_empty():
			last_error = "Identidad de sesión inválida."
			return false
	if not data.get("actions") is Array or data.actions.size() > MAX_ATTEMPTS:
		last_error = "Número de intentos inválido."
		return false
	var unique := {}
	for action in data.actions:
		if not action is String or action.is_empty() or unique.has(action):
			last_error = "Historial de intentos inválido."
			return false
		unique[action] = true
	var count: int = data.actions.size()
	if data.state not in ["offered", "captured", "escaped"] or (data.state == "offered" and count >= MAX_ATTEMPTS) or (data.state == "captured" and count < 1) or (data.state == "escaped" and count != MAX_ATTEMPTS):
		last_error = "Estado de captura inconsistente."
		return false
	if not (data.get("chance") is float or data.get("chance") is int) or not is_finite(float(data.chance)):
		last_error = "Probabilidad de sesión inválida."
		return false
	if not policy.is_configured() or data.policy_id != policy.identifier() or not policy.permits(data.rarity) or data.chance != policy.chance_for(data.rarity):
		last_error = "Las reglas del Libro no coinciden con la sesión guardada."
		return false
	_encounter_id = data.encounter_id
	_rarity = data.rarity
	_policy_id = data.policy_id
	_chance = float(data.chance)
	_actions = data.actions.duplicate()
	state = data.state
	return true
