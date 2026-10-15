extends RefCounted
# Run original four-point contracts unchanged against their original data.
# The real twelve-point campaign is covered independently by unification_tests.
static func activate() -> void:
 preload("res://scripts/jade_route.gd")._definition = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview29/jade_route.json"))
 preload("res://scripts/progression_rules.gd")._rules = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview29/level_progression.json"))
 var tree = preload("res://scripts/trainer_skill_tree.gd")
 tree.specification()
 tree._cached_spec = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/preview29/trainer_skill_tree.json"))
