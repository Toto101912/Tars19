import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../painters/tars_graphics.dart';
import 'neural_screen.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(painter: QuantumGridPainter(), size: Size.infinite),

          Center(
            child: GestureDetector(
              onTap: () {
                // Navegar al chat visualizador
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NeuralScreen()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // EL BOTÓN EAR (Oído)
                  Container(
                    width: 180, height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFBB37E6), width: 2),
                      boxShadow: [BoxShadow(color: const Color(0xFFBB37E6),blurRadius: 50)],
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.hearing, size: 80, color: Colors.white),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: 1500.ms),

                  const SizedBox(height: 40),

                  Text("INTRODUCE COMANDO",
                      style: GoogleFonts.shareTechMono(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)
                  ).animate().fadeIn().slideY(begin: 0.5, end: 0),

                  const SizedBox(height: 10),
                  Text("Toca para iniciar enlace neural", style: GoogleFonts.shareTechMono(color: Colors.white38)),
                ],
              ),
            ),
          ),

          // Flecha indicadora del boceto
          Positioned(
            right: 30, top: MediaQuery.of(context).size.height * 0.45,
            child: Row(
              children: [
                Text("CHAT DE VOZ", style: GoogleFonts.shareTechMono(color: Colors.white30)).animate().fadeIn(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white30).animate(onPlay: (c) => c.repeat()).moveX(begin: 0, end: 10, duration: 1000.ms),
              ],
            ),
          )
        ],
      ),
    );
  }
}