#!/usr/bin/env python3
"""Fast static guard for Oathbound final-integration readiness boundaries."""

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
        raise AssertionError(f"{label}: retired Technique-slot language returned: {needle!r}")


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

    retired_phrases = (
        "five direct Technique slots",
        "five direct slots",
        "direct-slot",
        "same-slot replacement",
        "direct slotted Techniques",
        "25 direct slotted Techniques",
        "rare same-slot replacement",
    )
    for label, text in (("ASSET_INVENTORY", asset), ("MILESTONE_04", milestone)):
        for phrase in retired_phrases:
            forbid(text, phrase, label)

    require(asset, "Unlimited run-owned collection", "ASSET_INVENTORY")
    require(asset, "five action-trigger classifications", "ASSET_INVENTORY")
    require(milestone, "unlimited additive ownership", "MILESTONE_04")
    require(milestone, "trigger labels, not equipment slots", "MILESTONE_04")
    require(ui, "no global Technique inventory cap", "TECHNIQUE_REWARDS")
    require(ui, "trigger classifications, not Technique slots", "TECHNIQUE_REWARDS")
    require(vfx, "not Technique slots", "TECHNIQUE_VFX")
    require(vfx, "Multiple owned Techniques may respond to the same action", "TECHNIQUE_VFX")

    # Heart combat remains deliberately unauthored. Contract tests may drive the
    # downstream completion signal, but a normal gameplay shell must reject it.
    require(heart, "func complete_for_contract_test()", "HeartEncounterShell")
    require(heart, 'get_meta("contract_test", false)', "HeartEncounterShell")
    require(heart, "contract completion rejected outside test mode", "HeartEncounterShell")
    require(endgame_smoke, "Normal Heart shell accepted the contract-only completion shortcut", "EndgameCampaignContractSmoke")
    require(endgame_smoke, 'set_meta("contract_test", true)', "EndgameCampaignContractSmoke")

    # The release wrapper may still recognize base-menu implementation sentinels, but
    # those internal strings must be replaced before reaching the player.
    require(front_end, 'LOCALIZATION.ui("front_end.build_label", "Development Build")', "OathboundFrontEnd")
    require(front_end, 'LOCALIZATION.ui("front_end.settings.subtitle", "Audio, accessibility, readability, and input.")', "OathboundFrontEnd")
    require(front_end, 'LOCALIZATION.ui("front_end.credits.subtitle", "Credits and acknowledgements")', "OathboundFrontEnd")
    require(front_end, "Credits, licenses, and third-party notices are being finalized for release.", "OathboundFrontEnd")

    # Final art milestone says major placeholder art must be gone, but external asset
    # provenance is not allowed to disappear from the release checklist just to make a
    # readiness check look green. Known unresolved evidence stays explicit until solved.
    require(milestone_7, "no major placeholder art remains", "MILESTONE_07")
    blocker_count = attribution.count("**Release status:** BLOCKED")
    if blocker_count < 5:
        raise AssertionError(
            "RELEASE_ATTRIBUTION_AUDIT: expected the known font/music/GUI/SFX/texture blocker sections to remain explicit"
        )
    for path in (
        "game/oathbound/Font/tenderness.otf",
        "game/oathbound/Audio/Music/battleThemeA.mp3",
        "game/oathbound/Audio/GUI/click.wav",
        "game/oathbound/Audio/GUI/hover.wav",
        "game/oathbound/Textures/hub.png",
    ):
        require(attribution, path, "RELEASE_ATTRIBUTION_AUDIT")

    print(
        "[FinalIntegrationReadiness] PASS - slotless Technique production aligned | "
        "Heart completion test-only | player-facing front end clean | attribution blockers explicit"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"[FinalIntegrationReadiness] FAIL - {exc}", file=sys.stderr)
        raise SystemExit(1)
