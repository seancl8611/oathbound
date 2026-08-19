extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const FALLBACK_ICON = "res://icon.svg"

const UPGRADES = {
	# =========================
	# STORM STANCE — CHAIN LIGHTNING (common → uncommon)
	# =========================
	"storm_chain_1": {
		"icon": ICON_PATH + "storm_chain.png",
		"displayname": "Crackling Arc",
		"details": "Hits have a chance to chain lightning to 1 nearby enemy.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "common"
	},
	"storm_chain_range": {
		"icon": ICON_PATH + "storm_chain.png",
		"displayname": "Widened Conductor",
		"details": "Chain lightning radius increased by 30%.",
		"level": "Level: 2",
		"prerequisite": ["storm_chain_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "uncommon"
	},
	"storm_chain_jump": {
		"icon": ICON_PATH + "storm_chain.png",
		"displayname": "Forked Bolt",
		"details": "Chain lightning jumps to 1 additional target.",
		"level": "Level: 2",
		"prerequisite": ["storm_chain_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# STORM STANCE — SHOCK (common → uncommon)
	# =========================
	"storm_shock_1": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Static Buildup",
		"details": "Hits apply Shock stacks. Shock consumes when enemy attacks, dealing bonus damage per stack.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "common"
	},
	"storm_shock_duration": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Lingering Charge",
		"details": "Shock stacks last 2s longer before expiring.",
		"level": "Level: 2",
		"prerequisite": ["storm_shock_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "uncommon"
	},
	"storm_shock_stacks": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Overcharge",
		"details": "Max Shock stacks increased from 5 to 7.",
		"level": "Level: 2",
		"prerequisite": ["storm_shock_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# STORM STANCE — RARE (new interactions)
	# =========================
	"storm_shock_parry": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Galvanic Deflect",
		"details": "Parrying applies 2 Shock stacks to the attacker.",
		"level": "Level: 3",
		"prerequisite": ["storm_shock_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 1,
		"rarity": "rare"
	},
	"storm_shock_chain": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Shock Discharge",
		"details": "When Shock pops, it chains lightning to 1 nearby enemy.",
		"level": "Level: 3",
		"prerequisite": ["storm_shock_1", "storm_chain_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 1,
		"rarity": "rare"
	},
	"storm_shock_posture": {
		"icon": ICON_PATH + "storm_shock.png",
		"displayname": "Nerve Strike",
		"details": "Shock pop deals small posture damage in addition to HP damage.",
		"level": "Level: 3",
		"prerequisite": ["storm_shock_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 1,
		"rarity": "rare"
	},

	# =========================
	# STORM STANCE — LEGENDARY (gated: 2+ storm picks)
	# =========================
	"storm_shock_ring": {
		"icon": ICON_PATH + "storm_legendary.png",
		"displayname": "Thunderclap",
		"details": "Shock pops create a small ring zap around the enemy, damaging all nearby targets.",
		"level": "Level: 4",
		"prerequisite": ["storm_shock_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "storm",
		"weight": 1,
		"rarity": "legendary"
	},

	# =========================
	# FROST STANCE — CHILL (common → uncommon)
	# =========================
	"frost_chill_1": {
		"icon": ICON_PATH + "frost_chill.png",
		"displayname": "Biting Cold",
		"details": "Hits apply Chill stacks. Chill slows enemy movement slightly per stack.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "common"
	},
	"frost_chill_duration": {
		"icon": ICON_PATH + "frost_chill.png",
		"displayname": "Deep Cold",
		"details": "Chill stacks last 2s longer before expiring.",
		"level": "Level: 2",
		"prerequisite": ["frost_chill_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "uncommon"
	},
	"frost_chill_slow": {
		"icon": ICON_PATH + "frost_chill.png",
		"displayname": "Numbing Wind",
		"details": "Chill slow per stack increased. Max slow at cap ~20%.",
		"level": "Level: 2",
		"prerequisite": ["frost_chill_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# FROST STANCE — FREEZE (common → uncommon)
	# =========================
	"frost_freeze_1": {
		"icon": ICON_PATH + "frost_freeze.png",
		"displayname": "Flash Frost",
		"details": "Parrying has a chance to briefly Freeze the attacker (0.8s).",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "common"
	},
	"frost_chill_freeze": {
		"icon": ICON_PATH + "frost_freeze.png",
		"displayname": "Permafrost",
		"details": "Enemies Freeze when Chill reaches max stacks.",
		"level": "Level: 2",
		"prerequisite": ["frost_chill_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "uncommon"
	},
	"frost_freeze_duration": {
		"icon": ICON_PATH + "frost_freeze.png",
		"displayname": "Bitter Snap",
		"details": "Freeze duration increased by 0.3s.",
		"level": "Level: 2",
		"prerequisite": ["frost_freeze_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# FROST STANCE — RARE
	# =========================
	"frost_shatter_pulse": {
		"icon": ICON_PATH + "frost_freeze.png",
		"displayname": "Shatter Pulse",
		"details": "When Freeze ends or Shatters, emits a Chill pulse adding 2 stacks to nearby enemies.",
		"level": "Level: 3",
		"prerequisite": ["frost_freeze_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 1,
		"rarity": "rare"
	},
	"frost_parry_chill": {
		"icon": ICON_PATH + "frost_chill.png",
		"displayname": "Frost Guard",
		"details": "Parrying applies 2 bonus Chill stacks to the attacker.",
		"level": "Level: 3",
		"prerequisite": ["frost_chill_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 1,
		"rarity": "rare"
	},
	"frost_shatter_damage": {
		"icon": ICON_PATH + "frost_freeze.png",
		"displayname": "Glacial Fracture",
		"details": "Shattering a frozen enemy deals burst posture damage.",
		"level": "Level: 3",
		"prerequisite": ["frost_freeze_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 1,
		"rarity": "rare"
	},

	# =========================
	# FROST STANCE — LEGENDARY
	# =========================
	"frost_shatter_blast": {
		"icon": ICON_PATH + "frost_legendary.png",
		"displayname": "Avalanche",
		"details": "Hitting a frozen enemy triggers an AOE chill blast. Can hit frozen enemies twice before Shatter.",
		"level": "Level: 4",
		"prerequisite": ["frost_freeze_1", "frost_chill_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "frost",
		"weight": 1,
		"rarity": "legendary"
	},

	# =========================
	# HEX STANCE — CURSE (common → uncommon)
	# =========================
	"hex_curse_1": {
		"icon": ICON_PATH + "hex_curse.png",
		"displayname": "Creeping Hex",
		"details": "Hits have a chance to apply Curse stacks. Cursed enemies deal less damage and have slower attack windups.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "common"
	},
	"hex_curse_stacks": {
		"icon": ICON_PATH + "hex_curse.png",
		"displayname": "Deepening Dread",
		"details": "Curse damage reduction increased. Max stacks reduce enemy damage by up to 30%.",
		"level": "Level: 2",
		"prerequisite": ["hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "uncommon"
	},
	"hex_curse_duration": {
		"icon": ICON_PATH + "hex_curse.png",
		"displayname": "Lingering Malice",
		"details": "Curse stacks last 2s longer before expiring.",
		"level": "Level: 2",
		"prerequisite": ["hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# HEX STANCE — DOOM (common → uncommon)
	# =========================
	"hex_doom_1": {
		"icon": ICON_PATH + "hex_doom.png",
		"displayname": "Sealed Fate",
		"details": "Parries and max Curse stacks apply Doom. Doom detonates after a short delay for burst damage.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "common"
	},
	"hex_doom_damage": {
		"icon": ICON_PATH + "hex_doom.png",
		"displayname": "Grave Sentence",
		"details": "Doom detonation damage increased by 25%.",
		"level": "Level: 2",
		"prerequisite": ["hex_doom_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "uncommon"
	},
	"hex_doom_delay": {
		"icon": ICON_PATH + "hex_doom.png",
		"displayname": "Swift Judgment",
		"details": "Doom detonation delay reduced by 0.3s.",
		"level": "Level: 2",
		"prerequisite": ["hex_doom_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# HEX STANCE — RARE
	# =========================
	"hex_parry_doom": {
		"icon": ICON_PATH + "hex_doom.png",
		"displayname": "Karmic Return",
		"details": "Parrying a cursed enemy has a high chance to apply Doom directly.",
		"level": "Level: 3",
		"prerequisite": ["hex_doom_1", "hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "rare"
	},
	"hex_doom_spread": {
		"icon": ICON_PATH + "hex_doom.png",
		"displayname": "Plague Burst",
		"details": "When Doom detonates, applies 2 Curse stacks to nearby enemies.",
		"level": "Level: 3",
		"prerequisite": ["hex_doom_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "rare"
	},
	"hex_curse_spread": {
		"icon": ICON_PATH + "hex_curse.png",
		"displayname": "Spreading Blight",
		"details": "When a cursed enemy dies, spread 2 Curse stacks to nearby enemies.",
		"level": "Level: 3",
		"prerequisite": ["hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "rare"
	},
	"hex_expose": {
		"icon": ICON_PATH + "hex_curse.png",
		"displayname": "Exposed Weakness",
		"details": "Hitting cursed enemies deals bonus posture damage per Curse stack.",
		"level": "Level: 3",
		"prerequisite": ["hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "rare"
	},
	# =========================
	# HEX STANCE — LEGENDARY
	# =========================
	"hex_doom_chain": {
		"icon": ICON_PATH + "hex_legendary.png",
		"displayname": "Death Knell",
		"details": "Doom detonation triggers Doom on nearby cursed enemies (once per room per enemy).",
		"level": "Level: 4",
		"prerequisite": ["hex_doom_1", "hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "legendary"
	},
	"hex_doom_execute": {
		"icon": ICON_PATH + "hex_legendary.png",
		"displayname": "Final Verdict",
		"details": "Doom deals double damage to max-cursed enemies. Curse stacks persist after Doom detonation instead of expiring.",
		"level": "Level: 4",
		"prerequisite": ["hex_doom_1", "hex_curse_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "hex",
		"weight": 1,
		"rarity": "legendary"
	},
	# =========================
	# EMBER STANCE — BURN (common → uncommon)
	# =========================
	"ember_burn_1": {
		"icon": ICON_PATH + "ember_burn.png",
		"displayname": "Kindling Strike",
		"details": "Hits apply Burn (Intensity 1). Burn deals small tick damage over time, refreshable.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "common"
	},
	"ember_burn_tick": {
		"icon": ICON_PATH + "ember_burn.png",
		"displayname": "Smoldering Edge",
		"details": "Burn Intensity increased to 2, dealing more tick damage.",
		"level": "Level: 2",
		"prerequisite": ["ember_burn_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "uncommon"
	},
	"ember_burn_duration": {
		"icon": ICON_PATH + "ember_burn.png",
		"displayname": "Slow Burn",
		"details": "Burn duration increased by 2s.",
		"level": "Level: 2",
		"prerequisite": ["ember_burn_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# EMBER STANCE — SCORCH ZONES (common → uncommon)
	# =========================
	"ember_scorch_1": {
		"icon": ICON_PATH + "ember_scorch.png",
		"displayname": "Blazing Trail",
		"details": "Dashing leaves a short scorch trail. Scorch zones apply Burn and deal chip damage to enemies inside.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "common"
	},
	"ember_scorch_size": {
		"icon": ICON_PATH + "ember_scorch.png",
		"displayname": "Widened Blaze",
		"details": "Scorch zone radius increased by 25%.",
		"level": "Level: 2",
		"prerequisite": ["ember_scorch_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "uncommon"
	},
	"ember_scorch_duration": {
		"icon": ICON_PATH + "ember_scorch.png",
		"displayname": "Lingering Pyre",
		"details": "Scorch zones last 2s longer.",
		"level": "Level: 2",
		"prerequisite": ["ember_scorch_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# EMBER STANCE — RARE
	# =========================
	"ember_parry_scorch": {
		"icon": ICON_PATH + "ember_scorch.png",
		"displayname": "Rebuke of Flame",
		"details": "Parrying creates a small scorch zone at the attacker's feet.",
		"level": "Level: 3",
		"prerequisite": ["ember_scorch_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 1,
		"rarity": "rare"
	},
	"ember_kill_scorch": {
		"icon": ICON_PATH + "ember_scorch.png",
		"displayname": "Funeral Pyre",
		"details": "Killing an enemy creates a scorch circle at the corpse.",
		"level": "Level: 3",
		"prerequisite": ["ember_scorch_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 1,
		"rarity": "rare"
	},
	"ember_burn_scorch_amp": {
		"icon": ICON_PATH + "ember_burn.png",
		"displayname": "Heat Surge",
		"details": "Burning enemies in scorch zones reach Intensity 3: increased tick damage and reduced posture recovery.",
		"level": "Level: 3",
		"prerequisite": ["ember_burn_1", "ember_scorch_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 1,
		"rarity": "rare"
	},

	# =========================
	# EMBER STANCE — LEGENDARY
	# =========================
	"ember_scorch_eruption": {
		"icon": ICON_PATH + "ember_legendary.png",
		"displayname": "Eruption",
		"details": "When a scorch zone expires, it erupts dealing burst damage to all enemies inside.",
		"level": "Level: 4",
		"prerequisite": ["ember_scorch_1", "ember_burn_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "ember",
		"weight": 1,
		"rarity": "legendary"
	},
	
	# =========================
	# SHADOW STANCE — MARK (common → uncommon)
	# =========================
	"shadow_mark_1": {
		"icon": ICON_PATH + "shadow_mark.png",
		"displayname": "Assassin's Eye",
		"details": "Hits have a 30% chance to Mark an enemy. Max 1 Marked enemy. Hitting the marked enemy refreshes duration; hitting a new enemy replaces the mark after a brief lock window.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "common"
	},
	"shadow_mark_parry": {
		"icon": ICON_PATH + "shadow_mark.png",
		"displayname": "Keen Instinct",
		"details": "Parrying guarantees Mark on the attacker.",
		"level": "Level: 2",
		"prerequisite": ["shadow_mark_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "uncommon"
	},
	"shadow_mark_duration": {
		"icon": ICON_PATH + "shadow_mark.png",
		"displayname": "Lingering Sight",
		"details": "Mark duration increased by 3s.",
		"level": "Level: 2",
		"prerequisite": ["shadow_mark_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# SHADOW STANCE — EXPOSE / CONSUME (common → uncommon)
	# =========================
	"shadow_expose_1": {
		"icon": ICON_PATH + "shadow_expose.png",
		"displayname": "Exploit Opening",
		"details": "Parrying a Marked enemy consumes the Mark: applies Expose (bonus posture damage taken) and grants Shadow Charge (next sword hit spawns an afterimage slash).",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "common"
	},
	"shadow_expose_posture": {
		"icon": ICON_PATH + "shadow_expose.png",
		"displayname": "Pressure Point",
		"details": "Expose posture damage bonus increased by 15%.",
		"level": "Level: 2",
		"prerequisite": ["shadow_expose_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "uncommon"
	},
	"shadow_expose_window": {
		"icon": ICON_PATH + "shadow_expose.png",
		"displayname": "Patience of the Blade",
		"details": "Afterimage double-hit window increased by 1s.",
		"level": "Level: 2",
		"prerequisite": ["shadow_expose_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 2,
		"rarity": "uncommon"
	},

	# =========================
	# SHADOW STANCE — RARE
	# =========================
	"shadow_dash_consume": {
		"icon": ICON_PATH + "shadow_expose.png",
		"displayname": "Phantom Step",
		"details": "Dashing near a Marked enemy consumes the Mark, triggering Expose and Shadow Charge.",
		"level": "Level: 3",
		"prerequisite": ["shadow_mark_1", "shadow_expose_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 1,
		"rarity": "rare"
	},
	"shadow_mark_cap": {
		"icon": ICON_PATH + "shadow_mark.png",
		"displayname": "Keen Hunter",
		"details": "Mark apply cooldown reduced by 40%. Marks last 2s longer.",
		"level": "Level: 3",
		"prerequisite": ["shadow_mark_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 1,
		"rarity": "rare"
	},

	# =========================
	# SHADOW STANCE — LEGENDARY
	# =========================
	"shadow_afterimage_chain": {
		"icon": ICON_PATH + "shadow_legendary.png",
		"displayname": "Phantom Cascade",
		"details": "Afterimage hits can trigger Mark on their target. Consuming that Mark refreshes Expose.",
		"level": "Level: 4",
		"prerequisite": ["shadow_mark_1", "shadow_expose_1"],
		"type": "stance",
		"show_as": "upgrade",
		"domain": "shadow",
		"weight": 1,
		"rarity": "legendary"
	},

	# =========================
	# FALLBACK
	# =========================
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health.",
		"level": "N/A",
		"prerequisite": [],
		"type": "item",
		"show_as": "item",
		"domain": "item",
		"weight": 1,
		"rarity": "common"
	}
}

static func get_icon(upgrade_id: String) -> String:
	if upgrade_id in UPGRADES:
		var path = UPGRADES[upgrade_id].get("icon", FALLBACK_ICON)
		if ResourceLoader.exists(path):
			return path
	return FALLBACK_ICON
