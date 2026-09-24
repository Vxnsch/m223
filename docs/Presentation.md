# Abschlusspräsentation 4RCHIVE

## Demo-Reihenfolge

1. Registrierung mit absichtlich falscher Passwortbestätigung zeigen.
2. Erfolgreich registrieren und einloggen.
3. Im Archiv nach einem Kleidungsstück suchen und die Detailseite öffnen.
4. Als normaler Benutzer zeigen, dass keine Schreibfunktionen sichtbar sind.
5. Als Uploader eine Page mit Beschreibung, Datum, Link und Bild erstellen.
6. Als Admin eine Rolle ändern, das Aktivitätsprotokoll öffnen und eine Page
   löschen.
7. `bin/rails test` ausführen und das grüne Ergebnis zeigen.

## Mögliche Multiple-Choice-Fragen

Richtige Antwort jeweils mit `*`.

1. Wo liegt das Passwort in der Datenbank?
   - Im Klartext in `password`
   - *Als BCrypt-Hash in `password_digest`*
   - In der Session
   - Im Cookie

2. Was speichert die Session nach dem Login?
   - E-Mail und Passwort
   - *Die Benutzer-ID*
   - Die Rolle
   - Den ganzen User

3. Warum ruft Login `reset_session` auf?
   - Um das Passwort zu hashen
   - Um Tests zu beschleunigen
   - *Um Session-Fixation zu verhindern*
   - Um Pundit zu starten

4. Wer darf eine Page löschen?
   - Jeder eingeloggte User
   - Uploader und Admin
   - *Nur Admin*
   - Niemand

5. Reicht es, den Löschen-Button auszublenden?
   - Ja, dann kann niemand löschen
   - *Nein, die URL muss serverseitig durch Pundit geprüft werden*
   - Ja, wenn CSS das Element versteckt
   - Nur bei Gästen

6. Was passiert, wenn das Speichern einer neuen Page fehlschlägt?
   - Die Page bleibt, der Log fehlt
   - *Die Transaktion rollt alles zurück*
   - Nur das Bild wird gespeichert
   - Rails stürzt ab

7. Was macht `with_lock` beim Löschen?
   - Hasht das Passwort
   - *Sperrt den Page-Datensatz gegen parallele Löschungen*
   - Zeigt eine Fehlermeldung
   - Startet Pundit

8. Wie sucht die App?
   - Mit Tippfehlerkorrektur
   - *Titelvergleich ohne Gross-/Kleinschreibung, `sanitize_sql_like` schützt `%` und `_`*
   - Nur exakte IDs
   - Volltext über alle Tabellen

## Verständnisfragen

### Wie funktioniert die Authentifizierung?

`has_secure_password` hasht das Passwort mit BCrypt. In der Datenbank liegt nur
`password_digest`. Beim Login prüft `authenticate` das eingegebene Passwort
gegen diesen Hash. Nach Erfolg speichert die Session nur die Benutzer-ID.

### Warum wird beim Login `reset_session` aufgerufen?

Eine alte Session-ID wird verworfen, bevor die Benutzer-ID gespeichert wird.
Das verhindert Session-Fixation.

### Wie funktionieren Rollen und Berechtigungen?

`User#role` erlaubt nur `user`, `uploader` oder `admin`. Pundit-Policies prüfen
serverseitig jede geschützte Aktion. Das Ausblenden eines Links allein wäre
keine Sicherheit, weil die URL direkt aufgerufen werden könnte.

### Wie hängen die Modelle zusammen?

Ein User hat viele Pages. Eine Page gehört zu einem User und hat viele
ContentItems. Ein User hat viele ActivityLogs. Beim Löschen eines übergeordneten
Datensatzes entfernt `dependent: :destroy` die abhängigen Datensätze.

### Was macht die Transaktion?

Beim Erstellen werden Page, Informationen und Log-Eintrag gemeinsam
gespeichert. Wenn ein Schritt fehlschlägt, wird alles zurückgerollt.

### Was macht das Locking?

`with_lock` sperrt die Page während der Löschung. Parallele Löschvorgänge können
dadurch nicht gleichzeitig denselben Datensatz verändern.

### Was prüft die Suche?

Sie vergleicht den kleingeschriebenen Titel mit der kleingeschriebenen Eingabe.
`sanitize_sql_like` schützt die Sonderzeichen `%` und `_` vor unbeabsichtigter
Wildcard-Bedeutung.

### Welche Fehler erkennen die wichtigsten Tests?

- Session-Tests: kaputte Loginroute, falsche Anmeldung, fehlender Logout.
- Registrierungstests: doppelte E-Mail, zu kurzes oder nicht bestätigtes
  Passwort.
- Page-Tests: fehlende Zugriffssperre, falsche Suchresultate, fehlende Details,
  unerlaubtes Erstellen/Löschen.
- Policy-Tests: eine Rolle erhält zu viele oder zu wenige Rechte.
- Profiltests: Benutzer sieht fremde Daten oder kann sich selbst zum Admin
  machen.
- Admin-Tests: normale Benutzer erreichen Benutzerverwaltung oder Logs.

## Bekannte offene Punkte

Page-Bearbeitung, Upload-Prüfworkflow, detailliertes responsives Styling,
Leistungsmessung und automatische Rechtschreibkorrektur sind nicht Teil des
aktuellen Umsetzungsstands.
