// =============================================
//  compras.js — Módulo Lista de Compras
// =============================================

let productos = [];

// ── Agregar producto ──────────────────────────
function agregarProducto() {
  const inputNombre   = document.getElementById('inputProducto');
  const inputCantidad = document.getElementById('inputCantidad');
  const error         = document.getElementById('mensajeError');

  const nombre   = inputNombre.value.trim();
  const cantidad = parseInt(inputCantidad.value);

  // Validaciones
  if (!nombre) {
    mostrarError('⚠️ Escribe el nombre del producto.');
    inputNombre.focus();
    return;
  }
  if (!cantidad || cantidad < 1) {
    mostrarError('⚠️ La cantidad debe ser mayor a 0.');
    inputCantidad.focus();
    return;
  }

  // Verificar duplicado
  const existe = productos.find(p => p.nombre.toLowerCase() === nombre.toLowerCase());
  if (existe) {
    mostrarError('⚠️ Ese producto ya está en la lista.');
    return;
  }

  // Crear objeto producto
  const producto = {
    id:         Date.now(),
    nombre:     nombre,
    cantidad:   cantidad,
    completado: false
  };

  productos.push(producto);
  limpiarError();
  inputNombre.value   = '';
  inputCantidad.value = 1;
  inputNombre.focus();

  renderizarLista();
}

// ── Eliminar producto ─────────────────────────
function eliminarProducto(id) {
  productos = productos.filter(p => p.id !== id);
  renderizarLista();
}

// ── Marcar como completado ────────────────────
function toggleCompletado(id) {
  const producto = productos.find(p => p.id === id);
  if (producto) {
    producto.completado = !producto.completado;
    renderizarLista();
  }
}

// ── Limpiar toda la lista ─────────────────────
function limpiarLista() {
  if (productos.length === 0) return;
  const confirmar = confirm('¿Seguro que quieres eliminar toda la lista?');
  if (confirmar) {
    productos = [];
    renderizarLista();
  }
}

// ── Renderizar la lista en el HTML ────────────
function renderizarLista() {
  const ul         = document.getElementById('listaProductos');
  const listaVacia = document.getElementById('listaVacia');
  const totalEl    = document.getElementById('totalProductos');
  const cantidadEl = document.getElementById('totalCantidad');

  // Limpiar lista
  ul.innerHTML = '';

  // Mostrar/ocultar mensaje vacío
  if (productos.length === 0) {
    listaVacia.style.display = 'block';
    totalEl.textContent    = '0';
    cantidadEl.textContent = '0';
    return;
  }

  listaVacia.style.display = 'none';

  // Actualizar contadores
  totalEl.textContent    = productos.length;
  cantidadEl.textContent = productos.reduce((acc, p) => acc + p.cantidad, 0);

  // Crear cada item
  productos.forEach(producto => {
    const li = document.createElement('li');
    li.classList.add('item-producto');
    if (producto.completado) li.classList.add('completado');

    li.innerHTML = `
      <button class="btn-check" onclick="toggleCompletado(${producto.id})" title="Marcar"></button>
      <span class="item-nombre">${producto.nombre}</span>
      <span class="item-cantidad">x${producto.cantidad}</span>
      <button class="btn-eliminar" onclick="eliminarProducto(${producto.id})" title="Eliminar">✕</button>
    `;

    ul.appendChild(li);
  });
}

// ── Enter para agregar ────────────────────────
function handleEnter(event) {
  if (event.key === 'Enter') agregarProducto();
}

// ── Mensajes de error ─────────────────────────
function mostrarError(msg) {
  document.getElementById('mensajeError').textContent = msg;
}
function limpiarError() {
  document.getElementById('mensajeError').textContent = '';
}

// ── Inicializar ───────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  renderizarLista();
});