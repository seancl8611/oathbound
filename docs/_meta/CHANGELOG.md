---
id: META-CHANGELOG
title: Documentation Changelog
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-14
---

# Documentation Changelog

## 2026-08-14 — Technique roster, rarity, and eligibility lock

- Completed the current working launch Technique roster at **50 actual Techniques plus 10 refinements**.
- Locked the roster composition as 25 direct slotted Techniques, 15 same-family Supporting Techniques, 5 Cross-family Techniques, and 5 family Legendaries.
- Added the approved same-family Supporting roster and one Legendary capstone for Echo, Rupture, Seal, Rift, and Crimson.
- Added five Rare Cross-family Techniques: Resonant Break, Fractured Memory, Shattered Scar, Exposed Break, and Bound Wound.
- Added ten selective refinements; refinements remain small parent-Technique upgrades and do not count as separate Techniques.
- Locked the rarity distribution at **10 Common / 18 Uncommon / 17 Rare / 5 Legendary**. Refinements have no rarity.
- Locked direct-Technique eligibility around an empty combat slot with no family prerequisite; Rare direct Techniques may still be a player's first pickup from that family.
- Locked Supporting eligibility around an already-owned effect that can actually interact with the support, preventing dead support offers.
- Locked Cross-family eligibility around existing investment in both listed families plus any entry-specific mechanic requirement.
- Locked Legendary eligibility at **3 native Techniques from that family, including at least 1 slotted Technique**. Same-family Supporting Techniques count; Cross-family Techniques and refinements do not.
- Advanced the active Technique-system work to reward frequency, offer-generation order, rarity probabilities/source weighting, rare replacement behavior, and the complete roster audit.
- Kept exact combat values, rarity probabilities, reward weights, and offer frequency deferred to prototyping and reward-system design.

## 2026-08-13 — Direct Technique matrix lock and repo cleanup

- Locked the full **25-Technique direct matrix** at qualitative paper-design depth after final review.
- Approved all five direct rows across Echo, Rupture, Seal, Rift, and Crimson.
- Finalized Echo's direct row as Lingering Cut, Second Draw, Passing Shadow, Remembered Reversal, and Final Memory.
- Finalized Rupture's direct row as Rupturing Edge, Mountain Breaker, Breaching Step, Breaking Reversal, and Shattered Ground.
- Finalized Seal's direct row as Sealing Cuts, Binding Draw, Warding Step, Counterseal, and Passing Seal.
- Finalized Rift's direct row as Rift Edge, Deep Rift, Shearing Step, Rift Reversal, and Parting Rift.
- Kept Crimson's approved row as Open Wound, Deep Cut, Blood Arc, Exposed Guard, and Predator's Wake.
- Removed stale live-design language that still treated Echo, Rupture, Seal, Rift, or the full matrix as unresolved.
- Advanced the active Technique task to the later catalog layers: **Legendary, Supporting, Cross-family, refinements, replacements, rarity, prerequisites, and eligibility**.
- Rebased the Crimson Vulnerable redesign onto the current `main` documentation baseline so the live repo no longer depends on the previously diverged stacked-branch history.
- Historical Burst entries remain only as explicitly superseded design history.

## 2026-08-12 — Crimson Vulnerable / backstab redesign

- Superseded the 2026-08-11 Crimson **Burst** family direction.
- Locked backstab as a universal positional hit classification based on genuinely striking an enemy from behind; Crimson does not create fake backstab windows through forced facing, widened rear arcs, scripted enemy behavior, or ordinary slow.
- Rebuilt Crimson around **Vulnerable**, a short enemy status that causes genuine backstabs to deal substantially increased direct Health damage.
- Kept Vulnerable deliberately narrow: it does not slow, stun, root, alter facing, suppress movement abilities, or change enemy awareness.
- Established that not every Crimson Technique needs to apply or reference Vulnerable; the family may also use standalone direct Health damage, bounded AoE, and backstab payoffs.
- Added a standalone-value requirement so a Crimson Technique remains worthwhile even when it is the player's only Crimson pickup.
- Approved the Crimson direct five-slot row at qualitative depth:
  - **Basic Attack — Open Wound:** qualifying Basic hits apply Vulnerable.
  - **Held Attack — Deep Cut:** a Held backstab deals extremely high Health damage and partially bypasses defensive mitigation.
  - **Dash — Blood Arc:** Dash Attack creates a wide bounded crimson sword arc for direct Health damage and nearby coverage.
  - **Parry / Counter — Exposed Guard:** a successful Counter applies Vulnerable.
  - **Deathblow — Predator's Wake:** nearby survivors become Vulnerable after a Deathblow resolves.
