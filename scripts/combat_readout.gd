extends RefCounted
# Read-only presentation adapter. Never owns a live encounter dictionary.
const Catalog = preload("res://scripts/combat_catalog.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const Router = preload("res://scripts/encounter_router.gd")

static func effects(unit: Dictionary) -> String:
	var lines: Array[String] = []
	if unit.get("guard", 0.0) > 0:
		lines.append("Protección %d%%: reduce el próximo ataque recibido." % roundi(unit.guard * 100))
	if unit.get("boost", 0.0) > 0:
		lines.append("Potenciación +%d%%: se consume en su próximo ataque." % roundi(unit.boost * 100))
	if unit.get("relay_boost", 0.0) > 0.0 and int(unit.get("relay_until", 0)) > 0:
		lines.append("Relevo +%d%% hasta turno %d; no se acumula con otra potenciación." % [roundi(unit.relay_boost * 100), int(unit.relay_until)])
	if unit.get("weaken", 0.0) > 0:
		lines.append("Debilitamiento -%d%%: reduce el daño de su próximo ataque." % roundi(unit.weaken * 100))
	return "\n".join(lines) if not lines.is_empty() else "Sin efectos pendientes."

static func describe(effect: Dictionary, scale: float = 1.0) -> String:
	var parts: Array[String] = []
	if effect.has("power"): parts.append("Ataque de potencia %d%%." % roundi(effect.power * 100))
	if effect.has("heal"): parts.append("Recupera hasta %d de Vida al activo, sin superar su máximo." % roundi(effect.heal * scale))
	if effect.has("guard"): parts.append("Protección del %d%% ante el próximo ataque recibido." % roundi(minf(0.8, effect.guard * scale) * 100))
	if effect.has("boost"): parts.append("Potenciación +%d%% al próximo ataque del activo." % roundi(effect.boost * scale * 100))
	if effect.has("weaken"): parts.append("Reduce %d%% el daño del próximo ataque rival." % roundi(minf(0.8, effect.weaken * scale) * 100))
	if effect.has("grant_boost"): parts.append("Tras atacar, otorga +%d%% al próximo ataque del compañero vivo elegido, incluido él mismo o una reserva." % roundi(effect.grant_boost * 100))
	if effect.has("relay_boost"): parts.append("Tras atacar, intercambia con una reserva viva. Su ataque aumenta %d%% durante las próximas %d rondas. El rival responde contra quien entra." % [roundi(effect.relay_boost * 100), int(effect.relay_rounds)])
	return " ".join(parts)

static func _unit(data: Dictionary, tactical: bool, role: String, active_id: String, round_id: int) -> Dictionary:
	var stats: Dictionary = Catalog.stats_at_level(data.species_id, int(data.get("level", 1))) if tactical else Legacy.rules().stats
	var ready: int = int(data.ready.get("insignia", 0))
	return {"name": Catalog.species_name(data.species_id), "level": int(data.get("level", 1)), "id": data.instance_id, "role": role if role == "Rival" else ("Derrotado" if data.hp == 0 else ("Activo" if data.instance_id == active_id else "Reserva")), "hp": int(data.hp), "max_hp": int(stats.life), "attack": int(stats.attack), "defense": int(stats.defense), "effects": effects(data), "signature_ready": "Insignia: vuelve en turno %d." % ready if ready > round_id else "Insignia: sin recarga pendiente."}

static func build(snapshot: Dictionary) -> Dictionary:
	var model = Router.create(snapshot)
	if not model.restore(snapshot): return {}
	var data: Dictionary = model.snapshot()
	var tactical: bool = data.schema == 2
	var members: Array
	var enemy: Dictionary
	if tactical:
		members = data.members
		enemy = data.enemy
	else:
		members = [{"instance_id": data.ally_id, "species_id": data.ally_species, "hp": data.player_hp, "guard": data.guard, "boost": data.boost, "weaken": 0.0, "ready": data.ready}]
		enemy = {"instance_id": "rival", "species_id": "tanugami", "hp": data.enemy_hp, "guard": 0.0, "boost": 0.0, "weaken": data.weaken, "ready": {}}
	var team := []
	var active := {}
	for member in members:
		var entry := _unit(member, tactical, "Equipo", data.ally_id, int(data.round))
		team.append(entry)
		if member.instance_id == data.ally_id: active = entry
	var skills := []
	for id in ["golpe", "guardia", "insignia"]:
		var definition: Dictionary = Catalog.action(data.ally_species, id) if tactical else Legacy.rules().actions[id]
		skills.append({"name": definition.name, "description": describe(definition), "cooldown": int(definition.cooldown), "ready_turn": int(data.ready.get(id, 0)), "status": model.reason("karmany", id)})
	var resonances := []
	for id in data.loadout:
		var rank_id: int = int(data.loadout[id])
		var definition: Dictionary = Legacy.rules().resonances[id]
		resonances.append({"name": definition.name + " · rango %d" % rank_id, "description": describe(definition, 1.0 + (rank_id - 1) * 0.1), "cooldown": int(definition.cooldown), "ready_turn": int(data.get("trainer_ready", data.ready).get(id, 0)), "status": model.reason("trainer", id)})
	var phase_text: String = {"battle": "Resonancia opcional → habilidad o cambio → respuesta rival.", "replacement": "Elige un compañero vivo: el reemplazo no provoca otro ataque rival.", "capture": "Rival derrotado: usa el Libro para intentar el vínculo.", "captured": "Vínculo logrado.", "escaped": "El rival escapó.", "defeat": "Equipo derrotado.", "retreated": "Encuentro abandonado."}.get(data.phase, "")
	if not tactical and data.phase == "battle": phase_text = "Resonancia opcional → habilidad del Karmany → respuesta rival."
	if Router.pending(data): phase_text = "Respuesta rival pendiente. Las acciones del jugador están bloqueadas."
	var rival_entry := _unit(enemy, tactical, "Rival", "", int(data.round))
	if not tactical: rival_entry.signature_ready = "Insignia: cada tercer turno del encuentro anterior."
	return {"turn": int(data.round), "phase": phase_text, "legacy": not tactical, "active": active, "enemy": rival_entry, "team": team, "skills": skills, "resonances": resonances}
