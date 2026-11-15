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
