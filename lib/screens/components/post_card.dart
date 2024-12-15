import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final String postId;
  final VoidCallback onCommentPressed;

  const PostCard({
    super.key,
    required this.post,
    required this.postId,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      // color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post title
          Text(
            post['postTitle'] ?? "No Title",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Post description
          Text(post['postDesc'] ?? "No Description"),
          const SizedBox(height: 12),

          // Post interactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Show user who posted
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirestoreHelper.firestoreHelper
                    .fetchUserById(post['userId'] ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userName = snapshot.data?.get('name') ?? "Unknown";
                    return Text("@$userName");
                  }
                  return const Text("Loading...");
                },
              ),

              // Likes and comments row
              Row(
                children: [
                  // Likes
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleLike(postId, post),
                        child: Icon(
                          post['likes'] != null &&
                                  post['likes'].contains(
                                      FirebaseAuth.instance.currentUser?.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 28,
                          color: Colors.red,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirestoreHelper.firestoreHelper
                            .fetchPostById(postId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final likes =
                                snapshot.data?.get('likes') as List? ?? [];
                            return Text("${likes.length}");
                          }
                          return const Text("0");
                        },
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Comments
                  Column(
                    children: [
                      GestureDetector(
                        onTap: onCommentPressed,
                        child: const Icon(
                          CupertinoIcons.chat_bubble,
                          size: 28,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirestoreHelper.firestoreHelper
                            .fetchPostById(postId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final comments =
                                snapshot.data?.get('comments') as List? ?? [];
                            return Text("${comments.length}");
                          }
                          return const Text("0");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  // Toggle like functionality
  Future<void> _toggleLike(String postId, Map<String, dynamic> post) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final likes = post['likes'] ?? [];
    if (likes.contains(userId)) {
      // Remove like
      await FirebaseFirestore.instance.collection('Posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Add like
      await FirebaseFirestore.instance.collection('Posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
