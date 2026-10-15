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
	return {"zephyr": "Zephyr", "tanugami": "Tanugami", "ushigane": "Ushigane", "kitsunibi": "Kitsunibi", "sakuromushi": "Sakuromushi"}.get(id, id)
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
		"sakuromushi": "Ataque de potencia 100%; potencia 25% el próximo golpe del compañero elegido."
	}.get(species, "")
	return effect

static func stats_at_level(id: String, level: int) -> Dictionary:
	var result := stats(id)
	if result.is_empty(): return result
	var multiplier := 1.0 + float(preload("res://scripts/progression_rules.gd").rules().stat_step) * (level - 1)
	for key in ["life", "attack", "defense"]: result[key] = roundi(float(result[key]) * multiplier)
	return result
