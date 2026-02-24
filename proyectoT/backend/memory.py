import json
import os
import re

MEMORY_PATH = "tars/data/memory.json"


class TarsMemory:
    def __init__(self, max_messages=100):
        self.max_messages = max_messages
        self.data = self._load_memory()

    def _load_memory(self):
        if not os.path.exists(MEMORY_PATH):
            return {"nombre": None, "historial": []}

        with open(MEMORY_PATH, "r", encoding="utf-8") as f:
            return json.load(f)

    def _save_memory(self):
        with open(MEMORY_PATH, "w", encoding="utf-8") as f:
            json.dump(self.data, f, ensure_ascii=False, indent=2)

    def add(self, role, content):
        self.data["historial"].append({
            "role": role,
            "content": content
        })

        # limitar tamaño
        self.data["historial"] = self.data["historial"][-self.max_messages:]
        self._save_memory()

    def get_context(self):
        return self.data["historial"]

    def set_nombre(self, nombre):
        self.data["nombre"] = nombre
        self._save_memory()

    def get_nombre(self):
        return self.data.get("nombre")


def extraer_nombre(texto: str):
    patrones = [
        r"me llamo (\w+)",
        r"mi nombre es (\w+)",
        r"soy (\w+)",
        r"mi identidad es (\w+)"
    ]

    texto = texto.lower()

    for patron in patrones:
        match = re.search(patron, texto)
        if match:
            return match.group(1).capitalize()

    return None
