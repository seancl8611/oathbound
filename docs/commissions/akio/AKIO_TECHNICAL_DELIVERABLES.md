# Akio Technical Deliverables

Status: **artist-facing technical contract for Stage 1**

## 1. Native source package

The commission must include the complete editable source asset, not only exported sprites.

Required:

- self-contained Blender `.blend` file compatible with the agreed Blender version;
- final editable character mesh;
- katana and scabbard as separate editable objects;
- UVs;
- source textures and materials;
- deformation skeleton / armature;
- animator-friendly control rig;
- skin weights / deformation setup;
- all commissioned animation Actions with editable keyframes/curves;
- render scene / camera / lighting used for the 2D conversions;
- all required external textures packed or delivered in a clearly documented relative folder structure.

Optional but useful exchange exports:

- FBX and/or glTF copy of the final skinned character;
- separate animation exports where practical.

The native `.blend` remains the authority because future animation and directional rendering will be produced from it.

## 2. Rig requirements

The rig should be built for long-term reuse rather than only the first nine clips.

Minimum expectations:

- reliable humanoid deformation through sword-combat poses;
- clean shoulders, elbows, wrists, hips, knees and ankles;
- hand controls appropriate for katana grip changes;
- practical IK/FK or equivalent animator controls where useful;
- weapon-parent / weapon-space controls that make katana animation easy to revise;
- stable root / master control;
- no required proprietary add-on unless disclosed and approved in advance;
- no destructive bake that prevents later animation editing.

Recommended named attachment points / empties / bones:

- right hand weapon attachment;
- left hand weapon / support attachment;
- hip / scabbard attachment;
- weapon tip;
- weapon base / hilt;
- body-center VFX point;
- optional head / chest / back attachment points for future Blood Aspect or Prosthetic presentation.

Exact naming can be agreed with the artist, but it must be documented.

## 3. Model organization for future variants

Akio's Blood Aspects may eventually change visible range, weapon treatment, materials, FX or portions of his silhouette.

Where practical:

- keep weapon geometry modular;
- keep major accessories / outer-cloth pieces logically separated;
- use understandable material slots;
- avoid unnecessary mesh merging that makes future visual variants difficult;
- preserve a clean neutral/base Akio state from which variants can be derived.

This does not require building the Aspect variants during Stage 1.

## 4. Animation source requirements

Each Stage 1 animation must exist as a clearly named editable Blender Action.

Preferred names:

- `Akio_Idle`
- `Akio_Move`
- `Akio_Dash`
- `Akio_Defend`
- `Akio_Hurt`
- `Akio_Death`
- `Akio_Attack_QuickSlash`
- `Akio_Attack_CrossCut`
- `Akio_Attack_HeavyCleave`

Animations should be primarily in-place at the root. Internal body translation and footwork are expected; gameplay travel is not baked into the character's world position.

The artist chooses the exact clip durations and impact poses. We will tune Godot around the accepted animation instead of requiring the artist to hit current prototype timestamps.

## 5. Eight-direction 2D conversion

The first game-ready conversion uses these independent directions:

`e, se, s, sw, w, nw, n, ne`

Do not rely on horizontal mirroring for the final delivered proof. Akio's handedness, katana/scabbard placement, clothing asymmetry and future Aspect details should remain correct.

The recommended production method is:

1. author each action once on the 3D rig;
2. keep one fixed render camera and lighting setup;
3. rotate the actor/root through the eight approved yaw angles;
4. render every frame with transparency;
5. preserve one stable feet/contact registration point across every direction and animation.

The repository already has a Blender directional-render automation path. The delivered `.blend` should be structured so that automation can reference the character armature, actor root and render camera without destructive scene changes.

## 6. Master renders vs runtime derivatives

Do **not** make 128x128 the only archival output.

Required archival/master output:

- transparent RGBA PNG sequence;
- fixed canvas and fixed camera across every frame;
- high enough resolution to preserve the commissioned model's detail and allow future resampling/style experiments;
- no per-frame auto-cropping;
- stable foot registration;
- clean alpha edges;
- source render frame rate high enough to allow us to derive multiple runtime frame rates later.

A 1024x1024 master is a useful target if practical, but exact master resolution may be proposed by the artist based on framing and render quality. The important rule is that we retain a substantially higher-resolution master than the current gameplay proof.

Current Godot proof derivative:

- 128x128 RGBA;
- feet anchor `(64, 112)`;
- eight directions;
- current baseline 12 fps presentation;
- no per-frame crop;
- file pattern `<animation_base>_<direction>_<frame:03>.png`.

We may generate this derivative ourselves from the master renders. If the contractor is also responsible for the conversion, both the high-resolution masters and the game-ready derivative must be delivered.

## 7. Visual treatment deliverables

For the first pipeline evaluation, retain the same animation and camera while allowing more than one 2D treatment.

Preferred comparison outputs:

- clean stylized pre-render;
- downsampled / pixel-treated version;
- optional selective 2D cleanup / paint-over sample if separately scoped.

Do not destroy or overwrite the clean high-resolution render when creating a stylized derivative.

## 8. Registration and camera constraints

The character's world anchor is the feet/contact point.

Requirements:

- feet remain registered consistently through every frame;
- actor does not drift around the 2D canvas due to changing crop bounds;
- render camera position, lens/orthographic scale and pitch remain fixed for a given approved render profile;
- sword/cloth may extend within the canvas as needed;
- if the subject needs more room, enlarge the fixed master canvas/profile rather than crop different animations differently.

## 9. Rights / provenance requirements

The agreement should grant the project sufficient rights to treat the delivered Akio asset as a long-term production source.

Required contract language should cover:

- perpetual commercial game use;
- right to modify the model, rig, textures and animations;
- right to create unlimited derivative 2D renders / sprite sheets / promotional renders;
- right to create future animations from the rig;
- right to use the character asset and derivatives in game builds, trailers, store pages, marketing and promotional material;
- delivery of all editable source files described above;
- disclosure of any third-party base meshes, textures, mocap, animation libraries, purchased assets, fonts, plugins or AI-generated components used in the work;
- confirmation that any such dependencies permit the intended commercial modification and derivative use.

Preferred outcome for a bespoke Akio commission is assignment of the commissioned asset rights to the client where practical, rather than a narrow license to specific renders.

## 10. What is not a complete delivery

The following by themselves are insufficient:

- only PNG sprite frames;
- only an FBX with no native editable rig source;
- only a posed model with no animation controls;
- only baked videos / turntables;
- source files with missing textures or undisclosed paid dependencies;
- a rig that cannot be legally or technically modified for future Akio animations.