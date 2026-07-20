# Sicherheit

Diese Plattform ist ausschließlich für lokale Entwicklung.

- Nur Dummy-Credentials `test/test`; echte AWS-Schlüssel gehören weder in `.env` noch in Git.
- `.env` und persistente Daten sind ignoriert.
- Web-UIs und dynamische Proxybereiche sind an `127.0.0.1` gebunden.
- Floci und die explizite Toolbox mounten den Docker-Socket. Zugriff auf `/var/run/docker.sock` entspricht praktisch weitreichendem Zugriff auf den Docker-Host.
- Mock-Modus der Floci UI ist deaktiviert; AWS-Produktionssicherheit wird trotzdem nicht behauptet.
- Profilpasswörter in `.env.example` sind bewusst erkennbare Platzhalter und vor Start des jeweiligen Profils zu ändern.
- Secret-Scan: `git grep -nEi '(AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=\s*[^t])'`.
- Keine Telemetrie oder externen SaaS-Dienste sind für den Core erforderlich.
