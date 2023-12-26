// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/dialogs/show_error.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _email.text,
                                password: _password.text,
                              );
                              final user = userCredential.user;
                              await user!.sendEmailVerification();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Verification email sent to ${user.email}'),
                                duration: const Duration(seconds: 3),
                              ));
                              return Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      verifyEmailRoute, (route) => false)
                                  .then((_) {});
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "invalid-email") {
                                showErrorDialog(context, "Invalid Email");
                              } else if (e.code == "weak-password") {
                                showErrorDialog(context, "Weak Password");
                              } else if (e.code == "email-already-in-use") {
                                showErrorDialog(
                                    context, "Email Already in Use");
                              } else {
                                showErrorDialog(context, e.code);
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  );
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            }));
  }
}
