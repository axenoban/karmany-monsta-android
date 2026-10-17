extends "res://scripts/save_store.gd"
const PATH := "user://qa/profile.json"
func _init() -> void:
	super(PATH)
func save_profile(data: Dictionary) -> bool:
	if base_path != PATH or ProjectSettings.globalize_path(base_path).simplify_path() == ProjectSettings.globalize_path("user://profile.json").simplify_path():
		last_error = "Ruta QA inválida: escritura bloqueada."
		return false
	return super.save_profile(data)
