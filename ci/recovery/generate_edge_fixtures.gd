extends SceneTree
const Store=preload("res://scripts/save_store.gd")
const Tactical=preload("res://scripts/tactical_encounter.gd")
var OUT=""
func _initialize():call_deferred("run")
func save(app:Node,name:String):
 assert(Store.valid(app.profile))
 var f=FileAccess.open(OUT+name+".json",FileAccess.WRITE);f.store_string(JSON.stringify(app.profile,"",true,true));f.close()
func run():
 for argument in OS.get_cmdline_user_args():
  if argument.begins_with("--output="): OUT=argument.trim_prefix("--output=").trim_suffix("/")+"/"
 assert(not OUT.is_empty(),"pass --output=/absolute/fixtures/directory")
 DirAccess.make_dir_recursive_absolute(OUT)
 var app=root.get_node("App");app.storage=Store.new("user://extra32.json");app.load_failed=false
 for reserve in [false,true]:
  app.profile=Store.defaults()
  app.profile.skill_tree.level=10;app.profile.campaign.progression.trainer_xp=123
  app.profile.campaign.progression.units["zephyr-start"]={"level":5,"xp":87}
  if reserve:
   app.profile.campaign.sequence=1;app.profile.campaign.victories=1;app.profile.campaign.collection=[{"id":"jade-1","species":"tanugami"}]
   assert(app.change_team("add","jade-1"))
  assert(app.start_route("jade_point_1"));assert(app.discover_location(app.profile.campaign.encounter.id))
  var e=Tactical.new();assert(e.restore(app.profile.campaign.encounter));e.active().hp=1;e.state.enemy.ready.insignia=99;e._sync();app.profile.campaign.encounter=e.snapshot()
  assert(app.trial_action("karmany","golpe"));app.response_timer.stop();save(app,"original_pending_"+str(reserve))
  assert(app.trial_action("enemy"));save(app,"original_replacement" if reserve else "original_defeat")
  if reserve:
   assert(app.trial_action("replace","jade-1"));save(app,"original_replaced")
 print("EXTRA PREVIEW32 SNAPSHOTS COMPLETE");quit()
