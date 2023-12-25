import 'package:flutter/material.dart';
import 'home/homepage.dart'; // Import the Home component
import 'views/register_view.dart'; // Import the Home component
import 'views/login_view.dart'; // Import the Home component
import 'views/verify_email_view.dart'; // Import the Verify Email component
import 'views/notes_view.dart'; // Import the Notes component

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use the imported components here
      home: const LoginView(), // Use the Home component as the home screen
      routes: {
        // Add the routes here
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const Registerview(),
        '/verify': (context) => const VerifyEmailView(),
        '/notes': (context) => const NotesView(),
      },
    );
  }
}
