extends RefCounted
# Optional UX extension. Missing data is deliberately NOT a new journey.
const IDS := ["map", "entry", "search", "health", "turn", "skills", "trainer", "team", "replacement", "defeat", "xp", "binding", "skip_binding", "resume"]
const COPY := {
"map": "Selecciona un punto del mapa para explorar esa localización.",
"entry": "Entrar cuesta {coste} de stamina. Retomar un encuentro no vuelve a cobrarte.",
"search": "Pulsa Buscar encuentro para descubrir al Karmany de este lugar.",
"health": "Los PS indican la vida restante. Si llegan a cero, el Karmany queda fuera de combate.",
"turn": "Puedes usar una resonancia y después actuar con tu Karmany. El rival responderá.",
"skills": "Cada Insignia tiene su propio efecto y disponibilidad. Consulta su descripción.",
"trainer": "Las resonancias son opcionales. Puedes combatir sin utilizar ninguna.",
"team": "Cambiar de Karmany consume tu acción. El rival responderá contra el nuevo activo.",
"replacement": "Tu Karmany ha caído. Elige un compañero disponible: este relevo no provoca otro ataque rival.",
"defeat": "Todo tu equipo ha caído. No recibes XP por esta derrota. En el próximo encuentro, el equipo volverá recuperado.",
"xp": "Has ganado {xp} XP. Observa la barra para comprobar tu progreso y las subidas de nivel.",
"cap": "Has alcanzado el límite de experiencia de esta región.",
"binding": "Puedes intentar el vínculo con el Libro. Te quedan {intentos} intentos.",
"skip_binding": "Puedes continuar sin vincular. Tu victoria y la experiencia obtenida se conservan.",
"resume": "Volver al mapa conserva tu encuentro pendiente. Usa Retomar para continuar."
}
static func fresh() -> Dictionary:
	return {"version": 1, "seen": []}
static func valid(value: Variant) -> bool:
	if not value is Dictionary or value.get("version") != 1 or not value.get("seen") is Array: return false
	var seen: Array = value.seen
	for id in seen:
		if id not in IDS or seen.count(id) != 1: return false
	return true
static func automatic(profile: Dictionary, id: String) -> bool:
	var value: Variant = profile.get("first_session")
	return id in IDS and valid(value) and id not in value.seen
static func topics(profile: Dictionary, context: String, point_id: String = "") -> Array:
	var result: Array = []
	var campaign: Dictionary = profile.campaign
	var state: Dictionary = campaign.encounter
	var phase: String = state.get("phase", "")
	var ids: Array = []
	match context:
		"map":
			ids = ["map"]
			if phase in ["battle", "replacement", "capture"]: ids.append("resume")
		"entry": ids = ["entry"]
		"exploration": ids = ["search", "resume"]
		"battle":
			if phase == "battle": ids = ["health", "turn", "skills", "trainer", "team", "resume"]
			elif phase == "replacement": ids = ["replacement", "resume"]
			elif phase == "defeat": ids = ["defeat"]
			elif phase == "capture": ids = ["binding", "skip_binding", "resume"]
		"trainer": ids = ["trainer", "turn"] if phase == "battle" else []
		"team": ids = ["team"] if phase == "battle" else []
		"experience": ids = ["xp"]
		"binding", "choose", "duplicate": ids = ["binding", "skip_binding", "resume"] if phase == "capture" else []
		"defeat": ids = ["defeat"] if phase == "defeat" else []
	# Describe only the current, persisted receipt, never an inferred award.
	var receipt: Dictionary = campaign.get("progression", {}).get("last_reward", {})
	for id in ids:
		var text: String = COPY[id]
		if id == "entry":
			if preload("res://scripts/jade_route.gd").point(point_id).is_empty(): continue
			text = text.replace("{coste}", str(preload("res://scripts/jade_route.gd").entry_cost(point_id)))
		if id == "xp":
			if receipt.get("encounter_id") != state.get("id") or receipt.get("region", "").is_empty(): continue
			var lines: Array[String] = []
			for row in receipt.get("rows", []):
				var caption: String = "Entrenador" if row.id == "trainer" else preload("res://scripts/combat_catalog.gd").species_name(row.get("species_id", ""))
				lines.append("%s: +%d XP%s" % [caption, int(row.gained), " · " + COPY.cap if row.get("capped", false) else ""])
			# Individual XP can differ at the regional cap. Never sum it into a fictitious award.
			text = "\n".join(lines)
			for row in receipt.get("rows", []):
				if row.id == "trainer": text = COPY.xp.replace("{xp}", str(int(row.gained))) + "\n" + text
		if id == "binding":
			if not state.get("capture") is Dictionary: continue
			text = text.replace("{intentos}", str(maxi(0, preload("res://scripts/capture_session.gd").MAX_ATTEMPTS - state.capture.actions.size())))
		if id == "skills":
			var model = preload("res://scripts/encounter_router.gd").create(state)
			if not model.restore(state): continue
			for action_id in ["golpe", "guardia", "insignia"]:
				var definition: Dictionary = preload("res://scripts/combat_catalog.gd").action(state.get("ally_species", "zephyr"), action_id) if state.get("schema") == 2 else preload("res://scripts/trial_encounter.gd").rules().actions[action_id]
				var reason: String = model.reason("karmany", action_id)
				text += "\n%s: %s%s" % [definition.name, definition.get("description", ""), " · " + reason if not reason.is_empty() else ""]
		result.append({"id": id, "text": text})
	return result
