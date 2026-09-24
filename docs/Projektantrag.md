<h4>ÜK - m223</h4><p>21.09.2026</p>
<br>
<br>
<b>Vincent Schindel, INA 24-28c</b>

<h3>Projektantrag</h3>

 ### Problemstellung

 Ich als Kleider-Nerd hätte gerne an einem Zentralen Ort gewusst wo es meine Lieblingspieces zu kaufen gibt, wann sie das erste mal das Licht der welt erblickten und wie viel diese kosten.

 Sehr Simpel.

 ### Projekt

 - Domäne: Freizeit und Bekleidung
 - Name der Applikation: Archive (stilisiert als 4RCHIVE)
 - Vision: Archive hilft begeisterten schnell und angenehm benötigte Informationen zu Kleidern aufzurufen. 

 ### 1. MVP Iteration

 Die erste Anforderung von grosser wichtigkeit ist die Suchfunktion und die Erstellung von einzelnen Pages.

 ### Anforderungsanalyse

 ### Funktionale Anforderungen (priorisiert)

 1. Benutzer können sich registrieren und einloggen
 2. Benutzer können die Suchfunktion benutzen
 3. Benutzer können ein Kleidungsstück auswählen und Informationen anzeigen lassen
 4. Bilder sind vorhanden und werden Korrekt angezeigt
 5. Links sind vorhanden und führen zum Gewünschten Ziel
 6. Das Erstellen und Löschen einer Page ist möglich

 #### Qualitätsattribute

 1. Benutzerfreundlichkeit: Intuitive Benutzeroberfläche für Intuitive Bedienung
 2. Reaktionszeit: Maximale Ladezeit von 2 sec für schnelle Aufklärung
 3. Hohe Kompatibilität: Alle Browser der Neuzeit sind unterstützt. (Edge ausgeschlossen)
 4. Responsives Design: Mobile, Tablet und Browser
 5. Fehlertoleranz: Kontrollierte Fehleranzeigen anstatt absturz
 6. Genauigkeit: Suchanfragen dürfen keine Schreibefehler beinhalten

 ### Benutzerrollen

 1. Admin: Kann Pages erstellen, Pages bearbeiten, verfügbare Informationen hochladen und andere Überprüfen
 2. Benutzer: Kann die verfügbaren Pages und dessen Informationen einsehen und Links benutzen
 3. Uploader: Kann Pages erstellen und Informationen einfügen. Sonstige Rechte wie normale Benutzer

### ERM (Entity-Relationship-Model)

Das ursprüngliche ERM befindet sich unter `docs/ERM.png`. Die Abweichungen zur
Umsetzung sind in Kapitel 9 dokumentiert.

### Breadboards

```text
@Login
  - E-Mail
  - Passwort
  - Einloggen
    -> @Archiv
  - Konto erstellen
    -> @Registrierung
  Fehler -> @Login

@Registrierung
  - E-Mail
  - Passwort
  - Passwortbestätigung
  - Registrieren
    -> @Login
  Fehler -> @Registrierung

@Archiv
  - Suche nach Kleidungsstück
  - Ergebnisliste
    -> @Detailseite
  - Neue Page (Uploader/Admin)
    -> @PageErstellen
  - Profil
    -> @Profil
  - Abmelden
    -> @Login

@Detailseite
  - Name
  - Bild
  - Beschreibung
  - Veröffentlichungsdatum
  - Shop-/Quellenlink
  - Löschen (Admin)
    -> @Archiv

@PageErstellen
  - Name
  - Beschreibung
  - Veröffentlichungsdatum
  - Shop-/Quellenlink
  - Bild
  Erfolg -> @Detailseite
  Fehler -> @PageErstellen

@Benutzerverwaltung
  - Benutzerliste
  - Rollenauswahl
  - Rolle aktualisieren
    -> @Benutzerverwaltung
```

### Fat-Marker-Sketches

Die Skizzen befinden sich unter `docs/Fatmarkersketch.drawio.png`.

## Dokumentation 4RCHIVE

### 1. Ausgangslage & Zielsetzung

Informationen zu Kleidungsstücken sind auf verschiedene Shops und Quellen
verteilt. 4RCHIVE führt Name, Beschreibung, Veröffentlichungsdatum, Bild und
einen externen Link an einer Stelle zusammen. Angemeldete Benutzer können das
Archiv durchsuchen und Details öffnen.

### 2. Anforderungen

Die priorisierten funktionalen Anforderungen stehen in der
Anforderungsanalyse. Die Kernfunktion ist der Ablauf
`Login -> Suche -> Auswahl -> Detailseite`. Uploader und Admins erweitern das
Archiv durch neue Pages. Admins können Pages löschen und Benutzerrollen
verwalten.

### 3. Qualitätsanforderungen

