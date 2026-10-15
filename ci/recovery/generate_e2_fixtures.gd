extends SceneTree
const Store=preload("res://scripts/save_store.gd")
const Tactical=preload("res://scripts/tactical_encounter.gd")
const Route=preload("res://scripts/jade_route.gd")
var OUT=""
var app:Node
func _initialize():call_deferred("run")
func snap(name:String):
 assert(Store.valid(app.profile))
 var f=FileAccess.open(OUT+name+".json",FileAccess.WRITE);f.store_string(JSON.stringify(app.profile,"",true,true));f.close()
func hit():
 var e=Tactical.new();assert(e.restore(app.profile.campaign.encounter));e.state.enemy.hp=1;e._sync();app.profile.campaign.encounter=e.snapshot();assert(app.trial_action("karmany","golpe"));app.response_timer.stop()
func run():
 for argument in OS.get_cmdline_user_args():
  if argument.begins_with("--output="):OUT=argument.trim_prefix("--output=").trim_suffix("/")+"/"
 assert(not OUT.is_empty(),"pass --output=/absolute/fixtures/directory")
 DirAccess.make_dir_recursive_absolute(OUT)
 app=root.get_node("App");app.storage=Store.new("user://source-e2-save.json");app.profile=Store.defaults();app.load_failed=false
 app.profile.campaign.progression.trainer_xp=55
 app.profile.campaign.progression.units["zephyr-start"].xp=77
 assert(app.start_route("jade_point_1"));assert(app.discover_location(app.profile.campaign.encounter.id));snap("e2-legacy-battle")
 assert(app.trial_action("karmany","golpe"));app.response_timer.stop();snap("e2-legacy-pending")
 app.profile=Store.defaults();app.profile.campaign.sequence=1;app.profile.campaign.victories=1;app.profile.campaign.collection=[{"id":"jade-1","species":"sakuromushi"}]
 assert(app.change_team("add","jade-1"));assert(app.change_team("active","jade-1"))
 Route._definition={"schema":1,"points":[{"id":"jade_point_1","species":"tanugami","level":3,"cost":10,"first_xp":400,"repeat_xp":100,"enemies":[{"species_id":"tanugami","level":3},{"species_id":"ushigane","level":7}]}]}
 assert(app.start_route("jade_point_1"));assert(app.discover_location(app.profile.campaign.encounter.id));snap("e2-contract-battle")
 assert(app.trial_action("karmany","insignia",-1,"zephyr-start"));app.response_timer.stop();snap("e2-ally-relay")
 assert(app.trial_action("enemy"));hit();snap("e2-enemy-relay");hit();snap("e2-contract-victory")
 assert(app.trial_action("choose_capture","rival-0"));snap("e2-choice")
 app.profile.campaign.encounter.rolls=[0.875,0.125,0.5]
 assert(app.trial_action("capture"));snap("e2-attempt")
 assert(app.trial_action("capture"));snap("e2-captured")
 assert(app.continue_route(app.profile.campaign.encounter.id,app.profile.campaign.encounter.revision));snap("e2-map")
 print("ORIGINAL E2 SAVE FIXTURES: 10");quit()
