import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_learning/firebase_options.dart';
import 'package:flutter_learning/services/auth/auth_user.dart';
import 'package:flutter_learning/services/auth/auth_provider.dart';
import 'package:flutter_learning/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'dart:developer' as devtools show log;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFound();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw InvalidEmail();
      } else if (e.code == "weak-password") {
        throw WeakPassword();
      } else if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUse();
      } else {
        throw UnknownException();
      }
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    devtools.log('Current user => $user');
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFound();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotFound();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFound();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        throw InvalidLoginCredentials();
      } else {
        devtools.log('will there be an error here? $e');
        throw UserNotFound();
      }
    } catch (_) {
      devtools.log('this is the error in firebase auth provider $_');
      throw UserNotFound();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
