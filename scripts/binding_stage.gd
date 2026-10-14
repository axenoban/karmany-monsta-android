extends Control
const Motion = preload("res://scripts/motion_preferences.gd")
var reduced_motion := false
const EffectAudio = preload("res://scripts/effect_audio.gd")
var effect_audio: Node
# The outcome is already persisted. This node never changes capture or inventory.
signal finished
const Stage = preload("res://scripts/trial_stage.gd")
const BOOK = preload("res://assets/trial/binding_book.png")
const DURATION := 3.6
var species := "tanugami"
var background_id := "jade"
var outcome := "capture"
var cinematic := false
var elapsed := 0.0
var running := false
var completed := false
var status_label: Label
var skip_button: Button

static func art_scale(area: Vector2, full_screen: bool) -> float:
	return minf(area.x / 1280.0, area.y / 720.0) if full_screen else minf(area.x / 1000.0, area.y / 400.0)

static func smooth_phase(value: float) -> float:
	var t := clampf(value, 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)

# Normalized position, scale and alpha; testable without rendering or randomness.
static func sample(seconds: float, success: bool) -> Dictionary:
	var t := maxf(0.0, seconds)
	var approach := smooth_phase((t - 1.0) / 1.05)
	var start := Vector2(0.79, 0.39)
	var portal := Vector2(0.5, 0.55)
	var point := start.lerp(portal, approach)
	point.y -= sin(approach * PI) * 0.12
	var shrink := lerpf(1.0, 0.0 if success else 0.22, approach)
	var alpha := 1.0
	var angle := -sin(approach * PI) * 0.17
	if success:
		alpha = 1.0 - smooth_phase((t - 1.78) / 0.27)
	else:
		var rebound := smooth_phase((t - 2.05) / 0.8)
		point = point.lerp(start, rebound)
		point.y -= sin(rebound * PI) * 0.15
		shrink = lerpf(shrink, 1.0, rebound)
		angle += sin(rebound * PI) * 0.3
	return {"position": point, "scale": maxf(0.0, shrink), "alpha": alpha, "rotation": angle}

func _ready() -> void:
	reduced_motion = Motion.reduced(self)
	effect_audio = EffectAudio.new()
	add_child(effect_audio)
	mouse_filter = Control.MOUSE_FILTER_STOP if cinematic else Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	resized.connect(_layout)
	set_process(false)
	if cinematic:
		status_label = Label.new()
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		status_label.add_theme_color_override("font_color", Color("fff1cc"))
		status_label.add_theme_color_override("font_shadow_color", Color("091e23"))
		status_label.add_theme_constant_override("shadow_offset_x", 2)
		status_label.add_theme_constant_override("shadow_offset_y", 2)
		status_label.add_theme_font_size_override("font_size", 30)
		status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(status_label)
		skip_button = Button.new()
		skip_button.text = "Omitir animación"
		skip_button.pressed.connect(finish)
		add_child(skip_button)
	_layout()

func _layout() -> void:
	if status_label != null:
		status_label.position = Vector2(size.x * 0.12, size.y * 0.12)
		status_label.size = Vector2(size.x * 0.76, 100)
	if skip_button != null:
		skip_button.position = Vector2(size.x - 300, size.y - 100)
		skip_button.size = Vector2(250, 58)
	queue_redraw()

func play(result: String) -> void:
	outcome = result
	elapsed = 0.0
	completed = false
	running = true
	if cinematic and effect_audio != null: effect_audio.begin(EffectAudio.binding_cues(outcome))
	set_process(true)
	_update_text()
	queue_redraw()

func _update_text() -> void:
	if status_label == null: return
	status_label.text = "El Libro responde…" if elapsed < 1.0 else ("Estableciendo vínculo…" if elapsed < 2.65 else ("Vínculo logrado" if outcome == "captured" else ("El vínculo falló · el Karmany escapó" if outcome == "escaped" else "El vínculo falló · puedes volver a intentarlo")))

func _process(delta: float) -> void:
	if not running: return
	elapsed = minf(DURATION, elapsed + maxf(delta, 0.0))
	if effect_audio != null: effect_audio.advance(elapsed)
	_update_text()
	queue_redraw()
	if elapsed >= DURATION: finish()

func finish() -> void:
	if completed: return
	completed = true
	if effect_audio != null: effect_audio.stop()
	running = false
	set_process(false)
	finished.emit()

func _sprite(art: Texture2D, center: Vector2, extent: Vector2, alpha: float = 1.0, angle: float = 0.0, mirror: bool = false) -> void:
	if extent.x <= 0 or extent.y <= 0 or alpha <= 0: return
	var dimensions := Vector2(art.get_width(), art.get_height())
	var fitted := dimensions * minf(extent.x / dimensions.x, extent.y / dimensions.y)
	draw_set_transform(center, angle, Vector2(-1 if mirror else 1, 1))
	draw_texture_rect(art, Rect2(-fitted * 0.5, fitted), false, Color(1, 1, 1, alpha))
	draw_set_transform(Vector2.ZERO)

