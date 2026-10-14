extends Control

var mode := "battle"
var player_defeated := false
var enemy_defeated := false
static var _textures: Dictionary = {}

static func texture(id: String) -> Texture2D:
	if not _textures.has(id):
		_textures[id] = load("res://assets/trial/%s.png" % id)
	return _textures[id]

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)

func _actor(id: String, center: float, height: float, opacity: float = 1.0) -> void:
	var art := texture(id)
	var h := size.y * height
	var w := h * art.get_width() / art.get_height()
	var rect := Rect2(size.x * center - w / 2, size.y * 0.96 - h, w, h)
	draw_texture_rect(art, rect, false, Color(1, 1, 1, opacity))

func _draw() -> void:
	var background := texture("jade")
	draw_texture_rect(background, Rect2(Vector2.ZERO, size), false)
	if mode == "intro" or mode == "map":
		_actor("ezel", 0.20, 0.88)
		_actor("zephyr", 0.42, 0.62)
		_actor("axe", 0.80, 0.87)
	elif mode == "collection":
		_actor("zephyr", 0.34, 0.86)
		if not App.profile.campaign.collection.is_empty():
			_actor("tanugami", 0.66, 0.82, 1.0)
	else:
		_actor("ezel", 0.12, 0.80, 0.7)
		_actor("axe", 0.88, 0.75, 0.7)
		_actor("zephyr", 0.34, 0.86, 0.45 if player_defeated else 1.0)
		_actor("tanugami", 0.66, 0.82, 0.50 if enemy_defeated else 1.0)
