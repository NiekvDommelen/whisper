import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/homepage.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/chatpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisper',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromARGB(255, 81, 43, 129),
          onPrimary: const Color.fromARGB(255, 68, 119, 206),
          secondary: const Color.fromARGB(255, 53, 21, 93),
          onSecondary: const Color.fromARGB(40, 84, 35, 146),
          surface: const Color.fromARGB(255, 53, 21, 93),
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 53, 21, 93),
        ),
      ),
      // Check user authentication status and route accordingly
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}