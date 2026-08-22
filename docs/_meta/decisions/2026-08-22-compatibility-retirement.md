# Decision Record — Hushiro Compatibility Retirement

**Date:** 2026-08-22
**Status:** Resolved / compatibility-retirement gate passed
**Repository:** `seancl8611/oathbound`
**Pull request:** `#113`
**Validation branch:** `agent/compatibility-retirement`
**Validated implementation head:** `bec2ab584a18233e42d495915060d17ea5a51a06`

## Decision

The ordered Hushiro compatibility-retirement package has been executed successfully on PR #113. The current Hushiro runtime no longer depends on the retired `UpgradeDb` / `StanceEffects` prototype authorities or the old Hushiro Area1 compatibility trees.

This retirement is intentionally scoped to authorities whose current Hushiro callers have been eliminated or migrated. Yomori / Kagutsuchi compatibility aliases remain outside this package until those regions receive their own reconciliation.

## Retired Surface

PR #113 removes:

- the `UpgradeDb` autoload and `Utility/upgrade_db.gd` / `upgrade_db.tscn` prototype authority;
- the `StanceEffects` autoload and `autoload/stance_effects.gd` prototype authority;
- the obsolete `Utility/item_option.gd` / `item_option.tscn` UpgradeDb item-card surface;
- `Utility/Area1(old).tscn`;
- the old `Legacy/Area1` Event / MapScreen prototypes;
- the Hushiro `Areas/Area1` forwarding tree;
- the Hushiro `Enemy/Area 1` forwarding tree.

`Core/Chambers/Types/MerchantChamber.tscn` was migrated from the deleted Area1 shims directly to the canonical `OathboundMerchantChamber.gd`, `RouteGate.tscn`, and `EncounterSpawner.gd` resources.

## Contained Imported Archer Fallback

`Regions/Hushiro/Enemies/Standard/CorruptedArcherController.gd` still contains one inert fallback string for the former Area1 projectile path inside imported movement/aiming code. It is not a current runtime dependency: `CorruptedArcherRules.gd` preloads the canonical `Regions/Hushiro/Enemies/Standard/CorruptedArcherProjectile.tscn` and assigns `projectile_scene` before the inherited loader runs.

The permanent CI guard allows exactly that one contained fallback, verifies the canonical preload/assignment, rejects every other reference to `res://Enemy/Area 1/`, rejects all `res://Areas/Area1/` references, and rejects resurrection of the retired files/directories/autoloads.

## Direct Evidence

- Pull request: `#113` — `Retire obsolete Hushiro compatibility authorities`
- Exact tested implementation head: `bec2ab584a18233e42d495915060d17ea5a51a06`
- Validation run: GitHub Actions run `32595976342` — `success`
- Workflow: `Godot 4.7.2 Project Check` in `.github/workflows/godot-project-check.yml`
- Job: `project-check` (`97086850116`)
- `Verify retired Hushiro compatibility authorities stay absent`: passed.
- Godot 4.7.2 headless import and editor compile/load: passed.
- Current RunScene canonical-runtime ownership smoke: passed.
- Corruption state-machine contract: passed.
- Hushiro seeded route contract: passed across the existing 256-seed validation set.
- Complete generated Hushiro traversal: passed through all 12 counted chambers and the Chamber 12 Keeper/boss endpoint.
- Shrine chamber smoke: passed.
- Merchant chamber smoke after direct canonical-path migration: passed.
- Forge Relic menu smoke: passed.

## Gate Result

Compatibility retirement is no longer an open implementation gate. The current Hushiro stack has automated evidence that it imports, loads, owns the expected canonical runtimes, and completes the full structural Hushiro validation suite without the retired prototype authorities and forwarding trees.

This does not expand the package into the separate first-attempt base-katana / no-Aspect onboarding boundary, later-region reconciliation, or ordinary combat/economy tuning.

## Final PR Validation

This record and the implementation-queue update are documentation follow-up changes on PR #113. PR #113 must also pass the full `Godot 4.7.2 Project Check` workflow on the final exact documentation head before it is marked ready for review.
