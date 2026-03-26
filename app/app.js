const commentInput = document.getElementById("commentInput");
const saveBtn = document.getElementById("saveBtn");
const loadBtn = document.getElementById("loadBtn");
const statusEl = document.getElementById("status");
const commentsList = document.getElementById("commentsList");

const API_URL =
  "https://function-app-uniproject-dev.azurewebsites.net/api/items";

function setStatus(message, isError = false) {
  statusEl.textContent = message;
  statusEl.style.color = isError ? "#b91c1c" : "#6b7280";
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function renderComments(items) {
  if (!Array.isArray(items) || items.length === 0) {
    commentsList.innerHTML = `<p class="empty-state">Noch keine Kommentare vorhanden.</p>`;
    return;
  }

  const sortedItems = [...items].reverse();

  commentsList.innerHTML = sortedItems
    .map((item, index) => {
      const text = item.title ?? item.comment ?? "Kein Inhalt";
      const id = item.id ?? `Kommentar ${index + 1}`;

      return `
        <article class="comment">
          <div class="comment-meta">
            <span>Kommentar</span>
            <span>${escapeHtml(id)}</span>
          </div>
          <p class="comment-text">${escapeHtml(text)}</p>
        </article>
      `;
    })
    .join("");
}

async function loadComments() {
  setStatus("Kommentare werden geladen...");

  try {
    const response = await fetch(API_URL);
    const rawText = await response.text();

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${rawText}`);
    }

    const data = rawText ? JSON.parse(rawText) : [];
    renderComments(data);
    setStatus("Kommentare erfolgreich geladen.");
  } catch (error) {
    setStatus(`Fehler beim Laden: ${error.message}`, true);
    commentsList.innerHTML = `<p class="empty-state">Kommentare konnten nicht geladen werden.</p>`;
  }
}

async function saveComment() {
  const text = commentInput.value.trim();

  if (!text) {
    setStatus("Bitte zuerst einen Kommentar eingeben.", true);
    return;
  }

  setStatus("Kommentar wird gespeichert...");

  try {
    const payload = {
      id: crypto.randomUUID(),
      title: text,
    };

    const response = await fetch(API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const rawText = await response.text();

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${rawText}`);
    }

    commentInput.value = "";
    setStatus("Kommentar erfolgreich gespeichert.");
    await loadComments();
  } catch (error) {
    setStatus(`Fehler beim Speichern: ${error.message}`, true);
  }
}

saveBtn.addEventListener("click", saveComment);
loadBtn.addEventListener("click", loadComments);

commentInput.addEventListener("keydown", (event) => {
  if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
    saveComment();
  }
});
