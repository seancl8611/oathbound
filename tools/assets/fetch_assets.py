#!/usr/bin/env python3
"""Deterministic third-party asset intake for Oathbound.

Only manifest-listed HTTPS assets with an allowed license and destination are accepted.
Downloads are written atomically and SHA-256 verified before they enter Art3D.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import tempfile
import urllib.request

USER_AGENT = "Oathbound-Asset-Intake/1.0"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def safe_destination(repo_root: Path, relative: str, prefixes: list[str]) -> Path:
    normalized = relative.replace("\\", "/")
    if normalized.startswith("/") or ".." in Path(normalized).parts:
        raise ValueError(f"unsafe destination: {relative}")
    if not any(normalized.startswith(prefix) for prefix in prefixes):
        raise ValueError(f"destination outside approved prefixes: {relative}")
    destination = (repo_root / normalized).resolve()
    if repo_root.resolve() not in destination.parents:
        raise ValueError(f"destination escapes repository: {relative}")
    return destination


def download(url: str, destination: Path, expected_sha: str, max_bytes: int) -> dict:
    if not url.startswith("https://"):
        raise ValueError(f"only HTTPS sources are allowed: {url}")

    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    destination.parent.mkdir(parents=True, exist_ok=True)

    with tempfile.NamedTemporaryFile(delete=False, dir=destination.parent, suffix=".part") as temp:
        temp_path = Path(temp.name)
        digest = hashlib.sha256()
        total = 0
        try:
            with urllib.request.urlopen(request, timeout=90) as response:
                while True:
                    chunk = response.read(1024 * 1024)
                    if not chunk:
                        break
                    total += len(chunk)
                    if total > max_bytes:
                        raise RuntimeError(f"download exceeded manifest size limit: {url}")
                    digest.update(chunk)
                    temp.write(chunk)
        except Exception:
            temp_path.unlink(missing_ok=True)
            raise

    actual_sha = digest.hexdigest()
    if actual_sha.lower() != expected_sha.lower():
        temp_path.unlink(missing_ok=True)
        raise RuntimeError(
            f"SHA-256 mismatch for {url}: expected {expected_sha}, got {actual_sha}"
        )

    os.replace(temp_path, destination)
    return {"bytes": total, "sha256": actual_sha}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", default="tools/assets/asset_manifest.json")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--report", default="")
    parser.add_argument("--check", action="store_true", help="verify installed assets without downloading")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    manifest_path = (repo_root / args.manifest).resolve()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    policy = manifest["policy"]
    allowed_licenses = set(policy["allowed_licenses"])
    allowed_prefixes = list(policy["allowed_destination_prefixes"])
    max_bytes = int(float(policy.get("max_asset_mb", 32)) * 1024 * 1024)

    report = {"schema_version": 1, "assets": []}
    failures: list[str] = []

    for asset in manifest.get("assets", []):
        if not asset.get("enabled", True):
            continue
        asset_id = str(asset["id"])
        license_id = str(asset["license"])
        expected_sha = str(asset.get("sha256", "")).lower()
        if license_id not in allowed_licenses:
            failures.append(f"{asset_id}: license {license_id} is not approved")
            continue
        if len(expected_sha) != 64 or any(c not in "0123456789abcdef" for c in expected_sha):
            failures.append(f"{asset_id}: valid SHA-256 is required")
            continue

        try:
            destination = safe_destination(repo_root, str(asset["destination"]), allowed_prefixes)
            existing_sha = sha256_file(destination) if destination.exists() else ""
            if existing_sha == expected_sha:
                status = "verified"
                result = {"bytes": destination.stat().st_size, "sha256": existing_sha}
            elif args.check:
                raise RuntimeError(
                    "asset missing" if not destination.exists() else f"installed SHA mismatch ({existing_sha})"
                )
            else:
                result = download(str(asset["url"]), destination, expected_sha, max_bytes)
                status = "installed"
            report["assets"].append(
                {
                    "id": asset_id,
                    "status": status,
                    "destination": str(asset["destination"]),
                    **result,
                }
            )
            print(f"[asset-intake] {asset_id}: {status} -> {asset['destination']}")
        except Exception as exc:
            failures.append(f"{asset_id}: {exc}")

    report["ok"] = not failures
    report["failures"] = failures
    if args.report:
        Path(args.report).write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

    if failures:
        for failure in failures:
            print(f"[asset-intake] ERROR: {failure}")
        return 1

    print(f"[asset-intake] PASS: {len(report['assets'])} asset(s) verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
