import 'package:flutter/material.dart';
import 'package:flutter_learning/constants/routes.dart';
import 'package:flutter_learning/services/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false)
                        .then((_) {});
                  });
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Logged in as ${AuthService.firebase().currentUser}'),
                        ElevatedButton(
                          onPressed: () async {
                            AuthService.firebase().logOut();
                            return Navigator.pushNamed<void>(
                                context, loginRoute);
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
                        .pushNamedAndRemoveUntil(
                            verifyEmailRoute, (route) => false)
                        .then((_) {});
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
