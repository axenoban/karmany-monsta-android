extends Node
# Scene-owned voices: no orphan timers and no audio after the scene is freed.
const MAX_VOICES := 4
var cues: Array = []
var clock := 0.0
var generation := 0
var emitted: Array[String] = []
var voices: Array[AudioStreamPlayer] = []
static var clips: Dictionary = {}
const IDS := ["tap", "error", "swing", "hit", "zephyr", "ushigane", "kitsunibi", "sakuromushi", "heal", "shield", "boost", "control", "switch", "book_open", "book_pull", "bind_success", "bind_bounce", "escape", "victory", "defeat", "enter", "item"]

static func combat_cues(species: String, action: String) -> Array:
	match action:
		"golpe": return [[0.0, "swing"], [0.34, "hit"]]
		"insignia":
			if species == "tanugami": return [[0.0, "heal"], [0.20, "shield"]]
			return [[0.0, species if species in ["zephyr", "ushigane", "kitsunibi", "sakuromushi"] else "swing"], [0.34, "hit"]]
		"guardia", "proteccion": return [[0.0, "shield"]]
		"curacion": return [[0.0, "heal"]]
		"potenciacion": return [[0.0, "boost"]]
		"control", "propia": return [[0.0, "control"]]
		"switch": return [[0.0, "switch"]]
	return []

static func binding_cues(outcome: String) -> Array:
	return [[0.0, "book_open"], [1.0, "book_pull"], [2.05, "bind_success" if outcome == "captured" else "bind_bounce"]] + ([[2.85, "escape"]] if outcome == "escaped" else [])

func _ready() -> void:
	add_to_group("effect_audio")
	for i in range(MAX_VOICES):
		var voice := AudioStreamPlayer.new()
		voice.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
		voice.bus = "SFX"
		add_child(voice)
		voices.append(voice)

func play_cue(id: String) -> bool:
	var app := get_node_or_null("/root/App")
	if app == null or app.application_paused or not app.profile.get("settings", {}).get("sound", true) or app.profile.settings.get("effects_volume", 0.65) <= 0.0 or id not in IDS: return false
	if not clips.has(id): clips[id] = load("res://assets/sfx/%s.wav" % id)
	var voice: AudioStreamPlayer = null
	for player in voices:
		if not player.playing and not player.get_meta("queued", false):
			voice = player
			break
	if voice == null: return false # Bound simultaneous transients rather than stack them.
	voice.stream = clips[id]
	voice.set_meta("queued", true)
	_start_voice.call_deferred(voice, generation)
	emitted.append(id)
	if emitted.size() > 32: emitted.pop_front()
	return true

func _start_voice(voice: AudioStreamPlayer, expected_generation: int) -> void:
	if expected_generation != generation or not is_inside_tree(): return
	voice.set_meta("queued", false)
	var app := get_node_or_null("/root/App")
	if app == null or app.application_paused or not app.profile.settings.get("sound", true): return
	# Headless rule/UI suites validate scheduling without an output device.
	# The dedicated mixer smoke test opts in and checks real rendered samples.
	if DisplayServer.get_name() == "headless" and "--verify-audio-mixer" not in OS.get_cmdline_user_args(): return
	if voice.stream != null: voice.play()

func begin(schedule: Array) -> void:
	stop()
	cues = schedule.duplicate(true)
	clock = 0.0
	advance(0.0)

func advance(seconds: float) -> void:
	var gap := seconds - clock
	clock = seconds
	while not cues.is_empty() and float(cues[0][0]) <= seconds:
		var cue: Array = cues.pop_front()
		if gap <= 0.25: play_cue(cue[1]) # A skipped/long frame must not burst old cues.

func stop() -> void:
	generation += 1
	cues.clear()
	for voice in voices:
		voice.set_meta("queued", false)
		voice.stop()
		voice.stream = null

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED: stop()

func _exit_tree() -> void:
	stop()
