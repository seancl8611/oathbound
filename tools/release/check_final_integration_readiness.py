#!/usr/bin/env python3
"""Fast static guard for Oathbound's current final-integration boundaries."""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]

ASSET = ROOT / "docs/art_production/ASSET_INVENTORY.md"
MILESTONE = ROOT / "docs/art_production/milestones/MILESTONE_04.md"
UI = ROOT / "docs/ui_ux/TECHNIQUE_REWARDS.md"
VFX = ROOT / "docs/art_production/TECHNIQUE_VFX.md"
HEART = ROOT / "game/oathbound/Core/Endgame/HeartEncounterShell.gd"
ENDGAME_SMOKE = ROOT / "game/oathbound/Core/Endgame/Validation/EndgameCampaignContractSmoke.gd"
FRONT_END = ROOT / "game/oathbound/TitleScreen/OathboundFrontEnd.gd"
ATTRIBUTION = ROOT / "docs/external/RELEASE_ATTRIBUTION_AUDIT.md"
MILESTONE_7 = ROOT / "docs/art_production/milestones/MILESTONE_07.md"


def read(path: Path) -> str:
    if not path.is_file():
        raise AssertionError(f"missing required readiness authority: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def require(text: str, needle: str, label: str) -> None:
    if needle.casefold() not in text.casefold():
        raise AssertionError(f"{label}: missing required contract text: {needle!r}")


def forbid(text: str, needle: str, label: str) -> None:
    if needle.casefold() in text.casefold():
        raise AssertionError(f"{label}: retired contract text returned: {needle!r}")


def main() -> int:
    asset = read(ASSET)
    milestone = read(MILESTONE)
    ui = read(UI)
    vfx = read(VFX)
    heart = read(HEART)
    endgame_smoke = read(ENDGAME_SMOKE)
    front_end = read(FRONT_END)
    attribution = read(ATTRIBUTION)
    milestone_7 = read(MILESTONE_7)

    # Current Technique production is additive and uses only the shared triggers that
    # still exist across the supported Combat V2 kits. Do not restore retired trigger
    # families merely to satisfy historical counts/checks.
    for label, text in (
        ("ASSET_INVENTORY", asset),
        ("MILESTONE_04", milestone),
        ("TECHNIQUE_REWARDS", ui),
        ("TECHNIQUE_VFX", vfx),
    ):
        for phrase in (
            "five action-trigger classifications",
            "Parry / Counter, and Deathblow",
            "five direct Technique slots",
            "same-slot replacement",
            "50 actual Techniques plus 10 refinements",
        ):
            forbid(text, phrase, label)

    require(asset, "40 Techniques + 6 refinements", "ASSET_INVENTORY")
    require(asset, "Basic Attack, Held Attack, and Dash / Dash Attack", "ASSET_INVENTORY")
    require(milestone, "unlimited additive ownership", "MILESTONE_04")
    require(milestone, "trigger labels, not equipment slots", "MILESTONE_04")
    require(ui, "no global Technique inventory cap", "TECHNIQUE_REWARDS")
    require(ui, "trigger classifications, not Technique slots", "TECHNIQUE_REWARDS")
    require(vfx, "40 Techniques + 6 refinements", "TECHNIQUE_VFX")
    require(vfx, "Basic Attack", "TECHNIQUE_VFX")
    require(vfx, "Held Attack", "TECHNIQUE_VFX")
    require(vfx, "Dash / Dash Attack", "TECHNIQUE_VFX")

    # Heart combat remains deliberately unauthored. Contract tests may drive the
    # downstream completion signal, but a normal gameplay shell must reject it.
    require(heart, "func complete_for_contract_test()", "HeartEncounterShell")
    require(heart, 'get_meta("contract_test", false)', "HeartEncounterShell")
    require(heart, "contract completion rejected outside test mode", "HeartEncounterShell")
    require(endgame_smoke, "Normal Heart shell accepted the contract-only completion shortcut", "EndgameCampaignContractSmoke")
    require(endgame_smoke, 'set_meta("contract_test", true)', "EndgameCampaignContractSmoke")

    # Player-facing release strings must remain localized/clean.
    require(front_end, 'LOCALIZATION.ui("front_end.build_label", "Development Build")', "OathboundFrontEnd")
    require(front_end, 'LOCALIZATION.ui("front_end.settings.subtitle", "Audio, accessibility, readability, and input.")', "OathboundFrontEnd")
    require(front_end, 'LOCALIZATION.ui("front_end.credits.subtitle", "Credits and acknowledgements")', "OathboundFrontEnd")
    require(front_end, "Credits, licenses, and third-party notices are being finalized for release.", "OathboundFrontEnd")

    require(milestone_7, "no major placeholder art remains", "MILESTONE_07")
    blocker_count = attribution.count("**Release status:** BLOCKED")
    if blocker_count < 5:
        raise AssertionError("RELEASE_ATTRIBUTION_AUDIT: known release provenance blockers must remain explicit")
    for path in (
        "game/oathbound/Font/tenderness.otf",
        "game/oathbound/Audio/Music/battleThemeA.mp3",
        "game/oathbound/Audio/GUI/click.wav",
        "game/oathbound/Audio/GUI/hover.wav",
        "game/oathbound/Textures/hub.png",
    ):
        require(attribution, path, "RELEASE_ATTRIBUTION_AUDIT")

    print(
        "[FinalIntegrationReadiness] PASS - current Technique production aligned | "
        "Heart completion test-only | player-facing front end clean | attribution blockers explicit"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"[FinalIntegrationReadiness] FAIL - {exc}", file=sys.stderr)
        raise SystemExit(1)
