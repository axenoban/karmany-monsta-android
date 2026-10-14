extends Node

const Store = preload("res://scripts/save_store.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const LOG_PATH := "user://diagnostic.log"
var storage := Store.new()
var profile: Dictionary
var build_info: Dictionary = {}
var notice := ""
var load_failed := false

func _ready() -> void:
	profile = storage.load_profile()
	load_failed = not storage.last_error.is_empty()
	if load_failed:
		notice = storage.last_error
	elif storage.recovered_backup:
		notice = "Se recuperó tu partida desde el respaldo."
	var value: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/build_info.json"))
	if value is Dictionary:
		build_info = value
	log_event("Inicio · %s · %s" % [OS.get_name(), build_info.get("commit", "local")])

func commit_profile(next_profile: Dictionary) -> bool:
	if not storage.save_profile(next_profile):
		notice = storage.last_error
		log_event(notice)
		return false
	profile = next_profile.duplicate(true)
	load_failed = false
	return true

func start_journey() -> bool:
	var next_profile := profile.duplicate(true)
	next_profile.journey = {"started": true, "visited_jade": false}
	next_profile.skill_tree = TreeModel.defaults()
	return commit_profile(next_profile)

func visit_jade() -> bool:
	var next_profile := profile.duplicate(true)
	next_profile.journey.visited_jade = true
	return commit_profile(next_profile)

func set_preference(key: String, enabled: bool) -> bool:
	if load_failed or not profile.settings.has(key):
		return false
	var next_profile := profile.duplicate(true)
	next_profile.settings[key] = enabled
	return commit_profile(next_profile)

func change_tree(operation: String, node_id: String = "", expected_rank: int = -1) -> bool:
	if load_failed:
		notice = "Recupera la partida antes de modificar el árbol."
		return false
	var tree := TreeModel.new()
	if not tree.restore(profile.skill_tree):
		notice = tree.last_error
		return false
	if operation == "purchase" and expected_rank >= 0 and int(tree.state.ranks.get(node_id, 0)) != expected_rank:
		notice = "El nodo ya cambió. No se gastó otro punto."
		return false
	var changed := false
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
	var next_profile := profile.duplicate(true)
	next_profile.skill_tree = tree.snapshot()
	return commit_profile(next_profile)

func tap() -> void:
	if profile.settings.haptics and OS.get_name() == "Android":
		Input.vibrate_handheld(18)

func log_event(message: String) -> void:
	var existing := FileAccess.get_file_as_string(LOG_PATH) if FileAccess.file_exists(LOG_PATH) else ""
	if existing.length() > 24000:
		existing = existing.right(12000)
	var handle := FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if handle != null:
		handle.store_string(existing + Time.get_datetime_string_from_system() + " · " + message + "\n")

func diagnostic_report() -> String:
	return "Karmany Monsta · Diagnóstico\nVersión: %s\nBuild: %s\nCommit: %s\nMotor: %s\nSistema: %s %s\nModelo: %s\nPantalla: %s\nFPS: %.0f\nGuardado iniciado: %s\nValle visitado: %s\nRecuperación: %s\n\n%s" % [build_info.get("version", "?"), build_info.get("build", 0), build_info.get("commit", "local"), Engine.get_version_info().string, OS.get_name(), OS.get_version(), OS.get_model_name(), DisplayServer.screen_get_size(), Engine.get_frames_per_second(), profile.journey.started, profile.journey.visited_jade, storage.recovered_backup, FileAccess.get_file_as_string(LOG_PATH) if FileAccess.file_exists(LOG_PATH) else ""]

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED:
		log_event("Aplicación suspendida; los cambios ya están persistidos.")
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		log_event("Aplicación reanudada.")
