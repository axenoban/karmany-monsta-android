class_name SpeciesCatalog
extends RefCounted

var _entries: Dictionary = {}
var last_error:= ""

func load_file(path: String = "res://data/jade_species.json") -> bool:
	var parser:= JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK:
		last_error = "No se pudo leer el bestiario."
		return false
	if path == "res://data/jade_species.json":
		var forest: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/veil_species.json"))
		if forest is Dictionary: parser.data.species.append_array(forest.species)
	return load_data(parser.data)

func load_data(data: Variant) -> bool:
	last_error = ""
	if not data is Dictionary or data.get("schema") != 1 or not data.get("species") is Array:
		last_error = "Formato de bestiario inválido."
		return false
	var next_entries:= {}
	for entry in data.species:
		if not entry is Dictionary:
			last_error = "Ficha de especie inválida."
			return false
		for key in ["id", "name", "epithet", "biome", "rarity", "biology", "mythology", "physiology", "behavior"]:
			if not entry.get(key) is String or entry[key].strip_edges().is_empty():
				last_error = "Campo canónico ausente: " + key
				return false
		if next_entries.has(entry.id):
			last_error = "Identificador de especie duplicado: " + entry.id
			return false
		if not entry.get("resonance") is Dictionary:
			last_error = "Resonancia canónica ausente."
			return false
		for key in ["luminous", "shadow"]:
			if not entry.resonance.get(key) is String or entry.resonance[key].is_empty():
				last_error = "Descripción de resonancia ausente."
				return false
		next_entries[entry.id] = entry.duplicate(true)
	if next_entries.is_empty():
		last_error = "El bestiario está vacío."
		return false
	_entries = next_entries
	return true

func all_entries(rarity: String = "") -> Array:
	var result:= []
	for entry in _entries.values():
		if rarity.is_empty() or entry.rarity == rarity:
			result.append(entry.duplicate(true))
	return result

func find_species(species_id: String) -> Dictionary:
	return _entries.get(species_id, {}).duplicate(true)
