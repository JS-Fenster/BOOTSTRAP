# ============================================
# Claude Code Statusline - Installation Script
# ============================================
# Installiert:
# 1. JetBrainsMono Nerd Font
# 2. statusline.ps1 nach ~/.claude/
# 3. Claude Code settings.json Konfiguration
# 4. Windows Terminal Schriftart-Einstellung
# ============================================

param(
    [switch]$SkipFont,
    [switch]$SkipTerminal
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Claude Code Statusline - Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Pfade
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$claudeDir = "$env:USERPROFILE\.claude"
$statuslineSource = Join-Path $scriptDir "statusline.ps1"
$statuslineDest = Join-Path $claudeDir "statusline.ps1"

# ============================================
# 1. NERD FONT INSTALLATION
# ============================================
if (-not $SkipFont) {
    Write-Host "[1/4] Nerd Font Installation..." -ForegroundColor Yellow

    # Lokale Fonts im Repo?
    $localFontDir = Join-Path $scriptDir "JetBrainsMono"

    if (Test-Path $localFontDir) {
        Write-Host "      Lokale Fonts gefunden, nutze diese..." -ForegroundColor Gray
        $fontDir = $localFontDir
    } else {
        # Download falls nicht lokal vorhanden
        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        $fontZip = "$env:TEMP\JetBrainsMono.zip"
        $fontDir = "$env:TEMP\JetBrainsMono"

        Write-Host "      Downloading JetBrainsMono Nerd Font..." -ForegroundColor Gray
        try {
            Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip -UseBasicParsing
            Write-Host "      Download erfolgreich" -ForegroundColor Green
            Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
        } catch {
            Write-Host "      Download fehlgeschlagen: $_" -ForegroundColor Red
            Write-Host "      Manueller Download: https://www.nerdfonts.com/font-downloads" -ForegroundColor Yellow
            $fontDir = $null
        }
    }

    if ($fontDir -and (Test-Path $fontDir)) {
        # Install fonts
        Write-Host "      Installiere Schriftarten..." -ForegroundColor Gray
        $fonts = Get-ChildItem -Path $fontDir -Filter "*.ttf"

        # Erstelle lokalen Font-Ordner
        $userFontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
        if (-not (Test-Path $userFontDir)) {
            New-Item -ItemType Directory -Path $userFontDir -Force | Out-Null
        }

        foreach ($font in $fonts) {
            $destPath = Join-Path $userFontDir $font.Name
            if (-not (Test-Path $destPath)) {
                Copy-Item $font.FullName $destPath -Force
            }
        }

        # Register fonts in registry (current user)
        $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        foreach ($font in $fonts) {
            $fontName = $font.BaseName
            $fontFile = Join-Path $userFontDir $font.Name
            if (Test-Path $fontFile) {
                Set-ItemProperty -Path $regPath -Name "$fontName (TrueType)" -Value $fontFile -ErrorAction SilentlyContinue
            }
        }

        Write-Host "      Schriftarten installiert (Neustart evtl. erforderlich)" -ForegroundColor Green

        # Cleanup nur bei Download
        if ($fontZip -and (Test-Path $fontZip)) {
            Remove-Item $fontZip -Force -ErrorAction SilentlyContinue
            Remove-Item "$env:TEMP\JetBrainsMono" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
} else {
    Write-Host "[1/4] Nerd Font Installation... UEBERSPRUNGEN" -ForegroundColor DarkGray
}

# ============================================
# 2. STATUSLINE.PS1 KOPIEREN
# ============================================
Write-Host "[2/4] Statusline Script kopieren..." -ForegroundColor Yellow

# Erstelle .claude Ordner falls nicht vorhanden
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    Write-Host "      Ordner erstellt: $claudeDir" -ForegroundColor Gray
}

# Kopiere statusline.ps1
Copy-Item -Path $statuslineSource -Destination $statuslineDest -Force
Write-Host "      Kopiert: $statuslineDest" -ForegroundColor Green

# ============================================
# 3. CLAUDE CODE SETTINGS.JSON
# ============================================
Write-Host "[3/4] Claude Code Konfiguration..." -ForegroundColor Yellow

$claudeSettings = Join-Path $claudeDir "settings.json"
$statuslineCommand = "powershell -NoProfile -ExecutionPolicy Bypass -File $statuslineDest" -replace '\\', '\\'

$settingsContent = @{
    statusLine = @{
        type = "command"
        command = "powershell -NoProfile -ExecutionPolicy Bypass -File $($statuslineDest -replace '\\', '\\\\')"
    }
}

# Merge mit existierenden Settings falls vorhanden
if (Test-Path $claudeSettings) {
    try {
        $existingSettings = Get-Content $claudeSettings -Raw | ConvertFrom-Json
        # Fuege statusLine hinzu/ersetze
        $existingSettings | Add-Member -MemberType NoteProperty -Name "statusLine" -Value $settingsContent.statusLine -Force
        $settingsContent = $existingSettings
        Write-Host "      Bestehende settings.json aktualisiert" -ForegroundColor Gray
    } catch {
        Write-Host "      Neue settings.json wird erstellt" -ForegroundColor Gray
    }
}

$settingsContent | ConvertTo-Json -Depth 10 | Set-Content $claudeSettings -Encoding UTF8
Write-Host "      Konfiguriert: $claudeSettings" -ForegroundColor Green

# ============================================
# 4. WINDOWS TERMINAL SCHRIFTART
# ============================================
if (-not $SkipTerminal) {
    Write-Host "[4/4] Windows Terminal Konfiguration..." -ForegroundColor Yellow

    # Finde Windows Terminal settings.json
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $wtPreviewPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

    $terminalSettings = $null
    if (Test-Path $wtSettingsPath) {
        $terminalSettings = $wtSettingsPath
    } elseif (Test-Path $wtPreviewPath) {
        $terminalSettings = $wtPreviewPath
    }

    if ($terminalSettings) {
        try {
            $wtConfig = Get-Content $terminalSettings -Raw | ConvertFrom-Json

            # Setze Schriftart in defaults
            if (-not $wtConfig.profiles.defaults) {
                $wtConfig.profiles | Add-Member -MemberType NoteProperty -Name "defaults" -Value @{} -Force
            }

            $fontConfig = @{
                face = "JetBrainsMono NF"
            }

            if ($wtConfig.profiles.defaults -is [PSCustomObject]) {
                $wtConfig.profiles.defaults | Add-Member -MemberType NoteProperty -Name "font" -Value $fontConfig -Force
            } else {
                $wtConfig.profiles.defaults = @{ font = $fontConfig }
            }

            $wtConfig | ConvertTo-Json -Depth 20 | Set-Content $terminalSettings -Encoding UTF8
            Write-Host "      Schriftart gesetzt: JetBrainsMono NF" -ForegroundColor Green
        } catch {
            Write-Host "      Fehler beim Aktualisieren: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "      Windows Terminal nicht gefunden" -ForegroundColor DarkGray
    }
} else {
    Write-Host "[4/4] Windows Terminal Konfiguration... UEBERSPRUNGEN" -ForegroundColor DarkGray
}

# ============================================
# FERTIG
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Installation abgeschlossen!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host " Naechste Schritte:" -ForegroundColor Yellow
Write-Host " 1. Windows Terminal neu starten" -ForegroundColor White
Write-Host " 2. Claude Code neu starten" -ForegroundColor White
Write-Host ""
Write-Host " Erwartete Statuszeile:" -ForegroundColor Yellow
Write-Host " [Opus 4.5] [████████████░░░░░░░░] 45% | 120K frei" -ForegroundColor Cyan
Write-Host ""
