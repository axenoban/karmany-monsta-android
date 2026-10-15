extends Control
const Motion = preload("res://scripts/motion_preferences.gd")
var reduced_motion := false
const EffectAudio = preload("res://scripts/effect_audio.gd")
var effect_audio: Node

var mode := "battle"
var ally_species := "zephyr"
var enemy_species := "tanugami"
var collection_species := ""
var background_id := "jade"
var event: Dictionary = {}
var elapsed := 2.0
const DURATION := 0.66
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
	reduced_motion = Motion.reduced(self)
	effect_audio = EffectAudio.new()
	add_child(effect_audio)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	set_process(false)

func play(action_event: Dictionary) -> void:
	event = action_event.duplicate(true)
	elapsed = 0.0
	if effect_audio != null: effect_audio.begin(EffectAudio.combat_cues(event.get("species", ""), event.get("action", "")))
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	elapsed = minf(DURATION, elapsed + delta)
	if effect_audio != null: effect_audio.advance(elapsed)
	queue_redraw()
	if elapsed >= DURATION: set_process(false)

# Presentation only: no random rolls, timers or writes to the encounter.
static func offensive(species: String, action: String) -> bool:
	return action == "golpe" or (action == "insignia" and species != "tanugami")

static func impact(progress: float) -> float:
	return sin(clampf((progress - 0.42) / 0.30, 0.0, 1.0) * PI)

static func pose(species: String, action: String, progress: float) -> Vector3:
	var p := clampf(progress, 0.0, 1.0)
	var wave := sin(p * PI)
	if not offensive(species, action): return Vector3(0, -wave * 12, wave * 0.035)
	var anticipation := sin(clampf(p / 0.26, 0.0, 1.0) * PI)
	var strike := sin(clampf((p - 0.26) / 0.74, 0.0, 1.0) * PI)
	var strength := 1.35 if action == "insignia" else 1.0
	var reach: float = {"ushigane": 76.0, "kitsunibi": 68.0, "sakuromushi": 58.0, "zephyr": 72.0, "tanugami": 48.0}.get(species, 48.0)
	var lift: float = {"ushigane": -4.0, "kitsunibi": 38.0, "sakuromushi": 12.0, "zephyr": 28.0, "tanugami": 16.0}.get(species, 12.0)
	return Vector3((strike * reach - anticipation * 15) * strength, -strike * lift * strength, (anticipation * 0.06 - strike * 0.10) * strength)

func _actor(id: String, center: float, height: float, opacity: float = 1.0, mirrored: bool = false) -> void:
	var art := texture(id)
	var h := size.y * height
	var w := h * art.get_width() / art.get_height()
	var rect := Rect2(size.x * center - w / 2, size.y * 0.96 - h, w, h)
	var side := "ally" if center < 0.5 else "enemy"
	var motion := Vector3.ZERO
	if elapsed < DURATION and id not in ["ezel", "axe"] and event.get("side") == side:
		motion = pose(id, event.get("action", "golpe"), elapsed / DURATION)
		if side == "enemy": motion.x = -motion.x
	elif elapsed < DURATION and id not in ["ezel", "axe"] and offensive(event.get("species", ""), event.get("action", "")):
		var hit := impact(elapsed / DURATION)
		motion = Vector3(hit * (18 if side == "enemy" else -18), -hit * 5, hit * (0.06 if side == "enemy" else -0.06))
	motion = Motion.actor_motion(motion, reduced_motion)
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
		# The committed state already contains the incoming ally. For a relay event,
		# show the outgoing attacker first, then crossfade to the new active.
		var outgoing: String = event.get("species", "")
		var relaying := elapsed < DURATION and event.get("side") == "ally" and event.get("action") == "insignia" and outgoing == "sakuromushi" and outgoing != ally_species
		if relaying:
			var fade := clampf((elapsed / DURATION - 0.46) / 0.26, 0.0, 1.0)
			if fade < 1.0: _actor(outgoing, 0.34, 0.86, 1.0 - fade, mirror_for(outgoing, true))
			if fade > 0.0: _actor(ally_species, 0.34, 0.86, fade, mirror_for(ally_species, true))
		else:
			_actor(ally_species, 0.34, 0.86, 0.45 if player_defeated else 1.0, mirror_for(ally_species, true))
		_actor(enemy_species, 0.66, 0.82, 0.50 if enemy_defeated else 1.0, mirror_for(enemy_species, false))
		if elapsed < DURATION: _effects()

