extends SceneTree
# Pruebas UI sin tocar guardados ni ejecutar acciones de combate.
const Kit = preload("res://scripts/adventure_theme.gd")
const UI = preload("res://scripts/jade_ui.gd")
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(value: bool, description: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("UI INTEGRAL: " + description)

func run() -> void:
	var theme: Theme = Kit.create()
	for variation in ["JadePrimary", "JadeSelected", "JadeQuiet", "JadeNav", "JadeDanger"]:
		var button := Button.new()
		button.theme = theme
		button.theme_type_variation = variation
		for state in ["normal", "focus", "disabled"]:
			check(button.get_theme_stylebox(state) != null, variation + " tiene " + state)
		button.free()
	for role in ["primary", "quiet", "navigation", "danger", "selected"]:
		var control := Button.new()
		Kit.apply_role(control, role)
		check(not control.theme_type_variation.is_empty(), "rol " + role)
		control.free()
	var parent := VBoxContainer.new()
	parent.theme = theme
	root.add_child(parent)
	var title := UI.heading(parent, "Exploración")
	check(title.theme_type_variation == "JadePageTitle", "título")
	var section := UI.section(parent, "Acciones de combate")
	check(section.theme_type_variation == "JadeSectionTitle", "sección")
	var status := UI.status(parent, "Entrenador Nv. 1")
	check(status.theme_type_variation == "JadeStatus", "estado")
	var card := UI.panel(parent)
	check(card.get_parent().theme_type_variation == "JadeCard", "tarjeta")
	var last_action := UI.readout(parent, "Última acción", "LastAction")
	check(last_action == parent.get_node_or_null("LastAction"), "LastAction conserva ruta directa del HUD")
	check(last_action.get_node_or_null("ReadoutSurface") != null, "fondo de lectura disponible")
	check(parent.get_child_count() == 5, "composición sin duplicados")
	parent.queue_free()
	for i in range(3): await process_frame
	print("UI INTEGRAL: %d checks, %d failures" % [checks, failures])
	quit(1 if failures > 0 else 0)
