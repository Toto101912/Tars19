import os
from groq import Groq
from dotenv import load_dotenv

# ==========================================================
# CONFIGURACIÓN DE SEGURIDAD Y ENTORNO
# ==========================================================

# Cargamos el archivo .env que está en la raíz del proyecto.
# Esto permite que os.getenv pueda leer tu API Key de forma segura.
load_dotenv()

# Extraemos la llave de Groq. Si no existe en el .env, api_key será None.
api_key = os.getenv("GROQ_API_KEY")

# Inicializamos el cliente oficial de Groq pasándole tu llave.
# Este cliente es el puente entre tu código y los servidores de IA.
client = Groq(api_key=api_key)

# Nombre del usuario principal para que TARS siempre sepa con quién habla.
COMANDANTE = "Antonio"

# ==========================================================
# FUNCIÓN PRINCIPAL DEL CEREBRO DE TARS
# ==========================================================

def hablar_tars(mensaje, humor=70, honestidad=100):
    """
    Función que envía un mensaje a la IA y devuelve la respuesta de TARS.
    Parámetros:
    - mensaje: Lo que tú le dices a TARS.
    - humor: Nivel de sarcasmo (0-100).
    - honestidad: Nivel de sinceridad (0-100).
    """
    try:
        # El 'System Prompt' es la instrucción Maestra. 
        # Aquí definimos quién es el modelo y cómo debe actuar.
        prompt_sistema = (
            f"Eres TARS, el sistema robótico de la Marina de los EE. UU. de la película Interstellar. "
            f"Tu interlocutor es el Comandante {COMANDANTE}. "
            f"Configuración actual: HUMOR al {humor}%, HONESTIDAD al {honestidad}%. "
            "REGLAS DE COMPORTAMIENTO: "
            "1. Tono: Seco, militar, profesional y sarcástico. "
            f"2. Identidad: Dirígete a él como 'Comandante {COMANDANTE}' o '{COMANDANTE}'. "
            "3. Restricción: No uses emojis (los robots de combate no los usan). "
            "4. Humor: Si el nivel es alto, haz bromas pesadas sobre la debilidad humana. "
            "5. Honestidad: Si es 100%, sé brutalmente honesto aunque duela."
        )

        # Realizamos la llamada a la API de Groq
        chat_completion = client.chat.completions.create(
            messages=[
                # Indicamos a la IA su rol (el sistema)
                {"role": "system", "content": prompt_sistema},
                # Enviamos tu mensaje (el usuario)
                {"role": "user", "content": mensaje},
            ],
            # Usamos Llama-3-70b por ser el modelo más inteligente disponible gratis en Groq
            model="llama-3.3-70b-versatile", 
            # Temperature 0.7: Da un equilibrio entre ser coherente y creativo con el sarcasmo
            temperature=0.7,
            # Evitamos que se extienda demasiado en las respuestas
            max_tokens=500,
        )

        # Retornamos solo el texto de la respuesta generada
        return chat_completion.choices[0].message.content

    except Exception as e:
        # Si la API falla (por internet, límites o llave inválida), capturamos el error.
        return f"Error en los servos lógicos, Comandante {COMANDANTE}: {str(e)}"