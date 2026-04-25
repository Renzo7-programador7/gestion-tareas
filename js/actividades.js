let actividades = [];

function agregarActividad() {
  const input = document.getElementById('actividadInput');
  const prioridad = document.getElementById('prioridadSelect').value;
  const nombre = input.value.trim();

  if (!nombre) {
    alert('Escribe una actividad');
    return;
  }

  const actividad = {
    id: Date.now(),
    nombre,
    prioridad,
    completada: false
  };

  actividades.push(actividad);
  input.value = '';
  renderActividades();
}

function toggleCompletada(id) {
  actividades = actividades.map(a =>
    a.id === id ? { ...a, completada: !a.completada } : a
  );
  renderActividades();
}

function eliminarActividad(id) {
  actividades = actividades.filter(a => a.id !== id);
  renderActividades();
}

function limpiarTodo() {
  if (actividades.length === 0) return;
  if (confirm('¿Eliminar todas las actividades?')) {
    actividades = [];
    renderActividades();
  }
}

function actualizarContadores() {
  const total = actividades.length;
  const completadas = actividades.filter(a => a.completada).length;
  const pendientes = total - completadas;

  document.getElementById('totalCount').textContent = total;
  document.getElementById('completadoCount').textContent = completadas;
  document.getElementById('pendienteCount').textContent = pendientes;
}

function renderActividades() {
  const lista = document.getElementById('actividadesList');
  lista.innerHTML = '';

  actividades.forEach(a => {
    const li = document.createElement('li');
    li.className = `actividad-item ${a.completada ? 'completada' : ''}`;
    li.innerHTML = `
      <input type="checkbox" ${a.completada ? 'checked' : ''} onchange="toggleCompletada(${a.id})"/>
      <span class="actividad-nombre">${a.nombre}</span>
      <span class="prioridad-badge prioridad-${a.prioridad}">${a.prioridad}</span>
      <button class="btn-eliminar" onclick="eliminarActividad(${a.id})">🗑️</button>
    `;
    lista.appendChild(li);
  });

  actualizarContadores();
}