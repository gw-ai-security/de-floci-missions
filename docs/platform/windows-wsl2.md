# Windows, WSL2 und Linux

- Docker Desktop muss den Context `desktop-linux` und Linux Containers verwenden.
- PowerShell verwendet `scripts/*.ps1`; WSL/Linux verwendet `scripts/*.sh`.
- Host-URLs verwenden `localhost`; Container verwenden den DNS-Namen `floci`.
- Quellcode bleibt im Repository, persistente Servicezustände liegen in benannten Volumes. Das reduziert langsame WSL2-Bind-Mount-Zugriffe.
- Wenn ein Pfad nicht freigegeben ist, Docker Desktop unter **Resources > File Sharing** prüfen.
- Niemals Windows-Pfade in Compose hardcodieren. `/var/run/docker.sock` ist der Socket der Linux-VM.
