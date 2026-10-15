class_name TrainerSkillTree
extends RefCounted

const ProgressRules = preload("res://scripts/progression_rules.gd")
const Catalog = preload("res://scripts/species_catalog.gd")
static var _cached_spec: Dictionary = {}
static var _species_ids: Array = []
var state: Dictionary
var last_error := ""

static func specification() -> Dictionary:
	if _cached_spec.is_empty():
		var parser := JSON.new()
		if parser.parse(FileAccess.get_file_as_string("res://data/trainer_skill_tree.json")) != OK or not parser.data is Dictionary:
			return {}
		_cached_spec = parser.data
		var catalog := Catalog.new()
		if catalog.load_file():
			for entry in catalog.all_entries():
				_species_ids.append(entry.id)
	return _cached_spec.duplicate(true)

static func defaults() -> Dictionary:
	return {"schema": 1, "level": 1, "captured_species": [], "ranks": {}, "equipped": [], "unlocks": []}

static func _integer(value: Variant, minimum: int, maximum: int) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= minimum and value <= maximum and value == floor(value)

static func node_definition(node_id: String) -> Dictionary:
	for node in specification().get("nodes", []):
		if node.id == node_id:
			return node.duplicate(true)
	return {}

static func earned_points(data: Dictionary) -> int:
	var result := int(data.level)
	for milestone in specification().capture_milestones:
		if data.captured_species.size() >= milestone:
			result += 1
	return result

static func spent_points(data: Dictionary) -> int:
	var result := 0
	for rank_value in data.ranks.values():
		result += int(rank_value)
	return result + ProgressRules.unlock_spent(data)

static func valid(data: Variant) -> bool:
	var spec := specification()
	if spec.is_empty() or not data is Dictionary or data.get("schema") != 1 or not _integer(data.get("level"), 1, int(spec.level_cap)):
		return false
	if not data.get("captured_species") is Array or not data.get("ranks") is Dictionary or not data.get("equipped") is Array or data.equipped.size() > spec.equip_slots:
		return false
	var seen := {}
	for species_id in data.captured_species:
		if not species_id is String or species_id not in _species_ids or seen.has(species_id):
			return false
		seen[species_id] = true
	for node_id in data.ranks:
		if not node_id is String:
			return false
		var node := node_definition(node_id)
		var rank_value: Variant = data.ranks[node_id]
		if node.is_empty() or not _integer(rank_value, 1, int(node.max_rank)) or data.level < node.min_level + (rank_value - 1) * spec.rank_level_step:
			return false
		for prerequisite in node.prerequisites:
			if not data.ranks.has(prerequisite):
				return false
	if data.has("unlocks"):
		if not data.unlocks is Array: return false
		var purchased := {}
		for id in data.unlocks:
			if not id is String or purchased.has(id): return false
			var definition := ProgressRules.unlock(id)
			if definition.is_empty() or data.level < definition.min_level or (not definition.prerequisite.is_empty() and definition.prerequisite not in purchased): return false
			purchased[id] = true
	if spent_points(data) > earned_points(data):
		return false
	seen.clear()
	for node_id in data.equipped:
		if not node_id is String or not data.ranks.has(node_id) or seen.has(node_id):
			return false
		seen[node_id] = true
	return true

static func normalized(data: Dictionary) -> Dictionary:
	var result := data.duplicate(true)
	if not result.has("unlocks"): result.unlocks = []
	result.schema = 1
	result.level = int(result.level)
	for node_id in result.ranks:
		result.ranks[node_id] = int(result.ranks[node_id])
	return result

func _init() -> void:
	state = defaults()

func restore(data: Variant) -> bool:
	last_error = ""
	if not valid(data):
		last_error = "Progreso del árbol inválido."
		return false
	state = normalized(data)
	return true

func snapshot() -> Dictionary:
	return state.duplicate(true)

func points_available() -> int:
	return earned_points(state) - spent_points(state)

func purchase_reason(node_id: String) -> String:
	var node := node_definition(node_id)
	if node.is_empty():
		return "Resonancia desconocida."
	var rank_value := int(state.ranks.get(node_id, 0))
	if rank_value >= node.max_rank:
		return "Rango máximo alcanzado."
	var needed := int(node.min_level + rank_value * specification().rank_level_step)
	if state.level < needed:
		return "Requiere nivel %d." % needed
	for prerequisite in node.prerequisites:
		if not state.ranks.has(prerequisite):
			return "Aprende primero " + node_definition(prerequisite).name + "."
	if points_available() < 1:
		return "Necesitas un punto de habilidad."
	return ""

func purchase(node_id: String) -> bool:
	last_error = purchase_reason(node_id)
	if not last_error.is_empty():
		return false
	state.ranks[node_id] = int(state.ranks.get(node_id, 0)) + 1
	return true

func equip(node_id: String) -> bool:
	last_error = ""
	if not state.ranks.has(node_id):
		last_error = "Aprende la resonancia antes de equiparla."
		return false
	if state.equipped.has(node_id):
		last_error = "La resonancia ya está equipada."
		return false
	if state.equipped.size() >= specification().equip_slots:
		last_error = "Los cuatro espacios están ocupados. Retira una resonancia."
		return false
	state.equipped.append(node_id)
	return true

func unequip(node_id: String) -> bool:
	last_error = ""
	if not state.equipped.has(node_id):
		last_error = "La resonancia no está equipada."
		return false
	state.equipped.erase(node_id)
	return true

func gain_level() -> bool:
	last_error = ""
	if state.level >= specification().level_cap:
		last_error = "Nivel máximo del prototipo: 10."
		return false
	state.level += 1
	return true

func record_capture(species_id: String) -> bool:
	last_error = ""
	if species_id not in _species_ids:
		last_error = "Especie no registrada."
		return false
	if state.captured_species.has(species_id):
		last_error = "Esta especie ya cuenta para la bonificación."
		return false
	state.captured_species.append(species_id)
	return true

func power_multiplier(node_id: String) -> float:
	var rank_value := int(state.ranks.get(node_id, 0))
	return 0.0 if rank_value == 0 else 1.0 + (rank_value - 1) * float(specification().rank_power_step)

func reset_allocation() -> void:
	state.ranks.clear()
	state.equipped.clear()

func unlock_reason(id: String) -> String:
	var definition := ProgressRules.unlock(id)
	if definition.is_empty(): return "Desbloqueo desconocido."
	if id in state.unlocks: return "Ya desbloqueado."
	if state.level < definition.min_level: return "Requiere nivel %d." % int(definition.min_level)
	if not definition.prerequisite.is_empty() and definition.prerequisite not in state.unlocks: return "Adquiere antes la mejora anterior."
	if points_available() < definition.cost: return "Necesitas %d puntos disponibles." % int(definition.cost)
	return ""
func purchase_unlock(id: String) -> bool:
	last_error = unlock_reason(id)
	if not last_error.is_empty(): return false
	state.unlocks.append(id)
	return true
