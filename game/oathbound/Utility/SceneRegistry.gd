extends Node

## Canonical runtime scene registry.
##
## Current Hushiro content uses the professional Core/Regions layout. `shop` and
## `treasure` remain temporary route-token aliases only; new code should use
## `merchant` and `miniboss`.

var rooms := {
	"combat": preload("res://Regions/Hushiro/Chambers/CombatChamber.tscn"),
	"shrine": preload("res://Core/Chambers/Types/ShrineChamber.tscn"),
	"merchant": preload("res://Core/Chambers/Types/MerchantChamber.tscn"),
	"miniboss": preload("res://Core/Chambers/Types/MinibossChamber.tscn"),
	"rest": preload("res://Core/Chambers/Types/RestChamber.tscn"),
	"boss": preload("res://Core/Chambers/Types/BossChamber.tscn"),

	# Imported route compatibility. Remove when Yomori/Kagutsuchi routing is reconciled.
	"shop": preload("res://Core/Chambers/Types/MerchantChamber.tscn"),
	"treasure": preload("res://Core/Chambers/Types/MinibossChamber.tscn"),
}

var enemies_by_area := {
	1: {
		# Canonical Hushiro keys used by HushiroEncounterCatalog.
		"swordsman": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn"),
		"archer": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcher.tscn"),
		"hound": preload("res://Regions/Hushiro/Enemies/Standard/BlightedHound.tscn"),
		"bilemass": preload("res://Regions/Hushiro/Enemies/Standard/CellarBilemass.tscn"),
		"hollow": preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn"),
		"warden": preload("res://Regions/Hushiro/Enemies/Standard/Warden.tscn"),
	},
	2: {
		# Area 2 remains on its imported registry until the Yomori reconciliation pass.
		# Temporary Hushiro reuse points at canonical Hushiro scenes rather than shims.
		"soldier": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn"),
		"soldier2": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"archer": preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcher.tscn"),
		"archer2": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"dog": preload("res://Regions/Hushiro/Enemies/Standard/BlightedHound.tscn"),
		"shade": preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn"),
		"warden": preload("res://Regions/Hushiro/Enemies/Standard/Warden.tscn"),
		"healer": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"stalker": preload("res://Enemy/Area 2/Encounter/stalker_hound.tscn")
	},
	3: {
		# Area 3 likewise remains legacy until its own content pass.
		"soldier2": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"archer2": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"shade": preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn"),
		"healer": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"soldier3": preload("res://Enemy/Area 3/Encounter/court_guard.tscn"),
		"archer3": preload("res://Enemy/Area 3/Encounter/court_caster.tscn"),
		"vessel": preload("res://Enemy/Area 3/Encounter/hollow_vessel.tscn"),
		"brute": preload("res://Enemy/Area 3/Encounter/court_sentinel.tscn"),
		"shield": preload("res://Enemy/Area 3/Encounter/elite_defender.tscn")
	}
}
