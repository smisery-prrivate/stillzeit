# Stillzeit – Konzept

Eine Baby-App, die im Alltag genau eine Sache kann: Stillen tracken, einhändig. Unter der Haube
ist sie so gebaut, dass mehr Tracker, mehrere Kinder, eine Familie mit mehreren Handys und
Exporte nach Excel, Notion oder Drive dazukommen können, ohne das Datenmodell zu brechen.

## Bedienregeln (v1, unverändert in v2)
- Zwei runde Start-Buttons unten im Daumenbereich: **Links** und **Rechts** (Brustseite). Tipp =
  Stoppuhr startet; dann ein einziger dunkler Stopp-Button mit Zeit und Seite. Kein Formular.
  Die Seite, die beim letzten Mal nicht dran war, hat einen Ring als leisen Hinweis.
- Jede Zeile zeigt L oder R; "Letztes Stillen vor x min · links" sagt, welche Seite zuletzt war.
- Läuft die Uhr, zeigt der Button die Zeit und atmet leicht; "Verwerfen" darunter bricht ab.
- Stopp unter 10 Sekunden gilt als Fehltipp und wird nicht gespeichert.
- Der laufende Start liegt in localStorage: Bildschirm aus, App zu, Reload, die Uhr läuft weiter.
- Jede Zeile ein Stillen: Start – Ende, Dauer. Neueste oben.
- Zeilen sind nach Tag gruppiert. Die Tageskopfzeile zeigt Anzahl und Gesamtdauer; ihre Farbe
  wird mit der Anzahl kräftiger (Skala 0 bis 16 pro Tag).
- Oben "Letztes Stillen vor x min".
- Zeile antippen → "Löschen"; Löschen ist ein Tombstone (deleted: true), nie ein echtes Entfernen.
- Menü (⋯ oben rechts): Sicherung als JSON, Export als CSV, Sicherung wiederherstellen.
- Sprache Deutsch, weil die Nutzer Deutsch sprechen.

## Datenmodell (Schema 2, seit v2)
Ein einziges Objekt in localStorage unter `stillzeit.db`:

```
db = {
  schema: 2,
  device_id,                 // dieses Handy; später created_by pro Eintrag
  active_child,              // id des Kindes, für das der Button gerade zählt
  children: [ { id, name, born?, created_at, updated_at } ],
  events:   [ { id, type, child_id, start, end?, value?, unit?, note?,
                created_by, created_at, updated_at, deleted? } ]
}
```

- **Ein flaches Ereignis-Log.** Alles, was je getrackt wird, ist ein `event` mit einem `type`.
  Heute gibt es nur `feed` (start + end). Geplante Typen brauchen keine Schemaänderung:
  - `weight`, `height`, `head`: `start` = Messzeitpunkt, `value` + `unit` (kg, cm)
  - `sleep`: `start` + `end`
  - `diaper`, `medication`, `note`: `start`, optional `note`
  - Seite links/rechts beim Stillen: `note` oder ein Feld `side`; Felder dürfen dazukommen,
    alte Einträge bleiben gültig (fehlendes Feld = unbekannt).
- **IDs sind UUIDs**, nicht Zeitstempel, damit zwei Handys nie kollidieren.
- **`updated_at` auf jedem Eintrag + Tombstones** statt Löschen: damit ist "neuester gewinnt"
  als Sync-Regel bereits eingebaut. Die zentrale `save()` stempelt jede geänderte Zeile.
- **`child_id` auf jedem Eintrag** und `children[]`: mehrere Kinder sind nur ein Umschalter
  oben, der `active_child` setzt. Die Anzeige filtert schon heute nach `active_child`.
- **`created_by`** (heute = device_id): wird bei Familien-Sync zur Nutzer-ID.
- Alte v1-Daten (`stillzeit.v1`) werden beim ersten Start automatisch migriert.

## Wege, die offen bleiben (und wie sie gehen)
- **Mehr Tracker:** neuer `type`, ein zweiter Button oder ein Menüpunkt, eine Zeilen-Darstellung
  pro Typ. Datenspeicher und Export ändern sich nicht.
