# Claude Code Statusline - Block Style

Benutzerdefinierte Statusleiste fuer Claude Code mit Block-Fortschrittsbalken.

## Vorschau

```
[Opus 4.5] [████████████░░░░░░░░] 45% | 120K frei
```

**Farben:**
- Gruen: < 50% (gut)
- Cyan: 50-70% (halb voll)
- Gelb: 70-85% (Warnung)
- Rot + [!]: > 85% (kritisch)

## Quick Install

```powershell
# In PowerShell als Admin ausfuehren:
cd C:\Claude_Workspace\BOOTSTRAP\setup\claude-statusline
.\install.ps1
```

## Manuelle Installation

### 1. Nerd Font installieren

Download: [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip)

1. ZIP entpacken
2. Alle `.ttf` Dateien auswaehlen
3. Rechtsklick → "Fuer alle Benutzer installieren"

### 2. Statusline Script kopieren

```powershell
Copy-Item statusline.ps1 "$env:USERPROFILE\.claude\statusline.ps1"
```

### 3. Claude Code konfigurieren

Datei: `%USERPROFILE%\.claude\settings.json`

```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -ExecutionPolicy Bypass -File C:\\Users\\DEIN_USER\\.claude\\statusline.ps1"
  }
}
```

### 4. Windows Terminal Schriftart

Einstellungen → Profile → Standardwerte → Darstellung → Schriftart:
**JetBrainsMono Nerd Font**

Oder in `settings.json`:

```json
{
  "profiles": {
    "defaults": {
      "font": {
        "face": "JetBrainsMono Nerd Font"
      }
    }
  }
}
```

## Optionen

```powershell
# Ohne Font-Installation (falls schon installiert):
.\install.ps1 -SkipFont

# Ohne Terminal-Konfiguration:
.\install.ps1 -SkipTerminal
```

## Anpassungen

In `statusline.ps1`:

| Variable | Beschreibung | Standard |
|----------|--------------|----------|
| `$BASE_OVERHEAD_TOKENS` | System-Overhead abziehen | 35000 |
| `$barSize` | Balkenlaenge in Zeichen | 20 |

---

*Version: 1.0 | 2026-01-26*
