# 🌿 Documentación GitFlow — Gestión Integral

> **¿Para quién es este documento?**
> Para cualquier integrante del equipo, independientemente de su rol. No es necesario ser programador para entender cómo se organizó el trabajo en este proyecto. Cada sección explica el *qué* y el *por qué* antes del *cómo*.

---

## ¿Qué es GitFlow y por qué lo usamos?

Imagina que el proyecto es un edificio en construcción. No puedes derrumbar las paredes terminadas solo porque alguien quiere probar un diseño nuevo. GitFlow es el sistema de reglas que nos permite **construir partes nuevas sin afectar lo que ya funciona**.

En términos simples: GitFlow define **cómo se crea, revisa e integra cada cambio** al proyecto, de modo que el código que llega a los usuarios siempre sea estable.

---

## 🏛️ Las ramas del proyecto (las "líneas de trabajo")

Una **rama** es una copia independiente del proyecto donde se puede trabajar sin tocar el resto. Este proyecto usa la siguiente estructura:

```
main
 └── develop
      ├── feature/login
      ├── feature/PanelPrincipal
      ├── feature/actividades
      ├── feature/compras
      ├── feature/agregar-tarea
      ├── feature/eliminar-tarea
      ├── feature/ci-pipeline
      ├── feature/Documentacion
      ├── hotfix/correccion-ui
      └── hotfix/conflicto-resuelto
```

### Descripción de cada tipo de rama

| Rama | Propósito | ¿Quién la toca? | Estado |
|---|---|---|---|
| `main` | Versión oficial y estable del proyecto. Lo que "está en producción". | Solo mediante Pull Request aprobado | 🟢 Protegida |
| `develop` | Zona de integración. Aquí se reúnen todos los módulos terminados antes de pasar a `main`. | El equipo completo, tras revisión | 🔵 Activa |
| `feature/*` | Desarrollo de una funcionalidad nueva. Cada módulo tiene su propia rama. | El desarrollador asignado | 🟡 Temporal |
| `hotfix/*` | Corrección urgente de un error detectado. | El desarrollador que identifica el problema | 🔴 Urgente |

---

## 👥 Equipo y contribuciones

Estos son los colaboradores identificados en el historial real del repositorio:

| Colaborador (usuario Git) | Contribuciones registradas |
|---|---|
| `Renzo7-programador7` / `Renzo` | Estructura base, módulo de tareas (categorías, prioridades, etiquetas), hotfix de conflicto, CI |
| `ManuelGordillo` | Módulo de actividades, archivos de tareas, hotfix del botón agregar |
| `Carlos Infantas` / `CodeCaim` | Página de login, panel principal (dashboard) |
| `vegitto` | Módulo de actividades (versión inicial y mejorada) |
| `otrcosa59-ops` | Integración del pipeline de CI/CD (GitHub Actions) |

---

## 📅 Historial cronológico del proyecto

A continuación, el flujo real de trabajo desde el primer commit hasta hoy:

---

### Fase 1 — Inicio del proyecto
**21 de abril de 2026**

| Commit | Descripción | Autor | Rama |
|---|---|---|---|
| `1f58513` | Estructura inicial del proyecto | Renzo7-programador7 | `main` |

> Se crea el repositorio y se establece la estructura de carpetas base. Este commit es el único que va directamente a `main`, ya que representa el punto de partida vacío.

---

### Fase 2 — Desarrollo de los primeros módulos
**24 de abril de 2026**

