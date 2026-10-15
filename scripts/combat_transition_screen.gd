extends Control
signal finished
const Flow = preload("res://scripts/combat_transition.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
var receipt: Dictionary
var background_id:= "jade"
var elapsed:= 0.0
var done:= false
var arena: Control
var caption: Label
var app: Node
var entered:= false
func _ready() -> void :
	name = "CombatTransition"
	add_to_group("combat_transition")
	app = get_node("/root/App")
	mouse_filter = Control.MOUSE_FILTER_STOP
	arena = Stage.new()
	arena.background_id = background_id
	arena.actor_scale = 0.6
	arena.floor_ratio = 0.8
	arena.show_trainers = false
	arena.ally_species = receipt.before.get("ally_species", "zephyr")
	arena.enemy_species = receipt.before.get("enemy_species", "tanugami")
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade:= ColorRect.new()
	shade.color = Color(0.015, 0.04, 0.05, 0.3)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	caption = Label.new()
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_font_size_override("font_size", 32 if app.profile.settings.large_text else 28)
	caption.add_theme_color_override("font_shadow_color", Color.BLACK)
	caption.add_theme_constant_override("shadow_offset_x", 2)
	caption.add_theme_constant_override("shadow_offset_y", 2)
	add_child(caption)
	caption.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	caption.offset_top = 28
	caption.offset_left = 24
	caption.offset_right = -24
	var skip:= Button.new()
	skip.text = "Continuar"
	skip.custom_minimum_size = Vector2(210, 58)
	skip.add_theme_font_size_override("font_size", 26)
	var style:= StyleBoxFlat.new()
	style.bg_color = Color("163c42")
	style.border_color = Color("86c5c9")
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	skip.add_theme_stylebox_override("normal", style)
	add_child(skip)
	skip.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	skip.position -= Vector2(234, 82)
	skip.size = Vector2(210, 58)
	skip.pressed.connect(finish)
	if not receipt.fallen.is_empty(): arena.play(receipt.event)
	arena.set_process(false)
	update_frame()
func _process(delta: float) -> void :
	if done or app.application_paused: return
	elapsed = minf(Flow.duration(receipt), elapsed + maxf(delta, 0))
	update_frame()
	if elapsed >= Flow.duration(receipt): finish()
func update_frame() -> void :
	var has_fall: bool = not receipt.fallen.is_empty()
	var entry_start:= Flow.HIT + Flow.FALL if has_fall else 0.0
	arena.elapsed = minf(elapsed, Stage.DURATION)
	if arena.effect_audio != null: arena.effect_audio.advance(elapsed)
	if has_fall and elapsed < Flow.HIT:
		caption.text = ""
	elif has_fall and elapsed < entry_start:
		arena.fallen_side = receipt.fallen
		arena.fall_progress = clampf((elapsed - Flow.HIT) / Flow.FALL, 0, 1)
		var species: String = receipt.before.get("ally_species", "zephyr") if receipt.fallen == "ally" else receipt.before.get("enemy_species", "tanugami")
		caption.text = Catalog.species_name(species) + " no puede continuar"
	elif not receipt.entry.is_empty():
		if not entered:
			entered = true
			arena.effect_audio.play_cue("switch")
		arena.fallen_side = ""
		arena.ally_species = receipt.after.get("ally_species", "zephyr")
		arena.enemy_species = receipt.after.get("enemy_species", "tanugami")
		arena.entry_side = receipt.entry
		arena.entry_progress = clampf((elapsed - entry_start) / Flow.ENTRY, 0, 1)
		caption.text = "Entra " + Catalog.species_name(arena.ally_species if receipt.entry == "ally" else arena.enemy_species)
	arena.queue_redraw()
func finish() -> void :
	if done: return
	done = true
	set_process(false)
	arena.effect_audio.stop()
	if receipt.after.phase == "capture": app.play_sfx("victory")
	elif receipt.after.phase == "defeat": app.play_sfx("defeat")
	finished.emit()
