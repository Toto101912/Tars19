import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // Asegúrate de que no tenga una '/' al final
  final String _baseUrl = "https://proyecto-tars.onrender.com";

  Future<String> sendMessage(String message) async {
    try {
      // 🔥 CORRECCIÓN: Cambiamos '/chat' por '/hablar' para coincidir con tu servidor
      final url = Uri.parse("$_baseUrl/hablar");
      print("📡 Enviando datos a TARS: $message");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "mensaje": message, // Coincide con tu modelo EntradaTARS en Python
          "humor": 70,
          "honestidad": 100,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Según tu código Python, la respuesta viene en esta clave
        return data['respuesta_tars'];
      } else {
        return "TARS: Error de protocolo (${response.statusCode}).";
      }
    } catch (e) {
      return "TARS: Error de conexión. El servidor podría estar iniciando.";
    }
  }
}