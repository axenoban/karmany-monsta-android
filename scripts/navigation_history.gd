extends RefCounted
# Route names only: never retain destroyed UI nodes or persist UI state in saves.
const LIMIT := 32
const ROUTES := ["home", "map", "book", "settings", "diagnostics", "bestiary", "species", "trainers", "skill_tree", "loadout", "tree_lab", "intro", "jade_play", "battle", "exploration", "collection", "team", "prologue"]
var entries: Array[String] = []
func reset() -> void:
	entries.clear()
func visit(origin: String, destination: String) -> void:
	if destination not in ROUTES or origin == destination: return
	if destination == "home":
		reset()
		return
	# Explicit return to an existing ancestor collapses a cycle.
	var ancestor := entries.find(destination)
	if ancestor >= 0:
		entries.resize(ancestor)
		return
	# A scouting/combat mode change replaces the same live encounter view.
	if origin in ["intro", "battle", "exploration"] and destination in ["intro", "battle", "exploration"]: return
	if origin in ROUTES and (entries.is_empty() or entries.back() != origin):
		entries.append(origin)
		if entries.size() > LIMIT: entries.pop_front()
func previous(current: String, fallback: String) -> String:
	while not entries.is_empty():
		var candidate: String = entries.pop_back()
		if candidate in ROUTES and candidate != current: return candidate
	return fallback
