import 'package:echo_vibe/screens/pages/auth/auth.dart';
import 'package:echo_vibe/utils/theme/k_app_theme.dart';
import 'package:flutter/material.dart';

// import '../screens/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Echo Vibe",
      // home: const HomePage(),
      theme: KAppTheme.lightTheme,
      home: const Auth(),
    );
  }
}
