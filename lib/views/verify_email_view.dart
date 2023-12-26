import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning/constants/routes.dart';

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
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.sendEmailVerification();
                }
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
