import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/screens/components/my_text_field.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:echo_vibe/utils/statics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: titleController,
                  hintText: "Title",
                  prefixIcon: CupertinoIcons.text_justifyleft,
                ),
                MyTextField(
                  controller: descController,
                  hintText: "Description",
                  prefixIcon: CupertinoIcons.text_append,
                ),
                MyButton(
                  onTap: isLoading
                      ? null
                      : () async {
                          if (titleController.text.isNotEmpty &&
                              descController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await FirestoreHelper.firestoreHelper
                                  .addPost(
                                    titleController.text,
                                    descController.text,
                                  )
                                  .then(
                                    (value) => kSnackbar(
                                        context: context,
                                        msg: "Post Added Succesfully..."),
                                  );

                              setState(() {
                                titleController.clear();
                                descController.clear();
                                isLoading = false;
                              });

                              // ignore: empty_catches
                            } catch (e) {
                              showErrorDialog(
                                  context: context, message: e.toString());
                              setState(() {
                                isLoading = false;
                              });
                            }
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
                          "Add Post",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