| Commit | Descripción | Autor | Rama de origen |
|---|---|---|---|
| `2969524` | Se agrega página de logueo | Carlos Infantas | `feature/login` |
| `842e56b` | Se agrega página de inicio (dashboard) | Carlos Infantas | `feature/PanelPrincipal` |
| `d7bd8ec` | Se agrego módulo de Actividades | vegitto | `feature/actividades` |
| `284c086` | Módulo de actividades mejorado | vegitto | `feature/actividades` |
| `d108c82` | *(Merge PR #3)* Login integrado a develop | CodeCaim | `develop` ← `feature/login` |
| `9f299b1` | *(Merge PR #4)* Panel principal integrado a develop | CodeCaim | `develop` ← `feature/PanelPrincipal` |

> Tres desarrolladores trabajaron en paralelo el mismo día sin interferirse entre sí. Cada uno en su propia rama `feature/`.

---

### Fase 3 — Expansión del módulo de tareas
**25 – 28 de abril de 2026**

| Commit | Descripción | Autor | Rama |
|---|---|---|---|
| `27b90ea` | Agregando archivos de la sección tareas (`tareas.html`, `tareas.css`) | ManuelGordillo | `develop` |
| `468b4bc` | Merge de `feature/actividades` a `develop` | ManuelGordillo | `develop` |

---

### Fase 4 — Funcionalidades avanzadas y correcciones
**11 de mayo de 2026**

| Commit | Descripción | Autor | Rama de origen |
|---|---|---|---|
| `133f93a` | Se agregó módulo para agregar tareas | Renzo | `feature/agregar-tarea` |
| `2c8e828` | *(Merge PR #6)* Módulo agregar-tarea a develop | Renzo7-programador7 | `develop` |
| `e24d707` | Se agregó módulo para eliminar tareas | Renzo | `feature/eliminar-tarea` |
| `49cfd0a` | *(Merge PR #8)* Módulo eliminar-tarea a develop | Renzo7-programador7 | `develop` |
| `2101771` | Se corrigieron errores de interfaz | Renzo | `hotfix/correccion-ui` |
| `0d797dd` | *(Merge PR #7)* Hotfix UI a develop | Renzo7-programador7 | `develop` |

> En esta fase se usó un **hotfix** para corregir errores visuales detectados durante la integración. Este es el uso correcto de una rama `hotfix/`: corregir sin parar el desarrollo de otras funcionalidades.

---

### Fase 5 — Módulo de tareas completo
**12 de mayo de 2026**

| Commit | Descripción | Autor | Rama |
|---|---|---|---|
| `1c11e7e` | feat: estructura base del proyecto | Renzo7-programador7 | `develop` |
| `b434473` | feat: agregar categoría a las tareas | Renzo7-programador7 | `develop` |
| `0ad43e5` | feat: agregar prioridad a las tareas | Renzo7-programador7 | `develop` |
| `e3ee6fd` | fix: resolver conflicto entre categoría y prioridad | Renzo7-programador7 | `develop` |
| `19d8506` | feat: agregar etiquetas a las tareas | Renzo7-programador7 | `hotfix/conflicto-resuelto` |
| `b8c0106` | feat: agregar etiquetas a las tareas | Renzo7-programador7 | `hotfix/conflicto-resuelto` |
| `f78c122` | *(Merge PR #9)* Hotfix conflicto a develop | Renzo7-programador7 | `develop` |
| `b2b6ea7` | ci: agregar workflow de GitHub Actions | Renzo7-programador7 | `develop` |

> Se presenta un **conflicto de integración** entre dos funcionalidades desarrolladas en paralelo (categoría y prioridad). El equipo lo resolvió usando una rama `hotfix/conflicto-resuelto`, que es una práctica válida para conflictos críticos.

---

### Fase 6 — CI/CD y correcciones finales
**13 – 14 de mayo de 2026**

| Commit | Descripción | Autor | Rama de origen |
|---|---|---|---|
| `ae38d4c` | Hotfix: corrección botón de agregar tareas | ManuelGordillo | `develop` |
| `cfcbbe4` | ci: agregar workflow de GitHub Actions | otrcosa59-ops | `feature/ci-pipeline` |
| `d5b55b1` | *(Merge PR #10)* CI pipeline a develop | otrcosa59-ops | `develop` ← `feature/ci-pipeline` |

> Se incorpora **automatización mediante GitHub Actions**. Esto significa que a partir de este punto, ciertas verificaciones del código pueden ejecutarse automáticamente al hacer cambios, reduciendo errores humanos en las revisiones.

---

## 🔄 El ciclo de vida de un cambio (paso a paso)

Este es el proceso que **todo cambio debe seguir** en este proyecto:

```
1. IDENTIFICAR la tarea o problema
        │
        ▼
2. CREAR una rama nueva desde develop
   (nombre: feature/nombre-funcionalidad
            hotfix/descripcion-del-error)
        │
        ▼
3. DESARROLLAR el cambio en esa rama
   (puede tener uno o varios commits)
        │
        ▼
4. ABRIR un Pull Request hacia develop
   (solicitud de revisión al equipo)
        │
        ▼
5. REVISAR el código con otro integrante
        │
        ▼
6. INTEGRAR (merge) a develop si está aprobado
        │
        ▼
7. ELIMINAR la rama feature una vez integrada
        │
        ▼
8. Cuando develop es estable → MERGE a main
```

---

## ⚠️ Convenciones de nombres de commits usadas en el proyecto

Los mensajes de commit siguen un patrón para que cualquiera entienda qué cambió con solo leerlos:

| Prefijo | Significado | Ejemplo real del proyecto |
|---|---|---|
| `feat:` | Se agrega una nueva funcionalidad | `feat: agregar prioridad a las tareas` |
| `fix:` | Se corrige un error | `fix: resolver conflicto entre categoria y prioridad` |
| `ci:` | Cambios en automatización o configuración de despliegue | `ci: agregar workflow de GitHub Actions` |
| `Hotfix:` | Corrección urgente (usado sin prefijo estándar en algunos casos) | `Hotfix: correccion boton de agregar tareas` |
| *(sin prefijo)* | Commit descriptivo libre | `Se agrega página de logueo` |

---

## 📊 Resumen estadístico del repositorio

| Métrica | Valor |
|---|---|
| Total de commits | 25 |
| Ramas activas (locales + remotas) | 10 |
| Pull Requests integrados | 10 (PR #1 al #10) |
| Colaboradores | 5 |
| Período de desarrollo | 21 abril – 14 mayo de 2026 |
| Hotfixes realizados | 3 (`correccion-ui`, `conflicto-resuelto`, botón agregar) |

---

## ✅ Buenas prácticas aplicadas en este proyecto

- **Una funcionalidad = una rama**: Cada módulo (login, actividades, tareas, etc.) tuvo su propia rama `feature/`.
- **`main` nunca recibe commits directos**: Todo cambio pasa primero por `develop`.
- **Pull Requests como punto de revisión**: Ninguna integración a `develop` se hizo sin un PR documentado.
- **Hotfixes aislados**: Los errores urgentes se corrigieron en ramas separadas sin bloquear el desarrollo activo.
- **CI/CD integrado**: Se automatizaron verificaciones con GitHub Actions para reducir errores manuales.
