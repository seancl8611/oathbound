extends CharacterBody2D

## Minimal authoritative planar actor used only by the production-animation smoke.

var _attack_profile: Dictionary = {}
var _attack_elapsed: float = 0.0
var _attack_aim_dir := Vector2(0.0, -1.0)
var _facing_dir := Vector2(0.0, -1.0)
var hp: float = 100.0
