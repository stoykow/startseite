# Startseite: CI/CD-Demo

Eine persönliche Startseite mit Links, Gruppen, Profilen und Icons. Die Demo läuft mit PHP 8.3 und MariaDB. Der GitHub-Workflow prüft den Code und kann die App auf einem eigenen Webspace bereitstellen.

## Lokal ausprobieren

Voraussetzung ist Docker mit Docker Compose. Im geklonten Repository:

```bash
cp .env.example .env
docker compose up -d --build
```

Öffne [localhost:28860](http://localhost:28860) und registriere ein eigenes Konto. Die Datenbank und hochgeladenen Icons liegen in Docker-Volumes. Mit `docker compose down` stoppst du die Demo. In PowerShell kannst du die Beispieldatei mit `Copy-Item .env.example .env` kopieren.

## GitHub Actions im Fork einrichten

1. Klicke auf **Fork**, um eine eigene Kopie anzulegen. Öffne im Fork den Reiter **Actions** und aktiviere die Workflows, falls GitHub danach fragt.
2. Öffne **Actions → Startseite CI/CD → Run workflow**. Die PHP- und Dateiprüfungen laufen bereits ohne Variablen oder Secrets. Sie laufen zusätzlich bei Pushes und Pull Requests.
3. Für ein Deployment benötigst du eigenen PHP-Webspace mit `pdo_mysql`, eine bereits angelegte MariaDB-Datenbank, eine HTTPS-Adresse und einen FTPS-Zugang mit explizitem TLS und gültigem Zertifikat. Die Anwendung muss am Stamm der Domain erreichbar sein. Das Verzeichnis `assets/uploads/icons` muss für PHP beschreibbar sein.
4. Öffne im Fork **Settings → Secrets and variables → Actions**. Lege unter **Variables → New repository variable** die Variablen aus der ersten Tabelle an. Setze `STARTSEITE_DEPLOY_ENABLED` erst nach den anderen Einstellungen auf `true`.
5. Lege unter **Secrets → New repository secret** die Werte aus der zweiten Tabelle an. Verwende in deinem Fork deine eigenen Zugangsdaten und Inhalte.
6. Starte den Workflow erneut auf deinem Standardbranch und prüfe den Job **Per FTPS bereitstellen und prüfen**. Mit `STARTSEITE_DEPLOY_ENABLED=true` löst auch ein Push auf den Standardbranch ein Deployment aus.

### Repository-Variablen

| Name | Wert | Erforderlich |
| --- | --- | --- |
| `STARTSEITE_DEPLOY_ENABLED` | `true` schaltet das Deployment ein. Ohne diese Einstellung laufen nur die Prüfungen. | Ja, für Deployment |
| `STARTSEITE_DEPLOY_HOST` | FTPS-Hostname, zum Beispiel `ftp.example.org`, ohne Protokoll. | Ja |
| `STARTSEITE_PUBLIC_URL` | Öffentliche HTTPS-Adresse, zum Beispiel `https://start.example.org`. Sie dient auch als Basis für Links zum Teilen. | Ja |
| `STARTSEITE_DEPLOY_PORT` | FTPS-Port, standardmäßig `21`. | Nur bei abweichendem Port |
| `STARTSEITE_DEPLOY_PATH` | Verzeichnis aus Sicht des FTPS-Kontos, standardmäßig `/`, zum Beispiel `/public_html`. | Nur bei abweichendem Pfad |
| `STARTSEITE_DB_HOST` | Datenbankhost aus Sicht des Webservers, standardmäßig `localhost`. | Nur bei abweichendem Host |

### Repository-Secrets

| Name | Wert |
| --- | --- |
| `STARTSEITE_DEPLOY_USER` | FTPS-Benutzername deines Hosters. |
| `STARTSEITE_DEPLOY_PASSWORD` | FTPS-Passwort. |
| `MARIADB_DATABASE` | Name der vorhandenen Datenbank. |
| `MARIADB_USER` | Datenbankbenutzer der App. |
| `MARIADB_PASSWORD` | Passwort des Datenbankbenutzers. |
| `LEGAL_IMPRESSUM_PHP` | Vollständiger PHP-Inhalt deines Impressums. Nutze `impressum_example.php` als Vorlage. |
| `LEGAL_DATENSCHUTZ_PHP` | Vollständiger PHP-Inhalt deiner Datenschutzerklärung. Nutze `datenschutz_example.php` als Vorlage. |

Der Workflow erzeugt die beiden rechtlichen Seiten und `config/local.php` im Runner und lädt sie zusammen mit der App auf deinen Webspace. In Git gehören nur die Beispieldateien. Die `.env` aus der lokalen Docker-Anleitung bleibt auf deinem Rechner. GitHub Pages führt kein PHP aus.

Der Workflow prüft nach dem Upload, ob `login.php`, `impressum.php` und `datenschutz.php` per HTTPS erreichbar sind. Wenn der Upload fehlschlägt, prüfe den FTPS-Host, das Zielverzeichnis, das TLS-Zertifikat und die Zugriffsregeln deines Hosters. Falls der Login danach nicht lädt, prüfe die Datenbankdaten und ob deine PHP-Installation `pdo_mysql` unterstützt.

[GitHub-Dokumentation zu Variablen](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables) · [GitHub-Dokumentation zu Secrets](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets)