- **Mehrere Kinder:** Kind anlegen in `children`, Umschalter im Header, fertig.
- **Familie / mehrere Handys:** Supabase mit Magic Link, wie im PWA-Playbook. Tabellen
  `households`, `children`, `events` mit denselben Feldern wie hier; Row Level Security auf
  `household_id`. Sync = Upsert nach `updated_at`, Tombstones werden mitgesynct.
  Der Client läuft ohne Backend weiter (local-first).
- **Excel mit mehreren Sheets und Diagrammen:** Der JSON-Export ist die Quelle. Ein Sheet pro
  `type` (Stillen, Gewicht, ...), ein Sheet "Tage" mit Anzahl und Minuten pro Tag, Diagramme
  darauf. Kann als kleiner Python-Schritt oder direkt in der App (SheetJS) laufen.
- **Notion / Google Drive:** Adapter, die dasselbe Event-Log lesen. Drive: die JSON-Sicherung
  regelmäßig hochladen. Notion: eine Datenbank mit den Event-Feldern, `id` als Schlüssel für
  Upserts. Beides ist Export, nicht Wahrheit; die Wahrheit bleibt das lokale Log bzw. Supabase.

## Familie und Sync (seit v3)
- Local-first bleibt: ohne Anmeldung läuft alles wie vorher, nur auf diesem Handy.
- Anmeldung per Magic Link (E-Mail), kein Passwort. Supabase-Projekt wird mit Brain Relieve
  geteilt, alle Tabellen tragen das Präfix `sz_` (Schema in `supabase-schema.sql`).
- Eine **Familie** (`sz_households`) hat einen Code wie `3F9A-B21C`. Wer angemeldet ist, legt
  eine Familie an oder tritt mit dem Code bei. Mitglieder (`sz_members`) sehen und schreiben
  dieselben Kinder und Einträge; Row Level Security prüft die Mitgliedschaft.
- Zweites Handy mit **derselben** E-Mail: findet die Familie automatisch (Mitgliedschaft wird
  beim Start nachgeschlagen).
- **Laufendes Stillen ist ein Eintrag ohne `end`.** Dadurch sieht der Partner den laufenden
  Timer und kann ihn auch stoppen. Der alte `stillzeit.running`-Key wurde beim Update migriert.
- Beim Beitritt werden lokale Einträge auf das Kind der Familie umgehängt, wenn das Handy
  vorher nur das Standardkind "Baby" hatte, und alle lokalen Zeilen auf "jetzt" gestempelt,
  damit sie über jeden fremden Sync-Cursor steigen.
- Sync-Schleife wie im Playbook: pull `updated_at > cursor`, merge (neuester gewinnt), push
  lokale Zeilen `updated_at > cursor` als Upsert, Cursor pro Familie. Läuft nach jedem Speichern
  (1,2 s Debounce), beim Start, jede Minute, beim Aufwachen des Handys, beim Online-Gehen.
- Status ist sichtbar: Zeile unter "Letztes Stillen" ("✓ Familie synchron · vor 2 min",
  "⏸ Offline", "⚠ Sync fehlgeschlagen") und Details im Menü.
- Einmalige Einrichtung im Supabase-Dashboard: `supabase-schema.sql` im SQL-Editor ausführen und
  die App-URL unter Auth → URL Configuration → Redirect URLs eintragen.

## Versionen
- v1 (2026-09-21): Stoppuhr, Einträge, Tagesgruppen mit Farbe, "vor x min", Löschen.
- v2 (2026-09-21): Schema 2 (Event-Log, Kinder, UUIDs, created_by), Menü mit JSON/CSV-Export
  und Import, Back-Button schließt das Menü. Bedienung unverändert.
- v3 (2026-09-22): Familien-Sync über Supabase (Magic Link, Familien-Code, geteilte Kinder und
  Einträge, laufender Timer auf beiden Handys), Sync-Status sichtbar.
- v4 (2026-09-22): klare Fehlermeldung beim Anmelde-Link (Supabase-Mail-Limit, 429).
- v5 (2026-09-22): Start-Buttons Links/Rechts, Seite in Zeilen, Statuszeile und CSV; Ring am Button für die andere Seite.

## Ideen (gewünscht, noch offen)
- Sprachbedienung: "Stillen links", "Stopp" per Web Speech API (Android Chrome), wie in Braindump.
