import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/notes', (route) => false)
                        .then((_) {});
                  });
                  // Future.delayed(Duration.zero, () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const NotesView(),
                  //   ));
                  // });
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Logged in as ${user!.email}'),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            return Navigator.pushNamed<void>(context, '/login');
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Delay navigation to avoid conflicts during the build process
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/verify', (route) => false)
                        .then((_) {});
                    // Future.delayed(Duration.zero, () {
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const VerifyEmailView(),
                    //   ));
                  });
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
