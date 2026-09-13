# Combat V2 Defense and Readability Direction

Status: approved direction, September 2026.

## Why this changed

Oathbound's combat has moved away from a Sekiro-like duel model and toward a faster, crowd-driven hack-and-slash model. The first-room September playtests showed that carrying the old assumptions forward creates unnecessary cognitive and presentation load: ordinary enemies expose Posture/Deathblow state, most attacks ask for parry timing, and large counter indicators compete with multiple enemies, hazards, movement, and target selection.

The new defense model should make Akio worry primarily about **space, enemy count, target priority, positioning, dodging, and surviving overlapping pressure**. A missed parry should not be the universal failure state for ordinary combat.

## Core combat-resource hierarchy

- **Health** decides normal defeat.
- **Poise** is hidden and decides immediate flinch/interruption resistance.
- Standard-enemy **Posture is retired from the target architecture**. It should not be a second ordinary kill meter.
- Standard-enemy universal **Deathblow readiness is retired**.
- Reusable authored execution/finisher infrastructure may remain for minibosses, bosses, phase transitions, and deliberately-authored special moments.
- The player keeps a compact visible Health readout. Player-facing Posture is also slated for retirement as this migration completes.
- Standard enemies should not carry floating Health/Posture bars. Miniboss/boss Health presentation may remain where it improves encounter readability.

## Poise replaces the immediate-interruption job

Poise is deliberately not another player-facing resource bar. It answers one local question: **does this hit interrupt this action right now?**

Area 1 role intent:

| Role | Neutral | Committed | Result |
| --- | ---: | ---: | --- |
| Hollow / Hound / Archer | 1 | 1 | ordinary sword pressure can flinch them out of actions |
| Swordsman / Bilemass | 1 | 2 | easy to flinch while neutral; committed moves resist light hits |
| Warden / brute-control bodies | 2 | 3 | light pressure does not casually erase their commitments; heavier tools matter |

The exact values may evolve, but the role distinction is architectural: squishier bodies are interruptible; heavier/brute bodies earn resistance through Poise rather than inflated Health.

## Parry is opt-in, not universal

Parry remains in Oathbound, but it is no longer a foundational answer to every enemy attack.

### Default rule

**Ordinary attacks are not parry opportunities.**

An ordinary attack may be:
- avoided through movement/dash,
- blocked when that attack is authored as blockable,
- interrupted before impact when the enemy's Poise allows it,
- outranged or repositioned around.

Opening Akio's parry window against an ordinary blockable hit should resolve as defense/block rather than granting a parry reward.

### Special rule

Only deliberately-authored attacks opt into parry. New attack content should stamp:

`special_parry = true`

on the canonical attack hitbox/projectile. During migration, the existing `perilous` damage type remains a compatibility bridge for already-authored special thrust-style attacks.

Good candidates include:
- a signature Swordsman thrust,
- selected elite/miniboss techniques,
- boss signature moves and phase-specific counters,
- future special projectiles explicitly designed around reflection/counterplay.

Being dangerous, heavy, or unblockable does **not automatically mean parryable**. These are separate authored properties.

## Readability language

### Ordinary melee

No universal floating parry marker. Telegraph through body animation, pose, motion, weapon trail, sound, spacing, and the enemy's authored windup.

### Special parry opportunity

Use one **small, deterministic special-counter mark**. It should be visually subordinate to the enemy animation, not a large HUD element over the enemy. It should not cycle through yellow/red states that imply multiple simultaneous rules.

The current PressureDirector `impact_at` prediction remains useful timing authority for eligible close-frontline special attacks. The September playtest showed matched Swordsman contacts landed close to the scheduled predicted contact; the larger problem was that the cue appeared on ordinary attacks and carried too much visual/semantic weight.

### Projectile

A normal projectile is not automatically parryable. Flight/local collision geometry remains authoritative for its movement. A projectile receives the special-counter cue only when that projectile explicitly opts into special parry behavior.

### Hazard / ground attack

Spatial warning only. Never reuse parry/counter language for a landing zone, puddle, explosion footprint, or other positional hazard.

### Unblockable

`unblockable` and `special_parry` are independent. An unblockable attack may demand avoidance with no counter opportunity. A special parry move may be intentionally counterable. Presentation must communicate the authored answer rather than deriving it from one old Sekiro color ladder.

## Forgiveness target

The default defensive loop should be forgiving enough that an ordinary missed parry input does not convert every incoming attack into a high-damage timing failure. Holding/using defense against an ordinary blockable attack should continue into the block path; the special parry reward is reserved for attacks explicitly designed around it.

Difficulty should come primarily from:
- enemy groups and composition,
- overlapping intentions,
- target priority,
- movement and geometry,
- ranged/hazard pressure,
- attack commitment and Poise differences,
- waves and recovery openings.

## Production budget

Universal Posture/Deathblow/parry expectations multiply animation, execution, UI, cue, camera, targeting, and testing costs across every enemy. Reserving executions and parry moments for authored high-value encounters lets those moments receive better art and animation while common enemies remain readable in crowded fights.

## Migration contract

1. Introduce explicit special-parry classification and make ordinary defense ignore the old universal-parry assumption.
2. Reduce the shared special-counter indicator and remove ordinary-attack cue spam.
3. Retire standard-enemy PostureBar/Posture-break/Deathblow runtime ownership while preserving boss/miniboss execution infrastructure.
4. Retire player-facing Posture and reconcile block cost/guard behavior with the simpler defense model.
5. Continue profiling runtime/presentation churn as old Posture, Deathblow, and universal cue nodes leave the standard-enemy path.

This direction is a design authority, not a manual-playtest gate. Continue implementing coherent architectural work; request a playtest when a runtime question specifically benefits from one.
