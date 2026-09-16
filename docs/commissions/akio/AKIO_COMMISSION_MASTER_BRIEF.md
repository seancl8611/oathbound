# Akio Commission Master Brief

Status: **artist-facing draft for quotation / milestone scoping**

## 1. Goal

Create a production-quality 3D source character for **Akio**, Oathbound's playable samurai beast hunter, with a reusable rig and a first focused animation package that can be rendered into Oathbound's eight-direction 2D runtime.

This should be approached as a potential foundation for the final Akio asset, not a disposable generic test character. The first contract remains intentionally limited so the character, rig, animation language and rendered-2D result can be approved before commissioning the larger move library.

The 3D character is an **offline art-production source**. Normal gameplay remains 2D in Godot.

## 2. Character identity

Akio is a disciplined Order swordsman and beast hunter who repeatedly enters cursed territory with steel, ritual tools and controlled exposure to Beast Blood.

Current visual baseline:

- lean, dark, layered samurai-hunter silhouette;
- wrapped limbs and weathered outer cloth;
- compact practical armor rather than ceremonial or ornate armor;
- light lamellar reinforcement, leather, cords, pouches and ritual tags;
- strong readable katana silhouette at the hip;
- scarf / wrapped-cloth language and clear layered cloth clusters;
- practical field equipment such as seals, vials and utility gear may be represented where they do not create visual noise;
- grounded, restrained and dangerous rather than noble, flamboyant or decorative.

Akio must remain readable from the game's fixed high-angle gameplay camera. Weapon direction, hands, shoulders, upper-body pose and major cloth masses matter more than tiny costume details that disappear at gameplay scale.

The contractor will receive approved concept/reference images. Any unseen side/back details should be resolved through an approval turnaround before final modeling rather than invented silently.

## 3. Personality in motion

Akio should read as a trained hunter rather than an acrobatic showman:

- disciplined and efficient;
- compact sword mechanics;
- controlled recovery;
- minimal wasted motion;
- fast when an action calls for speed, but never weightless;
- heavy attacks should visibly require more commitment than light attacks;
- attacks should preserve clean weapon-path silhouettes from the high-angle camera.

Animation quality and combat readability are more important than decorative flourish.

## 4. Blood Aspect compatibility

Akio's Blood Aspects change his combat kit. They are **not currently just one universal three-hit combo with different numbers**.

Current gameplay structure:

- **No Aspect / baseline katana:** 3-hit basic phrase — Quick Slash -> Cross Cut -> Heavy Cleave.
- **Wolf:** 4-hit basic sequence with faster connected pressure and stronger pursuit identity.
- **Wraith:** 2-hit basic sequence built around longer reach and deliberate frontal spacing/control.
- **Ronin:** 3-hit slower, heavier and more committed sequence with stronger individual impact.
- Each Aspect also has its own held attack, dash attack, counter attack and later Blood Art / tier-specific actions.

The first commission does **not** need to animate every Aspect. Stage 1 establishes Akio's neutral/base physical vocabulary and a reusable rig. During early playtesting, Aspect actions may temporarily reuse the closest baseline animation family.

That reuse is a prototype presentation shortcut only. It does not mean the final Wolf, Wraith and Ronin kits must all use Quick Slash / Cross Cut / Heavy Cleave animations.

## 5. Future-proofing for Aspect variants

Because future Aspects may change Akio's apparent range, weapon treatment, silhouette or combat posture, the source asset should make later variation practical:

- katana and scabbard should remain separate, editable objects;
- weapon attachment / hand controls should be clean and reusable;
- provide obvious attachment points for right hand, left hand, hip/scabbard and weapon-tip VFX;
- clothing/accessories should be organized so selected pieces can be hidden, replaced or recolored where practical;
- material organization should allow future corruption / Blood Aspect treatments without rebuilding the mesh;
- the skeleton should be general enough for faster pursuit attacks, long-reaching thrusts and slower heavy committed attacks;
- do not bake one animation style so tightly into the rig that later weapon or stance variants require rebuilding the character.

## 6. Stage 1 scope

The first commission should include:

- final or near-final Akio base model;
- UVs, textures and materials;
- katana and scabbard;
- production-usable deformation rig and animator controls;
- eight-direction render setup / compatibility;
- first animation package defined in `AKIO_ANIMATION_SCOPE.md`;
- complete editable source package defined in `AKIO_TECHNICAL_DELIVERABLES.md`.

The aim is to get a convincing version of Akio into real combat quickly while ensuring the expensive source asset remains useful if this becomes the final production route.

## 7. Explicit non-goals for Stage 1

Do not include unless separately quoted:

- full Wolf animation library;
- full Wraith animation library;
- full Ronin animation library;
- Blood Arts;
- Prosthetic-specific animations;
- Techniques / upgrade-specific attacks;
- executions / deathblows beyond any later separately approved milestone;
- cinematic acting / dialogue animation;
- alternate costumes;
- final corruption transformation states.

## 8. Animator freedom

Do **not** treat current Godot attack durations as animation mandates.

We want the animator to design convincing motion based on qualitative combat roles. Examples:

- Quick Slash is the fast opening cut.
- Cross Cut is a distinct continuation with a broader or differently oriented body/weapon path.
- Heavy Cleave is the final attack of the baseline chain, should activate more deliberately, feel heavier, and carry a stronger follow-through/recovery.

Exact startup length, impact frame, recovery length and total clip duration are not locked commission requirements. We can tune Godot's combat data around an accepted animation.

The only hard separation is that animation presentation does not decide gameplay damage or collision authority.