class_name SaveStore
extends RefCounted

const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Campaign = preload("res://scripts/trial_campaign.gd")
const SCHEMA_VERSION := 3
var base_path: String
var last_error := ""
var recovered_backup := false

func _init(path: String = "user://profile.json") -> void:
	base_path = path

static func defaults() -> Dictionary:
	return {"schema": SCHEMA_VERSION, "settings": {"large_text": false, "haptics": true}, "journey": {"started": false, "visited_jade": false}, "skill_tree": TreeModel.defaults(), "campaign": Campaign.defaults()}

static func valid(data: Variant) -> bool:
	if not data is Dictionary or (data.get("schema") != 1 and data.get("schema") != 2 and data.get("schema") != SCHEMA_VERSION):
		return false
	if not data.get("settings") is Dictionary or not data.get("journey") is Dictionary:
		return false
	for key in ["large_text", "haptics"]:
		if not data.settings.get(key) is bool:
			return false
	for key in ["started", "visited_jade"]:
		if not data.journey.get(key) is bool:
			return false
	if data.journey.visited_jade and not data.journey.started:
		return false
	if data.schema == 1:
		return not data.has("skill_tree") and not data.has("campaign")
	return TreeModel.valid(data.get("skill_tree")) and (not data.has("campaign") if data.schema == 2 else Campaign.valid(data.get("campaign")))

func _read(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var handle := FileAccess.open(path, FileAccess.READ)
	if handle == null:
		return null
	var parser := JSON.new()
	if parser.parse(handle.get_as_text()) != OK:
		return null
	var parsed: Variant = parser.data
	if not valid(parsed):
		return null
	# Upgrade old APK saves in memory; preserve the original bytes until a real save.
	if parsed.schema == 1:
		parsed.skill_tree = TreeModel.defaults()
	if parsed.schema < 3:
		parsed.campaign = Campaign.defaults()
	parsed.schema = SCHEMA_VERSION
	parsed.skill_tree = TreeModel.normalized(parsed.skill_tree)
	parsed.campaign = Campaign.normalized(parsed.campaign)
	return parsed

func load_profile() -> Dictionary:
	last_error = ""
	recovered_backup = false
	var primary: Variant = _read(base_path)
	if primary != null:
		return primary
	var backup: Variant = _read(base_path + ".bak")
	if backup != null:
		recovered_backup = true
		return backup
	if FileAccess.file_exists(base_path) or FileAccess.file_exists(base_path + ".bak"):
		last_error = "No se pudo recuperar el guardado. Los archivos originales se conservan."
	return defaults()

func save_profile(data: Dictionary) -> bool:
	last_error = ""
	if not valid(data) or data.schema != SCHEMA_VERSION:
		last_error = "El guardado contiene datos inválidos."
		return false
	var temp_path := base_path + ".tmp"
	var handle := FileAccess.open(temp_path, FileAccess.WRITE)
	if handle == null:
		last_error = "No se pudo escribir el guardado: %s" % error_string(FileAccess.get_open_error())
		return false
	handle.store_string(JSON.stringify(data))
	handle.flush()
	var write_error := handle.get_error()
	handle.close()
	if write_error != OK or _read(temp_path) == null:
		last_error = "No se pudo verificar el guardado temporal."
		return false
	# Preserve the last valid primary. Never rotate a corrupt primary over a good backup.
	if _read(base_path) != null:
		var copy_error := DirAccess.copy_absolute(base_path, base_path + ".bak")
		if copy_error != OK:
			last_error = "No se pudo conservar el respaldo: %s" % error_string(copy_error)
			return false
	var replace_error := DirAccess.rename_absolute(temp_path, base_path)
	if replace_error != OK:
		last_error = "No se pudo finalizar el guardado: %s" % error_string(replace_error)
		return false
	# The very first save also gets a backup.
	if _read(base_path + ".bak") == null:
		var backup_error := DirAccess.copy_absolute(base_path, base_path + ".bak")
		if backup_error != OK:
			last_error = "Partida guardada, pero no se pudo crear su respaldo."
			return false
	return true
