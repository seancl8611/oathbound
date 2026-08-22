# Decision Record — Strand Permanent Progression Runtime

**Date:** 2026-08-22
**Status:** Resolved / runtime-integration gate passed
**Repository:** `seancl8611/oathbound`
**Pull request:** `#115`
**Validation branch:** `agent/strand-permanent-progression`
**Validated implementation head:** `eed625addf7ffee606e8289e34e2a57ca7972a20`

## Decision

The approved Strand permanent-progression architecture is now implemented as a persistent runtime rather than a read-only planning scaffold.

The current campaign has exactly three permanent-progression stations: Bloodwell for Akio and Run Infrastructure, Forge Bench for Prosthetics and Relics, and Blood Mirror for Blood Aspect progression. The introductory attempt remains free of the permanent-upgrade interface. Returning Blood opens the first Bloodwell band, the first Keeper defeat opens the Blood Mirror and Keeper-stage nodes, Twin Maws opens the next band, and the Shogun / first Binding clear opens the final structural band.

First-playtest numerical values in this package are centralized prototype tuning inside the progression runtime and remain adjustable without changing the approved node identities, resource ownership, unlock cadence, or station responsibilities.

## Implemented Boundary

PR #115 adds or reconciles:

- canonical persistent `MetaProgress`, including Mist, Scrolls, regional boss materials, purchased progression nodes, campaign flags, and Blood Cavern first-clear state;
- the full 18-node Bloodwell structure: 10 Akio nodes and 8 Run Infrastructure nodes;
- the full 9-node Blood Mirror structure: three persistent reliability nodes for each of Wolf, Wraith, and Ronin;
- first-return, Keeper, Twin Maws, and Shogun campaign-stage gates;
- exactly six boss-material-gated permanent nodes, two per regional boss material;
- working Bloodwell purchasing through persistent Mist and regional boss materials;
- live Bloodwell Health, Posture, Spirit, Rest-recovery, and starting-Technique-reroll integration where existing runtime hooks are already authoritative;
- canonical Bloodwell and Keeper-gated Blood Mirror stations in the Strand Hub;
- persistent Forge Prosthetic unlock/equip/upgrade state;
- the approved eight-Prosthetic / 19-rank / 66-Scroll upgrade economy with 2 / 4 / 6 Scroll rank costs;
- Forge presentation that exposes Scroll costs and suppresses the retired per-Prosthetic Relic-socket model;
- the approved one-slot persistent Relic collection/mastery surface at the Forge;
- the 10-Relic acquisition partition as exactly 4 campaign/Strand, 2 Blood Cavern/challenge, and 4 run-discovered Relics;
- one-time Blood Cavern challenge claim persistence;
- canonical GameFlow ownership assertions for the persistent Forge and Strand progression managers;
- focused `StrandProgressionRuntimeSmoke` coverage in the permanent Godot project gate.

The package does not reinterpret tuning-oriented nodes whose exact combat semantics still belong to their owning gameplay systems. Route Intelligence, Passage support, Deflection/Execution Stability, Shrine Stabilization, and individual Blood Mirror reliability values remain centralized progression effects/flags until their owning runtime pass consumes them. That is a tuning/integration boundary, not a second permanent-progression architecture.

## Direct Evidence

- Pull request: `#115` — `Implement Strand permanent progression runtime`
- Exact tested implementation head: `eed625addf7ffee606e8289e34e2a57ca7972a20`
- Validation run: GitHub Actions run `32602781220` — `success`
- Workflow: `Godot 4.7.2 Project Check` in `.github/workflows/godot-project-check.yml`
- Job: `project-check` (`97103457697`)
- Godot 4.7.2 headless import and editor compile/load: passed.
- Canonical RunScene ownership smoke: passed with `OathboundPersistentProstheticManager` and `OathboundStrandProgressionManager` as current authorities.
- Corruption state-machine contract: passed.
- First-attempt base-katana contract: passed.
- Hushiro seeded route contract: passed across the existing 256-seed validation set.
- Complete generated Hushiro traversal: passed through all 12 counted chambers and the Chamber 12 Keeper/boss endpoint.
- Shrine chamber smoke: passed.
- Merchant chamber smoke: passed.
- Current Forge menu smoke: passed with the Scroll-Prosthetic / one-slot-Relic presentation.
- Strand permanent progression contract: passed, including 18 Bloodwell nodes, 9 Blood Mirror nodes, six boss-material gates, first-return/keeper/twin/shogun cadence, a real Mist purchase, 19 Prosthetic ranks totaling 66 Scrolls, the 4 / 2 / 4 Relic source partition, one-time Blood Cavern claim behavior, and all three Hub stations.

## Gate Result

Strand / permanent progression is no longer an open structural implementation gate. The persistent campaign loop now has a coherent current runtime and automated regression contract while leaving ordinary numerical and presentation tuning available for later playtests.

The next dependency-sized implementation package is Yomori: reconcile the current Region 2 runtime with the approved encounter pool/layout, Embered Pilgrim, Rotwood Host, Twin Maws, and regional hazards without reopening already-closed player-build or Strand architecture.

## Final PR Validation

This record and the implementation-queue update are documentation follow-up changes on PR #115. PR #115 must also pass the full `Godot 4.7.2 Project Check` workflow on the final exact documentation head before merge.
