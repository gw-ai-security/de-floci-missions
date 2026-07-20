# Troubleshooting

## Port 4566/3000/4500 belegt

`scripts/doctor.ps1` zeigt Prozess und PID. Eigenen Prozess stoppen oder den statischen Hostport in `.env` ändern. Dynamische Floci-Portbereiche müssen frei bleiben.

## UI zeigt „Not connected“

`http://localhost:4566/_floci/health` prüfen, danach `docker compose logs floci-ui`. Der UI-Container muss `FLOCI_ENDPOINT=http://floci:4566` verwenden.

## Docker-Socket nicht erreichbar

Linux Containers aktivieren und prüfen, ob `/var/run/docker.sock` in Floci gemountet ist. Floci läuft bewusst als root, um den Desktop-Socket zu erreichen.

## Lambda/RDS/MSK/OpenSearch startet nicht

Mit `scripts/list-floci-resources.*` dynamische Container, Volumes und Ports anzeigen. Image-Pull, RAM und Netz `dea_floci_net` prüfen. OpenSearch benötigt typischerweise deutlich mehr RAM.

## EKS bleibt in CREATING

Port 6500–6599, k3s-Containerlogs und Docker-RAM prüfen. Nach fehlgeschlagenem Lab die EKS-Ressource über AWS CLI löschen.

## S3 Virtual-Hosted-Style DNS

Für lokale Clients Path Style aktivieren. Die Toolbox-Konfiguration setzt `addressing_style = path`.

## Athena Query hängt

Floci-Logs und den dynamischen `floci-duck`-Container prüfen. `FLOCI_SERVICES_ATHENA_MOCK` muss `false` bleiben.

## Spark erreicht S3 nicht

Endpoint `http://floci:4566`, Path Style, Dummy-Credentials und gemeinsames Netz prüfen. `spark-defaults.conf` enthält die zentrale S3A-Konfiguration.

## Windows-Dateifreigabe/WSL2

Docker Desktop File Sharing, WSL Integration und den Context `desktop-linux` prüfen. Das Repo nicht über einen nicht freigegebenen Laufwerkspfad mounten.

## Verwaiste Ressourcen

Zuerst `scripts/list-floci-resources.*`, danach projektspezifisches `reset.*`. Keine globalen Docker-Prune-Kommandos verwenden.
