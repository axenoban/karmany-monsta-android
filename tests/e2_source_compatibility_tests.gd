extends SceneTree
const Store=preload("res://scripts/save_store.gd")
const PATH="user://e2-source-compatibility.json"
var checks:=0
var failures:=0
func eq(a:Variant,b:Variant)->bool:
 return JSON.parse_string(JSON.stringify(a,"",true,true))==JSON.parse_string(JSON.stringify(b,"",true,true))
func check(value:bool,label:String):
 checks+=1
 if not value:
  failures+=1
  push_error("FAIL: "+label)
func _initialize():call_deferred("run")
func run():
 var dir:=DirAccess.open("res://tests/fixtures/e2")
 var store:=Store.new(PATH)
 for name in dir.get_files():
  for suffix in ["",".bak",".tmp"]:
   if FileAccess.file_exists(PATH+suffix):DirAccess.remove_absolute(PATH+suffix)
  var raw:=FileAccess.get_file_as_string(dir.get_current_dir()+"/"+name)
  var original:Dictionary=JSON.parse_string(raw)
  var file:=FileAccess.open(PATH,FileAccess.WRITE)
  file.store_string(raw)
  file.close()
  var loaded:=store.load_profile()
  check(store.last_error.is_empty(),"original E2 loads: "+name)
  if not store.last_error.is_empty():continue
  check(Store.valid(loaded),"E2 profile validates")
  check(FileAccess.get_file_as_string(PATH)==raw,"E2 read preserves bytes")
  check(eq(loaded.skill_tree,original.skill_tree),"E2 trainer and purchases unchanged")
  for key in ["encounter","collection","team","exploration","progression"]:
   check(eq(loaded.campaign[key],original.campaign[key]),"E2 "+key+" unchanged")
  check(eq(loaded.campaign.route.completed,original.campaign.route.completed),"E2 completed route unchanged")
  check(eq(loaded.campaign.route.current,original.campaign.route.current),"E2 current route unchanged")
  check(store.save_profile(loaded),"save original E2 profile")
  check(store.load_profile()==loaded,"E2 exact normalized roundtrip")
 for suffix in ["",".bak",".tmp"]:
  if FileAccess.file_exists(PATH+suffix):DirAccess.remove_absolute(PATH+suffix)
 print("ORIGINAL E2 COMPATIBILITY: %d checks, %d failures; 10 original-source saves"%[checks,failures])
 quit(1 if failures else 0)
