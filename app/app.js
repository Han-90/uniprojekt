const output = document.getElementById("output");
const seedBtn = document.getElementById("seedBtn");
const loadBtn = document.getElementById("loadBtn");

seedBtn.addEventListener("click", async () => {
  output.textContent = "Speichere Testdaten...";
  try {
    const res = await fetch("/api/seed", {
      method: "POST",
    });
    const data = await res.json();
    output.textContent = JSON.stringify(data, null, 2);
  } catch (err) {
    output.textContent = `Fehler: ${err}`;
  }
});

loadBtn.addEventListener("click", async () => {
  output.textContent = "Lade Daten...";
  try {
    const res = await fetch("/api/items");
    const data = await res.json();
    output.textContent = JSON.stringify(data, null, 2);
  } catch (err) {
    output.textContent = `Fehler: ${err}`;
  }
});