- Reserved brief invisibility / enemy-awareness suppression for a future Crimson **Legendary** through the working Unseen concept; exact Legendary implementation remains deferred.
- Removed Burst-ready, per-target Burst recharge, close-range Burst recovery, and radial Burst VFX from current production direction.
- Advanced Crimson from an unresolved direct-row task to a completed qualitative row awaiting the full five-family compatibility/readability audit.

## 2026-08-12 — Technique architecture consistency audit

- Audited Technique dependencies after the five family cores were locked.
- Removed stale four-active-plus-reserve and rest-room swapping language from the core loop, run structure, terminology, art inventory, and Milestone 4 scope.
- Removed remaining temporary Prosthetic-Technique assumptions from dependent run-build and production documentation; Prosthetic progression remains persistent Forge development.
- Synchronized full-scope, progression, reward, UI, combat, and production dependencies around five direct combat slots plus slotless supporting Techniques.
- Updated dependent summaries to recognize the then-current five defined family mechanics: Echo, Rupture, Seal, Rift, and Burst. Crimson Burst was subsequently superseded by the Vulnerable / backstab redesign above.
- Corrected the art inventory's Relic rarity summary to the currently provisional three-tier Common / Rare / Legendary sketch rather than the four-tier Technique rarity model.
- Confirmed the active design dependency was the direct five-by-five Technique matrix; that dependency was completed on 2026-08-13.

## 2026-08-11 — Rift and Crimson Burst family lock — Crimson portion superseded 2026-08-12

- Locked the Ivory / blade-circle family around **Rift**.
- Defined Rift as one visible ivory fracture-line on the enemy that automatically opens after a short fuse for direct Health damage.
- Further qualifying Rift applications intensify the same visible mark rather than adding exposed stacks; the fracture spreads and becomes more prominent as its eventual burst grows stronger.
- Positioned Rift as a **strong-upfront, moderate-scaling** family: one pickup is immediately useful, while deeper investment remains viable without requiring the highest synergy ceiling.
- Previously locked the Crimson / split-blood-drop family around **Burst**; that Crimson direction is now superseded by the 2026-08-12 Vulnerable / backstab redesign.
- The superseded Burst direction used immediate heavy direct AoE centered on a Burst-ready target, per-target recharge, close-range recovery acceleration, bounded pack behavior, and no persistent base damage zone.
- Explicitly allowed the five Technique families to use different buildup structures and different early / late power curves rather than forcing all families into stack-based scaling.
- Advanced the active Technique task to designing and approving the full five-by-five direct combat-slot matrix.

## 2026-08-09 — Core Technique-family mechanics pass

- Reclassified the earlier ~55-Technique concept pool as exploratory rather than the current launch roster.
- Paused cross-family Techniques and refinements until the five core families and direct combat-slot Techniques are stable.
- Kept families primarily player-recognizable through symbol, color treatment, effect behavior, VFX, and audio rather than formal school names.
- Clarified the pale-silver family around **echoes**: delayed additional sword slashes, not literal full-action repetition.
- Removed the separate `Fracture` term from the gold family.
- Defined the working **Rupture** rule as a visible buildup meter with no partial effect; full meter triggers a large posture burst, strong allowed hit reaction, and smaller nearby posture shockwave, then resets.
- Locked the Violet family around discrete **Seal stacks** rather than a buildup meter.
- Defined one Seal as a minor movement slow, two Seals as stronger movement restriction plus suppression of qualifying movement abilities, and three Seals as a brief **Bind** that roots without stunning and then clears the stacks.
- Explicitly separated Violet from posture mechanics: Seal does not inherently damage posture, suppress posture recovery, or trigger a posture burst.
- Defined the enemy-facing Seal visual as one mark, two connected marks, then a completed binding pattern during Bind.
- Advanced the active family-design question from Violet to the Ivory scalable mechanic.
- Marked the ivory and crimson families for redesign around concrete scalable mechanics rather than precision-only or Health-risk-only triggers.
- Clarified that refinements are small buffs to an existing slotted Technique, not separate Techniques.
- Standardized all Technique sources around the same Technique reward screen; combat rooms are the main source, with shops, treasure, minibosses, and regional bosses able to grant the same reward type.
- Removed Prosthetic Techniques and temporary Prosthetic specialization from the run-build system.
- Assigned Prosthetic progression to persistent Forge development using the existing Scroll currency model.
- Synchronized Technique, catalog, reward, progression, Prosthetic, UI, VFX, full-scope, decision, and open-question documentation.

