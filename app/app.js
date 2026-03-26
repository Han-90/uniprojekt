const output = document.getElementById("output");
const seedBtn = document.getElementById("seedBtn");
const loadBtn = document.getElementById("loadBtn");

const API_BASE =
  "https://function-app-uniproject-dev.azurewebsites.net/api/items";

seedBtn.addEventListener("click", async () => {
  output.textContent = "Speichere Testdaten...";
  try {
    const res = await fetch(API_BASE, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id: crypto.randomUUID(),
        title: "Hello from Static Web App",
      }),
    });

    const text = await res.text();
    output.textContent = text;

    if (!res.ok) {
      throw new Error(`HTTP ${res.status}: ${text}`);
    }
  } catch (err) {
    output.textContent = `Fehler: ${err}`;
  }
});

loadBtn.addEventListener("click", async () => {
  output.textContent = "Lade Daten...";
  try {
    const res = await fetch(API_BASE);

    const text = await res.text();
    output.textContent = text;

    if (!res.ok) {
      throw new Error(`HTTP ${res.status}: ${text}`);
    }
  } catch (err) {
    output.textContent = `Fehler: ${err}`;
  }
});
