# 🚀 Instalación y Ejecución del Proyecto

Guía práctica para instalar los componentes necesarios y ejecutar el proyecto Gestión Integral en entorno local.

---

## 1. Componentes necesarios

| Componente | ¿Obligatorio? | ¿Para qué se usa? |
|---|---|---|
| Navegador web moderno (Chrome, Edge, Firefox) | Sí | Ejecutar la aplicación web (login, dashboard, tareas, actividades, compras). |
| Python 3 | Recomendado | Levantar un servidor local para abrir correctamente todos los módulos web. |
| Git | Opcional | Clonar o actualizar el repositorio. |
| Node.js 20 | Opcional | Ejecutar validaciones de calidad (HTMLHint, JSHint, Stylelint), según pipeline CI. |

---

## 2. Obtener el proyecto

Si ya tienes la carpeta del proyecto, puedes pasar al paso 3.

Si aún no la tienes:

```powershell
git clone <URL_DEL_REPOSITORIO>
cd gestion-tareas
```

---

## 3. Ejecutar la aplicación web

### Opción recomendada: servidor local con Python

Desde la raíz del proyecto:

```powershell
python -m http.server
```

Luego abre en tu navegador la URL que aparezca en la terminal y entra a:

- `login.html` para iniciar sesión
- `index.html` para ir al panel principal

Esta opción evita problemas de carga de rutas en los módulos HTML/CSS/JS.

### Opción directa (solo pruebas rápidas)

También puedes abrir `login.html` con doble clic, pero algunos módulos pueden no comportarse igual que con servidor local.

---

## 4. Credenciales de acceso (modo demo)

El proyecto incluye usuarios de prueba definidos en el login:

- Admin:
  - Correo: `admin@example.com`
  - Contraseña: `admin123`
- Usuario:
  - Correo: `user@example.com`
  - Contraseña: `user123`

---

## 5. Ejecutar módulo Python de tareas (opcional)

El archivo `src/tareas.py` contiene funciones de gestión de tareas.

Ejecución directa:

```powershell
python src/tareas.py
```

Nota: este módulo define funciones (agregar, listar, completar, filtrar, priorizar y etiquetar), por lo que está pensado para importarse o integrarse en pruebas, no como aplicación interactiva de consola.

---

## 6. Validar calidad del código (opcional)

Estas validaciones están alineadas con los workflows CI del repositorio.

### 6.1 Instalar herramientas

```powershell
npm install -g htmlhint
npm install -g jshint
npm install -g stylelint stylelint-config-standard
```

### 6.2 Ejecutar validaciones

```powershell
htmlhint "**/*.html"
jshint --config .jshintrc (Get-ChildItem -Recurse -Filter *.js | Where-Object { $_.FullName -notmatch "\\.github\\" } | ForEach-Object { $_.FullName })
stylelint "**/*.css" --config .stylelintrc.json
```

---

## 7. Solución de problemas comunes

| Problema | Causa posible | Solución |
|---|---|---|
| No cargan estilos o scripts en algunas páginas | Apertura directa de archivos sin servidor local | Ejecuta el proyecto con `python -m http.server`. |
| No pasa del login | Credenciales incorrectas | Usa los usuarios demo indicados en esta guía. |
| Sesión no persiste | `localStorage` bloqueado por configuración del navegador | Habilita almacenamiento local o prueba en otro navegador. |
| Fallan validaciones de lint | Herramientas no instaladas globalmente | Instala los paquetes indicados en la sección 6. |

---

## 8. Flujo mínimo recomendado para cualquier perfil

1. Abrir terminal en la carpeta del proyecto.
2. Ejecutar `python -m http.server`.
3. Abrir navegador en la URL mostrada por la terminal.
4. Entrar a `login.html`.
5. Iniciar sesión con credenciales demo.
6. Navegar a Tareas, Compras y Actividades desde el dashboard.
