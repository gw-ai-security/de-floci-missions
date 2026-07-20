const list = document.querySelector("#mission-list");
const template = document.querySelector("#mission-template");
const search = document.querySelector("#search");
const empty = document.querySelector("#empty-state");
let missions = [];
let filter = "all";
let query = "";

const statusLabel = { completed: "Erledigt", "in-progress": "In Arbeit", "not-started": "Offen" };

async function load() {
  const response = await fetch("/api/missions");
  if (!response.ok) throw new Error("Missionen konnten nicht geladen werden");
  const data = await response.json();
  missions = data.missions;
  updateDashboard(data.updatedAt);
  render();
}

function updateDashboard(updatedAt) {
  const completed = missions.filter((mission) => mission.status === "completed").length;
  const active = missions.filter((mission) => mission.status === "in-progress").length;
  const open = missions.length - completed - active;
  const doneSteps = missions.reduce((sum, mission) => sum + mission.completed, 0);
  const totalSteps = missions.reduce((sum, mission) => sum + mission.total, 0);
  const percent = totalSteps ? Math.round((doneSteps / totalSteps) * 100) : 0;
  document.querySelector("#overall-percent").textContent = `${percent}%`;
  document.querySelector("#overall-ring").style.setProperty("--progress", `${percent * 3.6}deg`);
  document.querySelector("#overall-label").textContent = completed ? `${completed} Mission${completed === 1 ? "" : "en"} geschafft` : "Bereit zum Start";
  document.querySelector("#overall-detail").textContent = `${completed} von ${missions.length} Missionen erledigt`;
  document.querySelector("#stat-completed").textContent = completed;
  document.querySelector("#stat-active").textContent = active;
  document.querySelector("#stat-open").textContent = open;
  document.querySelector("#stat-milestones").textContent = `${doneSteps} / ${totalSteps}`;
  document.querySelector("#count-all").textContent = missions.length;
  document.querySelector("#count-open").textContent = open;
  document.querySelector("#count-active").textContent = active;
  document.querySelector("#count-completed").textContent = completed;
  document.querySelector("#updated-label").textContent = updatedAt ? `Zuletzt gespeichert: ${new Intl.DateTimeFormat("de-DE", { dateStyle: "medium", timeStyle: "short" }).format(new Date(updatedAt))}` : "Fortschritt wird lokal gespeichert";
}

function visibleMissions() {
  const normalized = query.toLocaleLowerCase("de-DE");
  return missions.filter((mission) => {
    const matchesFilter = filter === "all" || mission.status === filter;
    const haystack = [mission.id, mission.title, mission.phase?.title, mission.floci, mission.aws, ...mission.milestones.map((item) => item.title)].join(" ").toLocaleLowerCase("de-DE");
    return matchesFilter && haystack.includes(normalized);
  });
}

function missionNode(mission) {
  const node = template.content.firstElementChild.cloneNode(true);
  node.dataset.id = mission.id;
  node.classList.add(mission.status);
  node.querySelector(".mission-number").textContent = mission.status === "completed" ? "✓" : mission.id;
  node.querySelector(".mission-kicker").textContent = `Phase ${mission.phase.id} · ${mission.phase.title}`;
  node.querySelector(".mission-title").textContent = mission.title;
  node.querySelector(".mission-meta").textContent = [mission.duration, mission.className ? `Klasse ${mission.className}` : "", mission.examMapping ? `Exam ${mission.examMapping}` : ""].filter(Boolean).join("  ·  ");
  node.querySelector(".mission-count").textContent = `${mission.completed} / ${mission.total} Schritte`;
  node.querySelector(".mini-track i").style.width = `${Math.round((mission.completed / mission.total) * 100)}%`;
  node.querySelector(".mission-status").textContent = statusLabel[mission.status];
  node.querySelector(".body-count").textContent = `${mission.completed} von ${mission.total} abgeschlossen`;
  const summary = node.querySelector(".mission-summary");
  const body = node.querySelector(".mission-body");
  summary.addEventListener("click", () => {
    const expanded = summary.getAttribute("aria-expanded") === "true";
    summary.setAttribute("aria-expanded", String(!expanded));
    body.hidden = expanded;
  });

  const milestones = node.querySelector(".milestones");
  mission.milestones.forEach((milestone) => {
    const label = document.createElement("label");
    label.className = `milestone${milestone.completed ? " checked" : ""}`;
    label.innerHTML = `<input type="checkbox"><span class="check" aria-hidden="true">✓</span><span class="label"></span>`;
    const input = label.querySelector("input");
    input.checked = milestone.completed;
    input.setAttribute("aria-label", milestone.title);
    label.querySelector(".label").textContent = milestone.title;
    input.addEventListener("change", () => toggleMilestone(mission.id, milestone.id, input.checked, label));
    milestones.append(label);
  });
  return node;
}

async function toggleMilestone(missionId, milestoneId, completed, element) {
  element.classList.add("saving");
  try {
    const response = await fetch(`/api/milestones/${milestoneId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ completed })
    });
    if (!response.ok) throw new Error("Speichern fehlgeschlagen");
    const mission = missions.find((entry) => entry.id === missionId);
    const milestone = mission.milestones.find((entry) => entry.id === milestoneId);
    milestone.completed = completed;
    mission.completed = mission.milestones.filter((entry) => entry.completed).length;
    mission.status = mission.completed === mission.total ? "completed" : mission.completed ? "in-progress" : "not-started";
    const data = await response.json();
    updateDashboard(data.updatedAt);
    render(missionId);
  } catch (error) {
    element.querySelector("input").checked = !completed;
    element.classList.remove("saving");
    window.alert(error.message);
  }
}

function render(reopenId) {
  const visible = visibleMissions();
  list.replaceChildren(...visible.map(missionNode));
  empty.hidden = visible.length > 0;
  if (reopenId) {
    const card = list.querySelector(`[data-id="${reopenId}"]`);
    if (card) {
      card.querySelector(".mission-summary").setAttribute("aria-expanded", "true");
      card.querySelector(".mission-body").hidden = false;
    }
  }
}

search.addEventListener("input", (event) => { query = event.target.value.trim(); render(); });
document.querySelectorAll("[data-filter]").forEach((button) => button.addEventListener("click", () => {
  filter = button.dataset.filter;
  document.querySelectorAll("[data-filter]").forEach((item) => item.classList.toggle("active", item === button));
  render();
}));

load().catch((error) => {
  empty.hidden = false;
  empty.querySelector("h3").textContent = "Missionen konnten nicht geladen werden";
  empty.querySelector("p").textContent = error.message;
});
