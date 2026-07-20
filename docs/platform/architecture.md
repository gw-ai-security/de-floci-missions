# Plattformarchitektur

```mermaid
flowchart LR
  Browser["Browser"] --> Tracker["Mission Control :3000"]
  Browser --> Console["Floci UI :4500"]
  CLI["AWS CLI / SDK / IaC"] --> Floci["Floci Core :4566"]
  Console --> Floci
  Tracker --> Plan["Missionenplan Markdown"]
  Tracker --> Progress[("mission-progress Volume")]
  Floci --> State[("floci-state Volume")]
  Floci --> Docker["Docker Socket"]
  Docker --> Dynamic["Lambda / RDS / MSK / EKS / OpenSearch / ECS"]
  Profiles["Optionale Profile"] --> Floci
  subgraph Network["dea_floci_net"]
    Tracker
    Console
    Floci
    Profiles
    Dynamic
  end
```

## Endpoints

- Hostzugriff auf Floci: `http://localhost:4566`
- Containerzugriff auf Floci: `http://floci:4566`
- Missionsübersicht: `http://localhost:3000`
- Floci-Ressourcen-UI: `http://localhost:4500`

Alle statischen Webports sind an `127.0.0.1` gebunden. Das explizite Bridge-Netz `dea_floci_net` wird über `FLOCI_SERVICES_DOCKER_NETWORK` auch an dynamische Floci-Container weitergegeben.

Floci erhält den Docker-Socket ausschließlich, weil reale Lambda-, RDS-, MSK-, ECS-, EKS- und OpenSearch-Data-Planes Container erzeugen. Die Toolbox erhält ihn nur im expliziten Profil `tools`. Dieser Zugriff ist host-privilegiert und für Produktionsumgebungen ungeeignet.
