import test from "node:test";
import assert from "node:assert/strict";
import { parseMissions } from "../src/missions.mjs";

test("parses mission metadata and numbered milestones", () => {
  const result = parseMissions(`## M00 – Foundation\n\n**Dauer:** 2 h\n**Klasse:** A\n\n### Aufgaben\n\n1. Core starten.\n2. Health prüfen.\n`);
  assert.equal(result.length, 1);
  assert.equal(result[0].id, "M00");
  assert.equal(result[0].phase.id, "A");
  assert.equal(result[0].milestones.length, 2);
  assert.equal(result[0].milestones[1].title, "Health prüfen.");
});

test("uses the standard definition of done when no task list exists", () => {
  const [mission] = parseMissions("## M21 – Decision Workshop\n\n**Dauer:** 4 h\n");
  assert.equal(mission.milestones.length, 8);
  assert.match(mission.milestones[0].id, /^M21-/);
});
