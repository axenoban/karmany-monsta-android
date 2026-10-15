class_name CombatCatalog
extends RefCounted
static var _data: Dictionary = {}
static func all_species() -> Dictionary:
	if _data.is_empty():
		_data = JSON.parse_string(FileAccess.get_file_as_string("res://data/tactical_combat.json"))
	return _data.species.duplicate(true)
static func stats(id: String) -> Dictionary:
	return all_species().get(id, {})
static func species_name(id: String) -> String:
	return {"zephyr": "Zephyr", "tanugami": "Tanugami", "ushigane": "Ushigane", "kitsunibi": "Kitsunibi", "sakuromushi": "Sakuromushi", "sakuraneko": "Sakuraneko", "inubari": "Inubari", "suzumeko": "Suzumeko", "kodamashi": "Kodamashi", "mujina_kage": "Mujina-Kage", "tsukimi_usagi": "Tsukimi-Usagi", "kodama_shin": "Kodama-Shin", "karasu_origami": "Karasu-Origami"}.get(id, id)
static func action(species: String, id: String) -> Dictionary:
	if id == "golpe": return {"name": "Golpe", "power": 1.0, "cooldown": 0, "description": "Ataque de potencia 100%."}
	if id == "guardia": return {"name": "Protección", "guard": 0.5, "cooldown": 0, "description": "Reduce 50% el próximo ataque recibido."}
	if id != "insignia": return {}
	var effect: Dictionary = stats(species).get("signature", {}).duplicate(true)
	effect.name = "Insignia"
	effect.description = {
		"zephyr": "Ataque de potencia 150%.",
		"tanugami": "Recupera 12 de Vida y protege 25% del próximo ataque. Sin daño.",
		"ushigane": "Ataque de potencia 125% y protección propia del 25%.",
		"kitsunibi": "Ataque de potencia 120%; reduce 30% el próximo daño rival.",
		"sakuromushi": "Ataque de potencia 70%; tras golpear, releva a una reserva viva y potencia 20% su daño durante 2 rondas. El rival responde contra el nuevo activo."
	}.get(species, "")
	if effect.description.is_empty():
		var parts: Array[String] = []
		if effect.has("power"): parts.append("Daño %d%%." % roundi(effect.power * 100))
		if effect.has("heal"): parts.append("Cura %d de Vida." % int(effect.heal))
		if effect.has("guard"): parts.append("Protección %d%%." % roundi(effect.guard * 100))
		if effect.has("weaken"): parts.append("Próximo daño rival -%d%%." % roundi(effect.weaken * 100))
		if effect.has("grant_boost"): parts.append("Próximo golpe del compañero elegido +%d%%." % roundi(effect.grant_boost * 100))
		effect.description = " ".join(parts)
	return effect

static func stats_at_level(id: String, level: int) -> Dictionary:
	var result:= stats(id)
	if result.is_empty(): return result
	var multiplier:= 1.0 + float(preload("res://scripts/progression_rules.gd").rules().stat_step) * (level - 1)
	for key in ["life", "attack", "defense"]: result[key] = roundi(float(result[key]) * multiplier)
	return result
