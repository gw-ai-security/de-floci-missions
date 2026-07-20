import { createServer } from "node:http";
import { readFile, mkdir, rename, writeFile } from "node:fs/promises";
import { extname, join, normalize } from "node:path";
import { fileURLToPath } from "node:url";
import { parseMissions } from "./missions.mjs";

const ROOT = fileURLToPath(new URL("..", import.meta.url));
const PUBLIC = join(ROOT, "public");
const PORT = Number(process.env.PORT || 3000);
const PLAN_PATH = process.env.MISSION_PLAN_PATH || "/app/content/DEA-C01_Floci_Hands-on_Missionenplan.md";
const DATA_DIR = process.env.MISSION_DATA_DIR || "/app/data";
const PROGRESS_PATH = join(DATA_DIR, "progress.json");

const mime = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".svg": "image/svg+xml"
};

const plan = await readFile(PLAN_PATH, "utf8");
const missions = parseMissions(plan);
if (missions.length !== 44) {
  throw new Error(`Expected 44 missions in source plan, found ${missions.length}`);
}
await mkdir(DATA_DIR, { recursive: true });

let writeQueue = Promise.resolve();

async function readProgress() {
  try {
    return JSON.parse(await readFile(PROGRESS_PATH, "utf8"));
  } catch (error) {
    if (error.code === "ENOENT") return { version: 1, completed: {}, updatedAt: null };
    throw error;
  }
}

function saveProgress(progress) {
  writeQueue = writeQueue.then(async () => {
    const tempPath = `${PROGRESS_PATH}.tmp`;
    await writeFile(tempPath, `${JSON.stringify(progress, null, 2)}\n`, "utf8");
    await rename(tempPath, PROGRESS_PATH);
  });
  return writeQueue;
}

function json(response, status, payload) {
  response.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Content-Type-Options": "nosniff"
  });
  response.end(JSON.stringify(payload));
}

async function body(request) {
  let raw = "";
  for await (const chunk of request) {
    raw += chunk;
    if (raw.length > 16_384) throw new Error("Request body too large");
  }
  return JSON.parse(raw || "{}");
}

function enrichedMissions(progress) {
  return missions.map((mission) => {
    const completed = mission.milestones.filter((item) => progress.completed[item.id]).length;
    return {
      ...mission,
      completed,
      total: mission.milestones.length,
      status: completed === mission.milestones.length ? "completed" : completed > 0 ? "in-progress" : "not-started",
      milestones: mission.milestones.map((item) => ({ ...item, completed: Boolean(progress.completed[item.id]) }))
    };
  });
}

async function api(request, response, url) {
  if (request.method === "GET" && url.pathname === "/api/health") {
    return json(response, 200, { status: "ok", missionCount: missions.length });
  }

  if (request.method === "GET" && url.pathname === "/api/missions") {
    const progress = await readProgress();
    return json(response, 200, { missions: enrichedMissions(progress), updatedAt: progress.updatedAt });
  }

  const progressRoute = url.pathname.match(/^\/api\/milestones\/(M\d{2}-\d{2})$/);
  if (request.method === "PUT" && progressRoute) {
    const milestoneId = progressRoute[1];
    const exists = missions.some((mission) => mission.milestones.some((item) => item.id === milestoneId));
    if (!exists) return json(response, 404, { error: "Unknown milestone" });
    const payload = await body(request);
    if (typeof payload.completed !== "boolean") return json(response, 400, { error: "completed must be boolean" });
    const progress = await readProgress();
    if (payload.completed) progress.completed[milestoneId] = true;
    else delete progress.completed[milestoneId];
    progress.updatedAt = new Date().toISOString();
    await saveProgress(progress);
    return json(response, 200, { milestoneId, completed: payload.completed, updatedAt: progress.updatedAt });
  }

  return json(response, 404, { error: "Not found" });
}

async function staticFile(response, pathname) {
  const requested = pathname === "/" ? "index.html" : pathname.slice(1);
  const safe = normalize(requested).replace(/^(\.\.[/\\])+/, "");
  const filePath = join(PUBLIC, safe);
  if (!filePath.startsWith(PUBLIC)) return json(response, 403, { error: "Forbidden" });
  try {
    const content = await readFile(filePath);
    response.writeHead(200, {
      "Content-Type": mime[extname(filePath)] || "application/octet-stream",
      "Cache-Control": extname(filePath) === ".html" ? "no-cache" : "public, max-age=3600",
      "X-Content-Type-Options": "nosniff",
      "Content-Security-Policy": "default-src 'self'; style-src 'self'; script-src 'self'; img-src 'self' data:; connect-src 'self'"
    });
    response.end(content);
  } catch (error) {
    if (error.code === "ENOENT") return json(response, 404, { error: "Not found" });
    throw error;
  }
}

const server = createServer(async (request, response) => {
  try {
    const url = new URL(request.url, `http://${request.headers.host || "localhost"}`);
    if (url.pathname.startsWith("/api/")) await api(request, response, url);
    else await staticFile(response, url.pathname);
  } catch (error) {
    console.error(error);
    json(response, error instanceof SyntaxError ? 400 : 500, { error: error.message || "Internal error" });
  }
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Mission Tracker listening on http://0.0.0.0:${PORT} with ${missions.length} missions`);
});
