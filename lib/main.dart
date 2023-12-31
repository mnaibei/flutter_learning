import 'package:flutter/material.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/views/notes/create_update_note_view.dart';
import 'home/homepage.dart'; // Import the Home component
import 'views/register_view.dart'; // Import the Home component
import 'views/login_view.dart'; // Import the Home component
import 'views/verify_email_view.dart'; // Import the Verify Email component
import 'views/notes/notes_view.dart'; // Import the Notes component

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
      home: const LoginView(),
      routes: {
        // Add the routes here
        homeRoute: (context) => const HomePage(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const Registerview(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesRoute: (context) => const NotesView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNotesView(),
      },
    );
  }
}
