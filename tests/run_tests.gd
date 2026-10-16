extends SceneTree

const Store = preload("res://scripts/save_store.gd")
const TEST_PATH := "user://foundation_test_profile.json"
var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + description)

func _clean() -> void:
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(TEST_PATH + suffix):
			DirAccess.remove_absolute(TEST_PATH + suffix)

func _write(path: String, content: String) -> void:
	var handle := FileAccess.open(path, FileAccess.WRITE)
	handle.store_string(content)
	handle.close()

func _run() -> void:
	_clean()
	var store := Store.new(TEST_PATH)
	_check(store.load_profile() == Store.defaults(), "fresh install defaults")
	_check(store.last_error.is_empty(), "no false corruption on fresh install")
	var first := Store.defaults()
	first.journey.started = true
	_check(store.save_profile(first), "first save")
	_check(FileAccess.file_exists(TEST_PATH + ".bak"), "first save has backup")
	_check(Store.new(TEST_PATH).load_profile() == first, "reopen keeps first save")
	var second := first.duplicate(true)
	second.journey.visited_jade = true
	second.settings.large_text = true
	_check(store.save_profile(second), "second save")
	_check(Store.new(TEST_PATH).load_profile() == second, "visit and preference persist")
	_write(TEST_PATH + ".tmp", "interrupted write")
	_check(store.load_profile() == second, "interrupted temporary write does not replace valid save")
	_write(TEST_PATH, "corrupted primary")
	_check(store.load_profile() == first, "corrupt primary recovers previous valid save")
	_check(store.recovered_backup, "recovery is reported")
	_check(store.save_profile(second), "recovery can be saved")
	_write(TEST_PATH, "corrupted again")
	_check(store.load_profile() == first, "corrupt primary never overwrites valid backup")
	_write(TEST_PATH + ".bak", "corrupted backup")
	_check(store.load_profile() == Store.defaults(), "both corrupt files give safe defaults")
	_check(not store.last_error.is_empty(), "both corrupt files produce explicit error")
	_check(FileAccess.get_file_as_string(TEST_PATH) == "corrupted again", "corruption is not silently overwritten")
	_check(store.save_profile(second), "explicit new save after both files corrupt")
	_write(TEST_PATH, "corrupt replacement")
	_check(store.load_profile() == second and store.recovered_backup, "new save replaces invalid backup with a valid one")
	var invalid := second.duplicate(true)
	invalid.schema = 99
	_check(not store.save_profile(invalid), "unknown save schema refused")
	invalid = second.duplicate(true)
	invalid.settings.large_text = "true"
	_check(not Store.valid(invalid), "wrong setting type refused")
	invalid = Store.defaults()
	invalid.journey.visited_jade = true
	_check(not Store.valid(invalid), "visit without started journey refused")
	_check(not Store.new("user://missing-directory/profile.json").save_profile(second), "write failure is explicit")
	_clean()
	var app := root.get_node("App")
	app.storage = Store.new(TEST_PATH)
	app.profile = Store.defaults()
	app.load_failed = false
	_check(app.set_preference("large_text", true), "app commits preferences")
	_check(app.start_journey(), "app starts journey")
	_check(app.profile.settings.large_text, "new journey retains preferences")
	_check(app.visit_jade(), "app commits visit")
	_check(app.storage.load_profile().journey.visited_jade, "visit persists across app restart")
	var scene: PackedScene = load("res://scenes/main.tscn")
	var main := scene.instantiate()
	root.add_child(main)
	await process_frame
	for page in ["skill_tree", "loadout", "tree_lab", "home", "map", "book", "settings", "diagnostics", "bestiary", "trainers"]:
		main._show(page)
		await process_frame
		_check(main.get_node_or_null("Page") != null, "screen builds: " + page)
	# Screen construction above is not a user route. Exercise a real origin chain.
	main._show("home")
	main._show("map")
	main._show("trainers")
	main._back()
	_check(main.page == "map", "trainers back returns to map")
	main._show("bestiary")
	main.selected_species = "tanugami"
	main._show("species")
	await process_frame
	main._back()
	_check(main.page == "bestiary", "species back returns to list")
	main._back()
	_check(main.page == "map", "bestiary back returns to map")
	main._back()
	_check(main.page == "home", "back returns home")
	main.queue_free()
	await process_frame
	_clean()
	print("FOUNDATION TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
