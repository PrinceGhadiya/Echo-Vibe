import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/screens/components/my_text_field.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final String postId;
  final TextEditingController commentController;

  const CommentsSection({
    super.key,
    required this.postId,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirestoreHelper.firestoreHelper.fetchComments(postId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      List<dynamic> comments =
                          snapshot.data?.get('comments') ?? [];
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final userId = comment['userId'];
                          return ListTile(
                            title: Text(comment['comment'] ?? ""),
                            subtitle: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirestoreHelper.firestoreHelper
                                  .fetchUserById(userId),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return Text("Error fetching user");
                                } else if (userSnapshot.hasData) {
                                  final userName =
                                      userSnapshot.data?.get('name') ??
                                          "Unknown User";
                                  return Text("By: $userName");
                                }
                                return const Text("Loading user...");
                              },
                            ),
                            trailing: Text(
                              comment['timestamp'] != null
                                  ? (comment['timestamp'] as Timestamp)
                                      .toDate()
                                      .toString()
                                      .split(" ")[0]
                                  : "",
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: commentController,
                      hintText: "Write a comment...",
                      prefixIcon: CupertinoIcons.chat_bubble_2,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null && commentController.text.isNotEmpty) {
                        await FirestoreHelper.firestoreHelper.addComment(
                          postId,
                          user.uid,
                          commentController.text,
                        );
                        commentController.clear();
                      }
                    },
                    icon: const Icon(CupertinoIcons.paperplane),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
