class_name TacticalEncounter
extends RefCounted
const Catalog = preload("res://scripts/combat_catalog.gd")
const Legacy = preload("res://scripts/trial_encounter.gd")
const Turn = preload("res://scripts/shared_combat_turn.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Capture = preload("res://scripts/capture_session.gd")
var state: Dictionary = {}
var last_error := ""

static func unit(member: Dictionary) -> Dictionary:
	return {"instance_id": member.instance_id, "species_id": member.species_id, "hp": int(Catalog.stats(member.species_id).life), "guard": 0.0, "boost": 0.0, "weaken": 0.0, "ready": {}}
static func unit_valid(data: Variant) -> bool:
	if not data is Dictionary or not data.get("instance_id") is String or data.instance_id.is_empty() or not data.get("species_id") is String or Catalog.stats(data.species_id).is_empty(): return false
	if not Legacy.integer(data.get("hp"), 0, int(Catalog.stats(data.species_id).life)) or not data.get("ready") is Dictionary: return false
	for key in ["guard", "boost", "weaken"]:
		var value: Variant = data.get(key)
		if not (value is float or value is int) or not is_finite(value) or value < 0 or value > 0.8: return false
	for key in data.ready:
		if key not in ["golpe", "guardia", "insignia"] or not Legacy.integer(data.ready[key], 0, 1000000): return false
	return true
static func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("schema") != 2 or not data.get("id") is String or data.id.is_empty(): return false
	if data.get("phase") not in ["battle", "replacement", "capture", "captured", "escaped", "defeat", "retreated"] or not data.get("enemy_pending") is bool: return false
	for key in ["round", "revision"]:
		if not Legacy.integer(data.get(key), 1 if key == "round" else 0, 1000000): return false
	if not data.get("members") is Array or data.members.is_empty() or data.members.size() > 3 or not unit_valid(data.get("enemy")): return false
	var ids := {}
	var active := {}
	var living := 0
	for member in data.members:
		if not unit_valid(member) or ids.has(member.instance_id): return false
		ids[member.instance_id] = true
		if member.hp > 0: living += 1
		if member.instance_id == data.get("ally_id"): active = member
	if active.is_empty() or active.species_id != data.get("ally_species") or active.hp != data.get("player_hp") or data.enemy.hp != data.get("enemy_hp") or data.enemy.species_id != data.get("enemy_species"): return false
	if data.enemy.species_id == "zephyr" or ids.has(data.enemy.instance_id): return false
	if not data.get("loadout") is Dictionary or data.loadout.size() > 4 or not data.get("trainer_ready") is Dictionary: return false
	for key in data.loadout:
		if not Legacy.rules().resonances.has(key) or not Legacy.integer(data.loadout[key], 1, 3): return false
	for key in data.trainer_ready:
		if not data.loadout.has(key) or not Legacy.integer(data.trainer_ready[key], 0, 1000000): return false
	if not data.get("capture") is Dictionary or not data.get("last_action") is String or data.last_action.length() > 500 or not data.get("event") is Dictionary: return false
	if not data.get("rolls") is Array or data.rolls.size() != 3: return false
	for roll in data.rolls:
		if not (roll is float or roll is int) or not is_finite(roll) or roll < 0 or roll >= 1: return false
	var turn := Turn.new()
	if not turn.restore(data.get("turn")) or data.turn.turn_id != "%s:%d" % [data.id, int(data.round)]: return false
	if data.phase == "battle":
		return active.hp > 0 and data.enemy.hp > 0 and data.capture == {} and data.enemy_pending != turn.available("karmany")
	if data.enemy_pending: return false
	if data.phase == "replacement": return active.hp == 0 and living > 0 and data.enemy.hp > 0 and data.capture == {} and not turn.available("karmany")
	if data.phase == "defeat": return living == 0 and data.enemy.hp > 0 and data.capture == {}
	if data.phase == "retreated": return active.hp > 0 and data.enemy.hp > 0 and data.capture == {}
	var capture := Capture.new()
	return active.hp > 0 and data.enemy.hp == 0 and capture.restore(data.get("capture"), Legacy.policy()) and data.capture.encounter_id == data.id and capture.state == ("offered" if data.phase == "capture" else data.phase)

func begin(id: String, tree: Dictionary, rolls: Array, team: Dictionary, enemy_species: String) -> bool:
	if not state.is_empty() or not TreeModel.valid(tree) or enemy_species == "zephyr" or Catalog.stats(enemy_species).is_empty(): return false
	var members := []
	for member in team.members: members.append(unit(member))
	var loadout := {}
	for resonance in tree.equipped: loadout[resonance] = int(tree.ranks[resonance])
	var turn := Turn.new()
	turn.begin(id + ":1")
	state = {"schema": 2, "id": id, "phase": "battle", "round": 1, "revision": 0, "enemy_pending": false, "members": members, "ally_id": team.active_id, "enemy": unit({"instance_id": "rival", "species_id": enemy_species}), "loadout": loadout, "trainer_ready": {}, "rolls": rolls.duplicate(), "last_action": "", "event": {}, "turn": turn.snapshot(), "capture": {}}
	_sync()
	if not valid(state):
		state.clear()
		return false
	return true
func restore(data: Variant) -> bool:
	if not valid(data):
		last_error = "Encuentro táctico guardado inválido."
		return false
	state = data.duplicate(true)
	for key in ["schema", "round", "revision"]: state[key] = int(state[key])
	for member in state.members + [state.enemy]:
		member.hp = int(member.hp)
		for key in member.ready: member.ready[key] = int(member.ready[key])
	for key in ["schema", "sequence"]: state.turn[key] = int(state.turn[key])
	for key in state.loadout: state.loadout[key] = int(state.loadout[key])
	for key in state.trainer_ready: state.trainer_ready[key] = int(state.trainer_ready[key])
	if not state.capture.is_empty(): state.capture.schema = int(state.capture.schema)
	_sync()
	return true
func snapshot() -> Dictionary: return state.duplicate(true)
func active() -> Dictionary:
	for member in state.get("members", []):
		if member.instance_id == state.get("ally_id"): return member
	return {}
func _sync() -> void:
	state.ally_species = active().get("species_id", "")
	state.player_hp = active().get("hp", 0)
	state.enemy_hp = state.enemy.hp
	state.enemy_species = state.enemy.species_id
	state.ready = active().get("ready", {}).duplicate(true)
func _turn() -> SharedCombatTurn:
	var turn := Turn.new()
	turn.restore(state.turn)
	return turn
func ally_name() -> String: return Catalog.species_name(state.ally_species)
func enemy_name() -> String: return Catalog.species_name(state.enemy_species)
func last_action_text() -> String:
	return "Última acción: " + state.last_action if not state.last_action.is_empty() else "Resonancia opcional → habilidad o cambio → rival."
func reason(owner: String, id: String) -> String:
	if state.get("phase") != "battle": return "El combate no acepta acciones."
	if state.enemy_pending: return "Espera la respuesta del rival."
	if not _turn().available(owner): return "Ya usaste esta acción."
	var effect: Dictionary = Catalog.action(state.ally_species, id) if owner == "karmany" else Legacy.rules().resonances.get(id, {})
	if effect.is_empty() or (owner == "trainer" and not state.loadout.has(id)): return "Acción no disponible."
	var ready: Dictionary = active().ready if owner == "karmany" else state.trainer_ready
	if int(ready.get(id, 0)) > state.round: return "Disponible en turno %d." % int(ready[id])
	if effect.has("heal") and active().hp == int(Catalog.stats(state.ally_species).life): return "El activo tiene toda su Vida."
	return ""
func _finish_player(turn: SharedCombatTurn) -> void:
	if turn.state == "open": turn.close_turn()
	state.turn = turn.snapshot()
	if state.enemy.hp == 0:
		var capture := Capture.new()
		capture.begin(state.id, true, true, "Común", Legacy.policy())
		state.capture = capture.snapshot()
		state.phase = "capture"
	else: state.enemy_pending = true
func _log(text: String, side: String, action: String, species: String) -> void:
	state.last_action = text
	state.event = {"side": side, "action": action, "species": species}
	state.revision += 1
	_sync()
func _apply(source: Dictionary, target: Dictionary, effect: Dictionary, recipient: Dictionary, scale: float = 1.0) -> String:
	var parts: Array[String] = []
	if effect.has("power"):
		var raw := maxi(1, roundi(Catalog.stats(source.species_id).attack * effect.power * (1.0 + source.boost) - Catalog.stats(target.species_id).defense))
		var damage := maxi(1, roundi(raw * (1.0 - target.guard) * (1.0 - source.weaken)))
		target.hp = maxi(0, target.hp - damage)
		target.guard = 0.0
		source.weaken = 0.0
		source.boost = 0.0
		parts.append("%d de daño" % damage)
	if effect.has("heal"):
		var amount := mini(int(Catalog.stats(source.species_id).life) - int(source.hp), roundi(effect.heal * scale))
		source.hp += amount
		parts.append("+%d de Vida" % amount)
	if effect.has("guard"):
		source.guard = maxf(source.guard, minf(0.8, effect.guard * scale))
		parts.append("protección %d%%" % roundi(source.guard * 100))
	if effect.has("boost"):
		source.boost = maxf(source.boost, effect.boost * scale)
		parts.append("potenciación %d%%" % roundi(source.boost * 100))
	if effect.has("weaken") and target.hp > 0:
		target.weaken = maxf(target.weaken, minf(0.8, effect.weaken * scale))
		parts.append("próximo daño rival -%d%%" % roundi(target.weaken * 100))
	if effect.has("grant_boost") and recipient.hp > 0:
		recipient.boost = maxf(recipient.boost, effect.grant_boost)
		parts.append("%s: próximo golpe +%d%%" % [Catalog.species_name(recipient.species_id) + " · " + recipient.instance_id, roundi(recipient.boost * 100)])
	return "; ".join(parts)
func act(owner: String, id: String, target_id: String = "") -> bool:
	last_error = reason(owner, id)
	if not last_error.is_empty(): return false
	var source := active()
	var recipient := source
	var effect: Dictionary = Catalog.action(source.species_id, id) if owner == "karmany" else Legacy.rules().resonances[id]
	if effect.has("grant_boost"):
		if not target_id.is_empty():
			recipient = {}
			for member in state.members:
				if member.instance_id == target_id and member.hp > 0: recipient = member
		if recipient.is_empty():
			last_error = "Elige un compañero vivo."
			return false
	var turn := _turn()
	var ticket := turn.reserve(owner, "%s:%d:%s" % [state.id, state.round, owner])
	var result := _apply(source, state.enemy, effect, recipient, 1.0 if owner == "karmany" else 1.0 + (int(state.loadout[id]) - 1) * 0.1)
	if effect.cooldown > 0:
		var ready: Dictionary = source.ready if owner == "karmany" else state.trainer_ready
		ready[id] = state.round + int(effect.cooldown) + 1
	turn.commit_action(ticket)
	state.turn = turn.snapshot()
	if owner == "karmany": _finish_player(turn)
	_log("%s · %s · %s." % [ally_name() if owner == "karmany" else "Ezel", effect.name, result], "ally" if owner == "karmany" else "trainer", id, source.species_id)
	return true
func switch_to(id: String) -> bool:
	if state.get("phase") != "battle" or state.enemy_pending or not _turn().available("karmany"):
		last_error = "No puedes cambiar ahora."
		return false
	var selected := {}
	for member in state.members:
		if member.instance_id == id and member.hp > 0 and id != state.ally_id: selected = member
	if selected.is_empty():
		last_error = "Elige una reserva viva distinta."
		return false
	var turn := _turn()
	var ticket := turn.reserve("karmany", "%s:%d:change" % [state.id, state.round])
	turn.commit_action(ticket)
	state.ally_id = id
	_finish_player(turn)
	_log("Ezel · Cambio · entra %s; el rival responderá." % Catalog.species_name(selected.species_id), "ally", "switch", selected.species_id)
	return true
func _new_round() -> void:
	state.round += 1
	var turn := Turn.new()
	turn.begin("%s:%d" % [state.id, state.round])
	state.turn = turn.snapshot()
func end_round() -> bool:
	if state.get("phase") != "battle" or not state.enemy_pending:
		last_error = "No hay respuesta rival pendiente."
		return false
	var source: Dictionary = state.enemy
	var id := "insignia" if int(source.ready.get("insignia", 0)) <= state.round else "golpe"
	var effect: Dictionary = Catalog.action(source.species_id, id)
	if effect.has("heal") and int(Catalog.stats(source.species_id).life) - source.hp < effect.heal:
		id = "golpe"
		effect = Catalog.action(source.species_id, id)
	var result := _apply(source, active(), effect, source)
	if effect.cooldown > 0: source.ready[id] = state.round + int(effect.cooldown) + 1
	state.enemy_pending = false
	if active().hp == 0:
		state.phase = "defeat"
		for member in state.members:
			if member.hp > 0: state.phase = "replacement"
	else: _new_round()
	_log("%s · %s · %s." % [enemy_name(), effect.name, result], "enemy", id, source.species_id)
	return true
func replace_with(id: String) -> bool:
	if state.get("phase") != "replacement": return false
	for member in state.members:
		if member.instance_id == id and member.hp > 0:
			state.ally_id = id
			state.phase = "battle"
			_new_round()
			_log("Ezel · Reemplazo · entra %s sin otro ataque rival." % Catalog.species_name(member.species_id), "ally", "switch", member.species_id)
			return true
	last_error = "Elige un compañero vivo."
	return false
func attempt_capture() -> bool:
	if state.get("phase") != "capture": return false
	var capture := Capture.new()
	capture.restore(state.capture, Legacy.policy())
	var index := capture.attempts_used()
	capture.attempt("%s:capture:%d" % [state.id, index], state.rolls[index])
	state.capture = capture.snapshot()
	state.phase = "capture" if capture.state == "offered" else capture.state
	_log("Ezel · Libro · " + ("vínculo con %s logrado." % enemy_name() if state.phase == "captured" else ("tercer fallo; %s escapó." % enemy_name() if state.phase == "escaped" else "intento fallido; quedan %d." % capture.remaining_attempts())), "trainer", "capture", state.enemy_species)
	return true
func retreat() -> bool:
	if state.get("phase") not in ["battle", "replacement"] or state.enemy_pending: return false
	state.phase = "retreated"
	if active().hp == 0:
		for member in state.members:
			if member.hp > 0:
				state.ally_id = member.instance_id
				break
	_log("Ezel · Retirada · encuentro abandonado sin recompensa.", "trainer", "retreat", state.ally_species)
	return true
