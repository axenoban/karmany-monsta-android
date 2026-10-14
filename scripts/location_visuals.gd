extends RefCounted

# Descriptions of the existing decorative terrain, not new canonical place names.
const ENVIRONMENTS := ["Claro de hierba", "Arboleda", "Orilla del arroyo", "Sendero rocoso"]
const DESCRIPTIONS := [
	"Un claro abierto entre hierba y caminos de tierra.",
	"Árboles frondosos y rocas cubiertas de musgo rodean el camino.",
	"El agua del arroyo pasa junto a una orilla de piedras y hierba.",
	"El camino atraviesa rocas y vegetación en el extremo del recorrido."
]

static func index_for(point_id: String) -> int:
	return ["jade_point_1", "jade_point_2", "jade_point_3", "jade_point_4"].find(point_id)

static func details(point_id: String) -> Dictionary:
	var index := index_for(point_id)
	if index < 0: return {}
	return {"title": "Lugar %d" % (index + 1), "environment": ENVIRONMENTS[index], "description": DESCRIPTIONS[index], "background": point_id}

static func background_for(campaign: Dictionary) -> String:
	var current: Dictionary = campaign.get("route", {}).get("current", {})
	if current.get("encounter_id", "") != campaign.get("encounter", {}).get("id", ""):
		return "jade"
	var point_id: String = current.get("point_id", "")
	return point_id if index_for(point_id) >= 0 else "jade"
