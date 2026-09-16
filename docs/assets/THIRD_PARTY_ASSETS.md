# Third-Party Asset Register

This is Oathbound's provenance and intake policy for reusable third-party art used during the stylized-3D migration.

## Rules

- Prefer **CC0 1.0** for raw models, animations, textures, and other files committed to the public repository.
- A placeholder asset is not automatically approved as final Oathbound art.
- The original creator/source remains the licensing authority. A GitHub mirror may be used only as a deterministic machine-readable staging source when the original free download is interactive.
- Every automated binary download must be pinned to an immutable source revision and an expected SHA-256 before it enters `game/oathbound/Art3D/ThirdParty/`.
- `tools/assets/fetch_assets.py` fails closed on a license, path, HTTPS, size, or hash violation.
- Do not commit raw Mixamo files or other assets whose license does not allow redistribution as standalone repository files.
- Runtime gameplay authority never moves into a downloaded visual asset merely because it contains collision, root motion, or animation data.

The machine-readable authority for installed assets is `tools/assets/asset_manifest.json`.

## Current bootstrap assets

### Quaternius Universal Base Characters — Superhero Male reference

- Creator: **Quaternius**
- Official pack: `https://quaternius.com/packs/universalbasecharacters.html`
- Official free download: `https://quaternius.itch.io/universal-base-characters`
- License: **CC0 1.0 Universal**
- Intended Oathbound use: neutral humanoid mesh/skeleton reference for the Akio/Swordsman placeholder pipeline; **not final Akio art**.
- Upstream free Standard package SHA-256: `fdbf1804c90dfc1ea03e992bff7da2dfd1a79318e13270a660180f9308455f40`
- Machine-readable staging copy: `Seyamalam/blood-league-kickoff` pinned at commit `aa02a4e6d8337a0604d2da131bcbbeb1f01badf0`
- Staged GLB SHA-256: `a466828c67a4acc9b2413212ce6d9cde235e3aed9b675680c14fd9673858f118`
- Oathbound destination: `game/oathbound/Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb`
- Staging modifications documented upstream: converted/optimized from the official free Standard source while preserving the Quaternius humanoid skeleton; textures were normalized for runtime use.

The official Quaternius pack is the source/licensing authority. The staging repository is used only because its already-audited GLB is directly fetchable and hash-verifiable in automation.

### Quaternius Universal Animation Library — Standard no-root-motion reference

- Creator: **Quaternius** (with animation contributions credited by Quaternius upstream)
- Official pack: `https://quaternius.com/packs/universalanimationlibrary.html`
- Official free download: `https://quaternius.itch.io/universal-animation-library`
- License: **CC0 1.0 Universal**
- Intended Oathbound use: shared humanoid locomotion/reaction/combat placeholder source for retargeting and clip evaluation. Oathbound's combat runtime remains authoritative for timing and movement.
- Upstream free Standard package SHA-256: `cc73fc4e495b82958207316596317a3f40b9fa38065bde1027937452da537724`
- Machine-readable staging copy: `Seyamalam/blood-league-kickoff` pinned at commit `aa02a4e6d8337a0604d2da131bcbbeb1f01badf0`
- Staged GLB SHA-256: `4c748767741a3e495d89667b9a218b690ba9810b9517a12e960780e3ca72c4e9`
- Oathbound destination: `game/oathbound/Art3D/ThirdParty/Quaternius/UniversalAnimationLibrary/universal_animation_library.glb`
- Staging modifications documented upstream: no-root-motion free Standard clips were deduplicated/pruned/losslessly resampled while retaining the compatible Quaternius skeleton.

## Planned free asset sources

These sources are approved for evaluation but are **not installed until a specific asset is selected, pinned, and recorded in the manifest**:

- Quaternius CC0 modular outfits, animals, ruins, village, nature, and prop packs.
- Kenney CC0 3D kits for temporary rocks, trees, structures, and generic props where their style can be brought under Oathbound's material treatment.
- Poly Haven CC0 models/textures through its public API. Photorealistic materials must be deliberately flattened/stylized rather than used unchanged.
- Other public CC0 assets only after source/license/provenance verification.

## Placeholder-to-production rule

Downloaded assets are raw ingredients. Oathbound should unify them through:

1. the fixed illustrated three-quarter camera;
2. Oathbound-specific silhouette/costume kitbashing;
3. controlled palette and hand-painted/value-focused materials;
4. restrained specular/PBR response;
5. painterly/toon lighting and selective outlines/rim accents;
6. animation retargeting with gameplay-owned timing;
7. final replacement by bespoke/AI-assisted/commissioned art where identity requires it.

The purpose of the free cast is to produce a **credible visual test**, not to make Oathbound look like an asset-pack demo.
