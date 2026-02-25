import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/voice_service.dart'; // Asegúrate de tener este import
import 'mode_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _cmdController = TextEditingController();
  final VoiceService _voiceService = VoiceService(); // El oído de TARS
  bool _isAutoListening = false;
  String _voiceStatus = "ESPERANDO COMANDO...";

  @override
  void initState() {
    super.initState();
    // Iniciar escucha automática tras un breve delay para que la animación cargue
    Future.delayed(const Duration(seconds: 2), () => _startVoiceUnlock());
  }

  // --- LÓGICA DE DESBLOQUEO POR VOZ ---
  void _startVoiceUnlock() async {
    await _voiceService.init();
    setState(() {
      _isAutoListening = true;
      _voiceStatus = "ESCUCHANDO 'INICIAR TARS'...";
    });

    await _voiceService.listen(
      onListeningState: (state) => setState(() => _isAutoListening = state),
      onResult: (text) {
        print("Voz detectada: $text");
        // Verificamos si la frase mágica está en lo que dijiste
        if (text.toLowerCase().contains("iniciar tars") || text.toLowerCase().contains("tars")) {
          _accessGranted();
        } else {
          setState(() => _voiceStatus = "COMANDO INCORRECTO. REINTENTE.");
          // Reiniciar escucha tras error
          Future.delayed(const Duration(seconds: 2), () => _startVoiceUnlock());
        }
      },
    );
  }

  void _accessGranted() {
    _voiceService.speak("Acceso concedido. Bienvenido de nuevo.");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ModeScreen())
    );
  }

  void _checkManualCommand(String value) {
    if (value.toLowerCase().trim() == 'chat' || value.toLowerCase().trim() == 'tars') {
      _accessGranted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                    colors: [Color(0xFF1a0033), Colors.black],
                    radius: 0.8
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text("TARS OS v4.0", style: GoogleFonts.shareTechMono(color: Colors.white54)),

                const Spacer(),

                // ORBE DE ESTADO (Cambia de color si escucha)
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: _isAutoListening ? Colors.cyanAccent.withOpacity(0.3) : const Color(0xFFBB37E6).withOpacity(0.3),
                                  blurRadius: 40
                              )
                            ]
                        ),
                        child: Icon(
                            _isAutoListening ? Icons.graphic_eq : Icons.lock_outline,
                            size: 80,
                            color: _isAutoListening ? Colors.cyanAccent : const Color(0xFFBB37E6)
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 1000.ms),

                      const SizedBox(height: 30),
                      Text(_voiceStatus,
                          style: GoogleFonts.shareTechMono(
                              color: _isAutoListening ? Colors.cyanAccent : Colors.white,
                              fontSize: 14,
                              letterSpacing: 2
                          )
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // RESPALDO MANUAL (TEXTO)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: GlassmorphicContainer(
                    width: double.infinity, height: 60,
                    borderRadius: 15, blur: 20, alignment: Alignment.center, border: 2,
                    linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
                    borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.2)]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _cmdController,
                        style: GoogleFonts.shareTechMono(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "> Ingrese código o use voz...",
                          hintStyle: GoogleFonts.shareTechMono(color: Colors.white30),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_upward, color: Color(0xFFBB37E6)),
                            onPressed: () => _checkManualCommand(_cmdController.text),
                          ),
                        ),
                        onSubmitted: _checkManualCommand,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}