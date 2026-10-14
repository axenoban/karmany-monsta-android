extends Control

var mode := "battle"
var ally_species := "zephyr"
var enemy_species := "tanugami"
var collection_species := ""
var background_id := "jade"
var event: Dictionary = {}
var elapsed := 1.0
const DURATION := 0.62
var player_defeated := false
var enemy_defeated := false
static var _textures: Dictionary = {}
const RESTYLED := ["zephyr", "tanugami", "ushigane", "kitsunibi", "sakuromushi", "ezel", "axe"]
const FACING_RIGHT := ["zephyr", "tanugami", "kitsunibi"]

static func mirror_for(species: String, ally: bool) -> bool:
	return (species in FACING_RIGHT) != ally

static func texture(id: String) -> Texture2D:
	if not _textures.has(id):
		var asset_id := id + "_v2" if id in RESTYLED else ("jade_overhead_v2" if id == "jade_overhead" else ("jade_point_1" if id == "jade" else id))
		_textures[id] = load("res://assets/trial/%s.png" % asset_id)
	return _textures[id]

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	set_process(false)

func play(action_event: Dictionary) -> void:
	event = action_event.duplicate(true)
	elapsed = 0.0
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	elapsed = minf(DURATION, elapsed + delta)
	queue_redraw()
	if elapsed >= DURATION: set_process(false)

# Pure pose sampling keeps every motion bounded, reproducible and independent of combat.
static func pose(species: String, action: String, progress: float) -> Vector3:
	var wave := sin(clampf(progress, 0.0, 1.0) * PI)
	var strike := sin(clampf((progress - 0.18) / 0.65, 0.0, 1.0) * PI)
	if action in ["guardia", "switch"]: return Vector3(0, -wave * 8, wave * 0.03)
	var strength := 1.4 if action == "insignia" else 1.0
	match species:
		"ushigane": return Vector3(strike * 52 * strength - wave * 8, wave * 3, -wave * 0.08)
		"kitsunibi": return Vector3(strike * 48 * strength, -wave * 34 * strength, wave * 0.12)
		"sakuromushi": return Vector3(strike * 38 * strength, -wave * 9, -wave * 0.05)
		"zephyr": return Vector3(strike * 44 * strength, -wave * 22, -wave * 0.14)
		"tanugami": return Vector3(strike * 26 if action != "insignia" else 0, -wave * 13, wave * 0.1)
	return Vector3.ZERO

func _actor(id: String, center: float, height: float, opacity: float = 1.0, mirrored: bool = false) -> void:
	var art := texture(id)
	var h := size.y * height
	var w := h * art.get_width() / art.get_height()
	var rect := Rect2(size.x * center - w / 2, size.y * 0.96 - h, w, h)
	var side := "ally" if center < 0.5 else "enemy"
	var motion := Vector3.ZERO
	if elapsed < DURATION and event.get("side") == side:
		motion = pose(id, event.get("action", "golpe"), elapsed / DURATION)
		if side == "enemy": motion.x = -motion.x
	var pivot := rect.position + rect.size * 0.5
	draw_set_transform(pivot + Vector2(motion.x, motion.y), motion.z)
	rect.position = -rect.size * 0.5
	if mirrored:
		draw_set_transform(pivot + Vector2(motion.x, motion.y), motion.z, Vector2(-1, 1))
		draw_texture_rect(art, rect, false, Color(1, 1, 1, opacity))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture_rect(art, rect, false, Color(1, 1, 1, opacity))

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw() -> void:
	var background := texture(background_id)
	var tex_size := Vector2(background.get_width(), background.get_height())
	var source_size := size / maxf(maxf(size.x / tex_size.x, size.y / tex_size.y), 0.001)
	draw_texture_rect_region(background, Rect2(Vector2.ZERO, size), Rect2((tex_size - source_size) * 0.5, source_size))
	if mode == "intro" or mode == "map":
		_actor("ezel", 0.20, 0.88)
		_actor("zephyr", 0.42, 0.62)
		_actor("axe", 0.80, 0.87)
	elif mode == "collection":
		_actor("zephyr", 0.34, 0.86)
		if not collection_species.is_empty():
			_actor(collection_species, 0.66, 0.82, 1.0)
	else:
		_actor("ezel", 0.12, 0.80)
		_actor("axe", 0.88, 0.75)
		_actor(ally_species, 0.34, 0.86, 0.45 if player_defeated else 1.0, mirror_for(ally_species, true))
		_actor(enemy_species, 0.66, 0.82, 0.50 if enemy_defeated else 1.0, mirror_for(enemy_species, false))
		if elapsed < DURATION and event.get("action") == "insignia":
			var progress := elapsed / DURATION
			var color: Color = {"zephyr": Color("9deaff"), "tanugami": Color("87eca1"), "ushigane": Color("e8b763"), "kitsunibi": Color("9eeef0"), "sakuromushi": Color("f3a8ca")}.get(event.get("species"), Color.WHITE)
			color.a = sin(progress * PI) * 0.85
			var center := Vector2(size.x * (0.34 if event.get("side") == "ally" else 0.66), size.y * 0.56)
			var species: String = event.get("species", "")
			if species == "zephyr":
				for i in range(3): draw_arc(center, 25 + progress * 65 + i * 14, -1.0, 1.0, 24, color, 4, true)
			elif species == "kitsunibi":
				for i in range(4): draw_circle(center + Vector2(cos(progress * TAU + i * PI / 2), sin(progress * TAU + i * PI / 2)) * 48, 8, color)
			elif species == "sakuromushi":
				for i in range(6): draw_circle(center + Vector2(cos(i * TAU / 6), sin(i * TAU / 6)) * progress * 90, 6, color)
			else:
				draw_arc(center, 20 + progress * 65, 0, TAU, 48, color, 5 if species == "ushigane" else 3, true)
