import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

import tareas as tareas_module


def setup_function():
    # Reinicia la lista de tareas antes de cada prueba
    tareas_module.tareas.clear()


def test_agregar_tarea():
    tarea = tareas_module.agregar_tarea("Estudiar para el examen")
    assert tarea["titulo"] == "Estudiar para el examen"
    assert tarea["completada"] is False
    assert tarea["id"] == 1


def test_listar_tareas():
    tareas_module.agregar_tarea("Tarea 1")
    tareas_module.agregar_tarea("Tarea 2")
    resultado = tareas_module.listar_tareas()
    assert len(resultado) == 2


def test_completar_tarea():
    tarea = tareas_module.agregar_tarea("Lavar el auto")
    completada = tareas_module.completar_tarea(tarea["id"])
    assert completada["completada"] is True


def test_completar_tarea_inexistente():
    resultado = tareas_module.completar_tarea(999)
    assert resultado is None


def test_filtrar_por_categoria():
    tareas_module.agregar_tarea("Tarea general")
    resultado = tareas_module.filtrar_por_categoria("general")
    assert len(resultado) == 1
    assert resultado[0]["categoria"] == "general"


def test_tarea_prioritaria():
    tarea = tareas_module.agregar_tarea("Tarea urgente")
    actualizada = tareas_module.tarea_prioritaria(tarea["id"])
    assert actualizada["prioridad"] == "alta"


def test_etiquetar_tarea():
    tarea = tareas_module.agregar_tarea("Tarea con etiqueta")
    actualizada = tareas_module.etiquetar_tarea(tarea["id"], "urgente")
    assert actualizada["etiqueta"] == "urgente"