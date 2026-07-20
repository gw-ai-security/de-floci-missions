# Persistenz und Lifecycle

Floci läuft im Modus `hybrid` und schreibt nach `/app/data` im benannten Volume `floci-state`. Mission Control nutzt das getrennte Volume `mission-progress`. Profilzustände besitzen eigene Volumes.

- **Stop:** `scripts/stop.*` entfernt Container/Netz, behält Volumes.
- **Reset Mission State:** `scripts/reset.*` zeigt Projektressourcen, verlangt Bestätigung und entfernt nur Compose-Volumes dieses Projekts.
- **Full Clean:** `scripts/cleanup.*` führt Reset aus und entfernt zusätzlich lokal gebaute Images unter `dea-floci/*`.

Dynamische RDS-, MSK-, OpenSearch- und ECR-Volumes werden durch Floci verwaltet und tragen `floci=true`. Die Skripte führen absichtlich keinen globalen Volume-Prune aus. Vor manueller Entfernung mit `scripts/list-floci-resources.*` prüfen, ob die Ressource wirklich zu diesem Netz gehört.

Offizielle Speicherreferenz: https://floci.io/floci/configuration/storage/
