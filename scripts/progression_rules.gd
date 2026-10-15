extends RefCounted
static var _rules: Dictionary = {}
static func rules() -> Dictionary:
	if _rules.is_empty(): _rules = JSON.parse_string(FileAccess.get_file_as_string("res://data/level_progression.json"))
	return _rules.duplicate(true)
static func unlock(id: String) -> Dictionary:
	for entry in rules().unlocks:
		if entry.id == id: return entry
	for entry in rules().regions:
		if entry.id == id and entry.cost > 0:
			entry.prerequisite = entry.get("prerequisite", "")
			return entry
	return {}
static func region(id: String) -> Dictionary:
	for entry in rules().regions:
		if entry.id == id: return entry
	return {}
static func current_book(tree: Dictionary) -> String:
	var purchased: Array = tree.get("unlocks", [])
	return "book_upgrade_2" if "book_upgrade_2" in purchased else ("book_upgrade_1" if "book_upgrade_1" in purchased else "book_initial")
static func unlock_spent(tree: Dictionary) -> int:
	var total := 0
	for id in tree.get("unlocks", []): total += int(unlock(id).get("cost", 0))
	return total
static func region_reason(tree: Dictionary, id: String) -> String:
	var entry := region(id)
	if entry.is_empty(): return "Región todavía no disponible."
	if tree.level < entry.min_level: return "Requiere nivel %d." % int(entry.min_level)
	if entry.cost > 0 and id not in tree.get("unlocks", []): return "Requiere desbloqueo."
	return ""
