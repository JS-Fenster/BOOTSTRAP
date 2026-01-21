@echo off
setlocal

REM ============================================
REM 1) Git Repos aktualisieren
REM ============================================
echo === Git Repos aktualisieren ===

REM 1a) KB Repo pullen
if exist "C:\Claude_Workspace\KB\.git" (
    echo Pulling KB...
    pushd "C:\Claude_Workspace\KB"
    git pull
    popd
)

REM 1b) Work-Repos pullen
cd /d "C:\Claude_Workspace\WORK\repos"
for /d %%D in (*) do (
    if exist "%%D\.git" (
        echo Pulling %%D...
        pushd "%%D" && git pull && popd
    )
)

:start
REM Claude normal starten - CLAUDE.md wird automatisch gelesen
claude --dangerously-skip-permissions "/boot"

echo.
set /p restart="Claude neu starten? (j/n): "
if /i "%restart%"=="j" goto start