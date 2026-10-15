extends SceneTree
const Store = preload("res://scripts/save_store.gd")
const Route = preload("res://scripts/jade_route.gd")
const Policy = preload("res://scripts/regional_policy.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Progress = preload("res://scripts/level_progression.gd")
const Summary = preload("res://scripts/experience_summary.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const PATH := "user://regional-engine-tests.json"
var app: Node
var checks := 0
var failures := 0
var original_route: Dictionary
func _initialize() -> void: call_deferred("run")
func check(value: bool, caption: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + caption)
func fresh() -> void:
	app.response_timer.stop()
	app.storage = Store.new(PATH)
	app.load_failed = false
	app.profile = Store.defaults()
	app.profile.settings.sound = false
	app.pending_experience_id = ""
func definition(two: bool = true) -> Dictionary:
	# Synthetic sequence uses existing species solely to exercise E2 before E3 data activation.
	var point := {"id":"jade_point_1","species":"tanugami","level":3,"cost":10,"first_xp":400,"repeat_xp":100}
	if two: point.enemies = [{"species_id":"tanugami","level":3},{"species_id":"ushigane","level":7}]
	return {"schema":1,"points":[point]}
func start(two: bool = true) -> void:
	Route._definition = definition(two)
	check(app.start_route("jade_point_1"),"start frozen regional fixture")
	check(app.discover_location(app.profile.campaign.encounter.id),"discover without extra cost")
func hit() -> void:
	var model := Tactical.new()
	check(model.restore(app.profile.campaign.encounter),"restore before finishing-hit fixture")
	model.state.enemy.hp = 1
	model.state.rolls = [0.875,0.125,0.5]
	model._sync()
	app.profile.campaign.encounter = model.snapshot()
func find_button(node: Node, prefix: String) -> Button:
	if node is Button and node.text.begins_with(prefix): return node
	for child in node.get_children():
		var result := find_button(child,prefix)
		if result != null: return result
	return null
func run() -> void:
	app = root.get_node("App")
	Route.points()
	original_route = Route._definition.duplicate(true)
	fresh()
	start()
	var e: Dictionary = app.profile.campaign.encounter
	check(e.enemy.level==3 and e.enemy.hp==88 and e.enemy_team[1].hp==125,"fixed enemy levels and scaled HP")
	check(e.regional.reward==400 and e.regional.first and e.regional.cap==10,"frozen first reward")
	var model := Tactical.new()
	model.restore(e)
	model.active().hp=47
	model.active().guard=0.25
	model.active().ready.insignia=4
	model.state.enemy_team[1].hp=99
	model._sync()
	app.profile.campaign.encounter=model.snapshot()
	hit()
	var revision: int = app.profile.campaign.encounter.revision
	var before: Dictionary = app.profile.duplicate(true)
	app.storage=Store.new("user://missing-regional-directory/profile.json")
	check(not app.trial_action("karmany","golpe",revision) and app.profile==before,"failed relay commit preserves whole encounter")
	app.storage=Store.new(PATH)
	check(app.trial_action("karmany","golpe",revision),"first rival defeated")
	e=app.profile.campaign.encounter
	check(e.phase=="battle" and e.enemy_index==1 and e.enemy.hp==99,"next rival retains actual reserve HP")
	check(e.player_hp==47 and e.members[0].guard==0.25 and e.members[0].ready.insignia==4,"no ally healing or effect reset")
	check(e.round==2 and not e.enemy_pending and not app.trial_action("enemy"),"new round with no extra enemy attack")
	check(app.profile.campaign.victories==0 and app.profile.campaign.progression.last_reward.is_empty() and app.profile.campaign.route.completed.is_empty(),"no reward or route completion before whole team defeated")
	check(not app.trial_action("karmany","golpe",revision),"stale finishing callback refused")
	app.profile=app.storage.load_profile()
	check(app.profile.campaign.encounter==e,"reserve state roundtrips exactly")
	# Changing entry data cannot change an already started encounter.
	Route._definition.points[0].level=1
	Route._definition.points[0].first_xp=650
	check(app.start_route("jade_point_1") and app.profile.campaign.encounter==e and app.profile.campaign.exploration.value==90,"resume preserves contract, levels and entry payment")
	hit()
	before=app.profile.duplicate(true)
	app.storage=Store.new("user://missing-regional-directory/profile.json")
	check(not app.trial_action("karmany","golpe") and app.profile==before,"failed final win grants neither bonus, item nor victory")
	app.storage=Store.new(PATH)
	check(app.trial_action("karmany","golpe"),"whole team win")
	e=app.profile.campaign.encounter
	var reward: Dictionary = app.profile.campaign.progression.duplicate(true)
	check(e.phase=="capture" and app.profile.campaign.victories==1 and app.profile.campaign.route.completed.size()==1,"one victory for whole team")
	check(reward.bonuses==["jade/jade_point_1/v1"] and reward.units[Roster.STARTER]=={"level":3,"xp":100},"400 XP and unique bonus committed once")
	check(reward.last_reward.rows[0].gained==400 and reward.last_reward.rows[1].gained==400,"full amount per eligible recipient")
	check(e.capture_choice.is_empty() and not app.trial_action("capture"),"multi-rival capture requires choice")
	check(not app.trial_action("choose_capture","unknown"),"invalid choice refused")
	var rolls: Array = e.rolls.duplicate()
	before=app.profile.duplicate(true)
	app.storage=Store.new("user://missing-regional-directory/profile.json")
	check(not app.trial_action("choose_capture","rival-0") and app.profile==before,"failed choice save changes nothing")
	app.storage=Store.new(PATH)
	check(app.trial_action("choose_capture","rival-0"),"select first defeated rival")
	e=app.profile.campaign.encounter
	check(e.enemy_species=="tanugami" and e.enemy.level==3 and e.rolls==rolls and e.capture.actions.is_empty(),"choice keeps level and consumes no attempt or random draw")
	check(not app.trial_action("choose_capture","rival-1"),"choice locked for single binding")
	check(app.trial_action("capture") and app.profile.campaign.encounter.phase=="capture","first fixed roll fails")
	app.profile=app.storage.load_profile()
	check(not app.trial_action("choose_capture","rival-1") and app.profile.campaign.encounter.capture.actions.size()==1,"reload cannot switch target or reset attempts")
	check(app.trial_action("capture") and app.profile.campaign.encounter.phase=="captured","second fixed roll succeeds")
	var id: String = app.profile.campaign.encounter.id
	check(app.profile.campaign.progression.units[id]=={"level":3,"xp":0},"capture inherits encountered level without victory XP")
	check(app.profile.campaign.progression.last_reward==reward.last_reward and app.profile.campaign.victories==1,"capture never repeats rewards")
	check(not app.trial_action("capture") and app.profile.campaign.collection.size()==1,"no second creature from final")
	check(Store.valid(app.storage.load_profile()),"captured checkpoint validates")
	check(app.continue_route(id,app.profile.campaign.encounter.revision),"leave encounter")
	# Repeated point uses repeat XP, not original bonus, even after restart.
	start(false)
	check(app.profile.campaign.encounter.regional.reward==100 and not app.profile.campaign.encounter.regional.first,"replay freezes repeat award")
	hit()
	app.trial_action("karmany","golpe")
	check(app.profile.campaign.progression.units[Roster.STARTER]=={"level":3,"xp":200} and app.profile.campaign.progression.bonuses.size()==1,"repeat award applied once")
	check(app.profile.campaign.encounter.capture_choice=="rival-0","single rival needs no selection")
	# Legacy active checkpoint: no new policy is added retrospectively.
	fresh()
	Route._definition=JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview29/jade_route.json"))
	app.start_route("jade_point_1")
	app.discover_location(app.profile.campaign.encounter.id)
	var legacy: Dictionary = app.profile.duplicate(true)
	legacy.campaign.progression.erase("bonuses")
	check(app.storage.save_profile(legacy),"pre-E2 profile accepted")
	app.profile=app.storage.load_profile()
	Route._definition=definition()
	check(app.start_route("jade_point_1") and not app.profile.campaign.encounter.has("regional"),"active legacy encounter keeps initial rules")
	hit()
	app.trial_action("karmany","golpe")
	check(app.profile.campaign.progression.units[Roster.STARTER]=={"level":1,"xp":25} and app.profile.campaign.progression.bonuses.is_empty(),"legacy victory remains 25 XP and does not consume new bonus")
	app.trial_action("capture")
	app.trial_action("capture")
	check(app.profile.campaign.progression.units[app.profile.campaign.encounter.id]=={"level":1,"xp":0},"legacy capture remains level one")
	app.continue_route(app.profile.campaign.encounter.id,app.profile.campaign.encounter.revision)
	start(false)
	check(app.profile.campaign.encounter.regional.first,"historically completed point can claim new bonus once")
	# E1 integration: outgoing Sakuromushi strikes and changes ally on the same
	# action that defeats the first rival; only the next player round is opened.
	fresh()
	app.profile.campaign.sequence=1
	app.profile.campaign.victories=1
	app.profile.campaign.collection=[{"id":"jade-1","species":"sakuromushi"}]
	check(app.change_team("add","jade-1") and app.change_team("active","jade-1"),"prepare E1 relay team")
	start()
	hit()
	check(app.trial_action("karmany","insignia",-1,Roster.STARTER),"E1 relay can defeat first regional rival")
	e=app.profile.campaign.encounter
	check(e.ally_id==Roster.STARTER and e.enemy_index==1 and e.round==2 and not e.enemy_pending,"both relays atomic, no extra hit")
	check(e.members[0].relay_boost==0.2 and e.members[0].relay_until==3 and e.members[1].ready.insignia==4,"E1 duration and source cooldown retained")
	check(app.storage.load_profile().campaign.encounter==e,"combined relay persists")
	# Actual capture selector is built from the saved defeated roster in both text sizes.
	hit()
	app.trial_action("karmany","golpe")
	var won: Dictionary=app.profile.duplicate(true)
	root.size=Vector2i(1280,720)
	var main: Node=load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for large in [false,true]:
		app.profile=won.duplicate(true)
		app.profile.settings.large_text=large
		app.pending_experience_id=""
		app.pending_transition={}
		app.profile.campaign.aftermath={"encounter_id":app.profile.campaign.encounter.id,"step":"choose"}
		main._show("battle")
		await process_frame
		await process_frame
		var choice := find_button(main,"Elegir Ushigane")
		check(choice!=null and choice.get_global_rect().end.x<=1280,"capture target button fits viewport")
		check(find_button(main,"Intentar vínculo")==null,"no binding action before final target selection")
		choice.pressed.emit()
		await process_frame
		check(app.profile.campaign.encounter.enemy.level==7 and find_button(main,"Abrir el Libro")!=null,"UI selects second target and exposes binding")
		app.profile.campaign.encounter.rolls=[0.125,0.5,0.875]
		check(app.trial_action("capture"),"capture selected reserve")
		check(app.profile.campaign.progression.units[app.profile.campaign.encounter.id]=={"level":7,"xp":0},"selected reserve level retained")
	main.free()
	fresh()
	start(false)
	# Forged state must not silently normalize away violations.
	var valid_state: Dictionary = app.profile.campaign.encounter.duplicate(true)
	for key in ["reward","cap","repeat_xp"]:
		var invalid := valid_state.duplicate(true)
		invalid.regional[key]=-1
		check(not Tactical.valid(invalid),"reject negative frozen "+key)
	for mutation in ["index","reserve","identity","mirror","choice","level"]:
		var invalid := valid_state.duplicate(true)
		match mutation:
			"index": invalid.enemy_index=0.5
			"reserve": invalid.enemy_team.append(invalid.enemy_team[0])
			"identity": invalid.enemy_team[0].instance_id=Roster.STARTER
			"mirror": invalid.enemy.hp-=1
			"choice": invalid.capture_choice="rival-0"
			"level": invalid.regional.enemies[0].level=0
		check(not Tactical.valid(invalid),"reject corrupted regional "+mutation)
	var bad: Dictionary = app.profile.duplicate(true)
	bad.campaign.progression.bonuses=["jade/jade_point_1/v1","jade/jade_point_1/v1"]
	check(not Store.valid(bad),"duplicate bonus receipts rejected")
	# Multi-level presentation traverses every level and remains read-only.
	var row := {"before":{"level":1,"xp":0},"after":{"level":3,"xp":100},"gained":400,"capped":false}
	var levels := {}
	var last_xp := -1.0
	for i in range(101):
		var frame := Summary.frame(row,float(i)/100.0)
		levels[frame.level]=true
		var total: float = frame.xp + 100.0*frame.level*(frame.level-1)/2.0
		check(total >= last_xp and frame.xp <= frame.maximum,"multi-level XP monotonic and bounded")
		last_xp=total
	check(levels.size()==3 and last_xp==400,"all crossed levels shown, exact final XP")
	row.id=Roster.STARTER
	row.species_id="zephyr"
	row.level=3
	check(Summary.stat_changes(row,2).contains("80 → 84") and Summary.stat_changes(row,3).contains("80 → 88"),"intermediate stats follow the level currently shown")
	for reduced in [false,true]:
		app.profile.settings.reduced_motion=reduced
		var dialog := Summary.new()
		dialog.receipt={"region":"jade","rows":[row]}
		root.add_child(dialog)
		dialog.present()
		dialog.set_process(false)
		check(dialog.duration > Summary.DURATION,"multi-level presentation allows more time")
		dialog._process(dialog.duration)
		check(dialog.cards[0].bar.value==100 and dialog.cards[0].stats.text.contains("80 → 88"),"both motion modes finish at saved stats")
		dialog.free()
	Route._definition=original_route
	fresh()
	for suffix in ["",".bak",".tmp"]:
		if FileAccess.file_exists(PATH+suffix): DirAccess.remove_absolute(PATH+suffix)
	print("REGIONAL ENGINE: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
