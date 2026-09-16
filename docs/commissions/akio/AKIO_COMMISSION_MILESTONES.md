# Akio Commission Milestones

Status: **recommended contracting plan**

Use milestone approvals so the project can correct the character early instead of discovering visual or technical problems after the full model, rig and animation set are complete.

## Milestone 1 — concept translation / turnaround

Deliverables:

- front / side / back interpretation based on the approved Akio concept references;
- key material / color callouts;
- katana and scabbard placement;
- major clothing / armor layers identified;
- any proposed simplifications needed for high-angle readability.

Approval questions:

- does the silhouette read as Akio rather than a generic ornate samurai;
- is he lean, practical and field-worn;
- is the katana/scabbard silhouette strong;
- are unseen side/back decisions acceptable;
- are the shapes simple enough to survive the gameplay camera while still supporting higher-resolution renders.

Do not proceed to final modeling before this is accepted.

## Milestone 2 — 3D blockout

Deliverables:

- proportionally complete untextured or lightly shaded 3D blockout;
- major clothing/armor volumes;
- katana/scabbard and important accessories;
- neutral pose and high-angle preview renders.

Approval questions:

- does the character still read correctly from the actual Oathbound camera family;
- do sword, hands, shoulders and cloth masses remain readable;
- does the model avoid excessive small detail that disappears in gameplay;
- does the silhouette still match the approved turnaround.

## Milestone 3 — final model / materials

Deliverables:

- final topology;
- UVs;
- final or approved-near-final textures/materials;
- modular katana/scabbard;
- organized clothing/accessory pieces where practical;
- high-angle beauty/gameplay-scale previews.

Approval questions:

- is the character visually strong enough to plausibly become final Akio with later polish;
- do materials read under the planned stylized render setup;
- are important details visible without clutter;
- are future corruption / Aspect material variants feasible.

## Milestone 4 — rig and deformation test

Deliverables:

- production armature / deformation rig;
- animator controls;
- weapon and scabbard controls;
- named attachment points;
- deformation test poses for large sword swings, crouched/dash posture, guard posture and heavy overhead/body-rotation poses.

Approval questions:

- do shoulders, elbows, wrists, hips and cloth deform cleanly;
- can the sword be animated comfortably in one- and two-handed poses if needed;
- can the rig support fast Wolf-like movement, long Wraith-like thrusting and slow Ronin-like heavy actions later without rebuilding it;
- is the source file self-contained and editable.

## Milestone 5 — animation language proof

Before all nine animations are polished, approve a small representative subset:

- Idle;
- Move;
- Quick Slash;
- Heavy Cleave.

The animator should first provide blocking, then a polished pass after direction is approved.

Approval questions:

- does Akio move like a disciplined hunter;
- does Quick Slash feel fast and economical;
- does Heavy Cleave visibly take more commitment and read as a finisher;
- does the motion remain clear from the high-angle camera;
- does the style avoid unnecessary flourish.

No exact impact timestamps are required for approval. Evaluate motion quality, relative attack weight, silhouette and flow.

## Milestone 6 — complete Stage 1 animation package

Deliverables:

- Idle;
- Move;
- Dash;
- Defend;
- Hurt;
- Death;
- Quick Slash;
- Cross Cut;
- Heavy Cleave.

Approval questions:

- are the three sword attacks clearly differentiated;
- does the three-hit neutral phrase flow naturally while each clip remains independently usable;
- is Heavy Cleave a clear final payoff;
- do dash and movement support the intended responsive combat feel;
- can defense/hurt/death be read at gameplay distance.

## Milestone 7 — eight-direction render proof

Deliverables:

- approved fixed render camera / lighting profile;
- all Stage 1 animations rendered in `e,se,s,sw,w,nw,n,ne`;
- stable feet/contact registration;
- transparent high-resolution PNG masters;
- one current-runtime derivative set or enough masters for the project to generate it internally;
- sample clean-prerender and downsample/pixel-treated comparisons from the same source.

Approval questions:

- does Akio remain readable in every direction;
- are there bad angles where sword/body overlap destroys the attack silhouette;
- is feet registration stable;
- does the clean prerender or the lower-resolution treatment better fit Oathbound;
- is the pipeline practical to rerun after animation revisions.

## Milestone 8 — final source handoff

Required before final payment:

- complete `.blend`;
- textures/materials;
- all Stage 1 animation Actions;
- rig/control setup;
- render setup;
- master rendered frames;
- any agreed derivative frame set;
- documentation of attachment points / naming;
- disclosed third-party dependencies and licenses;
- confirmation of agreed commercial / modification / derivative rights.

Open the package on a clean machine or clean project path before accepting final delivery. Missing external textures, proprietary add-on dependencies or non-editable animation data should be treated as incomplete handoff.

## Expansion decision after Stage 1

Do not automatically order the full Akio library at final handoff.

First integrate Stage 1 into Oathbound and evaluate:

- movement readability;
- combat feel;
- attack-chain readability;
- eight-direction stepping;
- camera fit;
- clean prerender vs stylized/downsample treatment;
- revision speed from Blender to Godot.

If accepted, proceed to Stage 2 core extensions (Hold Thrust, Dash Slash, Counter Cut and any dedicated defense/execution animations), then commission Aspect-specific Wolf/Wraith/Ronin packages as their final visual/weapon identities become sufficiently stable.