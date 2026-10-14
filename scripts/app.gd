extends Node

const Store = preload("res://scripts/save_store.gd")
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
