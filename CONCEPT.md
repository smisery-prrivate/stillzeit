# Stillzeit – Konzept

Eine Baby-App, die genau eine Sache kann: Stillen tracken, einhändig.

## Regeln (v1)
- Ein großer runder Button unten im Daumenbereich. Tipp = Stoppuhr startet, Tipp = stoppt und
  legt einen Eintrag an. Kein Formular, keine Auswahl.
- Läuft die Uhr, zeigt der Button die Zeit und atmet leicht; "Verwerfen" darunter bricht ab.
- Stopp unter 10 Sekunden gilt als Fehltipp und wird nicht gespeichert.
- Der laufende Start wird in localStorage gehalten: Bildschirm aus, App zu, Reload – die Uhr läuft weiter.
- Jede Zeile ein Stillen: Start – Ende, Dauer. Neueste oben.
- Zeilen sind nach Tag gruppiert. Die Tageskopfzeile zeigt Anzahl und Gesamtdauer; ihre Farbe wird
  mit der Anzahl kräftiger (Skala 0 bis 16 pro Tag). So sieht man ohne Lesen, ob ein Tag 10× oder 15× war.
- Oben eine Zeile "Letztes Stillen vor x min". Das ist die Frage, die man sich am häufigsten stellt.
- Zeile antippen → "Löschen" erscheint; nochmal tippen → verschwindet. Löschen ist ein Tombstone (deleted: true).
- Daten nur lokal (localStorage, Key `stillzeit.v1`). Kein Sync, kein Konto. Kommt erst, wenn ein zweites Gerät real ist.
- Sprache Deutsch, weil die Nutzer Deutsch sprechen.

## Versionen
- v1 (2026-09-21): Stoppuhr, Einträge, Tagesgruppen mit Farbe, "vor x min", Löschen.

## Ideen für später (nur wenn gewünscht)
- Seite links/rechts, Fläschchen, Wickeln, Schlaf: jeweils erst, wenn es beim Benutzen fehlt.
- Export als CSV.
