# Outlook Kalender Umlaute Troubleshooting

> Stand: 2026-02-04

---

## Problem

Umlaute (ae, oe, ue, ss) in Outlook-Kalenderterminen werden nach dem Speichern in **Fragezeichen (?)** umgewandelt.

**Beispiel:**
- Eingabe: `Groesse Uebung aeoeuess`
- Nach Speichern: `Gr??e ?bung ????`

---

## Betroffene Konfiguration

| Komponente | Version/Wert | Status |
|------------|--------------|--------|
| **Office Build** | `16.0.19628.20150` | Problem-Version vom 27.01.2026 |
| **Update Channel** | Current Channel | - |
| **Exchange** | Exchange Online | Betroffene Umgebung |
| **Client** | Outlook Classic | Betroffene Umgebung |
| **System-Codepage (ACP)** | 1252 (ANSI) | Nicht UTF-8 |
| **OEM-Codepage** | 850 (DOS) | Alt |

---

## Ursache

Das Office-Update vom **27. Januar 2026** (Build 19628.20150) hat einen Encoding-Bug eingefuehrt:

- Nur **Kalendereintraege** sind betroffen (Mails funktionieren)
- Nur bei **HTML-Format** (Nur-Text funktioniert)
- Microsoft hatte in der gleichen Woche mehrere Encoding-Probleme

---

## Loesungen

### Option A: UTF-8 Beta aktivieren (empfohlen)

1. **Windows-Taste** druecken, `intl.cpl` eintippen, **Enter**
2. Reiter **"Verwaltung"** anklicken
3. Button **"Gebietsschema aendern..."** klicken
4. Haken setzen bei: **Beta: Unicode UTF-8 fuer weltweite Sprachunterstuetzung verwenden**
5. **OK** → **Neustart erforderlich**

**Status:** Angewendet am 2026-02-04, Test nach Neustart ausstehend

---

### Option B: Outlook-Codierung auf UTF-8 setzen

1. **Outlook** oeffnen
2. **Datei** → **Optionen**
3. Links auf **"Erweitert"** klicken
4. Runterscrollen zu **"Internationale Optionen"**
5. Bei **"Bevorzugte Codierung fuer ausgehende Nachrichten"**: **Unicode (UTF-8)** waehlen
6. **OK** klicken

---

### Option C: Office-Rollback

Falls A+B nicht helfen, Rollback auf vorherige Version:

```powershell
# Als Administrator ausfuehren
cd "C:\Program Files\Common Files\Microsoft Shared\ClickToRun"
.\OfficeC2RClient.exe /update user updatetoversion=16.0.19527.20250
```

**Hinweis:** Version 19527.20250 ist die letzte vor dem Bug (ca. 20. Januar 2026).

---

### Option D: Workaround - Nur-Text verwenden

Kalendereintraege als **Nur-Text** statt HTML erstellen:
- Rechtsklick im Textfeld → **Format** → **Nur-Text**

---

## Test nach Aenderungen

1. Neuen Kalender-Termin erstellen
2. Text eingeben: `Pruefung aeoeuess Groesse Uebung`
3. Speichern und wieder oeffnen
4. Pruefen ob Umlaute erhalten bleiben

---

## Diagnose-Befehle

```powershell
# Office-Version pruefen
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' | Select-Object VersionToReport, UpdateChannel

# System-Codepages pruefen (ACP sollte 65001 sein fuer UTF-8)
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage' | Select-Object ACP, OEMCP

# Regionale Einstellungen
Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\International' | Select-Object LocaleName, sLanguage
```

---

## Quellen

- [Borns IT-Blog: Microsoft 365 Umlaut-Probleme](https://borncity.com/blog/2026/02/02/microsoft-365-werden-mails-mit-den-zeichen-ae-geloescht/)
- [Borns IT-Blog: Outlook Umlauteproblem](https://borncity.com/blog/2026/01/26/outlook-for-ios-stuerzt-ab-outlook-umlaute-in-apple-mail/)
- [Administrator.de Forum](https://administrator.de/forum/outlook-umlaute-mail-encoding-676783.html)
- [Microsoft Q&A: Special characters replaced](https://learn.microsoft.com/en-us/answers/questions/2028586/special-characters-replaced-by-question-mark-in-ow)

---

## Changelog

- 2026-02-04: Initiale Dokumentation, UTF-8 Beta aktiviert, Test ausstehend
