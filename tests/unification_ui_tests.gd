extends SceneTree
const Store=preload("res://scripts/save_store.gd")
const Campaign=preload("res://scripts/trial_campaign.gd")
const TreeModel=preload("res://scripts/trainer_skill_tree.gd")
var checks:=0
var failures:=0
var app: Node
var main: Node
func _initialize():call_deferred("run")
func check(value:bool,label:String):
	checks+=1
	if not value:
		failures+=1
		push_error("FAIL: "+label)
func load_original(file:String):
	var raw: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview32/"+file+".json"))
	app.profile=preload("res://scripts/preview32_migration.gd").convert(raw)
	app.profile.skill_tree=TreeModel.normalized(app.profile.skill_tree)
	app.profile.campaign=Campaign.normalized(app.profile.campaign)
	app.pending_transition={}
	app.pending_experience_id=""
	app.response_timer.stop()
func check_buttons(node:Node):
	if node is Button and node.is_visible_in_tree():
		var rect:Rect2=node.get_global_rect()
		check(rect.position.x>=-1 and rect.end.x<=1281,"button fits horizontal viewport: "+node.text)
		check(rect.position.y>=-1 and rect.end.y<=721,"button fits vertical viewport: "+node.text)
	for child in node.get_children(): check_buttons(child)
func run():
	root.size=Vector2i(1280,720)
	app=root.get_node("App")
	app.load_failed=false
	app.storage=Store.new("user://unification-ui-tests.json")
	main=load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	var screens := [
		["jade_point_6_map","jade_play",""], ["veil_point_6_map","jade_play",""],
		["jade_point_6_battle","battle",""], ["veil_point_6_battle","battle",""],
		["veil_point_6_victory","battle","victory"], ["veil_point_6_victory","battle","experience"],
		["veil_point_6_victory","battle","choose"], ["veil_point_6_choice","battle","binding"],
		["veil_point_6_captured","battle",""], ["original_defeat","battle",""],
		["original_replacement","battle",""]]
	var render:bool="--allow-ui-review" in OS.get_cmdline_user_args()
	if render:DirAccess.make_dir_recursive_absolute("res://build/unification-ui")
	for large in [false,true]:
		for screen in screens:
			load_original(screen[0])
			app.profile.settings.large_text=large
			app.profile.settings.sound=false
			if not screen[2].is_empty():app.profile.campaign.aftermath={"encounter_id":app.profile.campaign.encounter.id,"step":screen[2]}
			main._show(screen[1])
			await process_frame
			await process_frame
			check_buttons(main)
			check(Store.valid(app.profile),"screen never corrupts saved state")
			if screen[1]=="battle":
				var trial=main.get_node("Page").get_child(0).get_child(1)
				var background=trial.get_node_or_null("ContinuousBackground")
				check(background!=null and background.size==trial.size,"continuous full arena background")
			if render:
				await RenderingServer.frame_post_draw
				root.get_texture().get_image().save_png("res://build/unification-ui/%s-%s-%s.png"%[screen[0],screen[2],"large" if large else "normal"])
	main.free()
	for suffix in ["",".bak",".tmp"]:
		if FileAccess.file_exists("user://unification-ui-tests.json"+suffix):DirAccess.remove_absolute("user://unification-ui-tests.json"+suffix)
	print("UNIFICATION UI: %d checks, %d failures"%[checks,failures])
	quit(1 if failures else 0)
