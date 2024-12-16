import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/screens/components/my_text_field.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:echo_vibe/utils/statics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {super.key,
      required this.userNameController,
      required this.bioController});

  final TextEditingController userNameController;
  final TextEditingController bioController;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              MyTextField(
                controller: widget.userNameController,
                hintText: "Update Username",
                prefixIcon: CupertinoIcons.person,
              ),
              MyTextField(
                controller: widget.bioController,
                hintText: "Update Bio",
                prefixIcon: CupertinoIcons.decrease_indent,
              ),
              MyButton(
                onTap: () async {
                  if (widget.userNameController.text.isNotEmpty &&
                      widget.bioController.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    await FirestoreHelper.firestoreHelper
                        .updateUserName(widget.userNameController.text);
                    await FirebaseAuth.instance.currentUser!
                        .updateDisplayName(widget.userNameController.text);
                    await FirestoreHelper.firestoreHelper
                        .updateUserBio(widget.bioController.text);
                    setState(() {
                      kSnackbar(
                          context: context,
                          msg: "Profile updated successfully...");
                      isLoading = false;
                      Navigator.pop(context);
                    });
                  } else {
                    kSnackbar(
                        context: context,
                        msg: "Please fill all fields...",
                        successSnkBar: false);
                  }
                },
                child: isLoading
                    ? Container(
                        height: 46,
                        width: 46,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : Text(
                        "Update",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
