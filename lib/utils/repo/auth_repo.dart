import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepo {
  /// Login user using email and password
  Future<User?> loginUser(
      {required String email,
      required String password,
      required BuildContext context});

  /// Signup - create account using email, username, and password
  Future<User?> signupUser(
      {required String email,
      required String username,
      required String password,
      required BuildContext context});

  // logout user
  Future<void> logoutUser({required BuildContext context});
}
