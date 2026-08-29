@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================================
rem Oathbound clean branch playtester
rem Usage:
rem   oathbound-playtest.cmd main
rem   oathbound-playtest.cmd agent/branch-name
rem
rem Recreates C:\OathboundPlaytest from the exact remote branch, performs the same
rem clean Godot 4.7.2 import/editor-load preflight used by CI, then launches editor.
rem ============================================================================

set "BRANCH=%~1"
set "PLAYTEST_DIR=C:\OathboundPlaytest"

if not defined BRANCH (
    echo.
    echo ERROR: No branch supplied.
    echo Usage: %~nx0 main
    echo.
    exit /b 2
)

git check-ref-format --branch "!BRANCH!" >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Invalid git branch name: !BRANCH!
    echo.
    exit /b 2
)

rem --- Locate repository -------------------------------------------------------
set "REPO_ROOT="
for /f "delims=" %%R in ('git rev-parse --show-toplevel 2^>nul') do (
    if not defined REPO_ROOT set "REPO_ROOT=%%R"
)
if not defined REPO_ROOT (
    pushd "%~dp0" >nul 2>&1
    if not errorlevel 1 (
        for /f "delims=" %%R in ('git rev-parse --show-toplevel 2^>nul') do (
            if not defined REPO_ROOT set "REPO_ROOT=%%R"
        )
        popd
    )
)
if not defined REPO_ROOT (
    echo.
    echo ERROR: Could not find the Oathbound git repository.
    echo Run this command from the repository or from a script stored inside it.
    echo.
    exit /b 3
)

pushd "!REPO_ROOT!" >nul
if errorlevel 1 (
    echo ERROR: Could not enter repository: !REPO_ROOT!
    exit /b 3
)

echo.
echo ============================================================
echo  OATHBOUND PLAYTEST
echo ============================================================
echo Repository : !REPO_ROOT!
echo Branch     : !BRANCH!
echo Playtest   : !PLAYTEST_DIR!
echo.

rem --- Resolve Godot executable -----------------------------------------------
set "GODOT_EXE="
for /f "delims=" %%G in ('git config --local --get oathbound.godotExe 2^>nul') do (
    if not defined GODOT_EXE set "GODOT_EXE=%%G"
)
if defined GODOT_EXE (
    if exist "!GODOT_EXE!" goto :godot_ready
    echo WARNING: Saved Godot executable no longer exists:
    echo          !GODOT_EXE!
    set "GODOT_EXE="
)
for /f "delims=" %%G in ('where godot.exe 2^>nul') do (
    if not defined GODOT_EXE set "GODOT_EXE=%%G"
)
for /f "delims=" %%G in ('where godot4.exe 2^>nul') do (
    if not defined GODOT_EXE set "GODOT_EXE=%%G"
)
if not defined GODOT_EXE (
    echo.
    echo Godot executable is not configured yet.
    echo Paste the full path to Godot 4.7.2. This is saved only in local git config.
    set /p "GODOT_EXE=Godot executable: "
)
if not exist "!GODOT_EXE!" (
    echo.
    echo ERROR: Godot executable was not found:
    echo        !GODOT_EXE!
    echo.
    popd
    exit /b 4
)
git config --local oathbound.godotExe "!GODOT_EXE!"

:godot_ready
echo Godot      : !GODOT_EXE!
echo.

rem --- Fetch exact remote state -----------------------------------------------
echo [1/7] Fetching latest origin...
git fetch --prune origin
if errorlevel 1 goto :git_fail

git show-ref --verify --quiet "refs/remotes/origin/!BRANCH!"
if errorlevel 1 (
    echo.
    echo ERROR: Remote branch does not exist: origin/!BRANCH!
    echo.
    popd
    exit /b 5
)
for /f "delims=" %%H in ('git rev-parse "origin/!BRANCH!"') do set "REMOTE_SHA=%%H"
echo       Remote SHA: !REMOTE_SHA!

