from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import time

# Importaciones de tus módulos locales
from Tars_api.core import hablar_tars
from Tars_api.memory import extraer_nombre

app = FastAPI(
    title="TARS - Tactical Adaptive Robotic System",
    description="Interfaz de IA de Grado Militar - Propiedad del Comandante Antonio",
    version="3.3.0"
)

# --- CONFIGURACIÓN DE SEGURIDAD (CORS) ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class EntradaTARS(BaseModel):
    mensaje: str = Field(..., example="TARS, reporte de situación.")
    humor: int = Field(default=70, ge=0, le=100)
    honestidad: int = Field(default=100, ge=0, le=100)

@app.get("/")
def root():
    """Panel de control de sistemas de TARS"""
    return {
        "sistema": "TARS",
        "estado": "Operativo / En Órbita",
        "comandante": "Antonio",
        "motor_actual": "Groq Llama-3.3-70B-Versatile",
        "protocolo": "Rescate de Datos",
        "mensaje_del_sistema": "Sistemas listos. ¿Listo para que te mienta un poco, Señor?"
    }

@app.post("/hablar")
async def hablar_principal(data: EntradaTARS):
    """Protocolo de comunicación principal"""
    inicio_proceso = time.time()
    try:
        # Detección de interlocutor
        nombre_detectado = extraer_nombre(data.mensaje) or "Antonio"
        
        # Procesamiento con el motor Llama 3.3 (Vía hablar_tars en core.py)
        respuesta = hablar_tars(
            mensaje=data.mensaje,
            humor=data.humor,
            honestidad=data.honestidad
        )

        latencia = f"{round(time.time() - inicio_proceso, 2)}s"

        # Respuesta con formato de grado militar
        return {
            "status": "online",
            "respuesta_tars": respuesta,
            "diagnostico": {
                "interlocutor": nombre_detectado,
                "humor_aplicado": f"{data.humor}%",
                "honestidad": f"{data.honestidad}%",
                "latencia_procesamiento": latencia,
                "motor": "Llama-3.3-70B-Versatile"
            }
        }
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Fallo en los servos lógicos: {str(e)}"
        ) from e