func _effects() -> void:
	if reduced_motion:
		_still_effects()
		return
	var p := elapsed / DURATION
	var species: String = event.get("species", "")
	var action: String = event.get("action", "")
	var ally: bool = event.get("side", "ally") == "ally"
	var origin := Vector2(size.x * (0.34 if ally else 0.66), size.y * 0.55)
	var target := Vector2(size.x * (0.66 if ally else 0.34), size.y * 0.55)
	var color: Color = {"zephyr": Color("9deaff"), "tanugami": Color("87eca1"), "ushigane": Color("e8b763"), "kitsunibi": Color("9eeef0"), "sakuromushi": Color("f3a8ca")}.get(species, Color.WHITE)
	color.a = sin(p * PI) * 0.8
	var radius := minf(size.y * 0.22, 68.0)
	if offensive(species, action):
		var travel := clampf((p - 0.25) / 0.28, 0.0, 1.0)
		var tip := origin.lerp(target, travel)
		if p > 0.25 and p < 0.58:
			for i in range(3):
				var offset := Vector2(0, (i - 1) * 12)
				draw_line(origin.lerp(tip, 0.45) + offset, tip + offset, color, 4 - i, true)
		var hit := impact(p)
		if hit > 0.0:
			draw_arc(target, radius * (0.35 + hit), 0, TAU, 32, color, 3, true)
			for i in range(8):
				var ray := Vector2.from_angle(i * TAU / 8 + 0.2)
				draw_line(target + ray * radius * 0.4, target + ray * radius * (0.5 + hit), color, 3, true)
	if action == "insignia":
		if species == "zephyr":
			for i in range(3): draw_arc(origin, radius * (0.4 + p) + i * 10, -1.2, 1.2, 24, color, 3, true)
		elif species == "kitsunibi":
			for i in range(4): draw_circle(origin + Vector2.from_angle(p * TAU + i * PI / 2) * radius, 5, color)
		elif species == "sakuromushi":
			for i in range(6): draw_circle(origin + Vector2.from_angle(i * TAU / 6) * p * radius * 1.6, 4, color)
	if action in ["guardia", "proteccion"] or (action == "insignia" and species in ["tanugami", "ushigane"]):
		draw_arc(origin, radius * (0.8 + p * 0.2), 0, TAU, 40, color, 5, true)
		draw_arc(origin, radius * 0.7, 0, TAU, 40, color, 2, true)
	if action == "curacion" or (action == "insignia" and species == "tanugami"):
		for i in range(3):
			var point := origin + Vector2((i - 1) * 26, -p * radius - i * 10)
			draw_line(point - Vector2(6, 0), point + Vector2(6, 0), color, 3, true)
			draw_line(point - Vector2(0, 6), point + Vector2(0, 6), color, 3, true)
	if action in ["switch", "potenciacion"]:
		draw_arc(origin, radius * (0.3 + p), 0, TAU, 40, color, 3, true)
	if action in ["control", "propia"]:
		for i in range(3):
			draw_arc(target + Vector2(0, (i - 1) * 15), radius * (0.6 + p * 0.2), 0, TAU, 32, color, 2, true)

func _still_effects() -> void:
	var action: String = event.get("action", "")
	var attacks := offensive(event.get("species", ""), action)
	var ally: bool = event.get("side", "ally") == "ally"
	var center := Vector2(size.x * (0.66 if ally == attacks else 0.34), size.y * 0.52)
	var radius := minf(28.0, size.y * 0.14)
	var alpha := sin(clampf(elapsed / DURATION, 0, 1) * PI) * 0.8
	var color := Color(0.68, 0.93, 0.95, alpha)
	if action == "curacion" or (action == "insignia" and event.get("species") == "tanugami"):
		color = Color(0.65, 1.0, 0.75, alpha)
		draw_line(center - Vector2(radius, 0), center + Vector2(radius, 0), color, 4, true)
		draw_line(center - Vector2(0, radius), center + Vector2(0, radius), color, 4, true)
	else:
		draw_arc(center, radius, 0, TAU, 32, color, 3, true)
		if attacks: draw_line(center + Vector2(-radius * 0.5, radius * 0.5), center + Vector2(radius * 0.5, -radius * 0.5), color, 3, true)
