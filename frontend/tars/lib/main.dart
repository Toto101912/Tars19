import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/intro_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const TarsApp());
}

class TarsApp extends StatelessWidget {
  const TarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TARS',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFBB37E6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB37E6),
          secondary: Color(0xFF00E5FF),
        ),
      ),
      home: const IntroScreen(),
    );
  }
}
