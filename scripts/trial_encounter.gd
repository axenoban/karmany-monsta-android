class_name TrialEncounter
extends RefCounted

const Turn = preload("res://scripts/shared_combat_turn.gd")
const Capture = preload("res://scripts/capture_session.gd")
const Books = preload("res://scripts/book_progression.gd")
const SkillTreeModel = preload("res://scripts/trainer_skill_tree.gd")
var state: Dictionary = {}
var last_error := ""
static var _rules: Dictionary = {}

static func rules() -> Dictionary:
	if _rules.is_empty():
		_rules = JSON.parse_string(FileAccess.get_file_as_string("res://data/trial_combat.json"))
	return _rules.duplicate(true)

static func integer(value: Variant, low: int, high: int) -> bool:
	return (value is int or value is float) and is_finite(value) and value >= low and value <= high and value == floor(value)

static func policy() -> BookCapturePolicy:
	var books := Books.new()
	books.load_file()
	return books.policy_for("book_initial")

static func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 1 or not data.get("id") is String or data.id.is_empty():
		return false
	if data.get("ally_species", "zephyr") not in ["zephyr", "tanugami"] or not data.get("ally_id", "zephyr-start") is String or data.get("ally_id", "zephyr-start").is_empty():
		return false
	if data.get("phase") not in ["battle", "capture", "captured", "escaped", "defeat", "retreated"]:
		return false
	for key in ["round", "revision"]:
		if not integer(data.get(key), 1 if key == "round" else 0, 1000000):
			return false
	for key in ["player_hp", "enemy_hp"]:
		if not integer(data.get(key), 0, int(rules().stats.life)):
			return false
	for key in ["guard", "boost", "weaken"]:
		var value: Variant = data.get(key)
		if not (value is float or value is int) or not is_finite(value) or value < 0 or value > 0.8:
			return false
	if not data.get("loadout") is Dictionary or data.loadout.size() > 4 or not data.get("ready") is Dictionary:
		return false
	for id in data.loadout:
		if not rules().resonances.has(id) or not integer(data.loadout[id], 1, 3):
			return false
	for id in data.ready:
		if (id != "insignia" and not rules().resonances.has(id)) or not integer(data.ready[id], 0, 1000000):
			return false
	if not data.get("rolls") is Array or data.rolls.size() != 3 or not data.get("log") is Array or data.log.size() > 6:
		return false
	for roll in data.rolls:
		if not (roll is float or roll is int) or not is_finite(roll) or roll < 0 or roll >= 1:
			return false
	for line in data.log:
		if not line is String or line.length() > 300:
			return false
	if data.has("last_action") and (not data.last_action is String or data.last_action.length() > 300):
		return false
	if data.has("enemy_pending") and not data.enemy_pending is bool:
		return false
	var turn := Turn.new()
	if not turn.restore(data.get("turn")) or data.turn.turn_id != "%s:%d" % [data.id, int(data.round)]:
		return false
	if data.phase != "battle" and enemy_pending_from(data):
		return false
	if data.phase == "battle":
		if data.has("enemy_pending") and enemy_pending_from(data) == turn.available("karmany"):
			return false
		return data.player_hp > 0 and data.enemy_hp > 0 and data.get("capture") == {}
	if data.phase == "defeat":
		return data.player_hp == 0 and data.enemy_hp > 0 and data.get("capture") == {}
	if data.phase == "retreated":
		return data.get("capture") == {} and data.player_hp > 0 and data.enemy_hp > 0
	var capture := Capture.new()
	return data.enemy_hp == 0 and data.player_hp > 0 and capture.restore(data.get("capture"), policy()) and data.capture.encounter_id == data.id and capture.state == ("offered" if data.phase == "capture" else data.phase)

