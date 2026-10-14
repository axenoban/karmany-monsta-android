class_name ResonanceLearning
extends RefCounted

var last_error := ""
var _identity: Dictionary = {}
var _definitions: Dictionary = {}
var _learned: Array = []

func configure(identity: Variant, definitions: Variant) -> bool:
	last_error = ""
	if not _identity.is_empty():
		last_error = "No se reemplaza un registro de aprendizaje iniciado."
		return false
	if not identity is Dictionary or not identity.get("trainer_id") is String or identity.trainer_id.is_empty() or not identity.get("type_id") is String or not identity.get("personality_id") is String or not definitions is Array:
		last_error = "Identidad de entrenador o catálogo inválidos."
		return false
	var next_definitions := {}
	for definition in definitions:
		if not definition is Dictionary or not definition.get("id") is String or definition.id.is_empty() or next_definitions.has(definition.id) or definition.get("access") not in ["general", "special", "explosive"]:
			last_error = "Definición de resonancia inválida o repetida."
			return false
		for key in ["trainer_types", "personalities"]:
			if not definition.get(key) is Array:
				last_error = "Requisitos de resonancia ausentes."
				return false
			for requirement in definition[key]:
				if not requirement is String or requirement.is_empty():
					last_error = "Requisito de resonancia inválido."
					return false
		if definition.access == "general" and (not definition.trainer_types.is_empty() or not definition.personalities.is_empty()):
			last_error = "El aprendizaje general no puede depender del tipo o personalidad."
			return false
		if definition.access != "general" and (definition.trainer_types.is_empty() or definition.personalities.is_empty()):
			last_error = "Una resonancia propia necesita requisitos de tipo y personalidad."
			return false
		next_definitions[definition.id] = definition.duplicate(true)
	_identity = identity.duplicate(true)
	_definitions = next_definitions
	return true

func _eligible(definition: Dictionary) -> bool:
	return definition.access == "general" or (_identity.type_id in definition.trainer_types and _identity.personality_id in definition.personalities)

func learn_general(resonance_id: String) -> bool:
	last_error = ""
	var definition: Dictionary = _definitions.get(resonance_id, {})
	if definition.is_empty() or definition.access != "general":
		last_error = "El árbol permite aprender resonancias generales configuradas."
		return false
	return _learn(resonance_id)

func unlock_personal(resonance_id: String) -> bool:
	last_error = ""
	var definition: Dictionary = _definitions.get(resonance_id, {})
	if definition.is_empty() or definition.access == "general" or not _eligible(definition):
		last_error = "La resonancia propia no corresponde al tipo y personalidad del entrenador."
		return false
	return _learn(resonance_id)

func _learn(resonance_id: String) -> bool:
	if _learned.has(resonance_id):
		last_error = "El entrenador ya conoce esta resonancia."
		return false
	_learned.append(resonance_id)
	return true

func learned_ids() -> Array:
	return _learned.duplicate()

func snapshot() -> Dictionary:
	return {"schema": 1, "identity": _identity.duplicate(true), "learned": _learned.duplicate()}

func restore(data: Variant, identity: Dictionary, definitions: Array) -> bool:
	last_error = ""
	if not _identity.is_empty() or not data is Dictionary or data.get("schema") != 1 or not data.get("identity") is Dictionary or data.identity != identity or not data.get("learned") is Array:
		last_error = "Registro de aprendizaje guardado inválido."
		return false
	var staged := ResonanceLearning.new()
	if not staged.configure(identity, definitions):
		last_error = staged.last_error
		return false
	var ids := {}
	for resonance_id in data.learned:
		if not resonance_id is String or ids.has(resonance_id) or not staged._definitions.has(resonance_id) or not staged._eligible(staged._definitions[resonance_id]):
			last_error = "Aprendizajes duplicados, desconocidos o incompatibles con el entrenador."
			return false
		ids[resonance_id] = true
	_identity = staged._identity.duplicate(true)
	_definitions = staged._definitions.duplicate(true)
	_learned = data.learned.duplicate()
	return true
