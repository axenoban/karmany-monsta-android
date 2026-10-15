extends RefCounted


const ENVIRONMENTS:= ["Claro de hierba", "Arboleda", "Orilla del arroyo", "Sendero rocoso", "Hierba del valle", "Rocas del camino"]
const DESCRIPTIONS:= [
	"Un claro abierto entre hierba y caminos de tierra.",
	"Árboles frondosos y rocas cubiertas de musgo rodean el camino.",
	"El agua del arroyo pasa junto a una orilla de piedras y hierba.",
	"El camino atraviesa rocas y vegetación en el extremo del recorrido.",
	"Vegetación baja entre los caminos de tierra del valle.",
	"Rocas y árboles rodean el tramo final de la ruta."
]

static func index_for(point_id: String) -> int:
	return ["jade_point_1", "jade_point_2", "jade_point_3", "jade_point_4", "jade_point_5", "jade_point_6"].find(point_id)

static func details(point_id: String) -> Dictionary:
	if point_id.begins_with("veil_point_"):
		var index:= int(point_id.trim_prefix("veil_point_")) - 1
		if index < 0 or index >= 6: return {}
		var names:= ["Entrada de bambú", "Rocas húmedas", "Raíces de bambú", "Sendero de cerezos", "Cañas huecas", "Claro entre la niebla"]
		var backgrounds:= ["veil_bamboo", "veil_roots", "veil_roots", "veil_roots", "veil_bamboo", "veil_clearing"]
		return {"title": "Lugar %d" % (index + 1), "environment": names[index], "description": "El sendero antiguo atraviesa bambú, raíces y niebla lechosa del Bosque del Velo.", "background": backgrounds[index]}
	var index:= index_for(point_id)
	if index < 0: return {}
	return {"title": "Lugar %d" % (index + 1), "environment": ENVIRONMENTS[index], "description": DESCRIPTIONS[index], "background": "jade_point_1" if index == 4 else ("jade_point_4" if index == 5 else point_id)}

static func background_for(campaign: Dictionary) -> String:
	var current: Dictionary = campaign.get("route", {}).get("current", {})
	if current.get("encounter_id", "") != campaign.get("encounter", {}).get("id", ""):
		return "jade"
	var point_id: String = current.get("point_id", "")
	return details(point_id).get("background", "jade")
