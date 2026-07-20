import { readFile, writeFile } from "node:fs/promises";
import { parseMissions } from "../mission-tracker/src/missions.mjs";

const source = new URL("../content/DEA-C01_Floci_Hands-on_Missionenplan.md", import.meta.url);
const target = new URL("../docs/platform/mission-infrastructure-matrix.md", import.meta.url);
const missions = parseMissions(await readFile(source, "utf8"));

function profile(number) {
  if ([22, 36, 40].includes(number)) return "spark";
  if (number === 37) return "vector";
  if (number === 38) return "rag";
  if ([32, 33].includes(number)) return "tools";
  return "core";
}

function addon(number) {
  const map = {
    14: "Floci erzeugt Redpanda dynamisch", 18: "Floci erzeugt PostgreSQL dynamisch",
    20: "Floci erzeugt DB-Container dynamisch", 22: "Spark Master + Worker", 24: "Floci erzeugt ECS/Batch-Container",
    25: "Floci erzeugt k3s dynamisch", 36: "Spark + Iceberg Runtime", 37: "PostgreSQL + pgvector",
    38: "deterministische lokale RAG-API", 40: "Spark Master + Worker", 41: "Floci erzeugt Stream-/Runtime-Container"
  };
  return map[number] || "keiner";
}

function limitation(mission) {
  const value = mission.className || "E";
  if (value.includes("D")) return "Lokaler Ersatz; kein identisches AWS Data Plane";
  if (value.includes("E")) return "Theorie/Entscheidung; optionaler Real-AWS-Abgleich";
  if (value.includes("C")) return "Primär Control Plane bzw. Statussimulation";
  if (value.includes("B")) return "Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen";
  return "Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas";
}

const rows = missions.map((mission) => {
  const services = [mission.aws, mission.floci].filter(Boolean).join(" / ") || mission.title;
  return `| ${mission.id} – ${mission.title.replaceAll("|", "\\|")} | ${services.replaceAll("|", "\\|")} | ${mission.floci.replaceAll("|", "\\|") || "Floci Core"} | ${addon(mission.number)} | \`${profile(mission.number)}\` | ${limitation(mission)} |`;
});

const document = `# Mission-Infrastruktur-Matrix\n\n> Generiert aus \`content/DEA-C01_Floci_Hands-on_Missionenplan.md\` mit \`node scripts/generate-mission-matrix.mjs\`. Der Missionenplan bleibt die fachliche Source of Truth.\n\n| Mission | benötigte Services | Floci-Komponente | Zusatzcontainer | Startprofil | lokale Einschränkungen |\n|---|---|---|---|---|---|\n${rows.join("\n")}\n`;

await writeFile(target, document, "utf8");
console.log(`Wrote ${missions.length} mission rows to ${target.pathname}`);
