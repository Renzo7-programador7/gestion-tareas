// Lista de compras en memoria
let compras = [];
let siguienteId = 1;

const inputArticulo = document.getElementById("input-articulo");
const inputCantidad = document.getElementById("input-cantidad");
const btnAgregar = document.getElementById("btn-agregar");
const tbody = document.getElementById("lista-compras");

function renderizar() {
  tbody.innerHTML = "";

  if (compras.length === 0) {
    const fila = document.createElement("tr");
    fila.innerHTML = `<td colspan="3" class="vacio">No hay artículos en la lista</td>`;
    tbody.appendChild(fila);
    return;
  }

  compras.forEach((item) => {
    const fila = document.createElement("tr");
    fila.innerHTML = `
      <td class="${item.comprado ? "comprado" : ""}">${item.nombre}</td>
      <td class="${item.comprado ? "comprado" : ""}">${item.cantidad}</td>
      <td>
        <button class="btn-comprado" data-id="${item.id}">✔</button>
        <button class="btn-eliminar" data-id="${item.id}">🗑</button>
      </td>
    `;
    tbody.appendChild(fila);
  });
}

function agregarArticulo() {
  const nombre = inputArticulo.value.trim();
  const cantidad = inputCantidad.value.trim() || "1";

  if (nombre === "") {
    alert("Escribe el nombre del artículo");
    return;
  }

  compras.push({
    id: siguienteId++,
    nombre: nombre,
    cantidad: cantidad,
    comprado: false,
  });

  inputArticulo.value = "";
  inputCantidad.value = "";
  inputArticulo.focus();
  renderizar();
}

function marcarComprado(id) {
  const item = compras.find((c) => c.id === id);
  if (item) item.comprado = !item.comprado;
  renderizar();
}

function eliminarArticulo(id) {
  compras = compras.filter((c) => c.id !== id);
  renderizar();
}

btnAgregar.addEventListener("click", agregarArticulo);

inputArticulo.addEventListener("keypress", (e) => {
  if (e.key === "Enter") agregarArticulo();
});

tbody.addEventListener("click", (e) => {
  const id = Number(e.target.dataset.id);
  if (!id) return;

  if (e.target.classList.contains("btn-comprado")) {
    marcarComprado(id);
  } else if (e.target.classList.contains("btn-eliminar")) {
    eliminarArticulo(id);
  }
});

renderizar();