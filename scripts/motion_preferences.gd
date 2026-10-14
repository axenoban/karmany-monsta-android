extends RefCounted
# Presentation preference only; durations, combat and capture stay unchanged.
static func reduced(node: Node) -> bool:
	var app := node.get_node_or_null("/root/App")
	return app != null and app.profile.get("settings", {}).get("reduced_motion", false)

static func actor_motion(motion: Vector3, enabled: bool) -> Vector3:
	return Vector3.ZERO if enabled else motion

static func binding_pose(seconds: float, success: bool) -> Dictionary:
	var fade := clampf((seconds - 2.05) / 0.30, 0.0, 1.0) if success else 0.0
	return {"position": Vector2(0.79, 0.39), "scale": 1.0, "alpha": 1.0 - fade, "rotation": 0.0}
