# 📋 Gestión Integral

Aplicación web de gestión personal que permite administrar tareas, registrar compras y hacer seguimiento de actividades desde un dashboard centralizado con autenticación de usuario.

---

## ✨ Características

- **Autenticación de usuario** — Formulario de login con validación de campos (formato de correo, longitud de contraseña) y gestión de sesión mediante `localStorage`.
- **Dashboard con navegación por cards** — Panel principal que centraliza el acceso a los tres módulos mediante tarjetas interactivas.
- **Gestión de Tareas** — Listado de tareas con acciones de completar, modificar y eliminar; filtrado por categoría y asignación de prioridad y etiquetas.
- **Seguimiento de Actividades** — Registro de actividades con niveles de prioridad (baja, media, alta), contador de estadísticas (total, pendientes, completadas) y limpieza de lista.
- **Lista de Compras** — Módulo para el control de artículos de compra (en desarrollo).
- **Módulo Python independiente** — Lógica de tareas implementada también en Python (`src/tareas.py`) con funciones de agregar, listar, completar, filtrar, priorizar y etiquetar tareas.
- **Diseño responsivo** — Adaptación a dispositivos móviles, tabletas y escritorio en todos los módulos.
- **Accesibilidad de movimiento** — Animaciones CSS respetan la preferencia `prefers-reduced-motion` del sistema operativo del usuario.
- **Linting de código** — Configuración de herramientas de análisis estático para HTML, JavaScript y CSS.

---

## 🛠️ Tecnologías

| Tecnología | Uso |
|---|---|
| HTML5 | Estructura y marcado de todas las páginas |
| CSS3 | Estilos, animaciones y diseño responsivo |
| JavaScript ES6 | Lógica de negocio en el navegador |
| Python 3 | Módulo de gestión de tareas en backend independiente |

---

## 📋 Prerrequisitos

- Navegador web moderno con soporte para ES6 y `localStorage`
- Python 3.x instalado (únicamente para ejecutar `src/tareas.py`)
- No requiere servidor ni instalación adicional para la parte web

---

## 📦 Dependencias

### Librerías externas (cargadas desde CDN — confirmadas en archivos fuente)

| Dependencia | Versión | Licencia | Propósito |
|---|---|---|---|
| Ionicons | 4.5.10-0 | MIT | Iconos SVG para acciones en `tareas.html` (completar, editar, eliminar) |
| Google Fonts — Inter | — | OFL-1.1 | Tipografía principal en módulo de actividades |
| Google Fonts — Poppins | — | OFL-1.1 | Tipografía principal en módulo de tareas |

### Herramientas de desarrollo (confirmadas por archivos de configuración)

| Herramienta | Archivo de config | Propósito |
|---|---|---|
| HTMLHint | `.htmlhintrc` | Análisis estático de HTML |
| JSHint | `.jshintrc` | Análisis estático de JavaScript (target ES6) |
| Stylelint | `.stylelintrc.json` | Análisis estático de CSS |

---

## 📁 Estructura del Proyecto

```
gestion-tareas/
│
├── index.html              # Dashboard principal — navegación por cards
├── login.html              # Página de autenticación
├── tareas.html             # Módulo de gestión de tareas
├── actividades.html        # Módulo de seguimiento de actividades
├── compras.html            # Módulo de lista de compras (en desarrollo)
│
├── agregar-tarea.js        # Módulo JS para agregar tareas
├── eliminar-tarea.js       # Módulo JS para eliminar tareas
├── fix-ui.css              # Correcciones puntuales de estilos UI
│
├── css/
│   ├── login.css           # Estilos del formulario de login
│   ├── index.css           # Estilos del dashboard principal
│   ├── tareas.css          # Estilos del módulo de tareas
│   └── actividades.css     # Estilos del módulo de actividades
│
├── js/
│   ├── login.js            # Validación y autenticación del login
│   ├── index.js            # Verificación de sesión y carga del dashboard
│   ├── tareas.js           # Lógica de tareas en el navegador
│   └── actividades.js      # Lógica de actividades (CRUD + estadísticas)
│
├── src/
│   └── tareas.py           # Módulo Python de gestión de tareas
│
├── img/                    # Directorio de recursos de imagen
│
├── .htmlhintrc             # Configuración HTMLHint
├── .jshintrc               # Configuración JSHint (ES6, browser)
├── .stylelintrc.json       # Configuración Stylelint
└── .gitignore              # Exclusiones de Git (*.pyc, __pycache__, .env)
```

---

## 📞 Contacto

| Campo | Detalle |
|---|---|
| Institución | Universidad Tecnológica del Perú (UTP) |
| Curso | Herramientas de Desarrollo |
| Ciclo | V |

---

## 📚 Documentación adicional

- [INSTALACION_Y_EJECUCION.md](INSTALACION_Y_EJECUCION.md)
- [GITFLOW.md](GITFLOW.md)

## Función A: notificaciones de tareas
