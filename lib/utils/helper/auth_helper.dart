import 'package:echo_vibe/utils/repo/auth_repo.dart';
import 'package:echo_vibe/utils/statics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHelper implements AuthRepo {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential? userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return userCredential.user;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context: context, message: e.toString());
    }
    return null;
  }

  @override
  Future<void> logoutUser({required BuildContext context}) async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context: context, message: e.toString());
    }
  }

  @override
  Future<User?> signupUser(
      {required String email,
      required String username,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential? userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user?.updateDisplayName(username);
        return userCredential.user;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context: context, message: e.toString());
    }
    return null;
  }

  /**
   * Login user using email and password
   */
}
