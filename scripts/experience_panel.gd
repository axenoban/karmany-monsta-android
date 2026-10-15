extends GridContainer

const Summary = preload("res://scripts/experience_summary.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Stage = preload("res://scripts/trial_stage.gd")
var receipt: Dictionary = {}
var large:= false
var cards: Array = []
func label(text: String, font: int) -> Label:
	var node:= Label.new()
	node.text = text
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", font + (2 if large else 0))
	return node
func _ready() -> void :
	columns = 2
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("h_separation", 16)
	add_theme_constant_override("v_separation", 16)
	for row in receipt.get("rows", []):
		if not row.has("before") or not row.has("after"): continue
		var panel:= PanelContainer.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var style:= StyleBoxFlat.new()
		style.bg_color = Color("123337")
		style.border_color = Color("467b70")
		style.set_border_width_all(1)
		style.set_corner_radius_all(14)
		style.set_content_margin_all(14)
		panel.add_theme_stylebox_override("panel", style)
		add_child(panel)
		var box:= VBoxContainer.new()
		box.add_theme_constant_override("separation", 8)
		panel.add_child(box)
		var header:= HBoxContainer.new()
		box.add_child(header)
		var portrait:= TextureRect.new()
		portrait.texture = Stage.texture("ezel" if row.id == "trainer" else row.species_id)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(54, 54)
		header.add_child(portrait)
		var caption:= label("Entrenador" if row.id == "trainer" else Catalog.species_name(row.species_id), 24)
		caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_child(caption)
		var gained:= label("+%d XP" % int(row.gained), 23)
		gained.autowrap_mode = TextServer.AUTOWRAP_OFF
		gained.add_theme_color_override("font_color", Color("b3ead4"))
		header.add_child(gained)
		var status:= label("", 20)
		box.add_child(status)
		var bar:= ProgressBar.new()
		bar.custom_minimum_size.y = 18
		bar.show_percentage = false
		box.add_child(bar)
		var stats:= label("", 18)
		stats.custom_minimum_size.y = 48
		stats.add_theme_color_override("font_color", Color("b9d9ce"))
		box.add_child(stats)
		cards.append({"row": row.duplicate(true), "status": status, "bar": bar, "stats": stats})
	set_fraction(0)
func set_fraction(fraction: float) -> void :
	for card in cards:
		var row: Dictionary = card.row
		var sample:= Summary.frame(row, fraction)
		card.bar.max_value = sample.maximum
		card.bar.value = sample.maximum if sample.full else sample.xp
		card.status.text = "Nv. %d · %s" % [sample.level, "Límite regional" if sample.full else "%d / %d XP" % [sample.xp, sample.maximum]]
		if sample.level > row.before.level:
			if row.id == "trainer": card.stats.text = "¡Subiste de nivel! +%d punto(s) del árbol." % (int(sample.level) - int(row.before.level))
			else:
				var before:= Catalog.stats_at_level(row.species_id, int(row.before.level))
				var after:= Catalog.stats_at_level(row.species_id, int(sample.level))
				card.stats.text = "Vida %d → %d   ·   Ataque %d → %d\nDefensa %d → %d   ·   Velocidad %d" % [before.life, after.life, before.attack, after.attack, before.defense, after.defense, after.speed]
		else: card.stats.text = "Progreso guardado" if sample.done else ""
