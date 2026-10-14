class_name BookProgression
extends RefCounted

const Policy = preload("res://scripts/book_capture_policy.gd")
var _levels: Array = []
var last_error := ""

func load_file(path: String = "res://data/book_levels.json") -> bool:
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK:
		last_error = "No se pudo leer la progresión del Libro."
		return false
	return load_data(parser.data)

func load_data(data: Variant) -> bool:
	last_error = ""
	if not data is Dictionary or data.get("schema") != 1 or not data.get("levels") is Array or data.levels.is_empty():
		last_error = "Progresión del Libro inválida."
		return false
	var next_levels := []
	var ids := {}
	var previous: BookCapturePolicy = null
	for level in data.levels:
		if not level is Dictionary or not level.get("name") is String or level.name.is_empty():
			last_error = "Nombre del Libro ausente."
			return false
		var policy := Policy.new()
		if not policy.configure(level):
			last_error = policy.last_error
			return false
		if ids.has(level.id):
			last_error = "Nivel del Libro duplicado."
			return false
		if previous != null and not policy.upgrade_preserves_access(previous):
			last_error = "La mejora del Libro reduce posibilidades o elimina acceso."
			return false
		ids[level.id] = true
		next_levels.append(level.duplicate(true))
		previous = policy
	_levels = next_levels
	return true

func all_levels() -> Array:
	return _levels.duplicate(true)

func policy_for(level_id: String) -> BookCapturePolicy:
	last_error = ""
	for level in _levels:
		if level.id == level_id:
			var policy := Policy.new()
			policy.configure(level)
			return policy
	last_error = "Nivel del Libro desconocido: " + level_id
	return null