func begin(id: String, tree: Dictionary, rolls: Array, ally_species: String = "zephyr", ally_id: String = "zephyr-start") -> bool:
	if not state.is_empty() or id.is_empty() or not SkillTreeModel.valid(tree):
		return false
	var loadout := {}
	for resonance in tree.equipped:
		loadout[resonance] = int(tree.ranks[resonance])
	var turn := Turn.new()
	turn.begin(id + ":1")
	state = {"schema": 1, "id": id, "ally_species": ally_species, "ally_id": ally_id, "phase": "battle", "enemy_pending": false, "round": 1, "revision": 0, "player_hp": int(rules().stats.life), "enemy_hp": int(rules().stats.life), "guard": 0.0, "boost": 0.0, "weaken": 0.0, "ready": {}, "loadout": loadout, "rolls": rolls.duplicate(), "log": [], "last_action": "", "turn": turn.snapshot(), "capture": {}}
	if not valid(state):
		state.clear()
		return false
	return true

func restore(data: Variant) -> bool:
	if not valid(data):
		last_error = "Encuentro guardado inválido."
		return false
	state = data.duplicate(true)
	state.enemy_pending = enemy_pending_from(data)
	state.ally_species = state.get("ally_species", "zephyr")
	state.ally_id = state.get("ally_id", "zephyr-start")
	for key in ["round", "revision", "player_hp", "enemy_hp"]:
		state[key] = int(state[key])
	return true

func snapshot() -> Dictionary:
	return state.duplicate(true)

func _turn() -> SharedCombatTurn:
	var turn := Turn.new()
	turn.restore(state.turn)
	return turn

func reason(owner: String, id: String) -> String:
	if state.get("phase") != "battle":
		return "El combate terminó."
	if state.get("enemy_pending", false):
		return "Espera la respuesta del rival."
	if owner == "trainer" and not _turn().available("karmany"):
		return "La resonancia debe usarse antes de la habilidad del Karmany."
	if not _turn().available(owner):
		return "Ya usaste esta acción en el turno."
	if owner == "trainer" and not state.loadout.has(id):
		return "Equipa esta resonancia antes del encuentro."
	var definitions: Dictionary = rules().actions if owner == "karmany" else rules().resonances
	if not definitions.has(id):
		return "Acción desconocida."
	if int(state.ready.get(id, 0)) > state.round:
		return "Disponible en turno %d." % int(state.ready[id])
	if id == "curacion" and state.player_hp == int(rules().stats.life):
		return ally_name() + " ya tiene toda su vida."
	return ""

func _log(line: String) -> void:
	state.last_action = line
	state.log = [line]

func act(owner: String, id: String) -> bool:
	last_error = reason(owner, id)
	if not last_error.is_empty():
		return false
	var turn := _turn()
	var ticket := turn.reserve(owner, "%s:%d:%s" % [state.id, state.round, owner])
	var definitions: Dictionary = rules().actions if owner == "karmany" else rules().resonances
	var effect: Dictionary = definitions[id]
	var scale := 1.0 if owner == "karmany" else 1.0 + (int(state.loadout[id]) - 1) * 0.1
	if effect.has("power"):
		var damage := maxi(1, roundi(float(rules().stats.attack) * float(effect.power) * (1.0 + float(state.boost)) - float(rules().stats.defense)))
		state.enemy_hp = maxi(0, state.enemy_hp - damage)
		state.boost = 0.0
		_log("%s · %s · %d de daño." % [ally_name(), effect.name, damage])
	elif effect.has("heal"):
		var healing := mini(int(rules().stats.life) - state.player_hp, roundi(effect.heal * scale))
		state.player_hp += healing
		_log("Ezel · %s · +%d de Vida." % [effect.name, healing])
	elif effect.has("guard"):
		state.guard = maxf(state.guard, minf(0.8, effect.guard * scale))
		_log("%s · %s · %d%% de protección ante el próximo ataque." % [ally_name() if owner == "karmany" else "Ezel", effect.name, roundi(state.guard * 100)])
	elif effect.has("boost"):
		state.boost = effect.boost * scale
		_log("Ezel · %s · +%d%% al próximo golpe." % [effect.name, roundi(state.boost * 100)])
	elif effect.has("weaken"):
		state.weaken = effect.weaken * scale
		_log("Ezel · %s · -%d%% de daño del próximo ataque rival." % [effect.name, roundi(state.weaken * 100)])
	if effect.cooldown > 0:
		state.ready[id] = state.round + int(effect.cooldown) + 1
	turn.commit_action(ticket)
	if owner == "karmany" and turn.state == "open":
		turn.close_turn()
	state.turn = turn.snapshot()
	state.revision += 1
	if state.enemy_hp == 0:
		var capture := Capture.new()
		capture.begin(state.id, true, true, "Común", policy())
		state.capture = capture.snapshot()
		state.phase = "capture"
	elif owner == "karmany":
		state.enemy_pending = true
	return true