func _draw() -> void:
	var bg := Stage.texture(background_id)
	var dimensions := Vector2(bg.get_width(), bg.get_height())
	var source := size / maxf(maxf(size.x / dimensions.x, size.y / dimensions.y), 0.001)
	draw_texture_rect_region(bg, Rect2(Vector2.ZERO, size), Rect2((dimensions - source) * 0.5, source))
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.015, 0.04, 0.07, 0.60 if cinematic else 0.30))
	if reduced_motion:
		_draw_reduced()
		return
	var t := elapsed if cinematic else 0.7
	var success := outcome == "captured"
	var book_center := Vector2(size.x * 0.5, size.y * 0.62)
	var portal := Vector2(size.x * 0.5, size.y * 0.55)
	var unit := art_scale(size, cinematic)
	var reveal := smooth_phase(t / 0.55) if cinematic else 1.0
	var charge := sin(clampf(t / 3.0, 0, 1) * PI)
	var result_pulse := sin(clampf((t - 2.05) / 0.85, 0, 1) * PI)
	var glow := Color("75edda") if not cinematic or t < 2.05 or success else Color("ffc18a")
	# Layered soft illumination confined to the book; no full-screen flashes.
	for i in range(8, 0, -1):
		var c := glow
		c.a = (0.018 + charge * 0.014) * reveal
		draw_circle(portal, (48 + i * 13 + result_pulse * 16) * unit, c)
	for ring in range(2):
		var points := PackedVector2Array()
		for i in range(65):
			var angle := i * TAU / 64
			points.append(book_center + Vector2(cos(angle) * (142 + ring * 20), sin(angle) * (28 + ring * 6) + 55) * unit * reveal)
		draw_polyline(points, Color(0.6, 0.86, 0.71, 0.22 * reveal), 2, true)
	# Inward orbiting motes travel continuously rather than drawing new random positions.
	for i in range(24):
		var fraction := fmod(i / 24.0 + t * 0.34, 1.0)
		var angle := i * 2.39996 + t * 0.65
		var radius := lerpf(160.0, 18.0, fraction) * unit
		var point := portal + Vector2(cos(angle) * radius, sin(angle) * radius * 0.5 - 18 * unit)
		var c := glow
		c.a = sin(fraction * PI) * 0.65 * reveal
		draw_circle(point, (1.3 + (i % 3) * 0.6) * unit, c)
	var book_size := Vector2(390, 235) * unit * Vector2(reveal, 0.8 + reveal * 0.2)
	_sprite(BOOK, book_center + Vector2(0, -sin(t * PI) * 3 * unit), book_size, reveal, sin(t * 17) * result_pulse * (0.012 if success else 0.025))
	# Light is drawn over the pages, so the paper catches the portal glow.
	for i in range(6, 0, -1):
		var bloom := glow
		bloom.a = reveal * (0.025 + charge * 0.025)
		draw_circle(portal, (12 + i * 8) * unit, bloom)
	if cinematic and t > 0.7 and t < 2.1:
		var tether_end: Vector2 = sample(t, success).position * size
		for strand in range(3):
			var ribbon := PackedVector2Array()
			for i in range(25):
				var f := i / 24.0
				var point := portal.lerp(tether_end, f)
				point.y += sin(f * PI) * sin(t * 4 + strand * 1.5) * 20 * unit
				ribbon.append(point)
			var tint := glow
			tint.a = 0.12 + strand * 0.045
			draw_polyline(ribbon, tint, (1 + strand * 0.5) * unit, true)
	var pose: Dictionary = sample(t, success) if cinematic else {"position": Vector2(0.79, 0.39), "scale": 1.0, "alpha": 0.0 if outcome in ["captured", "escaped"] else 1.0, "rotation": 0.0}
	if cinematic and t > 1 and t < 2.05:
		for i in range(5, 0, -1):
			var trail := sample(maxf(1.0, t - i * 0.035), success)
			_sprite(Stage.texture(species), trail.position * size, Vector2(280, 300) * unit * trail.scale, 0.035 * (6 - i), trail.rotation, Stage.mirror_for(species, false))
	_sprite(Stage.texture(species), pose.position * size, Vector2(280, 300) * unit * pose.scale, pose.alpha, pose.rotation, Stage.mirror_for(species, false))
	if cinematic and t > 2.05:
		var color := glow
		color.a = result_pulse * 0.8
		draw_arc(portal, (30 + (t - 2.05) * 125) * unit, 0, TAU, 64, color, 3 * unit, true)
		if success:
			for i in range(12):
				var ray := Vector2.from_angle(i * 2.39996)
				var point := portal + ray * (28 + (t - 2.05) * 100) * unit
				var sparkle := (2 + i % 3) * unit * result_pulse
				draw_line(point - Vector2(sparkle, 0), point + Vector2(sparkle, 0), color, 2 * unit, true)
				draw_line(point - Vector2(0, sparkle), point + Vector2(0, sparkle), color, 2 * unit, true)

func _draw_reduced() -> void:
	var unit := art_scale(size, cinematic)
	var center := Vector2(size.x * 0.5, size.y * 0.62)
	_sprite(BOOK, center, Vector2(390, 235) * unit)
	var pose: Dictionary = Motion.binding_pose(elapsed, outcome == "captured") if cinematic else {"position": Vector2(0.79, 0.39), "scale": 1.0, "alpha": 0.0 if outcome in ["captured", "escaped"] else 1.0, "rotation": 0.0}
	_sprite(Stage.texture(species), pose.position * size, Vector2(280, 300) * unit, pose.alpha, 0, Stage.mirror_for(species, false))
	if cinematic and elapsed >= 2.05:
		var color := Color("9de4bd") if outcome == "captured" else Color("ffd0a1")
		color.a = 0.65
		draw_arc(center + Vector2(0, -40) * unit, 44 * unit, 0, TAU, 48, color, 3 * unit, true)
		if outcome == "captured":
			var point := center + Vector2(0, -40) * unit
			draw_polyline(PackedVector2Array([point + Vector2(-20, 0) * unit, point + Vector2(-5, 14) * unit, point + Vector2(23, -18) * unit]), color, 4 * unit, true)
