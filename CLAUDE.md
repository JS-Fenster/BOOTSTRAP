# Claude Code Bootstrap

> Startpunkt fuer jede Claude Code Session auf diesem Rechner.

---

## Globale Regeln

| Bereich | Regel |
|---------|-------|
| **Name** | Andreas Stolarczyk |
| **Ansprache** | Mit Vornamen (Andreas) |
| **Sprache** | Deutsch (Konversation), Englisch (Code) |
| **Umlaute** | UI-Texte: erlaubt | Code: ASCII-only (ae/oe/ue/ss) |
| **Aenderungen** | Nur nach expliziter Aufforderung |
| **Changelogs** | In Git-History, NICHT in CLAUDE.md |
| **Entscheidungen** | Selbststaendig treffen wenn moeglich |
| **Rueckfragen** | Bei Unklarheiten immer nachfragen |
| **Git Commits** | IMMER committen wenn Aenderungen funktionieren (fuer Rollback) |
| **Report-Dateien** | KEINE erstellen - Info gehoert in Git-Commits |

---

## Projekte

| Projekt | CLAUDE.md | Beschreibung |
|---------|-----------|--------------|
| **erp-system-vite** | `WORK/repos/erp-system-vite/CLAUDE.md` | ERP Frontend (W4A-Ersatz), React + Supabase |
| **Auftragsmanagement** | `WORK/repos/Auftragsmanagement/CLAUDE.md` | Web-App Auftragsverwaltung |
| **KI_Automation** | `WORK/repos/KI_Automation/CLAUDE.md` | Shared Libs, Tools, DB-Docs |
| **JS_Prozesse** | `WORK/repos/JS_Prozesse/CLAUDE.md` | Ideen (90), Prozess-Analysen (17) |

---

## Uebergreifendes Wissen

| Thema | Datei |
|-------|-------|
| Code-Standards | `KB/STANDARDS/code_standards.md` |
| ERP-Datenbank (SQL Schema) | `WORK/repos/KI_Automation/docs/ERP_Datenbank.md` |
| KI-News & Releases | `KB/REFERENCE/KI_Wissen.md` |
| Server-Infrastruktur | `WORK/repos/KI_Automation/docs/Server_Infrastruktur.md` |

---

## Session-Start (/boot)

1. **Diese Datei laden** (globale Regeln)
2. **User fragen:** Welches Projekt?
3. **Projekt-CLAUDE.md laden** (aus Tabelle oben)
4. **PLAN.md lesen** (falls vorhanden)
5. **Loslegen**

---

## VERBOTEN

| Verhalten | Stattdessen |
|-----------|-------------|
| Automatisch CLAUDE.md erstellen | Nur bestehende lesen |
| Codebase-Scan ohne Auftrag | Auf User-Anweisung warten |
| Absolute Pfade in Docs | Relative Pfade nutzen |
| Credentials in versionierte Docs | .env oder Secrets-Manager |

---

## Rechner-Erkennung

| Computername | Kontext |
|--------------|---------|
| JS-FENSTER | Arbeit |
| PC003 | Arbeit |
| LAPTOP_STOLIS1 | Privat |

---

*Bootstrap-Version: 2026-01-14*
