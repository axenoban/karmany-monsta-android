extends SceneTree
const Store=preload("res://scripts/save_store.gd")
const Tactical=preload("res://scripts/tactical_encounter.gd")
var app: Node
var output=""
func _initialize(): call_deferred("run")
func save_snapshot(name: String):
 assert(Store.valid(app.profile),"original Preview32 fixture validates: "+name)
 var f=FileAccess.open(output+name+".json",FileAccess.WRITE)
 f.store_string(JSON.stringify(app.profile,"",true,true));f.close()
func run():
 for argument in OS.get_cmdline_user_args():
  if argument.begins_with("--output="): output=argument.trim_prefix("--output=").trim_suffix("/")+"/"
 assert(not output.is_empty(),"pass --output=/absolute/fixtures/directory")
 DirAccess.make_dir_recursive_absolute(output)
 DirAccess.make_dir_recursive_absolute(output)
 app=root.get_node("App");app.storage=Store.new("user://generate32.json");app.profile=Store.defaults();app.load_failed=false
 app.profile.skill_tree.level=15;app.profile.skill_tree.unlocks=["veil"]
 app.profile.campaign.progression.units["zephyr-start"]={"level":15,"xp":0}
 for region in ["jade","veil"]:
  assert(app.select_region(region))
  for point in preload("res://scripts/jade_route.gd").points(region):
   app.profile.campaign.exploration.value=100
   assert(app.start_route(point.id));assert(app.discover_location(app.profile.campaign.encounter.id))
   save_snapshot(point.id+"_battle")
   while app.profile.campaign.encounter.phase=="battle":
    var e=Tactical.new();assert(e.restore(app.profile.campaign.encounter));e.state.enemy.hp=1;e._sync();app.profile.campaign.encounter=e.snapshot()
    assert(app.trial_action("karmany","golpe"));app.response_timer.stop()
    if app.profile.campaign.encounter.phase=="battle":save_snapshot(point.id+"_relay")
   save_snapshot(point.id+"_victory")
   if app.profile.campaign.encounter.capture_choice.is_empty():
    assert(app.trial_action("choose_capture","rival-0"));save_snapshot(point.id+"_choice")
   app.profile.campaign.encounter.rolls=[0.875,0.125,0.5]
   assert(app.trial_action("capture"));save_snapshot(point.id+"_attempt")
   assert(app.trial_action("capture"));save_snapshot(point.id+"_captured")
   assert(app.continue_route(app.profile.campaign.encounter.id,app.profile.campaign.encounter.revision))
   save_snapshot(point.id+"_map")
 print("PREVIEW32 FIXTURES COMPLETE");quit()
