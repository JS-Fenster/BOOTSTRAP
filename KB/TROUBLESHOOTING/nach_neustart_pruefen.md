# Nach Neustart pruefen - UTF-8 Beta deaktiviert

> Datum: 2026-02-10
> Grund: UTF-8 Beta (Codepage 65001) hat WOT → w4a XML-Verarbeitung kaputt gemacht
> Aenderung: System-Codepage zurueck auf ACP=1252, OEMCP=850

---

## Pruefreihenfolge

### 1. Codepage verifizieren
```powershell
Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage' | Select-Object ACP, OEMCP
```
**Erwartet:** ACP=1252, OEMCP=850

### 2. WOT → w4a XML testen
- Einen Auftrag in WOT exportieren (oder bestehende `C:\Work4all XML\work4all.xml` nutzen)
- Warten bis `work4all_edit.xml` erzeugt wird
- Datei in Editor oeffnen → Umlaute muessen korrekt sein (ue, oe, ae, ss)
- In work4all einlesen → Positionen/Beschreibung pruefen

### 3. Outlook-Kalender testen
- Neuen Kalendertermin erstellen
- Text eingeben: `Pruefung Groesse Uebung Tuer Fenster`
- Speichern, schliessen, wieder oeffnen
- Umlaute muessen erhalten bleiben (kein ? oder Sonderzeichen)

### 4. Claude Code Statusline
- Claude Code oeffnen → Statusleiste unten muss angezeigt werden
- Modell, Prozent, freie Tokens sichtbar

---

## Falls etwas nicht funktioniert

| Problem | Loesung |
|---------|---------|
| Codepage noch 65001 | Neustart war nicht vollstaendig, nochmal neustarten |
| WOT/w4a XML immer noch kaputt | Python-Script (jsDev) neu starten - es erbt alte Codepage |
| Outlook-Umlaute wieder kaputt | Office-Update pruefen, ggf. Option B aus `outlook_umlaute.md` |
| Statusline fehlt | Hat nichts mit Codepage zu tun, separat debuggen |

---

## Wenn alles OK

Diese Datei kann geloescht werden. Doku in `outlook_umlaute.md` wurde aktualisiert.
