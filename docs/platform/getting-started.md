# Getting Started

1. Docker Desktop installieren und WSL2/Linux Containers aktivieren.
2. Repository klonen und in das Projektverzeichnis wechseln.
3. `Copy-Item .env.example .env` (Linux: `cp .env.example .env`).
4. Vor schweren Profilen die lokalen Passwörter und den Jupyter-Token in `.env` ändern.
5. `.\scripts\doctor.ps1` beziehungsweise `./scripts/doctor.sh` ausführen.
6. Optional alle externen Images mit `prefetch-images` vorladen.
7. Core mit `start-core` oder `docker compose up --build -d` starten.
8. Mission Control auf `http://localhost:3000` und Floci UI auf `http://localhost:4500` öffnen.
9. `docker compose exec floci awslocal sts get-caller-identity` ausführen.
10. Bei Bedarf `docker compose --profile tools run --rm toolbox bash` öffnen.
11. Ein Profil mit `start-profile` starten.
12. Mit `stop` beenden; Daten bleiben erhalten.
13. Bei Problemen zuerst `doctor`, `docker compose ps` und `docker compose logs floci` verwenden.

Unter WSL2 müssen Shellskripte ausführbar sein: `chmod +x scripts/*.sh`.
