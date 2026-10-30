import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JalRakshaApp());
}

class JalRakshaApp extends StatelessWidget {
  const JalRakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jal Raksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087E8B)),
        scaffoldBackgroundColor: const Color(0xFFF4FAFB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
