const PHASES = [
  { min: 0, max: 5, id: "A", title: "Foundation & Data Lake" },
  { min: 6, max: 10, id: "B", title: "Serverless & Events" },
  { min: 11, max: 15, id: "C", title: "Streaming" },
  { min: 16, max: 21, id: "D", title: "Datastores & Modeling" },
  { min: 22, max: 25, id: "E", title: "Big Data & Compute" },
  { min: 26, max: 31, id: "F", title: "Operations & Security" },
  { min: 32, max: 35, id: "G", title: "IaC, CI/CD & Costs" },
  { min: 36, max: 39, id: "H", title: "DEA-C01 v1.1" },
  { min: 40, max: 43, id: "I", title: "Capstones & Readiness" }
];

const TRACKED_SECTIONS = new Set([
  "aufgaben",
  "deliverables",
  "pflichtanforderungen",
  "abnahme",
  "readiness-kriterien",
  "incidents",
  "pro incident"
]);

const FALLBACK_MILESTONES = [
  "Problem und Anforderungen dokumentieren",
  "Architekturhypothese begründen",
  "Umsetzung über GUI durchführen",
  "Umsetzung über CLI oder SDK durchführen",
  "Infrastruktur als Code ergänzen",
  "Tests und technischen Nachweis ausführen",
  "Fehler injizieren und Troubleshooting dokumentieren",
  "AWS-Reality-Check und Exam Transfer abschließen"
];

function cleanInline(value) {
  return value
    .replace(/\*\*/g, "")
    .replace(/`/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function metadata(block, label) {
  const match = block.match(new RegExp(`^\\*\\*${label}:\\*\\*\\s*(.+)$`, "mi"));
  return match ? cleanInline(match[1]) : "";
}

function sectionMilestones(block) {
  const lines = block.split(/\r?\n/);
  const milestones = [];
  let section = "";

  for (const line of lines) {
    const heading = line.match(/^(#{1,6})\s+(.+?)\s*$/);
    if (heading) {
      section = heading[1] === "###" ? cleanInline(heading[2]).toLocaleLowerCase("de-DE") : "";
      continue;
    }

    if (!TRACKED_SECTIONS.has(section)) continue;
    const item = line.match(/^\s*(?:\d+[.)]|[-*])\s+(.+?)\s*$/);
    if (!item) continue;
    const text = cleanInline(item[1]);
    if (text && !milestones.includes(text)) milestones.push(text);
  }

  return milestones;
}

export function parseMissions(markdown) {
  const matches = [...markdown.matchAll(/^##\s+(M\d{2})\s+[–-]\s+(.+?)\s*$/gm)];
  return matches.map((match, index) => {
    const start = match.index;
    const end = matches[index + 1]?.index ?? markdown.length;
    const block = markdown.slice(start, end);
    const number = Number(match[1].slice(1));
    const phase = PHASES.find((entry) => number >= entry.min && number <= entry.max);
    const items = sectionMilestones(block);
    const milestones = (items.length ? items : FALLBACK_MILESTONES).map((title, itemIndex) => ({
      id: `${match[1]}-${String(itemIndex + 1).padStart(2, "0")}`,
      title
    }));

    return {
      id: match[1],
      number,
      title: cleanInline(match[2]),
      phase,
      duration: metadata(block, "Dauer"),
      className: metadata(block, "Klasse"),
      floci: metadata(block, "Floci"),
      aws: metadata(block, "AWS-Pendant"),
      examMapping: metadata(block, "Exam Mapping"),
      milestones
    };
  });
}

export { PHASES };
