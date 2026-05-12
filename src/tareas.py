tareas = []

def agregar_tarea(titulo, descripcion=""):
    tarea = {
        "id": len(tareas) + 1,
        "titulo": titulo,
        "descripcion": descripcion,
        "completada": False,
        "categoria": "general",
        "prioridad": "normal",
        "etiqueta": "sin-etiqueta"
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

def filtrar_por_categoria(categoria):
    return [t for t in tareas if t["categoria"] == categoria]

def tarea_prioritaria(id_tarea):
    for t in tareas:
        if t["id"] == id_tarea:
            t["prioridad"] = "alta"
            return t
    return None

def etiquetar_tarea(id_tarea, etiqueta):
    for t in tareas:
        if t["id"] == id_tarea:
            t["etiqueta"] = etiqueta
            return t
    return None
