// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/utilities/dialogs/show_success.dart';
import 'package:flutter_learning/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address.'),
            ElevatedButton(
              onPressed: () async {
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  await AuthService.firebase().sendEmailVerification();
                }
                await showSuccessDialog(
                    context, 'Verification email sent to ${user!.email}');
              },
              child: const Text('Resend Verification Email'),
            ),
            const Text('If you have already verified, please login.'),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                return Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false)
                    .then((_) {});
              },
              child: const Text('Login'),
            ),
          ],
        )));
  }
}
