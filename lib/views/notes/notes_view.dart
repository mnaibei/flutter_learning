// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/dialogs/show_logout.dart';
import 'package:flutter_learning/services/auth/auth_service.dart';
import 'package:flutter_learning/services/crud/notes_service.dart';
import 'package:flutter_learning/views/notes/notes_list_view.dart';
import 'dart:developer' as devtools show log;

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    // _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<MenuAction>(
            onSelected: (action) async {
              switch (action) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ],
        title: const Text('Notes'),
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData &&
                            (snapshot.data as List).isNotEmpty) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          print(allNotes);
                          return NotesListView(
                            notes: allNotes,
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(
                                id: note.id,
                              );
                            },
                          );
                        } else {
                          devtools.log("The screen should display 'No notes'");
                          return const Center(
                            child: Text('No notes'),
                          );
                        }
                      default:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  });
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen where users can create a new note
          Navigator.of(context).pushNamed(newNoteRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
