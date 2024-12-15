import 'package:echo_vibe/screens/pages/auth/login_page.dart';
import 'package:echo_vibe/screens/pages/home_page.dart';
import 'package:echo_vibe/utils/helper/auth_helper.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthHelper.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
