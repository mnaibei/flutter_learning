// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/utilities/dialogs/show_error.dart';
import 'package:flutter_learning/services/auth/auth_exceptions.dart';
import 'package:flutter_learning/services/auth/auth_service.dart';
import 'package:flutter_learning/views/register_view.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text('Login'),
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
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              await AuthService.firebase()
                                  .logIn(email: email, password: password);
                              final user = AuthService.firebase().currentUser;
                              devtools.log('User signed in: $user');
                              return Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      homeRoute, (route) => false)
                                  .then((_) {});
                              // } on FirebaseAuthException catch (e) {
                              //   print(e);
                              //   devtools.log(e.toString());
                              //   if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                              //     await showErrorDialog(
                              //         context, 'Invalid login credentials');
                              //   }
                            } on InvalidLoginCredentials {
                              await showErrorDialog(
                                  context, 'Invalid Login Credentials');
                            } on UserNotFound {
                              await showErrorDialog(
                                  context, 'Cannot log in, User not found');
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Registerview(),
                              ));
                            });
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
