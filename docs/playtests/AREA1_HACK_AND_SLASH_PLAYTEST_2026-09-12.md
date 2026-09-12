# Area 1 Hack-and-Slash Combat Playtest — 2026-09-12

## Frozen snapshot

This branch is an **immutable manual-playtest snapshot**. Do not push later implementation or tuning onto it.

- Branch: `playtest/area1-hack-and-slash-2026-09-12`
- Gameplay/checkpoint base: `358eacb08dd4414296d7b40664d20213f3f062ed`
- PR #166 gameplay merge: `d7ca53a11383ee3d9efdfd598b2ce38aeb9f95cb`
- PR #166 exact validated feature head: `8c812a73f399321d34bbab5fabf436e8fbc76d94`
- PR #166 validation: 11/11 exact-head workflows green
- PR #167 added the durable checkpoint plus the fail-hard Hushiro Combat Contract Gate; no gameplay tuning changed in that PR.

Older frozen comparison branches remain untouched:

- `playtest/combat-v2-phase7-2026-09-12`
- `playtest/area1-player-paced-2026-09-12`

## What changed in this snapshot

The target is now decisively **hack-and-slash first** for ordinary Area 1 combat. Weak enemies should not be major threats as lone targets. Danger should come primarily from groups, compositions, overlapping intentions, movement, geometry, target priority, authored defense, hazards, and wave pressure.

The base katana still deals:

- Quick Slash: 9 Health
- Cross Cut: 12 Health
- Heavy Cleave: 21 Health
- first three clean hits: 42 Health
- first four clean hits: 51 Health
- first five clean hits: 63 Health
- full six-hit pressure string: 84 Health

The six-hit sequence is now a **player pressure capability**, not the expected durability of a normal enemy:

`Quick -> Cross -> Heavy -> Quick -> Cross -> Heavy`

The first Heavy is midpoint punctuation and can continue into Quick #4. The second Heavy remains the natural endpoint. Existing held-Thrust branching, dash/parry cancellation, hitbox ownership, AttackEvent delivery, damage ownership, PlayerMotor, and CombatActionRunner remain canonical.

## Clean-hit durability targets

| Enemy | Health | Expected clean base-katana removal |
|---|---:|---|
| Hollow | 40 | about 3 hits |
| Blighted Hound | 50 | about 4 hits |
| Corrupted Archer | 45 | about 4 hits |
| Corrupted Swordsman | 60 | 5 hits |
| Cellar Bilemass | 60 | about 5 hits |
| Warden | 140 | about 11 hits; deliberate durable exception |

A Swordsman guard may deny the otherwise lethal five-hit line. That should create a small pressure extension, not turn every standard soldier into a duel. Hit six exists partly so Akio can keep going after a defended hit.

## Directional target handoff

Basic sword attacks now have a bounded soft-target helper. This is **not lock-on**.

Expected behavior:

- the player aims toward a nearby enemy and a basic swing may bias toward that enemy;
- alignment with player intent matters more than raw proximity;
- if the current fodder target dies during an unfinished string, the next basic swing can hand off to another nearby forward target;
- explicit player redirection must win immediately;
- enemies outside the short forward cone must not be selected;
- held Thrust, dash attack, counter, Blood Arts, and other non-basic action triggers are not governed by this helper;
- target assistance changes facing/steering only, never damage, hitboxes, collision, attack timing, or enemy pressure admission.

## Encounter behavior intentionally preserved

- PressureDirectorV2 schedules dangerous **impact timing**, not all enemy intent.
- Multiple enemies may approach, reposition, aim, or wind up together when impact windows remain fair.
- Standard Hushiro waves remain authored in the existing 3–6 active-enemy envelope.
- Mixed close-frontline occupancy remains role-aware.
- Clear -> next authored wave begins immediately; there is no intentional normal inter-wave dead air.
- Burst, staggered, and sequence arrival scripts remain in use.
- A 120-second anti-stall escalation can launch the next wave with survivors; it should be effectively invisible in ordinary skilled play.
- Health, Posture, and Poise remain separate systems.
- Posture/parry/Deathblow remain useful tactical layers rather than required standard-enemy kill paths.

## Playtest questions

### 1. Individual enemy lethality and durability

- Does a lone Hollow feel disposable rather than duel-like?
- Do Hounds and Archers usually disappear fast enough once Akio reaches them?
- Does a clean five-hit Swordsman kill feel fast without making the enemy meaningless inside a group?
- After one Swordsman guard, does the extra pressure feel like a brief variation rather than a reset into a duel?
- Does Bilemass die quickly enough once reached while its hazard pressure still matters before/around the engagement?
- Does Warden read as a deliberate durable/control exception rather than an HP sponge?

### 2. Hack-and-slash flow

- Can Akio stay offensively active through groups rather than repeatedly resetting to isolated one-on-one exchanges?
- When an enemy dies on hit 3, 4, or 5, does the unfinished string carry naturally into the next enemy?
- Does the first Heavy -> Quick #4 continuation feel intentional and responsive?
- Do ordinary enemies die quickly enough that room difficulty comes from the whole encounter rather than their individual Health bars?

### 3. Target handoff

- Does target handoff reduce swings into empty space after killing fodder?
- Does it choose the enemy you were actually aiming toward?
- Can you instantly redirect to another enemy without fighting sticky auto-aim?
- Does it ever pull you toward an enemy you clearly did not intend to attack?
- Does it feel helpful with tightly packed enemies without becoming an invisible lock-on system?

### 4. Multi-enemy pressure

- Do several enemies visibly approach/wind up at once?
- Does actual damage still arrive with readable spacing rather than a hidden global turn-token feel?
- Do Hound packs and Hollow groups feel threatening because of numbers/movement rather than durability?
- Are Archer/Bilemass spatial threats meaningful while melee bodies occupy Akio?
- Does Warden control pressure become more meaningful in a mixed room than alone?

### 5. Wave flow

- Does immediate chaining preserve combat momentum?
- Do burst/staggered/sequence arrivals make consecutive rooms feel meaningfully different?
- Is the 120-second anti-stall rule invisible in normal play?
- Do encounters still feel substantial even though individual standard enemies die quickly?

### 6. Oathbound tactical identity

- Is Posture still readable and useful without being mandatory for every kill?
- Do parry and Deathblow remain tempting tactical options rather than the only efficient route?
- Do committed enemy actions and Poise create authored exceptions without making ordinary hits feel powerless?

## Feedback format

After the playtest, return:

1. the Godot `.log` from the session;
2. the matching `combat_*.jsonl` telemetry export;
3. the room/enemy combination for any moment that felt wrong;
4. whether the problem felt primarily like **durability**, **enemy pressure**, **movement/steering**, **target handoff**, **readability**, or **encounter composition**;
5. one or two concrete examples such as “hit 4 killed too early,” “handoff pulled left when I aimed right,” “two Hounds felt passive,” or “Warden + Archer created good pressure.”

Do not tune by memory alone after this snapshot. Use the returned runtime evidence plus the player description to decide the next package.
