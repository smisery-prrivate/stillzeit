# Stillzeit – Konzept

Eine Baby-App, die im Alltag genau eine Sache kann: Stillen tracken, einhändig. Unter der Haube
ist sie so gebaut, dass mehr Tracker, mehrere Kinder, eine Familie mit mehreren Handys und
Exporte nach Excel, Notion oder Drive dazukommen können, ohne das Datenmodell zu brechen.

## Screens (seit v8)
Die App ist ein senkrechter Stapel von sieben Screens (im Kreis: nach dem letzten kommt wieder der erste), alle mit derselben Form (Statuszeile, Liste
nach Tagen, große Buttons unten). Wechsel über zwei Balken ▲/▼ oben und unten (56 px hoch, mit
dem Namen des Nachbar-Screens) oder Wischen nach oben/unten **im Button-Bereich oder auf den
Balken**. Über der Liste wird nicht gewischt, dort wird nur gescrollt (v8 versuchte "am Listenende
wischen", das fühlte sich unzuverlässig an). Der zuletzt offene Screen wird gemerkt.

0. **Geburt** (type `birth`, `note` = Bezeichnung; seit v14): Ereignisse vor und während der
   Geburt mit Zeitpunkt. Ein einziger Button "Ereignis festhalten" (keine fest verdrahteten
   Kategorien auf dem Screen, Pat: Schleimpfropf und Fruchtwasser waren nur Beispiele). Er öffnet
   ein Blatt mit Vorschlägen (Schleimpfropf gelöst, Fruchtwasser abgegangen, Wehen beginnen,
   Blutung, Hebamme angerufen, Losgefahren, In der Klinik, PDA, Presswehen, Geburt), einem
   Freitextfeld und dem Zeitpunkt. Tipp auf einen Vorschlag speichert sofort.
   **Eigene Kategorien entstehen von selbst**: was einmal frei eingetippt wurde, erscheint
   beim nächsten Mal als eigener Vorschlag ganz vorne (violett, häufigste zuerst). Kein
   Wehen-Timer, dafür gibt es eine eigene App. Steht im Stapel über Stillen; Startscreen bleibt
   Stillen. In der Übersicht erscheint eine Zeitleiste, sobald etwas eingetragen ist.
   Der Screen gibt keine medizinischen Hinweise, er hält nur fest.
1. **Stillen** (type `feed`, unten beschrieben)
2. **Windel**: zwei Buttons Urin (`pee`) und Stuhl (`poo`), ein Tipp = ein Eintrag mit Uhrzeit.
   Tageskopf "5 mal · 3 Urin · 2 Stuhl", Farbe nach Anzahl (Bernstein).
3. **Gewicht** (`weight`, value in kg): Button öffnet ein Eingabefeld, Komma erlaubt. Zeile zeigt
   den Wert und die Differenz zur vorigen Messung in Gramm.
4. **Größe** (`height`, value in cm): wie Gewicht, Differenz in cm.
5. **Medizin**: Fieber (`fever`, value in °C), Husten (`cough`, ein Tipp), Notiz (`med`, Freitext).
6. **Übersicht**: eine Karte pro Bereich mit Kurzfassung (letzte 24 h bzw. heute, Ø 7 Tage, zuletzt). Antippen
   klappt die Grafik auf: Stillen = Minuten pro Tag (links/rechts gestapelt, Anzahl als Zahl über
   dem Balken), Windel = Urin/Stuhl gestapelt pro Tag, Gewicht und Größe = Linie über die Zeit,
   Medizin = Fieberkurve mit 38-Grad-Linie und Husten pro Tag. Alles inline-SVG, eine Achse pro
   Grafik, keine Bibliothek, offline.

**Bearbeiten (seit v19, ersetzt "Zeit" aus v14)**: Tipp auf eine Zeile zeigt "Bearbeiten" und
"Löschen". Stillen: Seite, Beginn, Ende, Menge (ml, leer = unbekannt, 0 = nichts gekommen).
Gewicht, Größe, Fieber: Wert und Zeitpunkt. Notiz und Geburt: Text und Zeitpunkt. Windel und
Husten: Zeitpunkt. Prüfungen: nichts in der Zukunft, Ende nach Beginn. Unveränderte Zeitfelder
bleiben sekundengenau (das Feld zeigt nur Minuten).
**Kommentar (seit v21)**: im Bearbeiten-Fenster ein Feld "Kommentar" (bis 500 Zeichen) für
Stillen, Windel, Husten, Gewicht, Größe, Fieber. Er steht klein mit 💬 unter dem Eintrag, wird
im Feld `note` gespeichert (vorhandene Spalte, synct mit, steht im CSV). Bei Notiz und Geburt
ist `note` der Eintrag selbst, dort gibt es kein zweites Feld.
**Beim Start korrigieren (seit v22)**: direkt nach dem Start erscheint über der Liste
"Schon früher angefangen? vor 2 · 5 · 10 · 15 min · Andere · ✕". Ein Tipp verlegt den Beginn
zurück (gerechnet vom Moment des Starts), "Andere" öffnet das Bearbeiten-Fenster. Die Leiste
verschwindet nach einer Wahl, mit ✕ oder beim Stopp.
**Knöpfe (seit v23)**: oben Links und Rechts als große Kreise, darunter in einer zweiten Reihe
"🍼 Flasche" und "💧 Abpumpen" (Pat: "links, rechts in der Zeile und Flasche, Abpumpen und so
weiter"; v22 hatte alle drei in einer Reihe).
**Flasche (seit v22)**: Öffnet Menge (30/60/90/120/150 ml antippen oder eintippen,
0 erlaubt) und Zeitpunkt. Typ `bottle`, `value` + `unit: 'ml'`, kein Timer. Steht in der
Stillen-Liste mit 🍼, zählt im Tageskopf ("4 mal · 2 Flaschen · 1 h gesamt · 180 ml"), in
"Letzte Flasche vor …" und in der Übersicht (Summe heute, eigene Grafik ml pro Tag).
Bearbeiten: Menge, Zeitpunkt, Kommentar. Kein Schema-Update nötig (type ist freier Text).
**Zu spät gestartet**: während das Stillen läuft, steht neben "Verwerfen" der Knopf
"Beginn ändern" (Seite und Beginn).
**Menge beim Stillen (seit v19)**: nach dem Stopp erscheint über der Liste die Leiste
"Wie viel? 0 · 5 · 10 · 20 · 30 · 50 ml · Andere · ✕". Ein Tipp speichert, ✕ oder einfach
weitermachen lässt die Menge leer. Gespeichert als `value` + `unit: 'ml'` (vorhandene Spalten,
kein Schema-Update). Zeilen zeigen "12 min · 20 ml", der Tageskopf und die Übersicht die
ml-Summe, sobald Mengen da sind.

Alles landet im selben Event-Log, wird gleich gesynct und gleich exportiert.

## Bedienregeln Stillen (v1, unverändert in v2)
- Zwei runde Start-Buttons unten im Daumenbereich: **Links** und **Rechts** (Brustseite). Tipp =
  Stoppuhr startet; dann ein einziger dunkler Stopp-Button mit Zeit und Seite. Kein Formular.
  Die Seite, die beim letzten Mal nicht dran war, hat einen Ring als leisen Hinweis.
- Jede Zeile zeigt L oder R; "Letztes Stillen vor x min · links" sagt, welche Seite zuletzt war.
- Läuft die Uhr, zeigt der Button die Zeit und atmet leicht; "Verwerfen" darunter bricht ab.
- Jeder Stopp wird gespeichert, auch nach 2 Sekunden. Im Menü unter "Anzeige" lässt sich einstellen,
  dass Stillen kürzer als X Sekunden ausgeblendet wird (Standard 0 = alles zeigen). Ausgeblendete
  Einträge bleiben in den Daten und im Export. (Die frühere 10-Sekunden-Regel verwirrte beim Ausprobieren.)
- Der laufende Start liegt in localStorage: Bildschirm aus, App zu, Reload, die Uhr läuft weiter.
- Jede Zeile ein Stillen: Start – Ende, Dauer. Neueste oben.
- Zeilen sind nach Tag gruppiert. Die Tageskopfzeile zeigt Anzahl und Gesamtdauer; ihre Farbe
  wird mit der Anzahl kräftiger (Skala 0 bis 16 pro Tag).
- Oben "Letztes Stillen vor x min".
- Tageskopf: "3 mal · 42 min gesamt" (kein "3×", das liest sich wie eine Multiplikation).
- Der Bildschirm bleibt an, solange die App im Vordergrund ist (Screen Wake Lock). Wechselt man in
  eine andere App oder sperrt manuell, gibt das System die Sperre frei.
- Zeile antippen → "Löschen"; Löschen ist ein Tombstone (deleted: true), nie ein echtes Entfernen.
- Menü (⋯ oben rechts): Sicherung als JSON, Export als CSV, Sicherung wiederherstellen.
- **Löschen pro Bereich (seit v13)**: Menü → "Löschen" hat einen roten Button pro Bereich mit
  Anzahl ("Stillen löschen (23)", "Gewicht löschen (4)", ...), der Bereich, in dem man gerade ist,
  steht oben; darunter dunkelrot "Alles löschen". Nach der Rückfrage (in einer Familie mit
  Hinweis, dass es auch beim Partner löscht) immer diese Reihenfolge: komplette JSON-Sicherung
  als Datei in die Downloads, Kopie in der App (die neuesten drei), dann die Einträge des
  Bereichs als Tombstones. Jedes Löschen bekommt einen grünen "↩ ... zurückholen"-Button (die
  letzten fünf), der genau diese Einträge zurückholt, auch beim Partner.
  Bereichs-Löschen betrifft das aktive Kind; "Alles" betrifft alle Einträge.
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
- **Einrichtung als geführter Weg (seit v11)**, immer nur ein Schritt sichtbar:
  1. Nicht angemeldet: E-Mail eingeben, "Anmelde-Link per Mail schicken". Nach dem Klick auf den
     Link öffnet die App das Menü von selbst beim nächsten Schritt.
  2. Angemeldet ohne Familie: Frage "Wer von euch beiden startet?" mit zwei Karten
     "Ich starte" und "Ich wurde eingeladen" (erst dann erscheint das Code-Feld).
  3. In der Familie: grüne Karte "✓ Familie verbunden · 2 Personen verbunden · gleicht sich von
     selbst ab", Button "Partner einladen" teilt einen **Einladungs-Link** (`#join=CODE`). Wer
     den Link öffnet, sieht "Du wurdest eingeladen", meldet sich an und bekommt dann die Frage
     "Einladung in eine Familie · Code … · Beitreten / Nicht beitreten" mit der Zahl der eigenen
     Einträge, die geteilt würden (seit v20; vorher trat das Handy ohne Frage bei und lud seine
     Einträge in die fremde Familie hoch). Der Code steht klein darunter als Rückfall.
  - Kein "Jetzt synchronisieren"-Knopf mehr: der Abgleich läuft automatisch. Wer es eilig hat,
    tippt die Statuszeile unter dem Titel an.
- Status ist sichtbar: Zeile unter "Letztes Stillen" ("✓ Familie synchron · vor 2 min",
  "⏸ Offline", "⚠ Sync fehlgeschlagen") und Details im Menü.
- Einmalige Einrichtung im Supabase-Dashboard: `supabase-schema.sql` im SQL-Editor ausführen und
  die App-URL unter Auth → URL Configuration → Redirect URLs eintragen.

## Sicherheit (seit v16)
- Alles, was über den Familien-Sync, eine Sicherungsdatei oder den gemeinsamen Browser-Speicher kommt, gilt
  als fremd. `side` ist nur `L`, `R` oder leer (`sideOf`), alles andere wird beim Laden, Empfangen, Senden
  und Anzeigen verworfen. Freitext (`note`, Servertexte, Familien-Code) geht nur über `escapeHtml` in die Seite.
- Die Datenbank prüft `side` zusätzlich selbst (`sz_events_side_chk`, siehe `supabase-fix-2.sql`).
- **Content-Security-Policy** im Kopf von `index.html`: es läuft nur das eigene Skript. Die Seite trägt dafür
  den Fingerabdruck (sha256) ihres Skript-Blocks. Stimmt er nicht, startet die App nicht.
- **Anmelde-Link (seit v18, `adoptLink`):** Ein Link mit Tokens gilt als fremd, bis er sich ausweist. Der Server
  muss das Token bestätigen (`/auth/v1/user`), die Adresse kommt aus dieser Antwort. Ohne Rückfrage wird der Link
  nur übernommen, wenn dieses Handy in der letzten Stunde selbst einen Link für genau diese Adresse angefordert
  hat (`stillzeit.linkAsked`, geschrieben beim Tippen auf "Anmelde-Link per Mail schicken") und kein anderes
  Konto angemeldet ist. Sonst fragt die App und nennt die Adresse. Ein angemeldetes anderes Konto wird nie ohne
  diese Bestätigung ersetzt. Gleiches Muster wie Snapdoc (`snapdoc.linkAsked`) und Brain Relieve.
- **Release-Schritte:** Versions-Label in `index.html`, `CACHE` in `sw.js`, Zeile hier unter Versionen, und nach
  jeder Änderung am Skript `node tools/csp-hash.js`. Der Commit-Check `tools/hooks/pre-commit` lehnt einen
  veralteten Fingerabdruck ab (einmal pro Kopie des Repos einschalten: `git config core.hooksPath tools/hooks`).
- Tests liegen in `_preview/tests` (nicht im Repo): `t1-inject.js` prüft die Einschleusung, `t2-smoke.js` alle
  Screens, Sync und die Policy, `t3-signin-link.js` die Anmelde-Links.

## Versionen
- v1 (2026-09-21): Stoppuhr, Einträge, Tagesgruppen mit Farbe, "vor x min", Löschen.
- v2 (2026-09-21): Schema 2 (Event-Log, Kinder, UUIDs, created_by), Menü mit JSON/CSV-Export
  und Import, Back-Button schließt das Menü. Bedienung unverändert.
- v3 (2026-09-22): Familien-Sync über Supabase (Magic Link, Familien-Code, geteilte Kinder und
  Einträge, laufender Timer auf beiden Handys), Sync-Status sichtbar.
- v4 (2026-09-22): klare Fehlermeldung beim Anmelde-Link (Supabase-Mail-Limit, 429).
- v5 (2026-09-22): Start-Buttons Links/Rechts, Seite in Zeilen, Statuszeile und CSV; Ring am Button für die andere Seite.
- v6 (2026-09-22): Links blau, Rechts orange (komplementär, neutral, keine Wertung); unter einer Minute in Sekunden; 10-Sekunden-Regel entfernt; Einstellung "kürzer als X Sekunden ausblenden".
- v7 (2026-09-22): Wake Lock im Vordergrund; Tageskopf "3 mal · 7 min gesamt".
- v8 (2026-09-22): fünf Screens (Stillen, Windel, Gewicht, Größe, Medizin) mit Pfeilen und Wischen.
- v9 (2026-09-22): große Pfeil-Balken; Wischen nur im Button-Bereich und auf den Balken.
- v10 (2026-09-22): Navigation im Kreis; Übersichts-Screen mit Diagrammen.
- v11 (2026-09-24): Familie einrichten als geführter Weg, Einladungs-Link, Personenzahl, kein Sync-Knopf.
- v12 (2026-09-24): Alle Einträge löschen mit automatischer Sicherung und Rückgängig.
- v13 (2026-09-24): Löschen pro Bereich, Rückgängig pro Löschvorgang.
- v14 (2026-10-08): Screen Geburt mit einem Button, Vorschlägen, eigenen Kategorien, Zeitleiste; Zeit korrigieren.
- v15 (2026-10-09): Service Worker löscht nur noch eigene alte Caches (stillzeit-), die Offline-Kopien der anderen Apps auf derselben Adresse bleiben erhalten.
- v16 (2026-10-09): Sicherheit: `side` nur noch L oder R (Anzeige, Sync, Import, gespeicherte Daten), Servertexte
  und Familien-Code werden maskiert, Content-Security-Policy mit Skript-Fingerabdruck, kaputter Einladungs-Link
  stoppt die App nicht mehr. Datenbank-Regel in `supabase-fix-2.sql`.
- v17 (2026-10-09): CSV-Export: Textzellen, die wie eine Formel beginnen (`=`, `+`, `-`, `@`), bekommen ein
  Hochkomma vorangestellt, damit Excel sie als Text liest und nicht ausführt. Zahlen bleiben Zahlen. Die Datei
  beginnt mit der UTF-8-Kennung, damit Excel Umlaute richtig zeigt.
- v18 (2026-10-09): Sicherheit: Ein Anmelde-Link wird nur noch ohne Rückfrage übernommen, wenn dieses Handy ihn in
  der letzten Stunde für genau diese Adresse angefordert hat. Sonst fragt die App und nennt die Adresse. Der Server
  muss jedes Token bestätigen. Vorher konnte ein zugeschickter Link ein Handy in ein fremdes Konto anmelden und
  dessen Einträge in die fremde Familie hochladen.
- v19 (2026-10-23): Bearbeiten für alle Einträge, "Beginn ändern" beim laufenden Stillen, Menge in ml nach dem Stopp.
- v20 (2026-10-23): Einladungs-Link fragt vor dem Beitreten; Code aus dem Link nur A-Z, 0-9, Bindestrich.
- v21 (2026-10-23): Kommentar zu jedem Eintrag (Bearbeiten → Kommentar), sichtbar unter der Zeile.
- v22 (2026-10-25): "Schon früher angefangen?" direkt nach dem Start; Flasche mit Menge.
- v23 (2026-10-25): Abpumpen (Typ `pump`: Seite links/rechts/beide, Menge in ml, Zeit,
  Kommentar; eigene Summe "abgepumpt … ml" im Tageskopf, zählt NICHT als getrunken; eigene Karte
  in der Übersicht). Filter-Chips über der Stillen-Liste: Alle · Brust · Flasche · Abpumpen
  (gemerkt pro Handy). Knöpfe in zwei Reihen.
- v24 (2026-10-26): Übersicht, Karte Stillen mit neuer Zusammenfassung über Mahlzeiten (Brust +
  Flasche, Abpumpen zählt nicht): "Letzte 24 h: 6 Mahlzeiten (5 Brust, 1 Flasche) · 1 h 20 min Stillen",
  darunter nur wenn gemessen "Menge: 310 ml (3 von 6 gemessen) · Ø 103 ml pro Mahlzeit" (Ø nur über die
  gemessenen; "alle 6 gemessen", wenn keine fehlt), dann "Letzte 7 Tage: Ø 7,4 Mahlzeiten pro Tag · Ø 95 ml
  pro Mahlzeit (12 von 52 gemessen)". Beide Fenster rollend ab jetzt, nicht Kalendertag. Nur Flasche in den
  24 h: "2 Mahlzeiten (2 Flaschen)" ohne "0 Brust" und ohne Stillzeit (wie im Tageskopf).
- v25 (2026-10-26): "Claude fragen" auf der Übersicht. Pat wollte KI in der App über sein
  Claude-Abo; ein Abo lässt sich nicht als API an eine eigene App anschließen. Deshalb Weg A:
  Frage + Einträge (Zeitraum 7 Tage / 30 Tage / Alles, Standard 30) als Text, übergeben über das
  Android-Teilen-Menü an die Claude-App (dort antwortet Claude mit dem Abo; ohne Teilen-Menü wird
  kopiert). Kein Server, kein Schlüssel, keine Kosten. Weg B (Antwort direkt in Stillzeit über
  einen API-Schlüssel in einer Supabase Edge Function, pro Frage abgerechnet) ist offen.

- v26 (2026-10-27): Brust- und Flaschenmenge werden nie zusammengezählt (Pat: die Flasche gehört nicht in die Menge).
  Tageskopf: "3 mal · 40 min gesamt · 50 ml · 1 Flasche 90 ml" (die ml direkt nach der Stilldauer sind nur Brust).
  Übersicht-Karte Stillen: eigene Zeilen "Brust: … ml (x von y gemessen) · Ø … ml pro Stillen" und "Flasche: … ml",
  7 Tage: "· Brust Ø … ml (x von y gemessen) · Flasche Ø … ml". Mahlzeiten zählen weiter Brust + Flasche.
- v27 (2026-10-27): eindeutige Wörter, weil "Flasche" allein abgepumpt oder gegeben heißen konnte (Pat).
  Überall "gestillt", "Flasche gegeben", "abgepumpt". Tageskopf: "2 mal · 30 min gesamt · gestillt 50 ml ·
  Flasche gegeben 90 ml · abgepumpt 60 ml". Stillen-Karte: eigene Zeilen "Gestillt: …", "Flasche gegeben: …",
  "Abgepumpt: …" für 24 h (Summen) und 7 Tage (gestillt Ø pro Stillen über die gemessenen, Flasche und
  Abpumpen Ø pro Tag). Abpumpen zählt weiter nicht als Mahlzeit.
- v28 (2026-10-27): Kasten "Letzte 24 Stunden" oben auf dem Stillen-Screen, über den Filtern (Pat: die
  Tagesübersicht dort, wo eingetragen wird; bewusst rollende 24 h statt Kalendertag, damit es zur Übersicht
  passt). Vier Kacheln: Mahlzeiten (Brust · Flaschen), Gestillt (Dauer, darunter ml mit "x von y gemessen"),
  Flasche gegeben (ml, Anzahl), Abgepumpt (ml, Anzahl). Gleiche Regeln wie die Stillen-Karte; zeigt immer alle
  Einträge, unabhängig vom Filter; aktualisiert sich bei jedem Eintrag und jede Minute; versteckt, solange es
  auf dem Screen noch keinen Eintrag gibt. Ein laufendes Stillen zählt erst nach dem Stopp.
- v29 (2026-10-27): übersichtlicher (Pat: zu viel auf einmal, der Kasten zu groß). Stillen-Karte in der
  Übersicht: zwei Blöcke "Letzte 24 Stunden" / "Letzte 7 Tage" mit Überschrift und Trennlinie, eine Zeile pro
  Wert (Bezeichnung links, Wert fett, Details klein). Kasten auf dem Stillen-Screen: eine flache Zeile mit vier
  Zahlen (Mahlzeiten, Gestillt, Flasche gegeben, Abgepumpt), Details ("2 von 5 gemessen" usw.) per Tipp
  aufklappbar, gemerkt pro Handy.
- v30 (2026-10-27): derselbe 24-Stunden-Streifen auf dem Windel-Screen (Pat): Urin (Anzahl), Stuhl (Anzahl),
  Letzte Windel (vor …); Details: jeweils "zuletzt HH:MM". Die Windel-Karte in der Übersicht zählt jetzt
  ebenfalls die letzten 24 h statt "Heute", damit beide Stellen dieselben Zahlen zeigen.

## Ideen (gewünscht, noch offen)
- Sprachbedienung: "Stillen links", "Stopp" per Web Speech API (Android Chrome), wie in Braindump.
