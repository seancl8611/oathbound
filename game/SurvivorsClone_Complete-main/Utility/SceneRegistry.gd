extends Node

var rooms := {
	"combat":   preload("res://Areas/Area1/Combat.tscn"),
	"shrine":   preload("res://Areas/Area1/Shrine.tscn"),
	"shop":     preload("res://Areas/Area1/Shop.tscn"),
	"treasure": preload("res://Areas/Area1/Treasure.tscn"),
	"rest":     preload("res://Areas/Area1/Rest.tscn"),
	"boss":     preload("res://Areas/Area1/Boss.tscn")
}

var enemies_by_area := {
	1: {
		# Canonical Hushiro keys used by HushiroEncounterCatalog.
		"swordsman": preload("res://Enemy/Area 1/Encounter/corrupted_swordsman.tscn"),
		"archer": preload("res://Enemy/Area 1/Encounter/corrupted_archer.tscn"),
		"hound": preload("res://Enemy/Area 1/Encounter/blighted_hound.tscn"),
		"bilemass": preload("res://Enemy/Area 1/Encounter/Cellar_Bilemass.tscn"),
		"hollow": preload("res://Enemy/Area 1/Encounter/hollow.tscn"),
		"warden": preload("res://Enemy/Area 1/Encounter/warden.tscn"),
	},
	2: {
		# Area 2 remains on its imported registry until the Yomori reconciliation pass.
		"soldier": preload("res://Enemy/Area 1/Encounter/corrupted_swordsman.tscn"),
		"soldier2": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"archer": preload("res://Enemy/Area 1/Encounter/corrupted_archer.tscn"),
		"archer2": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"dog": preload("res://Enemy/Area 1/Encounter/blighted_hound.tscn"),
		"shade": preload("res://Enemy/Area 1/Encounter/hollow.tscn"),
		"warden": preload("res://Enemy/Area 1/Encounter/warden.tscn"),
		"healer": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"stalker": preload("res://Enemy/Area 2/Encounter/stalker_hound.tscn")
	},
	3: {
		# Area 3 likewise remains legacy until its own content pass.
		"soldier2": preload("res://Enemy/Area 2/Encounter/lingering_wraith.tscn"),
		"archer2": preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn"),
		"shade": preload("res://Enemy/Area 1/Encounter/hollow.tscn"),
		"healer": preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"),
		"soldier3": preload("res://Enemy/Area 3/Encounter/court_guard.tscn"),
		"archer3": preload("res://Enemy/Area 3/Encounter/court_caster.tscn"),
		"vessel": preload("res://Enemy/Area 3/Encounter/hollow_vessel.tscn"),
		"brute": preload("res://Enemy/Area 3/Encounter/court_sentinel.tscn"),
		"shield": preload("res://Enemy/Area 3/Encounter/elite_defender.tscn")
	}
}