rem --- Remove previous disposable worktree -----------------------------------
echo [2/7] Removing previous playtest checkout...
git worktree remove --force "!PLAYTEST_DIR!" >nul 2>&1
if exist "!PLAYTEST_DIR!" rmdir /s /q "!PLAYTEST_DIR!" >nul 2>&1
if exist "!PLAYTEST_DIR!" (
    echo.
    echo ERROR: Could not remove !PLAYTEST_DIR!
    echo Close Godot or File Explorer windows using that folder and run again.
    echo.
    popd
    exit /b 6
)
git worktree prune --expire now >nul 2>&1
if errorlevel 1 goto :git_fail

rem --- Create pristine detached checkout --------------------------------------
echo [3/7] Creating clean checkout from origin/!BRANCH!...
git worktree add --force --detach "!PLAYTEST_DIR!" "origin/!BRANCH!"
if errorlevel 1 goto :git_fail

rem --- Verify exact revision and canonical project ----------------------------
echo [4/7] Verifying checkout...
set "LOCAL_SHA="
for /f "delims=" %%H in ('git -C "!PLAYTEST_DIR!" rev-parse HEAD') do set "LOCAL_SHA=%%H"
if not defined LOCAL_SHA (
    echo ERROR: Could not determine playtest checkout SHA.
    popd
    exit /b 7
)
if /I not "!LOCAL_SHA!"=="!REMOTE_SHA!" (
    echo ERROR: Playtest SHA does not match remote branch.
    echo Remote : !REMOTE_SHA!
    echo Local  : !LOCAL_SHA!
    popd
    exit /b 7
)

set "PROJECT_DIR=!PLAYTEST_DIR!\game\oathbound"
set "PROJECT_FILE=!PROJECT_DIR!\project.godot"
set "IMPORT_LOG=!PLAYTEST_DIR!\playtest_import.log"
set "EDITOR_LOG=!PLAYTEST_DIR!\playtest_editor_check.log"
if not exist "!PROJECT_FILE!" (
    echo ERROR: Canonical Godot project was not found: !PROJECT_FILE!
    popd
    exit /b 8
)
echo       VERIFIED
 echo      Branch : origin/!BRANCH!
echo       SHA    : !LOCAL_SHA!
echo       Project: !PROJECT_FILE!

rem --- Build the fresh import cache before opening the editor -----------------
echo [5/7] Importing project headlessly...
"!GODOT_EXE!" --headless --path "!PROJECT_DIR!" --import > "!IMPORT_LOG!" 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Godot import failed. Full log:
    type "!IMPORT_LOG!"
    popd
    exit /b 9
)

rem --- Re-open headlessly after import and reject unresolved load errors -------
echo [6/7] Verifying clean editor load...
"!GODOT_EXE!" --headless --editor --path "!PROJECT_DIR!" --quit-after 3 > "!EDITOR_LOG!" 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Godot editor-load check failed. Full log:
    type "!EDITOR_LOG!"
    popd
    exit /b 9
)
findstr /C:"SCRIPT ERROR:" /C:"ERROR: Failed loading resource:" /C:"ERROR: Error calling deferred method:" "!EDITOR_LOG!" >nul 2>&1
if not errorlevel 1 (
    echo.
    echo ERROR: Clean editor load still contains a blocking script/resource error.
    echo Log: !EDITOR_LOG!
    type "!EDITOR_LOG!"
    popd
    exit /b 9
)

echo       IMPORT PREFLIGHT PASSED

rem --- Launch exact Godot project ---------------------------------------------
echo [7/7] Launching Godot with explicit project path...
echo.
echo ============================================================
echo  READY TO PLAYTEST
echo  !BRANCH!
echo  !LOCAL_SHA!
echo ============================================================
echo.
start "" "!GODOT_EXE!" --editor --path "!PROJECT_DIR!"
if errorlevel 1 (
    echo ERROR: Windows could not launch Godot.
    popd
    exit /b 9
)

popd
exit /b 0

:git_fail
echo.
echo ERROR: Git operation failed. The playtest project was not launched.
echo.
popd
exit /b 10
