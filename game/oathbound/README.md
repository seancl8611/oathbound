# Oathbound Runtime Structure

This directory is the canonical Godot project root.

## Naming conventions

- Use **Region** for major run areas (`Hushiro`, `Yomori`, `Kagutsuchi`).
- Use **Chamber** for playable rooms in a run.
- Use PascalCase for GDScript and scene filenames.
- Prefer domain names over prototype numbering (`Hushiro`, not `Area1`).
- Prefer role names that describe gameplay purpose (`MerchantChamber`, `MinibossChamber`) over ambiguous prototype names (`Shop`, `Treasure`).
- New implementation must not be added to deprecated compatibility directories.

## Current layout

```text
Core/
  Chambers/
    ChamberBase.gd
    CombatChamberBase.gd
    RouteGate.gd
    RouteGate.tscn
    Types/
      BossChamber.*
      MerchantChamber.*
      MinibossChamber.*
      RestChamber.*
      ShrineChamber.*
  Encounters/
    EncounterSpawner.gd

Regions/
  Hushiro/
    Chambers/
      CombatChamber.*
    Encounters/
      EncounterSpawner.gd
    Enemies/
      Standard/
      Minibosses/
      Bosses/
      Legacy/

Legacy/
  Area1/
    # Retired prototype resources kept outside the canonical runtime structure.
```

`Areas/Area1/` and `Enemy/Area 1/` are temporary compatibility-shim locations for imported resources with hard-coded historical paths. The runtime registry points to canonical `Core/` and `Regions/Hushiro/` resources. These shims should shrink as later-region reconciliation removes the remaining old references.

Yomori and Kagutsuchi enemy directories remain in their imported layout until their own implementation passes; renaming unreconciled content early would create unnecessary migration risk.

## Current chamber role IDs

New Hushiro routing uses:

- `combat`
- `shrine`
- `merchant`
- `rest`
- `miniboss`
- `boss`

`shop` and `treasure` are legacy route aliases for unreconciled later-region compatibility only.
