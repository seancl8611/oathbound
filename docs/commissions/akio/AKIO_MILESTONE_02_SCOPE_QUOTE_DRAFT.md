---

title: Akio Milestone 2 — Draft Scope and Quote Request

status: draft_for_review

last_reviewed: 2026-11-03

audience: internal_now_artist_after_approval

---

> **ARCHIVED INTERNAL REFERENCE — NOT THE LIVE COMMISSION DRAFT.** The active, editable Milestone 2 document plan is in [Google Drive — Commission Document Plan](https://docs.google.com/document/d/1g6sypige1VriDhsglEDiPRwW50Cz2AAAtBUATZmI8AQ/edit). This GitHub copy records an earlier detailed draft; do not maintain it as a second source of truth or send it to Hammer without review.

# OATHBOUND — AKIO MILESTONE 2

*Core Animation Completion | Draft Scope & Quote Request (v0.1, 3 November 2026)*

STATUS: Internal working draft for review. Not sent to Hammer, quoted, accepted, signed, or authorized. Milestone 1 / polished Proof A remains the immediate priority.

## 1. Purpose and continuity

Request a separate price, schedule, and checkpoint plan from Hammer for completing Akio’s baseline nine-animation library. Build on the accepted Milestone 1 character model, materials, katana/scabbard, reusable Blender rig, and three source Actions. Do not rebuild or repurchase accepted work. The Client generates eight-direction transparent PNG renders and integrates them into Godot 2D; Hammer delivers editable 3D source animation, not sprite sheets or gameplay programming.

This draft supplements the existing Akio Character Production Specification (Exhibit A). The executed Artist Services Agreement remains authoritative for Milestone 1; Milestone 2 requires new written authorization and agreed commercial terms. This document does not modify the current engagement.

## 2. Baseline deliverables to quote

Six new, editable Blender animation Actions, all built on the accepted Akio source rig. Each Action must read from the eight required directions (E, SE, S, SW, W, NW, N, NE) when rendered client-side.

- Dash / Step-Dodge — compact evasive motion with a clear initiation, travel/body commitment, and recovery pose. Game code controls distance and invulnerability.

- Defend — disciplined defensive body/katana posture suitable for the current kit; must be visually distinguishable from standing idle. Do not presume universal parry or posture-break mechanics.

- Hurt — concise, readable reaction with recovery toward a known combat stance, without authoring damage or collision logic.

- Death — convincing collapse/defeat with a stable end pose and client-controlled respawn transition.

- Cross Cut — distinct follow-up to Quick Slash in the three-hit basic attack phrase; readable blade trajectory, anticipation, strike, follow-through, and recovery.

- Heavy Cleave — slower, heavier finishing hit with committed weight transfer, strong strike/readability, and a coherent final ready/recovery posture.

Previously commissioned Idle, Move / Combat Run, and Quick Slash are the other three parts of the intended nine-Action baseline and are not new Milestone 2 deliverables unless an explicitly agreed revision or additional variant is required.

## 3. Critical preproduction question: sword-out combat continuity

Our Proof A testing found that Quick Slash includes a draw–strike–resheath cycle, while existing Idle and Run are sheathed. That is acceptable for a stand-alone proof, but automatically resheathing after every hit will interrupt a continuous three-hit combo and snap visually when transitioning to sheathed Idle/Run.

Before finalizing price or animating Cross Cut / Heavy Cleave, Hammer and Client should choose the lowest-work solution that produces coherent state transitions. Preferred test behavior is: sheathed outside combat → draw at engagement → remain sword-drawn during the combo and immediate combat movement → sheath deliberately when safe. This is a proposed design to approve, not an already contracted animation package.

### Request a separate optional price for any additional source work

- Sword-drawn Idle and Move/Run variants if the new continuity plan actually requires them.

- Sword-drawn Quick Slash variation, or splitting/reusing existing draw/strike/sheath source keys into editable, reusable Actions.

- Separate draw and sheath transitions, including attack interruption / safe handoff where practical.

- Any other required existing-Action changes, with a note of what Hammer considers included conformity/revision work versus new work.

The quote should identify a MINIMUM functional continuity option and any more polished alternative separately. Do not imply all optional variants are included in the baseline six-Action fee. If continuity cannot work reliably without particular extras, make those explicit dependencies and price them before kickoff.

## 4. Proposed checkpoint structure

### Preflight — Scope and continuity approval (before paid production)

Confirm the accepted Milestone 1 .blend revision and dependencies, weapon-state design, desired 3-hit key poses, gameplay-camera direction samples, source convention (Blender Actions/slots, NLA behavior), and which extra variants—if any—are mandatory. Obtain one written itemized quote and schedule. If the artist needs paid exploratory animation to resolve these questions, quote that as a separate small preproduction task.

### M2-A — Full three-hit combo (first production checkpoint)

Produce Cross Cut and Heavy Cleave as editable Actions on the existing rig; include the agreed minimum continuity work if separately authorized. Review three-hit key poses/start-end states first, then test Quick Slash → Cross Cut → Heavy Cleave in Godot at real gameplay zoom, all eight directions, with normal combo inputs and approved cancels. These two actions should be visually distinct and must not automatically resheath between attacks.

### M2-B — Movement and defense (second production checkpoint)

Produce Dash and Defend; verify transitions between drawn/sheathed states as covered by the agreed scope. Test Dash → Idle/Run/Attack, Defend entry/exit, and eight-direction stance and feet registration, with gameplay travel/invulnerability controlled by Godot.

### M2-C — Reactions, final integration and handoff (third production checkpoint)

Produce Hurt and Death; confirm recovery/death/respawn presentation, source organization, Action/slot naming, materials/rig reuse and the complete nine-action client-side SpriteFrames profile. Run final in-engine acceptance against the full set. Hold final written acceptance until requested conforming corrections are resolved.

These checkpoints are proposed review/payment gates inside ONE Milestone 2 follow-on commission, not three unrelated commissions or new character-model proofs. The precise commercial grouping and whether the fee is quoted by Action or by checkpoint are for Hammer to propose.

## 5. Technical delivery and acceptance

- Editable Blender .blend source using the accepted source character, armature, materials, katana/scabbard objects and documented dependencies; any new necessary helper scripts included.

- For each Action: clear name and rig Action slot; intended start/end keys, full actual keyed range, loop/non-loop designation, endpoint/closure rule, source FPS and animation phase/key-pose notes. Report keyed poses outside manual playback range or stashed NLA strips.

- Primarily in-place animation with stable feet/root/contact point; no authoritative movement distance or baked collision/hit windows. Maintain weapon handedness and full blade silhouette from every camera direction.

- Client renders and validates eight independent views with unchanged projection, pivot, scale and source traceability. Check every frame for omissions, repeats, discontinuities, incorrect Action slot/NLA evaluation and unexpected cropping.

- Client-side Godot acceptance judges startup/strike/recovery, state-to-state continuity, speed adaptation, directional readability, playable input/cancel behavior and crowded Hushiro composition. Technical validation does not automatically constitute creative acceptance.

- Working 512×512/30 FPS eight-view Akio tests are useful references but not a permanent deliverable resolution or a requirement for Hammer to supply sprite PNGs. The final render/export contract remains client-owned.

Specific Proof A learnings to apply: Run’s keys extended past a saved 16-frame range and were correctly evaluated as an 18-frame cycle; Idle’s end is a duplicate closure; the 44-frame Quick Slash remains a candidate pending final playtest. The client’s camera jitter was not an artist defect. Source-to-PNG auditing is mandatory for all Milestone 2 deliveries.

## 6. Review, pricing and commercial request

Please quote the six new baseline Actions individually and/or as a grouped Milestone 2 package. Show any economy from reusing the existing rig, model, and poses. Break out essential drawn-sword continuity work and optional polish/variants as separate line items so the Client can approve the minimum coherent package without surprise scope growth.

- Proposed checkpoint prices for M2-A (combo), M2-B (movement/defense), and M2-C (reactions/final handoff), plus any paid preflight work.

- Earliest realistic availability, overall lead time, delivery/review cadence, and dependencies on accepted Milestone 1 source.

- Included number of consolidated creative revision rounds, treatment of nonconforming deliverables, in-engine readability corrections, and fees for additional changes.

- Proposed deposits and balances by checkpoint. Previous Milestone 1 used 50% upfront and 50% after written acceptance per stage; this is a negotiation reference, NOT an automatic Milestone 2 term.

- Commercial usage rights to new Actions, source handoff, and continuity with approved Blender/Rigify licensing, confidentiality, third-party disclosure and source editability. Final terms belong in a separately executed agreement or written amendment.

No artwork, agreement change, payment, kickoff, or artist reply is requested by this internal draft alone. The Client may revisit every proposed detail while Proof A is being finished.

## 7. Out of scope for this proposed Milestone 2

- New player character design, new 3D model or universal rig redesign unless required for correction and specifically agreed.

- Wolf, Wraith and Ronin Aspect animation libraries or blood transformations.

- Corrupted Swordsman, other enemies, bosses, NPCs, environments, props, VFX, HUD or UI.

- Client-side rendering, eight-direction PNG exports, Godot programming, combat damage timing, hitboxes or movement physics.

- Unquoted extra drawn-sword variants, transitions, polishing passes or animations beyond the six baseline Actions.

## 8. Internal decision log — pending before sending

- Approve a minimal sword-state strategy and clarify the minimum additional visual Actions, if any.

- Accept or specifically revise unresolved Milestone 1 artist-facing issues (N/S Run gait, weapon continuity, Quick Slash closing keys); keep client-side bugs outside the artist quote.

- Decide whether to ask Hammer for one package quote plus three checkpoint prices, or an initial M2-A quote with optional M2-B/M2-C estimates. Preferred: quote the whole scope up front, approve work/payments by checkpoint.

- Choose the exact trigger for requesting the quote: preliminary availability discussion while Proof A is pending versus formal pricing only after Proof A acceptance.

Internal source references: docs/commissions/akio/AKIO_COMMISSION_BRIEF.md; docs/commissions/akio/AKIO_MILESTONE_02_PLANNING.md; docs/commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md; tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md; signed Artist Services Agreement and Exhibit A in Google Drive.
