class_name CombatStructure
extends RefCounted

var _rules: Dictionary = {}
var last_error := ""

func load_file(path: String = "res://data/combat_structure.json") -> bool:
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK:
		last_error = "No se pudo leer la estructura de combate."
		return false
	return load_data(parser.data)

func load_data(data: Variant) -> bool:
	last_error = ""
	if not data is Dictionary or data.get("schema") != 1:
		last_error = "Estructura de combate inválida."
		return false
	# These exact limits were approved by the creator; do not silently broaden them.
	if data.get("team_capacity") != 3 or data.get("active_per_side") != 1 or data.get("skills_per_species") != 3 or data.get("signature_skills_per_species") != 1:
		last_error = "La estructura no coincide con los límites aprobados."
		return false
	if data.get("stats") != ["vida", "ataque", "defensa", "velocidad"] or data.get("resonance_owner") != "trainer":
		last_error = "Estadísticas o propietario de resonancias incorrectos."
		return false
	var turn: Variant = data.get("shared_turn")
	var learning: Variant = data.get("resonance_learning")
	if not turn is Dictionary or turn.get("karmany_actions") != 1 or turn.get("trainer_actions") != 1 or turn.get("order") != "free":
		last_error = "El turno no coincide con el orden libre y presupuesto aprobados."
		return false
	if not learning is Dictionary or learning.get("general_access") != "any_trainer_type" or learning.get("personal_access") != "type_and_personality" or learning.get("provider") != "library_or_school":
		last_error = "El aprendizaje no coincide con las reglas aprobadas."
		return false
	if not data.get("trainer_roles") is Array or data.trainer_roles.is_empty():
		last_error = "Tipos de entrenador ausentes."
		return false
	var ids := {}
	for role in data.trainer_roles:
		if not role is Dictionary:
			last_error = "Tipo de entrenador inválido."
			return false
		for key in ["id", "name", "purpose"]:
			if not role.get(key) is String or role[key].is_empty():
				last_error = "Definición del entrenador incompleta."
				return false
		if ids.has(role.id) or not role.get("skill_definitions") is Array:
			last_error = "Tipo duplicado o habilidades del entrenador inválidas."
			return false
		ids[role.id] = true
	_rules = data.duplicate(true)
	return true

func rules() -> Dictionary:
	return _rules.duplicate(true)

func role_definition(role_id: String) -> Dictionary:
	for role in _rules.get("trainer_roles", []):
		if role.id == role_id:
			return role.duplicate(true)
	return {}

func trainer_skills_ready(role_id: String) -> bool:
	return not role_definition(role_id).get("skill_definitions", []).is_empty()
