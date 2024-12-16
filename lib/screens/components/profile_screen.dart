import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/screens/components/comment_section.dart';
import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/screens/components/post_card.dart';
import 'package:echo_vibe/screens/pages/edit_profile/edit_profile_page.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirestoreHelper.firestoreHelper.fetchUserById(userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text("ERROR: ${userSnapshot.error}"));
          }

          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            final userData = userSnapshot.data!.data();
            if (userData == null) {
              return const Center(child: Text("No user data available"));
            }

            String userName = userData['name'] ?? "N/A";
            String bio = userData['bio'].isEmpty
                ? "No bio available"
                : userData['bio'] ?? "No bio available";
            int followers = (userData['followers'] as List).length;
            int following = (userData['following'] as List).length;

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirestoreHelper.firestoreHelper.fetchPostsByUserId(userId),
              builder: (context, postSnapshot) {
                if (postSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (postSnapshot.hasError) {
                  return Center(child: Text("ERROR: ${postSnapshot.error}"));
                }

                int postCount =
                    postSnapshot.hasData ? postSnapshot.data!.docs.length : 0;

                List<QueryDocumentSnapshot<Map<String, dynamic>>> postsData =
                    postSnapshot.hasData ? postSnapshot.data!.docs : [];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header Section
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(
                              userData['profileImage'] ??
                                  'https://via.placeholder.com/150',
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn(
                                      count: "$postCount",
                                      label: "Posts",
                                      context: context,
                                    ),
                                    _buildStatColumn(
                                        count: "$followers",
                                        label: "Followers",
                                        context: context),
                                    _buildStatColumn(
                                        count: "$following",
                                        label: "Following",
                                        context: context),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                MyButton(
                                  child: const Text("Edit Profile"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageAnimationTransition(
                                        page: EditProfilePage(
                                          userNameController:
                                              TextEditingController(
                                                  text: userName),
                                          bioController:
                                              TextEditingController(text: bio),
                                        ),
                                        pageAnimationType:
                                            RightToLeftTransition(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bio Section
                      Text(
                        "BIO",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bio,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 24),

                      // Posts Section
                      Text(
                        "Posts",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      ...postsData.map((post) {
                        final postId = post.id;
                        final postData = post.data();
                        return PostCard(
                          post: postData,
                          postId: postId,
                          onCommentPressed: () {
                            var commentController = TextEditingController();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => CommentsSection(
                                postId: postId,
                                commentController: commentController,
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text("User not found"));
        },
      ),
    );
  }

  // Method to build the follower, following, and post count columns
  Column _buildStatColumn(
      {required String count,
      required String label,
      required BuildContext context}) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
