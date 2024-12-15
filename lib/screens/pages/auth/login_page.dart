import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/screens/components/my_text_field.dart';
import 'package:echo_vibe/screens/pages/auth/signup_page.dart';
import 'package:echo_vibe/utils/helper/auth_helper.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:echo_vibe/utils/statics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    /// Login method
    Future<void> login() async {
      if (emailController.text.isNotEmpty && pwController.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        User? user = await AuthHelper.authHelper.loginUser(
          email: emailController.text,
          password: pwController.text,
          context: context,
        );
        if (user != null) {
          // kSnackbar(context: context, msg: "Login successful...");
          // setState(() {
          //   isLoading = false;
          // });
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     PageAnimationTransition(
          //       page: HomePage(),
          //       pageAnimationType: FadeAnimationTransition(),
          //     ),
          //     (route) => false);
          await FirestoreHelper.firestoreHelper.addUserInFirestore();
        } else {
          kSnackbar(
            context: context,
            msg: "Login Failed...",
            successSnkBar: false,
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        kSnackbar(
            context: context,
            msg: "Please fill all fields...",
            successSnkBar: false);
        setState(() {
          isLoading = false;
        });
      }
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 68,
                  color: appColors.primary,
                ),
                Text(
                  "You have been missed...",
                  style: textTheme.labelLarge,
                ),
                SizedBox(height: 18),
                MyTextField(
                  controller: emailController,
                  hintText: "E-mail",
                  prefixIcon: Icons.mail,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: pwController,
                  hintText: "Password",
                  prefixIcon: Icons.password,
                  isObsecure: true,
                ),
                SizedBox(height: 18),
                isLoading
                    ? Container(
                        height: 46,
                        width: 46,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: appColors.secondary,
                        ),
                      )
                    : MyButton(
                        onTap: login,
                        child: Text(
                          "Login",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                  ),
                        ),
                      ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: textTheme.labelMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        /**
                         * Navigate to sign up page.
                         */
                        Navigator.push(
                            context,
                            PageAnimationTransition(
                                page: SignupPage(),
                                pageAnimationType: RightToLeftTransition()));
                      },
                      child: Text(
                        " Sign up",
                        style: textTheme.labelMedium!.copyWith(
                          color: Colors.blue[600]!,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
