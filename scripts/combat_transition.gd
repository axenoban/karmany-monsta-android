extends RefCounted

const HIT:= 0.66
const FALL:= 1.05
const ENTRY:= 0.55
static func between(before: Dictionary, after: Dictionary, operation: String, action: String) -> Dictionary:
	if before.is_empty() or after.get("id") != before.get("id") or before.get("phase") not in ["battle", "replacement"]: return {}
	var fallen:= ""
	if int(before.get("player_hp", 0)) > 0 and int(after.get("player_hp", 0)) == 0: fallen = "ally"
	var relay: bool = after.get("enemy_index", 0) != before.get("enemy_index", 0) and operation != "choose_capture"
	if int(before.get("enemy_hp", 0)) > 0 and (int(after.get("enemy_hp", 0)) == 0 or relay): fallen = "enemy"
	var replacement: bool = operation == "replace" and before.get("ally_id") != after.get("ally_id")
	if fallen.is_empty() and not replacement: return {}
	var event: Dictionary = after.get("event", {}).duplicate(true)
	if relay: event = {"side": "ally", "species": before.get("ally_species", "zephyr"), "action": action}
	return {"id": after.id, "revision": after.revision, "fallen": fallen, "entry": "enemy" if relay else ("ally" if replacement else ""), "before": before.duplicate(true), "after": after.duplicate(true), "event": event}
static func duration(receipt: Dictionary) -> float:
	return (HIT + FALL if not receipt.get("fallen", "").is_empty() else 0.0) + (ENTRY if not receipt.get("entry", "").is_empty() else 0.0)
static func fall_pose(progress: float, reduced: bool = false) -> Dictionary:
	var p:= clampf(progress, 0, 1)
	var settle:= smoothstep(0.05, 0.65, p)
	return {"offset": Vector2.ZERO if reduced else Vector2(-8 * sin(p * PI), 30 * settle), "angle": 0.0 if reduced else 0.2 * settle, "scale": Vector2.ONE if reduced else Vector2(1 + 0.04 * settle, 1 - 0.18 * settle), "alpha": 1.0 - 0.86 * smoothstep(0.38, 1.0, p), "ring": sin(p * PI)}
