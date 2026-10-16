extends Node

const CombatTransition = preload("res://scripts/combat_transition.gd")
var pending_transition: Dictionary = {}
const Aftermath = preload("res://scripts/aftermath_flow.gd")
const EffectAudio = preload("res://scripts/effect_audio.gd")
var ui_audio: Node
const Progress = preload("res://scripts/level_progression.gd")
const ProgressRules = preload("res://scripts/progression_rules.gd")
signal combat_updated
signal profile_changed
const QAStore = preload("res://scripts/qa_store.gd")
var qa_active := false
var qa_preset: Dictionary = {}
var normal_storage: RefCounted
var profile_epoch := 0
var ui_epoch := 0
const RESPONSE_DELAY:= 0.7
var response_timer: Timer
var response_error:= ""
var application_paused:= false
var response_encounter_id:= ""
var response_revision:= -1

const Store = preload("res://scripts/save_store.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Energy = preload("res://scripts/exploration_energy.gd")
const Route = preload("res://scripts/jade_route.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const Router = preload("res://scripts/encounter_router.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
var animation_key:= ""

var pending_experience_id:= ""
const Campaign = preload("res://scripts/trial_campaign.gd")
const LOG_PATH:= "user://diagnostic.log"
var storage:= Store.new()
var profile: Dictionary
var build_info: Dictionary = {}
var notice:= ""
var load_failed:= false

func _ready() -> void :
	response_timer = Timer.new()
	response_timer.one_shot = true
	var initial_epoch := profile_epoch
	response_timer.timeout.connect(func():
		if initial_epoch == profile_epoch: _resolve_enemy_response())
	add_child(response_timer)
	var bus:= AudioServer.get_bus_index("SFX")
	if bus < 0:
		AudioServer.add_bus()
		bus = AudioServer.bus_count - 1
		AudioServer.set_bus_name(bus, "SFX")
		var limiter:= AudioEffectLimiter.new()
		limiter.ceiling_db = -1.0
		limiter.threshold_db = -3.0
		AudioServer.add_bus_effect(bus, limiter)
	ui_audio = EffectAudio.new()
	add_child(ui_audio)
	var first_install := not FileAccess.file_exists(storage.base_path) and not FileAccess.file_exists(storage.base_path + ".bak")
	profile = storage.load_profile()
	if first_install and storage.last_error.is_empty(): profile.first_session = preload("res://scripts/first_session.gd").fresh()
	apply_audio_preferences()
	load_failed = not storage.last_error.is_empty()
	if load_failed:
		notice = storage.last_error
	elif storage.recovered_backup:
		notice = "Se recuperó tu partida desde el respaldo."
	var value: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/build_info.json"))
	if value is Dictionary:
		build_info = value
	log_event("Inicio · %s · %s" % [OS.get_name(), build_info.get("commit", "local")])
	if not profile.campaign.encounter.is_empty():
		animation_key = "%s:%d" % [profile.campaign.encounter.id, int(profile.campaign.encounter.revision)]
	_schedule_enemy_response()

func commit_profile(next_profile: Dictionary) -> bool:
	if qa_active and (not qa_available() or not storage is QAStore or storage.base_path != QAStore.PATH):
		notice = "Escritura bloqueada: aislamiento QA inválido."
		return false
	var candidate:= next_profile.duplicate(true)
	if Store.valid(candidate) and candidate.get("schema") == Store.SCHEMA_VERSION:
		candidate.skill_tree = TreeModel.normalized(candidate.skill_tree)
		candidate.campaign = Campaign.normalized(candidate.campaign)
	if not storage.save_profile(candidate):
		notice = storage.last_error
		log_event(notice)
		return false
	profile = candidate.duplicate(true)
	apply_audio_preferences()
	load_failed = false
	_schedule_enemy_response()
	return true

func start_journey() -> bool:
	var next_profile:= profile.duplicate(true)
	next_profile.first_session = preload("res://scripts/first_session.gd").fresh()
	next_profile.r1_intro = {"version": 1, "status": "pending"}
	next_profile.journey = {"started": true, "visited_jade": false}
	next_profile.skill_tree = TreeModel.defaults()
	next_profile.campaign = Campaign.defaults()
	return commit_profile(next_profile)

func visit_jade() -> bool:
	var next_profile:= profile.duplicate(true)
	next_profile.journey.visited_jade = true
	return commit_profile(next_profile)

func set_preference(key: String, enabled: bool) -> bool:
	if load_failed or not profile.settings.has(key):
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.settings[key] = enabled
	return commit_profile(next_profile)

func change_tree(operation: String, node_id: String = "", expected_rank: int = -1) -> bool:
	if operation in ["level", "capture"] and not (qa_active and qa_available()):
		notice = "Esta simulación requiere el laboratorio QA aislado."
		return false
	if load_failed:
		notice = "Recupera la partida antes de modificar el árbol."
		return false
	var tree:= TreeModel.new()
	if not tree.restore(profile.skill_tree):
		notice = tree.last_error
		return false
	if operation == "purchase" and expected_rank >= 0 and int(tree.state.ranks.get(node_id, 0)) != expected_rank:
		notice = "El nodo ya cambió. No se gastó otro punto."
		return false
	var changed:= false
	match operation:
		"purchase": changed = tree.purchase(node_id)
		"equip": changed = tree.equip(node_id)
		"unequip": changed = tree.unequip(node_id)
		"level": changed = tree.gain_level()
		"capture": changed = tree.record_capture(node_id)
		"reset":
			tree.reset_allocation()
			changed = true
	if not changed:
		notice = tree.last_error if not tree.last_error.is_empty() else "Operación del árbol desconocida."
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.skill_tree = tree.snapshot()
	if not commit_profile(next_profile): return false
	play_sfx("item")
	return true

func apply_audio_preferences() -> void :
	var bus:= AudioServer.get_bus_index("SFX")
	if bus < 0: return
	var settings: Dictionary = profile.get("settings", {})
	var level: float = float(settings.get("effects_volume", 0.65))
	AudioServer.set_bus_volume_db(bus, linear_to_db(maxf(level, 0.001)) - 6.0)
	AudioServer.set_bus_mute(bus, not settings.get("sound", true) or level <= 0.0)

func set_effect_volume(level: float) -> bool:
	if load_failed or not is_finite(level) or level < 0 or level > 1: return false
	var next:= profile.duplicate(true)
	next.settings.effects_volume = level
	return commit_profile(next)

func play_sfx(id: String) -> void :
	if ui_audio != null: ui_audio.play_cue(id)

func tap() -> void :
	play_sfx("tap")
	if profile.settings.haptics and OS.get_name() == "Android":
		Input.vibrate_handheld(18)

func log_event(message: String) -> void :
	var existing:= FileAccess.get_file_as_string(LOG_PATH) if FileAccess.file_exists(LOG_PATH) else ""
	if existing.length() > 24000:
		existing = existing.right(12000)
	var handle:= FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if handle != null:
		handle.store_string(existing + Time.get_datetime_string_from_system() + " · " + message + "\n")

func diagnostic_report() -> String:
	return "Karmany Monsta · Diagnóstico\nVersión: %s\nBuild: %s\nCommit: %s\nMotor: %s\nSistema: %s %s\nModelo: %s\nPantalla: %s\nFPS: %.0f\nGuardado iniciado: %s\nValle visitado: %s\nRecuperación: %s\n\n%s" % [build_info.get("version", "?"), build_info.get("build", 0), build_info.get("commit", "local"), Engine.get_version_info().string, OS.get_name(), OS.get_version(), OS.get_model_name(), DisplayServer.screen_get_size(), Engine.get_frames_per_second(), profile.journey.started, profile.journey.visited_jade, storage.recovered_backup, FileAccess.get_file_as_string(LOG_PATH) if FileAccess.file_exists(LOG_PATH) else ""]

func _notification(what: int) -> void :
	if what == NOTIFICATION_APPLICATION_PAUSED:
		application_paused = true
		if response_timer != null: response_timer.stop()
		log_event("Aplicación suspendida; los cambios ya están persistidos.")
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		application_paused = false
		_schedule_enemy_response()
		log_event("Aplicación reanudada.")

func start_trial(enemy_species: String = "tanugami") -> bool:
	return _start_encounter(enemy_species)

func start_route(point_id: String) -> bool:
	if load_failed: return false
	var route: Dictionary = profile.campaign.get("route", Route.defaults())
	var selected:= Route.point(point_id)
	if selected.is_empty() or not Route.unlocked(route, point_id):
		notice = "Vence en el punto anterior para desbloquear este encuentro."
		return false
	if not profile.campaign.encounter.is_empty() and profile.campaign.encounter.phase in ["battle", "replacement", "capture"]:
		if route.current.get("point_id") == point_id: return true
		notice = "Retoma y termina el encuentro actual antes de iniciar otro."
		return false
	var reason:= ProgressRules.region_reason(profile.skill_tree, Route.region_for(point_id))
	if not reason.is_empty() and not qa_active:
		notice = reason
		return false
	return _start_encounter(selected.species, point_id)

func _start_encounter(enemy_species: String, point_id: String = "") -> bool:
	if load_failed:
		return false
	var next_profile:= profile.duplicate(true)
	if not next_profile.campaign.encounter.is_empty() and next_profile.campaign.encounter.phase in ["battle", "replacement", "capture"]:
		return true
	if not Roster.valid(next_profile.campaign.team, next_profile.campaign):
		notice = "Elige un equipo válido antes de comenzar."
		return false
	var energy: Dictionary = next_profile.campaign.get("exploration", Energy.defaults())
	if not point_id.is_empty():
		energy = Energy.spend(energy, Route.entry_cost(point_id), int(Time.get_unix_time_from_system()))
		if energy.is_empty():
			notice = "Stamina insuficiente. Espera la recuperación o usa un recuperador en el mapa."
			return false
	energy.drop = {}
	energy.scouting = not point_id.is_empty()
	next_profile.campaign.exploration = energy
	if not qa_active and not point_id.is_empty() and not ProgressRules.region_reason(next_profile.skill_tree, Route.region_for(point_id)).is_empty():
		notice = ProgressRules.region_reason(next_profile.skill_tree, Route.region_for(point_id))
		return false
	next_profile.campaign.progression = Progress.normalized(next_profile.campaign)
	var prepared_team: Dictionary = next_profile.campaign.team.duplicate(true)
	for member in prepared_team.members: member.level = int(next_profile.campaign.progression.units[member.instance_id].level)
	var encounter:= Tactical.new()
	next_profile.campaign.aftermath = {}
	next_profile.campaign.sequence += 1
	var rolls:= [randf(), randf(), randf()]
	if not encounter.begin("jade-%d" % int(next_profile.campaign.sequence), profile.skill_tree, rolls, prepared_team, enemy_species, ProgressRules.current_book(next_profile.skill_tree)):
		notice = encounter.last_error
		return false
	if not point_id.is_empty() and Route.point(point_id).has("level"):
		var contract := preload("res://scripts/regional_policy.gd").freeze(Route.point(point_id), Route.region_for(point_id), next_profile.campaign.progression.bonuses)
		if not encounter.configure_region(contract):
			notice = "Configuración regional inválida."
			return false
	next_profile.campaign.encounter = encounter.snapshot()
	if not next_profile.campaign.has("route"): next_profile.campaign.route = Route.defaults()
	next_profile.campaign.route.current = {} if point_id.is_empty() else {"point_id": point_id, "encounter_id": encounter.state.id}
	if not point_id.is_empty():
		next_profile.campaign.exploration.drop = {"encounter_id": encounter.state.id, "roll": randi_range(0, 9999), "resolved": false, "received": false}
	next_profile.journey.started = true
	next_profile.journey.visited_jade = true
	if not commit_profile(next_profile): return false
	play_sfx("enter")
	return true

func mark_intro_seen() -> bool:
	if load_failed:
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.intro_seen = true
	return commit_profile(next_profile)

func trial_action(operation: String, action_id: String = "", expected_revision: int = -1, target_id: String = "") -> bool:
	if load_failed:
		return false
	var encounter = Router.create(profile.campaign.encounter)
	if not encounter.restore(profile.campaign.encounter):
		notice = encounter.last_error
		return false
	if expected_revision >= 0 and expected_revision != encounter.state.revision:
		notice = "Esta acción ya fue procesada."
		return false
	if profile.campaign.get("exploration", Energy.defaults()).scouting and operation != "retreat":
		notice = "Explora la localización antes de iniciar el combate."
		return false
	var previous_state: Dictionary = encounter.snapshot()
	var previous_phase: String = encounter.state.phase
	var changed:= false
	match operation:
		"karmany", "trainer":
			changed = encounter.act(operation, action_id, target_id) if encounter is Tactical else encounter.act(operation, action_id)
		"switch": changed = encounter.switch_to(action_id) if encounter is Tactical else false
		"replace": changed = encounter.replace_with(action_id) if encounter is Tactical else false
		"enemy": changed = encounter.end_round()
		"capture": changed = encounter.attempt_capture()
		"choose_capture": changed = encounter.choose_capture(action_id) if encounter is Tactical else false
		"retreat": changed = encounter.retreat()
	if not changed:
		notice = encounter.last_error
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.encounter = encounter.snapshot()
	if next_profile.campaign.has("exploration"): next_profile.campaign.exploration.scouting = false
	if encounter is Tactical:
		next_profile.campaign.team.active_id = encounter.state.ally_id
	var tree:= TreeModel.new()
	tree.restore(next_profile.skill_tree)
	if previous_phase == "battle" and encounter.state.phase == "capture":
		next_profile.campaign.victories += 1
		if next_profile.campaign.has("exploration"): next_profile.campaign.exploration = Energy.resolve_drop(next_profile.campaign.exploration, encounter.state.id)
		if next_profile.campaign.has("route"):
			next_profile.campaign.route = Route.record_victory(next_profile.campaign.route, encounter.state.id)
		next_profile.campaign.progression = Progress.award(next_profile.campaign, tree.state, encounter.state)
		next_profile.campaign.aftermath = Aftermath.checkpoint(next_profile.campaign, "victory")
	if previous_phase == "capture" and encounter.state.phase == "captured":
		var captured_species: String = encounter.state.get("enemy_species", "tanugami")
		next_profile.campaign.collection.append({"id": encounter.state.id, "species": captured_species})
		next_profile.campaign.progression = Progress.normalized(next_profile.campaign)
		if encounter.state.has("regional"):
			next_profile.campaign.progression.units[encounter.state.id] = {"level": int(encounter.state.enemy.get("level", 1)), "xp": 0}
		if not tree.state.captured_species.has(captured_species):
			tree.record_capture(captured_species)
	if operation == "choose_capture":
		next_profile.campaign.aftermath = Aftermath.checkpoint(next_profile.campaign, Aftermath.decision(next_profile.campaign))
	elif operation == "capture":
		next_profile.campaign.aftermath = Aftermath.checkpoint(next_profile.campaign, "binding") if encounter.state.phase == "capture" else {}
	next_profile.skill_tree = tree.snapshot()
	if not commit_profile(next_profile): return false
	pending_transition = CombatTransition.between(previous_state, encounter.state, operation, action_id)
	if previous_phase == "battle" and encounter.state.phase == "capture":
		pending_experience_id = encounter.state.id
		if pending_transition.is_empty(): play_sfx("victory")
	elif encounter.state.phase == "defeat" and previous_phase != "defeat" and pending_transition.is_empty(): play_sfx("defeat")
	elif operation == "retreat": play_sfx("switch")
	return true

func change_team(operation: String, instance_id: String) -> bool:
	if load_failed:
		return false
	var roster:= Roster.new()
	var next_team:= roster.change(profile.campaign, operation, instance_id)
	if next_team.is_empty():
		notice = roster.last_error
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.team = next_team
	if not commit_profile(next_profile): return false
	play_sfx("switch")
	return true

func _schedule_enemy_response() -> void :
	if response_timer == null:
		return
	response_timer.stop()
	response_error = ""
	response_encounter_id = ""
	response_revision = -1
	if application_paused or load_failed or profile.campaign.encounter.is_empty():
		return
	var data: Dictionary = profile.campaign.encounter
	if not Router.pending(data):
		return
	response_encounter_id = data.id
	response_revision = int(data.revision)
	response_timer.start(RESPONSE_DELAY)

func _resolve_enemy_response() -> void :
	if application_paused or profile.campaign.encounter.is_empty():
		return
	var data: Dictionary = profile.campaign.encounter
	if data.id != response_encounter_id or int(data.revision) != response_revision or not Router.pending(data):
		return
	if not trial_action("enemy", "", response_revision):
		response_error = notice
	combat_updated.emit()

func retry_enemy_response() -> void :
	_schedule_enemy_response()
	combat_updated.emit()

func consume_animation(data: Dictionary) -> bool:
	var key:= "%s:%d" % [data.id, int(data.revision)]
	if key == animation_key: return false
	animation_key = key
	return not data.get("event", {}).is_empty()

func continue_route(expected_encounter_id: String, expected_revision: int) -> bool:
	if load_failed: return false
	var campaign: Dictionary = profile.campaign
	var encounter: Dictionary = campaign.encounter
	var route: Dictionary = campaign.get("route", Route.defaults())
	if encounter.is_empty() or encounter.id != expected_encounter_id or int(encounter.revision) != expected_revision or route.current.get("encounter_id") != encounter.id or encounter.phase not in ["capture", "captured", "escaped"] or not Route.completed(route, route.current.get("point_id", "")):
		notice = "Este resultado ya cambió o el encuentro no terminó en victoria."
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.encounter = {}
	next_profile.campaign.aftermath = {}
	next_profile.campaign.route.current = {}
	if next_profile.campaign.has("exploration"):
		next_profile.campaign.exploration.drop = {}
		next_profile.campaign.exploration.scouting = false
	return commit_profile(next_profile)

func stamina_view(now: int = -1) -> Dictionary:
	return Energy.refreshed(profile.campaign.get("exploration", Energy.defaults()), int(Time.get_unix_time_from_system()) if now < 0 else now)

func use_recovery_item(expected_revision: int) -> bool:
	if load_failed: return false
	var current: Dictionary = profile.campaign.get("exploration", Energy.defaults())
	if int(current.revision) != expected_revision:
		notice = "El inventario ya cambió."
		return false
	var next_energy:= Energy.consume_item(current, int(Time.get_unix_time_from_system()))
	if next_energy.is_empty():
		notice = "Necesitas un recuperador y stamina por recuperar."
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.exploration = next_energy
	if not commit_profile(next_profile): return false
	play_sfx("item")
	return true

func discover_location(expected_id: String) -> bool:
	if load_failed or not profile.campaign.get("exploration", Energy.defaults()).scouting or profile.campaign.encounter.get("id") != expected_id: return false
	var next_profile:= profile.duplicate(true)
	next_profile.campaign.exploration.scouting = false
	if not commit_profile(next_profile): return false
	play_sfx("enter")
	return true

func purchase_unlock(id: String) -> bool:
	if load_failed: return false
	if not profile.campaign.encounter.is_empty() and profile.campaign.encounter.phase in ["battle", "replacement", "capture"]:
		notice = "Termina el encuentro antes de mejorar el Libro."
		return false
	var tree:= TreeModel.new()
	if not tree.restore(profile.skill_tree) or not tree.purchase_unlock(id):
		notice = tree.last_error
		return false
	var next_profile:= profile.duplicate(true)
	next_profile.skill_tree = tree.snapshot()
	if not commit_profile(next_profile): return false
	play_sfx("item")
	return true
func redistribute_resonances() -> bool:
	if not profile.campaign.encounter.is_empty() and profile.campaign.encounter.phase in ["battle", "replacement", "capture"]:
		notice = "Termina el encuentro antes de redistribuir."
		return false
	return change_tree("reset")

func consume_experience(encounter_id: String) -> Dictionary:
	if pending_experience_id != encounter_id: return {}
	pending_experience_id = ""
	var receipt: Dictionary = profile.campaign.get("progression", {}).get("last_reward", {})
	if receipt.get("encounter_id") != encounter_id or receipt.get("region", "").is_empty(): return {}
	return receipt.duplicate(true)

func select_region(region_id: String) -> bool:
	var reason:= ProgressRules.region_reason(profile.skill_tree, region_id)
	if not reason.is_empty() and not qa_active:
		notice = reason
		return false
	if not profile.campaign.encounter.is_empty() and profile.campaign.encounter.phase in ["battle", "replacement", "capture"]:
		notice = "Termina el encuentro antes de viajar entre regiones."
		return false
	var next:= profile.duplicate(true)
	next.campaign.route = Route.normalized(next.campaign.route)
	next.campaign.route.selected = region_id
	return commit_profile(next)


func advance_aftermath(encounter_id: String, expected_step: String) -> bool:
	if load_failed or profile.campaign.encounter.get("id") != encounter_id or Aftermath.step(profile.campaign) != expected_step: return false
	var next_step:= Aftermath.next(profile.campaign)
	if next_step.is_empty(): return false
	var candidate:= profile.duplicate(true)
	candidate.campaign.aftermath = Aftermath.checkpoint(candidate.campaign, next_step)
	if not commit_profile(candidate): return false
	pending_experience_id = ""
	return true

func finish_aftermath(encounter_id: String, revision: int) -> bool:
	var encounter: Dictionary = profile.campaign.encounter
	if load_failed or encounter.get("id") != encounter_id or int(encounter.get("revision", -1)) != revision or encounter.get("phase") not in ["capture", "captured", "escaped", "defeat", "retreated"]: return false
	if profile.campaign.route.current.get("encounter_id") == encounter_id and encounter.phase in ["capture", "captured", "escaped"]:
		return continue_route(encounter_id, revision)
	var candidate:= profile.duplicate(true)
	candidate.campaign.encounter = {}
	candidate.campaign.aftermath = {}
	candidate.campaign.route.current = {}
	candidate.campaign.exploration.drop = {}
	candidate.campaign.exploration.scouting = false
	return commit_profile(candidate)

func consume_transition() -> Dictionary:
	var receipt:= pending_transition
	pending_transition = {}
	if receipt.get("id") != profile.campaign.encounter.get("id") or receipt.get("revision") != profile.campaign.encounter.get("revision"): return {}
	return receipt

func dismiss_first_session(id: String) -> bool:
	var session = preload("res://scripts/first_session.gd")
	if load_failed or not session.automatic(profile, id): return false
	var next := profile.duplicate(true)
	next.first_session.seen.append(id)
	return commit_profile(next)

# Presentation acknowledgment only; the normal transaction owns all persistence.
func finish_r1_intro(status: String) -> bool:
	if load_failed or status not in ["completed", "skipped"] or not profile.has("r1_intro"): return false
	if profile.r1_intro.status != "pending": return true
	var next := profile.duplicate(true)
	next.r1_intro.status = status
	next.campaign.intro_seen = true
	return commit_profile(next)

# Export feature is explicit. Editor runs require the explicit development setting.
func qa_available() -> bool:
	return OS.has_feature("qa_preview") or (OS.has_feature("editor") and bool(ProjectSettings.get_setting("karmany/qa/development", false)))

func _switch_profile(next_store: RefCounted, next_profile: Dictionary, is_qa: bool) -> void:
	profile_epoch += 1
	if qa_active != is_qa: ui_epoch += 1
	if response_timer != null:
		response_timer.stop()
		response_timer.queue_free()
	response_timer = Timer.new()
	response_timer.one_shot = true
	var epoch := profile_epoch
	response_timer.timeout.connect(func():
		if epoch == profile_epoch: _resolve_enemy_response())
	add_child(response_timer)
	pending_transition = {}
	pending_experience_id = ""
	animation_key = ""
	response_encounter_id = ""
	response_revision = -1
	storage = next_store
	profile = next_profile.duplicate(true)
	qa_active = is_qa
	load_failed = false
	apply_audio_preferences()
	profile_changed.emit()
	_schedule_enemy_response()

func enter_qa() -> bool:
	if not qa_available() or qa_active or load_failed: return false
	if DirAccess.make_dir_recursive_absolute("user://qa") != OK:
		notice = "No se pudo crear el directorio QA. Tu partida no cambió."
		return false
	var target := QAStore.new()
	var fresh := preload("res://scripts/qa_profile.gd").preset(1, 0, [{"species":"zephyr", "level":1}], 0, "jade", 1, 100)
	if not target.save_profile(fresh):
		notice = target.last_error
		return false
	normal_storage = storage
	qa_preset = fresh.duplicate(true)
	_switch_profile(target, fresh, true)
	return true

func apply_qa(candidate: Dictionary) -> bool:
	if not qa_active or not qa_available() or candidate.is_empty() or not Store.valid(candidate): return false
	if not commit_profile(candidate): return false
	qa_preset = candidate.duplicate(true)
	_switch_profile(storage, candidate, true)
	return true

func exit_qa() -> bool:
	if not qa_active or normal_storage == null: return false
	var restored: Dictionary = normal_storage.load_profile()
	if not normal_storage.last_error.is_empty():
		notice = "No se pudo recuperar la partida normal. Permaneces en QA sin escribirla. " + normal_storage.last_error
		return false
	_switch_profile(normal_storage, restored, false)
	normal_storage = null
	qa_preset = {}
	return true
