class_name BookCapturePolicy
extends RefCounted

# Production levels live in book_levels.json; test fixtures stay in tests/.
var _policy: Dictionary = {}
var last_error := ""

func configure(data: Variant) -> bool:
	last_error = ""
	if not data is Dictionary or not data.get("id") is String or data.id.is_empty():
		last_error = "Identificador de reglas del Libro ausente."
		return false
	if not data.get("chances") is Dictionary or data.chances.is_empty():
		last_error = "Probabilidades del Libro pendientes de configuración."
		return false
	for rarity in data.chances:
		var chance: Variant = data.chances[rarity]
		if not rarity is String or rarity.is_empty() or not (chance is float or chance is int):
			last_error = "Rareza o probabilidad inválida."
			return false
		if not is_finite(float(chance)) or chance < 0 or chance > 1:
			last_error = "La probabilidad debe estar entre 0 y 1."
			return false
	_policy = data.duplicate(true)
	return true

func is_configured() -> bool:
	return not _policy.is_empty()

func identifier() -> String:
	return _policy.get("id", "")

func permits(rarity: String) -> bool:
	return _policy.get("chances", {}).has(rarity)

func chance_for(rarity: String) -> float:
	# -1 signals missing rules; never invent a fallback probability.
	return float(_policy.get("chances", {}).get(rarity, -1.0))

func upgrade_preserves_access(previous: BookCapturePolicy) -> bool:
	if not is_configured() or not previous.is_configured():
		return false
	for rarity in previous._policy.chances:
		if not permits(rarity) or chance_for(rarity) < previous.chance_for(rarity):
			return false
	return true
