extends RefCounted
class_name OathboundParryPolicy

## Combat V2 defense classification.
##
## Parry is an opt-in special response, not the default answer to every enemy hit.
## Ordinary attacks may still be blockable/dodgeable according to their authored
## metadata, but opening Akio's parry window does not erase them unless the attack is
## explicitly classified as a special parry opportunity.
##
## New content should stamp `special_parry=true` on the actual attack Area2D/projectile.
## `damage_type == "perilous"` remains a temporary compatibility bridge for already-
## authored Hushiro specials while those attacks migrate onto explicit metadata.

const META_SPECIAL_PARRY: StringName = &"special_parry"


static func is_special_parry_attack(source: Node, damage_type: String = "") -> bool:
	if source != null and is_instance_valid(source):
		if source.has_meta(META_SPECIAL_PARRY):
			return bool(source.get_meta(META_SPECIAL_PARRY))
		# Some delivery paths pass the owning enemy rather than the hitbox. Allow an
		# explicitly-authored owner-level special without treating legacy `parryable`
		# metadata as opt-in.
		if source.has_meta("oathbound_special_parry"):
			return bool(source.get_meta("oathbound_special_parry"))
	return damage_type == "perilous"


static func ordinary_attack_can_parry(source: Node, damage_type: String = "") -> bool:
	return is_special_parry_attack(source, damage_type)