func end_round() -> bool:
	last_error = ""
	if state.get("phase") != "battle" or not state.get("enemy_pending", false):
		last_error = "Primero elige una acción de " + ally_name() + "."
		return false
	var power := 1.5 if state.round % 3 == 0 else 1.0
	var base_damage := maxi(1, roundi(float(rules().stats.attack) * power - float(rules().stats.defense)))
	var damage := maxi(1, roundi(base_damage * (1.0 - state.guard) * (1.0 - state.weaken)))
	state.player_hp = maxi(0, state.player_hp - damage)
	state.enemy_pending = false
	_log("Tanugami · %s · %d de daño." % ["Insignia" if power > 1.0 else "Golpe", damage])
	state.guard = 0.0
	state.weaken = 0.0
	state.revision += 1
	if state.player_hp == 0:
		state.phase = "defeat"
	else:
		state.round += 1
		var next_turn := Turn.new()
		next_turn.begin("%s:%d" % [state.id, state.round])
		state.turn = next_turn.snapshot()
	return true

func attempt_capture() -> bool:
	if state.get("phase") != "capture":
		last_error = "La captura no está activa."
		return false
	var capture := Capture.new()
	capture.restore(state.capture, policy())
	var index := capture.attempts_used()
	capture.attempt("%s:capture:%d" % [state.id, index], state.rolls[index])
	state.capture = capture.snapshot()
	state.phase = "capture" if capture.state == "offered" else capture.state
	state.revision += 1
	_log("Ezel · Libro · " + ("vínculo logrado." if capture.state == "captured" else ("tercer fallo; Tanugami escapó." if capture.state == "escaped" else "intento fallido; quedan %d." % capture.remaining_attempts())))
	return true

func retreat() -> bool:
	if state.get("phase") != "battle" or state.get("enemy_pending", false):
		last_error = "Espera la respuesta del rival antes de abandonar."
		return false
	state.phase = "retreated"
	state.revision += 1
	_log("Ezel · Retirada · encuentro abandonado sin recompensa.")
	return true

static func last_action_from(data: Dictionary) -> String:
	if data.has("last_action"):
		return data.last_action
	# Recover the actual action from older saves, ignoring the phase announcement.
	var lines: Array = data.get("log", [])
	for index in range(lines.size() - 1, -1, -1):
		var line: String = lines[index]
		if line.begins_with("Zephyr") or line.begins_with("Ezel") or line.begins_with("Tanugami:"):
			return line
	return ""

func last_action_text() -> String:
	var action := last_action_from(state)
	return "Última acción: " + action if not action.is_empty() else "Usa una resonancia opcional primero; la habilidad del Karmany dará paso al rival."

func ally_name() -> String:
	return "Tanugami aliado" if state.get("ally_species", "zephyr") == "tanugami" else "Zephyr"

static func enemy_pending_from(data: Dictionary) -> bool:
	if data.has("enemy_pending"):
		return data.enemy_pending
	if data.get("phase") != "battle":
		return false
	for action in data.get("turn", {}).get("history", []):
		if action.owner == "karmany": return true
	return false
