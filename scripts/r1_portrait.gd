extends Control
# Missing canonical illustrations use a neutral silhouette, never a fabricated species.
var art: Texture2D
var silhouette := false
func setup(id: String, hidden_species: bool = false) -> void:
	silhouette = hidden_species
	if silhouette:
		var shader := Shader.new()
		shader.code = "shader_type canvas_item; void fragment() { COLOR = vec4(vec3(0.25, 0.36, 0.35), texture(TEXTURE, UV).a); }"
		var ink := ShaderMaterial.new()
		ink.shader = shader
		material = ink
	var stage = preload("res://scripts/trial_stage.gd")
	var asset_id: String = id + "_v2" if id in stage.RESTYLED else id
	if ResourceLoader.exists("res://assets/trial/%s.png" % asset_id): art = stage.texture(id)
	custom_minimum_size = Vector2(130, 140)
	mouse_filter = MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
func _draw() -> void:
	if art:
		var ratio := minf(size.x / art.get_width(), size.y / art.get_height())
		var extent := art.get_size() * ratio
		draw_texture_rect(art, Rect2((size - extent) / 2, extent), false, Color.WHITE)
	else:
		draw_circle(size * Vector2(0.5,0.32), 26, Color("49635f"))
		draw_style_box(_shape(), Rect2(size.x * 0.25,size.y * 0.5,size.x * 0.5,size.y * 0.45))
func _shape() -> StyleBoxFlat:
	var shape := StyleBoxFlat.new()
	shape.bg_color = Color("49635f")
	shape.set_corner_radius_all(25)
	return shape