## 2026-08-09 — Technique architecture overhaul

- Replaced the four unrestricted active Technique slots plus reserve with five direct combat slots: Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow.
- Limited each direct combat slot to one Technique at a time; ordinary direct Techniques no longer stack within the same action.
- Added rare same-slot replacement offers and removed the general reserve inventory model.
- Added slotless supporting Techniques with no global inventory cap; practical growth is limited by reward opportunities, route choices, rarity, prerequisites, and run length.
- Kept one refinement maximum per eligible slotted Technique while separating refinements from broader supporting upgrades.
- Kept Common / Uncommon / Rare / Legendary Technique rarity and allowed some Legendary candidates to use family-investment prerequisites, with exact thresholds deferred.
- Reframed Technique families as internal effect/build structures that must support comparable depth across several core combat actions rather than unequal mechanic buckets.
- Removed the old Blade / Deflection / Execution / Movement / General launch quotas and the old ~30-Technique count as correctness requirements.
- Rejected generic elemental schools as the main Technique-family structure; familiar effects such as slow, AoE, extended reach, delayed damage, chaining, restraint, and recovery should use Oathbound-specific presentation.

## 2026-08-07 — Aspect questions closed for current scope

- Treated Wolf, Wraith, and Ronin Tier 0-IV packages as locked at current qualitative paper-design depth after user review.
- Removed the final cross-roster Aspect comparison and other resolved Aspect/Tier audits from the active question tracker.
- Kept exact combat values, timings, hitboxes, growth percentages, collision, and presentation tuning deferred to prototyping and implementation.
- Advanced the active design area to the launch run-build content catalog.

## 2026-08-07 — Ronin package lock and Aspect documentation cleanup

- Approved Ronin's Tier 0 weapon foundation without changing its six-action moveset or strongest-guard/slow-posture-recovery identity.
- Kept Steadfast Reprisal, Falling Mountain with Deep Rupture, Unbroken Resolve with Measured Weight and Perfect Weight, and Shattering Wake as Ronin's Tier I-IV headline package.
- Added Ronin's repeated supporting growth rule: every Embrace from Tier I through Tier IV modestly increases maximum player-posture capacity without increasing posture recovery or block efficiency.
- Marked all three launch Aspect packages complete at qualitative Tier 0-IV paper-design depth.

## 2026-08-06 — Wraith Tier IV Beyond the Veil lock

- Approved Beyond the Veil as Wraith Tier IV.
- Increased Pale Lance and Ghostline Slash spectral reach within locked Tier IV boundaries.
- Added extended deathblow initiation through a valid clear frontal path and brief movement-only Veilstride after killing deathblows.

## 2026-08-06 — Wraith Tier III Spectral Passage lock

- Replaced Veiled Guard with Spectral Passage.
- Made qualifying spectral attacks continue through ordinary-enemy bodies across remaining authored geometry with reduced secondary Health damage and meaningful posture / guard pressure.

## 2026-08-05 — Wraith Tier II corridor Blood Art lock

- Replaced the temporary duration-state version of Wraith's Reach with one immediate sweep-corridor-echo Blood Art.

## 2026-08-05 — Aspect package revision and repository synchronization

- Completed Ronin's working qualitative Tier 0-IV package.
- Replaced Wolf's Dire Hunt transformation with Blood Hunt and replaced Apex Feast with Apex Mauling.
- Reopened and then completed Wraith's remaining Tier package audit.

## 2026-07-11 — Blood Aspect, Technique, and room-reward redesign

- Made Wolf, Wraith, and Ronin Blood Aspects the central run identities with fixed Tier 0-IV vertical escalation through Corruption and Shrine Embrace.
- Removed Storm, Frost, Ember, Hex, and Shadow as player stance families.
- Replaced the former stance and broad boon layers with temporary Techniques.
- Introduced the original four-active-plus-reserve Technique model, later superseded by the 2026-08-09 architecture.
- Added a previewed room-reward framework.

## 2026-07-11 — Production bible completion

- Completed Blood Aspect and Prosthetic VFX briefs, cross-area room identities, HUD requirements, currency naming/persistence, and the polished Milestone 1 Style Test structure.

## 2026-07-10 — Production bible migration

- Expanded overview, scope, gameplay, lore, regions, enemies, bosses, trials, UI, and VFX into version-controlled authoritative documents.

## 2026-07-10 — Repository architecture

- Established version-controlled documentation sections, source-of-truth rules, terminology, decision log, open-question register, and update protocol.
