import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { parseMissions } from "../../mission-tracker/src/missions.mjs";

test("the source plan exposes every mission from M00 to M43", async () => {
  const source = await readFile(new URL("../../content/DEA-C01_Floci_Hands-on_Missionenplan.md", import.meta.url), "utf8");
  const missions = parseMissions(source);
  assert.equal(missions.length, 44);
  assert.deepEqual(missions.map((mission) => mission.id), Array.from({ length: 44 }, (_, index) => `M${String(index).padStart(2, "0")}`));
  assert.ok(missions.every((mission) => mission.milestones.length > 0));
});
