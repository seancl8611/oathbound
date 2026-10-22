---
id: COMMISSION-AKIO-HAMMER-PROOF-A-FEEDBACK
title: Hammer — Akio Proof A Playtest Feedback Tracker
category: commission-feedback
status: draft
authority: supporting
last_reviewed: 2026-10-22
topics:
  - hammer
  - akio
  - proof-a
  - animation-review
  - quick-slash
  - sheathing
---

# Hammer — Akio Proof A Playtest Feedback Tracker

**Purpose:** Living internal working record of observed in-game animation problems, positives, questions to ask Hammer, and artist-dependent improvements. Use this to prepare *one* clear, prioritized feedback message. **This file has not been sent to Hammer; entries are not automatic change orders, approved extra scope, or final acceptance/rejection.**

**Status:** In review; main feedback priority is repeated re-sheathing in combat.  
**Working game branch:** \`agent/akio-checkpoint-b-playtest\`.  
**Naming caution:** "Checkpoint B" is the current game/playtest asset and branch label. The repository's commission brief calls the first three **Proof A animations** the **Milestone 1 / Checkpoint C** animation deliverable, after Checkpoint B's 3D source handoff. Do not confuse the debug label with the contractual milestone name.

## Contract and ownership boundaries

- [Akio commission brief](AKIO_COMMISSION_BRIEF.md) is the repository's *commission technical authority*; the detailed external production spec and signed agreement govern actual scope, revision allowances, acceptance, payment and deliverable rights.
- Hammer authors editable model/rig/animation **Blender Actions**; the client owns eight-direction PNG generation, import, hitboxes, combat timing, collision, invulnerability, dashes and gameplay transitions. **Do not ask Hammer to fix Godot gameplay timing or deliver eight PNG sets unless the agreement is changed.**
- Proof A includes editable **Idle**, **Move / Combat Run**, and **Quick Slash**. Additional draw/sheath, drawn-sword Idle/Run variants, or a second slash Action might be new work: **ask feasibility, extent and price first**, and obtain written approval before scope expands.
- Reference: [current source-vs-gameplay testing](../../content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md) and [internal implementation tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md).

## Confirmed positives — preserve these

| ID | Observation | Status / implication |
|---|---|---|
| HP-01 | Original Quick Slash source animation looks better at its delivered 30 FPS than the heavily compressed prototype playback. Full sequence has **41 frames (~1.37 s)**. | **Observed by project owner.** Preserve the authored source for comparison; do not request blanket shortening or global re-timing. |
| HP-02 | The fast initial draw/unsheathe portion is acceptable; the complaint is **not** that the sword needs to be drawn more slowly. | **Observed by project owner.** Do not inadvertently slow or exaggerate the initial unsheathe. |
| HP-03 | Initial in-game integration confirms the source can be rendered/played in eight directions. | **Technically integrated, not a final art-quality approval.** Judge animation quality at real gameplay scale. |

## Artist-feedback queue — highest priority first

| ID | Priority | Finding / desired outcome | Status |
|---|---|---|---|
| HA-01 | **P0 — first message to Hammer** | **Repeated sheathing after every Quick Slash looks unnatural** during rapid attacks and would be especially conspicuous between hits of the future three-hit combo. Aim for a sword that stays out during active combat, with deliberate sheathing only when appropriate. | **Confirmed in playtest; solution pending artist discussion.** |
| HA-02 | P0 dependency | Current **Idle and Move/Run source poses also show the sword sheathed**. Trimming the tail of Quick Slash alone would cause the weapon to snap back into its sheath on movement/idle transitions. Any sword-out solution needs coherent resting/moving poses or an artist-supported transition approach. | **Confirmed by frame inspection; discuss minimal viable art package.** |
| HA-03 | P1 | Ask whether Hammer can **separate the existing draw/strike/sheath material** into editable Actions or variations using his existing Blender rig and keys. Preserve the source full-sequence Action. | **Proposal / feasibility question; not commissioned yet.** |
| HA-04 | P1 | Explore a **drawn-sword Quick Slash** ending in a ready posture instead of sheathing, plus **combat-ready Idle** and **combat-ready Move/Run**. A separate **sheath transition** can follow later after combat stops. | **Candidate design / new-scope discussion, not approved deliverables.** |
| HA-05 | P2 | Some earlier directional movement tests described **N/S Run as waddling**; determine whether the issue persists at native frame cadence and accepted camera view before sending a specific correction. | **Provisional subjective concern; reproduce and capture reference video first.** |
| HA-06 | P2 | Source blade extension/impact read differently by direction in earlier tests. Check all eight views at correct playback speed and actual game size before identifying a particular pose as defective. | **Requires comparative review; no artist revision request yet.** |

### Evidence for the P0 sheathing issue

- In \`game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames/attack_quick_slash_e_020.png\` through ~\`_026.png\`, the sword is visibly drawn/extended.
- By \`attack_quick_slash_e_029.png\` through \`_040.png\`, the sword is being returned to the sheath / reaches its sheathed pose.
- \`idle_e_000.png\` and \`move_e_000.png\` also show the default sheathed state.
- These are **client-rendered directional frames** used as evidence of the Blender Action; if Hammer is reviewing, send a short in-engine video and relevant Action/key-pose references, **not** a request that he edit the PNG derivatives.

## Preferred direction to discuss, NOT an authorized scope change

**Combat-readiness model:** Start sheathed outside combat; draw for initial combat engagement; perform consecutive strikes and defensive movement while sword stays drawn; return to sheathed state only after combat ends / a deliberate quiet interval. This retains Akio's restrained swordsman identity without visibly re-sheathing after every tap.

**Possible staged artist conversation:**

1. **Minimum first ask:** Confirm Hammer agrees the repeated sheath will look awkward in a chained combat context, and ask the least disruptive way to prevent it **in the editable Blender source**.
2. **Likely option:** Split/derive a first draw/attack, a repeatable sword-already-drawn Quick Slash, a matching drawn Idle and Move, and eventually a separate sheath Action. Determine which changes are revisions versus additions before committing to all of them.
3. **After feasibility/quote:** Approve only what is needed for a clean Proof A test. The full core combo (Cross Cut / Heavy Cleave) remains future work under the original milestone structure.

**Important alternative to ask about:** If Hammer can reuse a convincing partial drawn-sword segment plus a ready pose with little added work, compare that solution against commissioning full new loops. **Do not assume a frame-range cut alone is production-ready**, since movement transitions also have to agree.

## Questions to send Hammer

- Would you agree that repeating the complete draw → cut → sheath cycle for every basic attack will feel unnatural once Akio chains strikes?
- Can the existing Blender rig/Actions be adapted so an opening Quick Slash draws the blade but subsequent cuts **start and end sword-drawn**?
- Which of the following can be derived from the current work, and which would require new animation effort: sword-out Idle, sword-out Run, first draw, stand-alone sheath transition, and sword-out Quick Slash?
- What is the **smallest coherent set** that will let us demonstrate seamless back-to-back strikes and return to Idle/Run at the target high-angle camera?
- Can the modified source remain in-place, directionally readable and editable as separate Blender Actions without needing alternate proprietary tools?
- Would these be within any existing revision allowance, or should we treat them as a **separately priced addition**? What delivery/iteration cost or schedule change would you estimate?
- Are there intentional posing differences among the eight views that we should account for when syncing hit frames? The **client** will tune collision/hitboxes, not Hammer.

## Ready-to-send feedback outline — DRAFT ONLY

> The original Quick Slash animation looks noticeably better at its intended 30 FPS, so I want to preserve that quality. One issue became clear during in-game testing: Akio visibly sheaths his sword at the end of each Quick Slash, which would repeat between rapid attacks and the hits of a longer combo. Ideally he would keep the sword drawn during active combat and only sheath it after combat has stopped. Since the current Idle and Run poses also show the sword sheathed, I want to understand the simplest way to make the transitions consistent using the existing Blender rig. Do you think we could adapt or split the current Action into a draw/opening cut and a sword-drawn follow-up, and potentially add matching sword-out Idle/Run and a separate sheath transition? Please let me know what could be handled as a revision and what would require additional scope and cost. I can share a short gameplay clip and the frame ranges that prompted the feedback.

**Do not send directly from this file without owner review.** Keep the tone collaborative; don't imply that all proposed extra Actions are already purchased.

## Follow-up and acceptance log

| Date | Item | Outcome / next step |
|---|---|---|
| 2026-10-22 | In-game source 30 FPS versus prototype speed | User prefers source pacing; preserve and keep testing its gameplay fit. |
| 2026-10-22 | Repeated sheathing between attacks | Confirmed problem; **top priority for next Hammer feedback**. |
| 2026-10-22 | Scope, exact Action split, additions and revisions | **Pending discussion with Hammer**, no quote or change order recorded. |
| — | Message sent / Hammer response | **Not yet recorded.** |
| — | Revision approved / assets delivered / accepted | **Not yet recorded.** |

## Maintenance rule for later reviews

Append new findings with IDs (\`HA-07\`, etc.), mark **observed / suspected / proposed / approved / sent / resolved**, and link the supporting gameplay clip, rendered frame or Hammer reply. Do not erase an issue just because we changed the Godot timing. Promote an item into the commission brief or a change order **only after actual agreement**, and update [the integration tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md) if the deliverable changes.
