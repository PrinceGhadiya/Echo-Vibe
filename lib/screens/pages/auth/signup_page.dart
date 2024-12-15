import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/screens/components/my_text_field.dart';
import 'package:echo_vibe/utils/helper/auth_helper.dart';
import 'package:echo_vibe/utils/statics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/helper/firestore_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    void signupUser() async {
      if (emailController.text.isNotEmpty &&
          pwController.text.isNotEmpty &&
          confirmPwController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        if (pwController.text == confirmPwController.text) {
          setState(() {
            isLoading = true;
          });
          User? user = await AuthHelper.authHelper.signupUser(
              email: emailController.text,
              username: usernameController.text,
              password: pwController.text,
              context: context);
          await FirestoreHelper.firestoreHelper.addUserInFirestore();
          Navigator.pop(context);
          setState(() {
            isLoading = false;
          });
          if (user == null) {
            kSnackbar(context: context, msg: "Signup failed...");
            setState(() {
              isLoading = false;
            });
          }
        } else {
          kSnackbar(
              context: context,
              msg: "Password does not match...",
              successSnkBar: true);
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(),
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
                  "Sign up to enter your e-world",
                  style: textTheme.labelLarge,
                ),
                SizedBox(height: 18),
                MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  prefixIcon: Icons.mail,
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                MyTextField(
                  controller: confirmPwController,
                  hintText: "Confirm Password",
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
                        onTap: signupUser,
                        child: Text(
                          "Sign up",
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
                      "Have an account?",
                      style: textTheme.labelMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        /**
                         * 
                         */
                        Navigator.pop(context);
                      },
                      child: Text(
                        " Log in",
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
