import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../services/chat_service.dart';
import '../../services/voice_service.dart';
import '../painters/tars_graphics.dart';

class NeuralScreen extends StatefulWidget {
  const NeuralScreen({super.key});
  @override
  State<NeuralScreen> createState() => _NeuralScreenState();
}

class _NeuralScreenState extends State<NeuralScreen> with TickerProviderStateMixin {
  late AnimationController _energyCtrl;
  late AnimationController _pulseCtrl;

  final VoiceService _voiceService = VoiceService();
  final ChatService _apiService = ChatService();

  String _status = "ESPERANDO ORDEN";
  String _transcript = "";
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _energyCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _initSystem();
  }

  void _initSystem() async {
    await _voiceService.init();
    _voiceService.speak("Enlace neural establecido. Te escucho.");
  }

  // --- LÓGICA DEL BUCLE DE CONVERSACIÓN ---
  void _toggleListening() async {
    if (_isListening) {
      _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _status = "ESCUCHANDO...";
        _transcript = "";
        _isListening = true;
      });

      await _voiceService.listen(
        onListeningState: (state) => setState(() => _isListening = state),
        onResult: (text) async {
          setState(() {
            _transcript = text;
            _status = "PROCESANDO DATOS...";
            _processing = true;
          });

          // 1. Enviar a Render
          String response = await _apiService.sendMessage(text);

          setState(() {
            _processing = false;
            _status = "TRANSMITIENDO...";
            _isSpeaking = true;
          });

          // 2. Hablar respuesta
          await _voiceService.speak(response);

          setState(() {
            _isSpeaking = false;
            _status = "ESPERANDO...";
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _energyCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // FONDO ANIMADO
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _energyCtrl,
              builder: (_, __) => CustomPaint(
                painter: FractalEnergyPainter(
                  animationValue: _energyCtrl.value,
                  pulseValue: _pulseCtrl.value,
                  isSpeaking: _isSpeaking || _processing,
                ),
              ),
            ),
          ),

          // INTERFAZ DE CRISTAL (Overlay)
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),

                // ORBE CENTRAL (VISUALIZADOR)
                _buildCoreVisualizer(),

                const Spacer(),

                // TRANSCRIPCIÓN EN TIEMPO REAL
                if (_transcript.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('>> "$_transcript"',
                      style: GoogleFonts.shareTechMono(color: Colors.cyanAccent, fontSize: 16),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(),
                  ),

                // PANEL DE CONTROL INFERIOR
                _buildControlDeck(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreVisualizer() {
    return Container(
      width: 200, height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: _processing
              ? [Colors.cyan, Colors.transparent]
              : [const Color(0xFFBB37E6), Colors.transparent],
        ),
      ),
      child: Center(
        child: Icon(
          _isListening ? Icons.mic : (_isSpeaking ? Icons.graphic_eq : Icons.circle),
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildControlDeck() {
    return GlassmorphicContainer(
      width: double.infinity, height: 140,
      borderRadius: 40, blur: 20, alignment: Alignment.center, border: 0,
      linearGradient: LinearGradient(colors: [Colors.black, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
      borderGradient: const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_status, style: GoogleFonts.shareTechMono(color: const Color(0xFFDA70D6), letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGlassBtn(Icons.settings, "CONFIG", () {}),

              // BOTÓN PRINCIPAL DE MICRÓFONO
              GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: _isListening ? [Colors.red, Colors.orange] : [const Color(0xFFD500F9), const Color(0xFF651FFF)]),
                    boxShadow: [BoxShadow(color: const Color(0xFFD500F9), blurRadius: 20)],
                  ),
                  child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 30),
                ).animate(target: _isListening ? 1 : 0).scale(end: const Offset(1.2, 1.2)),
              ),

              _buildGlassBtn(Icons.chat_bubble, "TEXTO", () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBtn(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(onPressed: onTap, icon: Icon(icon, color: Colors.white54)),
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white54)),
          Text("MODO NEURAL", style: GoogleFonts.shareTechMono(color: Colors.white)),
          const Icon(Icons.wifi_tethering, color: Colors.greenAccent),
        ],
      ),
    );
  }
}