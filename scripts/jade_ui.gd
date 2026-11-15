extends RefCounted
# Layouts visuales compartidos. No tiene efectos sobre reglas ni guardados.
const Art = preload("res://scripts/trial_stage.gd")
const Design = preload("res://scripts/adventure_theme.gd")

static func backdrop(parent: Control, asset: String, shade: float = 0.65) -> void:
	var image := TextureRect.new()
	image.name = "JadeBackdrop"
	image.texture = Art.texture(asset)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var veil := ColorRect.new()
	veil.color = Color(0.015, 0.07, 0.055, shade)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(veil)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

static func heading(parent: Node, title: String) -> Label:
	var stack := VBoxContainer.new()
	stack.name = "JadePageHeading"
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.add_theme_constant_override("separation", 6)
	parent.add_child(stack)
	var caption := Label.new()
	caption.text = title
	caption.theme_type_variation = "JadePageTitle"
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(caption)
	var accent := ColorRect.new()
	accent.name = "HeadingAccent"
	accent.color = Design.JADE
	accent.custom_minimum_size = Vector2(104, 2)
	accent.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	accent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(accent)
	return caption

static func section(parent: Node, title: String) -> Label:
	var result := Label.new()
	result.text = title
	result.theme_type_variation = "JadeSectionTitle"
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(result)
	return result

static func status(parent: Node, text: String) -> Label:
	var shell := PanelContainer.new()
	shell.name = "JadeStatus"
	shell.theme_type_variation = "JadeStatusPanel"
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(shell)
	var label := Label.new()
	label.text = text
	label.theme_type_variation = "JadeStatus"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	shell.add_child(label)
	return label

static func region_header(parent: Node, asset: String, title: String, state: String, large_text: bool = false) -> Control:
	# Mayor protagonismo del paisaje sin sumar altura a la tarjeta de región.
	# Solo se superpone texto real; el arte original y el botón externo se preservan.
	var frame := Control.new()
	frame.name = "RegionArt"
	frame.custom_minimum_size = Vector2(0, 116)
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.clip_contents = true
	parent.add_child(frame)
	var picture := TextureRect.new()
	picture.name = "RegionIllustration"
	picture.texture = Art.texture(asset)
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(picture)
	picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.name = "RegionCaptionShade"
	var tint := Design.INK
	tint.a = 0.86
	shade.color = tint
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	shade.offset_top = -73
	var caption := VBoxContainer.new()
	caption.name = "RegionCaption"
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.add_theme_constant_override("separation", 2)
	frame.add_child(caption)
	caption.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	caption.offset_left = 12
	caption.offset_right = -12
	caption.offset_top = -70
	caption.offset_bottom = -5
	caption.alignment = BoxContainer.ALIGNMENT_END
	var name_label := Label.new()
	name_label.name = "RegionName"
	name_label.text = title
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 25 if large_text else 22)
	name_label.add_theme_color_override("font_color", Design.PAPER)
	caption.add_child(name_label)
	var state_label := Label.new()
	state_label.name = "RegionState"
	state_label.text = state
	state_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	state_label.add_theme_font_size_override("font_size", 22 if large_text else 19)
	state_label.add_theme_color_override("font_color", Design.MIST)
	caption.add_child(state_label)
	return frame

static func readout(parent: Node, content: String, id: String = "JadeReadout", font_size: int = 22) -> Label:
	# Una superficie ligera legible sobre fondos pintados; no captura eventos.
	var holder := PanelContainer.new()
	holder.name = "ReadoutSurface"
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bg := Design.INK
	bg.a = 0.80
	holder.add_theme_stylebox_override("panel", Design.box(bg, Design.EDGE, 3))
	parent.add_child(holder)
	var label := Label.new()
	label.name = id
	label.text = content
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Design.PAPER)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(label)
	return label

static func panel(parent: Node) -> VBoxContainer:
	var shell := PanelContainer.new()
	shell.theme_type_variation = "JadeCard"
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(shell)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	shell.add_child(content)
	return content

static func row(parent: Node) -> HBoxContainer:
	var result := HBoxContainer.new()
	result.add_theme_constant_override("separation", 16)
	parent.add_child(result)
	return result

static func art(parent: Node, asset: String, height: float = 280) -> TextureRect:
	var image := TextureRect.new()
	image.texture = Art.texture(asset)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size = Vector2(180, height)
	image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	return image
