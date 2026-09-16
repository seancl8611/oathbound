# Akio Animation Scope

Status: **Stage 1 commission scope**

## Animation philosophy

The first animation package should make Akio feel convincing in real combat without paying for his entire eventual Blood Aspect / Technique library.

The animator should receive qualitative goals rather than hard-coded impact timestamps. We want authored variation in anticipation, speed, body mechanics, follow-through and recovery. Godot combat values can be tuned after the animation is approved.

All gameplay-facing clips should be authored so they read clearly from the fixed high-angle camera and at relatively small on-screen character scale.

## Stage 1 required animations

### 1. Idle / combat-ready stance

Purpose: establish Akio's default silhouette and character identity.

Guidelines:

- disciplined ready posture;
- katana/scabbard remain clearly readable;
- restrained breathing / weight shift rather than excessive fidgeting;
- should transition cleanly into movement, defense and sword attacks.

### 2. Combat movement / run

Purpose: represent Akio's normal analog movement.

Guidelines:

- responsive combat locomotion, not a casual jog;
- efficient footwork and controlled upper body;
- sword and scabbard should remain stable enough to read at gameplay scale;
- must look convincing when rendered from all eight directions.

The game may move Akio at any analog angle even though the visual set begins with eight directional buckets.

### 3. Dash / step-dodge

Purpose: sell Akio's fast committed repositioning and defensive mobility.

Guidelines:

- short, decisive burst;
- compact silhouette;
- should clearly differ from normal running;
- avoid elaborate flips or acrobatics unless specifically approved later.

### 4. Defend / guard-ready

Purpose: cover the first playable defensive presentation for ordinary guard and special parry windows.

Guidelines:

- compact frontal defensive posture;
- sword position should immediately communicate defense;
- shoulders/hands/weapon line must remain readable from the high-angle camera;
- Stage 1 may use one shared defensive family; dedicated parry-success/counter poses can be added later.

### 5. Hurt reaction

Purpose: show that Akio took a real hit without making every hit look like a full knockdown.

Guidelines:

- short and readable;
- directional readability should survive eight-direction rendering;
- preserve the possibility of future heavier stagger / knockdown reactions as separate clips.

### 6. Death

Purpose: complete basic combat-state coverage for real playtests.

Guidelines:

- grounded and readable;
- not excessively long or cinematic;
- avoid large root displacement that makes 2D registration difficult.

## Stage 1 baseline sword chain

These three attacks are the neutral / no-Aspect basic phrase used to establish Akio's core sword language.

### 7. Quick Slash

Role: **fast opening attack**.

Guidelines:

- compact, efficient cut;
- little wasted motion;
- should feel suitable as the first hit in a responsive chain;
- visibly lighter and less committed than Heavy Cleave.

### 8. Cross Cut

Role: **distinct second attack / continuation**.

Guidelines:

- should not look like the exact same slash repeated;
- use a different weapon path, body rotation or side transition;
- broader or more committed than Quick Slash while remaining a normal basic strike;
- should naturally flow toward the final Heavy Cleave.

### 9. Heavy Cleave

Role: **final attack of the baseline basic chain**.

Guidelines:

- slower and more deliberate to activate than the earlier basic attacks;
- stronger anticipation / weight transfer;
- clearly heavier impact silhouette;
- more committed follow-through and recovery;
- should read as the payoff / punctuation of the three-hit phrase.

No exact seconds, impact frame or recovery frame are prescribed. The animator should propose a convincing version and we will tune gameplay timing around the accepted motion.

## Combo-flow goal

The basic phrase should feel like:

`fast opening cut -> distinct continuation -> deliberate heavy finisher`

The three animations should flow into one another without needing to become one inseparable baked animation. Each remains an independent action so the game can branch, stop, cancel or repeat according to gameplay rules.

## Stage 2 — core sword extensions after Stage 1 approval

If Stage 1 works well in-game, the next animation commission should add the core situational moves that already exist in gameplay:

- **Hold Thrust** — deliberate narrow single-target thrust / punish;
- **Dash Slash** — sword attack flowing out of Akio's dash movement;
- **Counter Cut** — fast retaliatory cut following successful defensive timing;
- optional dedicated **Parry / Deflect reaction** if the shared Defend family is no longer sufficient;
- optional **Deathblow / execution** once the final execution presentation is ready to be authored.

## Stage 3 — Blood Aspect-specific animation packages

Aspect-specific animation should be commissioned only after the base rig and Stage 1 presentation are accepted.

Current gameplay identities to preserve when that phase begins:

### Wolf

- four-hit basic sequence;
- fastest / closest-range connected pressure identity;
- pursuit and forward-driving attack language;
- later Wolf-specific held, dash, counter and Blood Art actions.

### Wraith

- two-hit basic sequence;
- longer reach and spacing/control identity;
- more deliberate frontal line / arc language;
- later long-reaching held, dash, counter and Blood Art actions.

### Ronin

- three-hit basic sequence;
- slowest, heaviest and most committed basic identity;
- stronger individual attack weight and defensive stability;
- later heavy held, dash, counter, reprisal and Blood Art actions.

Final Aspect visuals may also use different weapons, range treatments, materials, FX and silhouette changes. Stage 1 should therefore prove the reusable Akio rig rather than hard-code all future variants into the first animation package.

## Root / registration rule

Gameplay movement remains in Godot. Animations should be authored primarily in-place at the root so movement distance can be tuned independently.

Natural body translation, weight shift, lunging poses and footwork inside the animation are encouraged. Avoid baking large world-space root travel into the source action unless a later move is intentionally scoped around authored root motion and the integration plan is revised.