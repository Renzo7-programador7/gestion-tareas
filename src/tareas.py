tareas = []

def agregar_tarea(titulo, descripcion=""):
    tarea = {
        "id": len(tareas) + 1,
        "titulo": titulo,
        "descripcion": descripcion,
        "completada": False,
        "prioridad": "normal"
    }
    tareas.append(tarea)
    return tarea

def listar_tareas():
    return tareas

def completar_tarea(id_tarea):
    for t in tareas:
        if t["id"] == id_tarea:
            t["completada"] = True
            return t
    return None

def tarea_prioritaria(id_tarea):
    for t in tareas:
        if t["id"] == id_tarea:
            t["prioridad"] = "alta"
            return t
    return None