- Validierungsfehler werden im Formular angezeigt; unzulässige Aktionen führen
  zu einer kontrollierten Meldung statt zu einem Absturz.
- Die Suche arbeitet ohne Beachtung der Gross-/Kleinschreibung und schützt
  Sonderzeichen in SQL-LIKE-Anfragen.
- Geschützte Bereiche leiten nicht angemeldete Personen zum Login um.
- Moderne Browser werden durch Rails `allow_browser` vorausgesetzt.
- Das Layout enthält den Viewport-Metatag. Weiteres responsives Styling und
  eine Messung der Zwei-Sekunden-Anforderung sind noch offen.

### 4. Berechtigungskonzept

Pundit erzwingt die Berechtigungen serverseitig:

- `user`: Archiv durchsuchen, Pages und Links ansehen, eigenes Profil ändern.
- `uploader`: alle Benutzerrechte sowie Pages mit Informationen und Bild
  erstellen.
- `admin`: alle Uploaderrechte, Pages löschen, Benutzerrollen verwalten und
  das Aktivitätsprotokoll ansehen.

Ausgeblendete Links sind nur Benutzerführung. Auch ein direkter Aufruf einer
verbotenen URL wird durch die Policy abgewiesen.

### 5. Datenmodell

- `User 1:n Page`: Ein Benutzer kann mehrere Pages erstellen.
- `Page 1:n ContentItem`: Eine Page enthält Beschreibung, Link und Datum.
- `Page 1:1 ActiveStorage-Bild`: Das Bild wird über Active Storage verwaltet.
- `User 1:n ActivityLog`: Aktionen werden dem ausführenden Benutzer zugeordnet.

Passwörter werden nicht im Klartext gespeichert. `has_secure_password` legt nur
einen BCrypt-Hash in `password_digest` ab. Die Rolle ist als String mit den
zulässigen Werten `user`, `uploader` und `admin` umgesetzt.

### 6. UI-/Interaktionskonzept

Nach dem Login erscheint das Archiv mit Suche und Ergebnisliste. Ein Treffer
führt auf die Detailseite. Die Navigation zeigt Profil und Logout für alle
Benutzer; Adminfunktionen werden nur Admins angezeigt. Formulare zeigen
Validierungsfehler direkt an.

### 7. Transaktions- & Locking-Konzept

Beim Erstellen werden `Page`, zugehörige `ContentItem`-Daten und der
Aktivitätslog-Eintrag in einer Datenbanktransaktion gespeichert. Schlägt ein
Teil fehl, wird nichts dauerhaft gespeichert.

Beim Löschen sperrt `with_lock` den Page-Datensatz. Innerhalb einer Transaktion
werden Log-Eintrag und Löschung ausgeführt. So können zwei gleichzeitige
Löschvorgänge denselben Datensatz nicht unkontrolliert verändern.

### 8. Umsetzungsstand

Umgesetzt sind Registrierung, Login, Logout, Profil, Rollenprüfung mit Pundit,
Benutzerverwaltung, Aktivitätsprotokoll, Suche, Listen-/Detailansicht,
Page-Erstellung, Page-Löschung, Links und Bild-Upload/-Anzeige. Die
automatisierten Tests prüfen Erfolgs- und Fehlerfälle.

### 9. Abweichungen & offene Punkte

- Das ursprüngliche ERM zeigt eine eigene Rollentabelle. Für drei feste Rollen
  verwendet die Umsetzung stattdessen ein validiertes `role`-Feld.
- Page-Bearbeitung und ein fachlicher Prüfprozess für Uploads sind noch nicht
  umgesetzt.
- Responsives Styling, Leistungsmessung und eine automatische
  Rechtschreibkorrektur der Suche sind offen.
- Die ERM-Grafik muss um `ActivityLog` und Active Storage ergänzt werden.

### 10. Anforderungsvalidierung

- Registrierung/Login: durch Controller-Tests für Erfolg und Fehler geprüft.
- Suche: Test stellt sicher, dass nur passende Titel angezeigt werden.
- Detailinformationen/Links: Test prüft Titel, Text und Ziel-URL.
- Bilder: Formular und Detailansicht unterstützen Active Storage; ein
  manueller Uploadtest ist erforderlich.
- Erstellen/Löschen: Tests prüfen Uploader-Erstellung und Admin-Löschung.
- Rollen: Policy- und Controller-Tests prüfen erlaubte und verbotene Aktionen.
- Fehlerbehandlung: Tests prüfen doppelte E-Mail, kurzes Passwort,
  Passwortbestätigung, falschen Login und unzulässige Rollenaktionen.

### 11. Konsistenz von Dokumentation & Umsetzung

Routen, Modelle, Policies und Tests wurden mit dieser Dokumentation
abgeglichen. Noch nicht umgesetzte Punkte werden in Kapitel 9 ausdrücklich als
offen ausgewiesen und nicht als abgeschlossen dargestellt.