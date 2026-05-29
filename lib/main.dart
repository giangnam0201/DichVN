import 'package:flutter/material.dart';
import 'screens/translator_screen.dart';

void main() {
  runApp(const DichVNApp());
}

class DichVNApp extends StatelessWidget {
  const DichVNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DichVN Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const TranslatorScreen(),
    );
  }
}
