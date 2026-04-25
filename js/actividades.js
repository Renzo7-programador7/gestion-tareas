let actividades = [];

function agregarActividad() {
  const input = document.getElementById("inputActividad");
  const prioridad = document.getElementById("prioridad").value;

  const texto = input.value.trim();
  if (!texto) return;

  actividades.push({ texto, prioridad, completado: false });

  input.value = "";
  render();
}

function render() {
  const lista = document.getElementById("listaActividades");
  lista.innerHTML = "";

  actividades.forEach((act, i) => {
    const li = document.createElement("li");

    li.innerHTML = `
      <span class="${act.completado ? 'completada' : ''}">
        ${act.texto}
      </span>
      <button onclick="eliminar(${i})">❌</button>
    `;

    li.onclick = () => {
      act.completado = !act.completado;
      render();
    };

    lista.appendChild(li);
  });

  actualizar();
}

function eliminar(i) {
  actividades.splice(i, 1);
  render();
}

function actualizar() {
  document.getElementById("total").textContent = actividades.length;
  document.getElementById("pendientes").textContent =
    actividades.filter(a => !a.completado).length;
  document.getElementById("completadas").textContent =
    actividades.filter(a => a.completado).length;
}

function limpiar() {
  actividades = [];
  render();
}