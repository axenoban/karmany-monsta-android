extends VBoxContainer
signal finished(status: String)
const Portrait = preload("res://scripts/r1_portrait.gd")
const LINES := [
	"Axe: «Ezel, antes de emprender el viaje hay algo que debes recordar.»",
	"Axe: «Los Karmany no son solo fuerza. Observa a tu compañero y aprende de él.»",
	"Axe: «Cada lugar exige esfuerzo. Cuida tu stamina y usa el Libro cuando llegue el momento.»",
	"Ezel: «Lo entiendo, Axe. Quiero descubrir lo que hay más allá.»",
	"Axe: «Entonces, adelante. El camino es tuyo.»"]
var index := 0
var reduced := false
var large := false
var caption: Label
var next_button: Button
var actors: HBoxContainer
var book: Control
var animation: Tween
var closed := false
func _ready() -> void:
	add_theme_constant_override("separation", 12)
	var frame := PanelContainer.new()
	frame.custom_minimum_size.y = 190
	frame.size_flags_vertical = SIZE_EXPAND_FILL
	add_child(frame)
	var background := TextureRect.new()
	background.texture = preload("res://scripts/trial_stage.gd").texture("jade")
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = MOUSE_FILTER_IGNORE
	frame.add_child(background)
	actors = HBoxContainer.new()
	actors.alignment = BoxContainer.ALIGNMENT_CENTER
	frame.add_child(actors)
	for id in ["axe", "ezel", "zephyr"]:
		var portrait := Portrait.new()
		portrait.setup(id)
		portrait.custom_minimum_size = Vector2(180,180)
		portrait.size_flags_horizontal = SIZE_EXPAND_FILL
		actors.add_child(portrait)
	book = Portrait.new()
	book.setup("binding_book")
	book.custom_minimum_size = Vector2(130,130)
	actors.add_child(book)
	var reading := ScrollContainer.new()
	reading.custom_minimum_size.y = 125 if large else 100
	reading.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(reading)
	caption = Label.new()
	caption.size_flags_horizontal = SIZE_EXPAND_FILL
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_font_size_override("font_size", 30 if large else 26)
	reading.add_child(caption)
	var actions := HBoxContainer.new()
	add_child(actions)
	for label in ["Atrás", "Omitir", "Siguiente"]:
		var button := Button.new()
		button.text = label
		button.custom_minimum_size.y = 64
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		actions.add_child(button)
		match label:
			"Atrás": button.pressed.connect(back)
			"Omitir": button.pressed.connect(func(): finish("skipped"))
			_: next_button = button; button.pressed.connect(advance)
	present()
func present() -> void:
	book.visible = index == 2
	caption.text = "%d / 5 · %s" % [index + 1, LINES[index]]
	next_button.text = "Explorar Valle Jade" if index == 4 else "Siguiente"
	if animation: animation.kill()
	actors.modulate.a = 1.0
	for i in range(3): actors.get_child(i).modulate = Color.WHITE if (index != 1 or i == 2) else Color(0.65,0.65,0.65)
	if not reduced:
		actors.modulate.a = 0.3
		animation = create_tween()
		animation.tween_property(actors, "modulate:a", 1.0, 0.35)
func advance() -> void:
	if closed: return
	if index == 4: finish("completed")
	else: index += 1; present()
func back() -> void:
	if index > 0: index -= 1; present()
	else: finish("skipped")
func finish(status: String) -> void:
	if closed: return
	closed = true
	finished.emit(status)
