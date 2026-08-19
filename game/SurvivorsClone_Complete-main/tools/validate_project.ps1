param(
    [string]$GodotExe = "godot"
)

$ErrorActionPreference = "Stop"
$ExpectedVersion = "4.7.2.stable.official"
$ExpectedHash = "ed1daf0bf"
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

Write-Host "Oathbound Godot validation"
Write-Host "Project: $ProjectRoot"
Write-Host "Godot:   $GodotExe"

$versionOutput = (& $GodotExe --version 2>&1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0) {
    throw "Could not run Godot executable: $GodotExe"
}

Write-Host "Version: $versionOutput"

if (($versionOutput -notlike "*$ExpectedVersion*") -or ($versionOutput -notlike "*$ExpectedHash*")) {
    throw "Wrong Godot build. Expected v$ExpectedVersion [$ExpectedHash]."
}

Write-Host "`n[1/2] Importing all project resources headlessly..."
& $GodotExe --headless --path $ProjectRoot --import
if ($LASTEXITCODE -ne 0) {
    throw "Godot resource import failed with exit code $LASTEXITCODE."
}

Write-Host "`n[2/2] Starting the project headlessly for a short smoke test..."
& $GodotExe --headless --path $ProjectRoot --quit-after 5
if ($LASTEXITCODE -ne 0) {
    throw "Godot startup smoke test failed with exit code $LASTEXITCODE."
}

Write-Host "`nValidation completed successfully. Manual editor playtesting is still required."
