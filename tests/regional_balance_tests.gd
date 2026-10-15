extends SceneTree
const Model=preload("res://scripts/tactical_encounter.gd")
const Policy=preload("res://scripts/regional_policy.gd")
const Route=preload("res://scripts/jade_route.gd")
const TreeModel=preload("res://scripts/trainer_skill_tree.gd")
var checks:=0
var failures:=0
func _initialize():call_deferred("run")
func check(value:bool,label:String):
	checks+=1
	if not value:
		failures+=1
		push_error("FAIL: "+label)
func run():
	var rows:=[]
	for region in ["jade","veil"]:
		for point in Route.points(region):
			for offset in [-2,0]:
				var level:=maxi(1,int(point.level)+offset)
				var tree:=TreeModel.defaults()
				tree.level=level
				var team:Dictionary={"members":[],"active_id":"balance-0"}
				for i in range(3):team.members.append({"instance_id":"balance-%d"%i,"species_id":["zephyr","ushigane","sakuromushi"][i],"level":level})
				var model:=Model.new()
				check(model.begin("balance",tree,[0.125,0.5,0.875],team,point.species),"begin balance sample")
				check(model.configure_region(Policy.freeze(point,region,[])),"exact production balance contract")
				var actions:=0
				while model.state.phase in ["battle","replacement"] and actions<400:
					var ok:=false
					if model.state.phase=="replacement":
						for member in model.state.members:
							if member.hp>0:ok=model.replace_with(member.instance_id);break
					elif model.state.enemy_pending:ok=model.end_round()
					else:
						var action:="insignia" if model.reason("karmany","insignia").is_empty() else "golpe"
						var target:=""
						if model.state.ally_species=="sakuromushi" and action=="insignia":
							for member in model.state.members:
								if member.instance_id!=model.state.ally_id and member.hp>0:target=member.instance_id;break
						ok=model.act("karmany",action,target)
					check(ok and Model.valid(model.snapshot()),"bounded valid balance transition")
					if not ok:break
					actions+=1
				check(model.state.phase in ["capture","defeat"],"simulation terminates without stalemate")
				rows.append({"point":point.id,"team_level":level,"enemy_level":int(point.level),"outcome":model.state.phase,"rounds":int(model.state.round),"actions":actions})
	DirAccess.make_dir_recursive_absolute("res://build")
	var file:=FileAccess.open("res://build/regional-balance.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(rows,"  ",true,true))
	file.close()
	print("REGIONAL BALANCE: %d checks, %d failures; 24 deterministic simulations (no balance changes)"%[checks,failures])
	quit(1 if failures else 0)
