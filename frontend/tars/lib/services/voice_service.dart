import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool isInitialized = false;

  Future<void> init() async {
    if (!isInitialized) {
      await _speech.initialize();
      await _tts.setLanguage("es-ES"); // Español
      await _tts.setPitch(0.6);        // Voz grave (TARS)
      await _tts.setSpeechRate(0.5);   // Velocidad calmada
      isInitialized = true;
    }
  }

  // Escuchar al humano
  Future<void> listen({required Function(String) onResult, required Function(bool) onListeningState}) async {
    if (!_speech.isAvailable) await init();

    onListeningState(true);
    _speech.listen(
      onResult: (val) {
        if (val.finalResult) {
          onListeningState(false);
          onResult(val.recognizedWords);
        }
      },
      localeId: "es-ES",
      cancelOnError: true,
    );
  }

  void stopListening() {
    _speech.stop();
  }

  // TARS habla
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }
}