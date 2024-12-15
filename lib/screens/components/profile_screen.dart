import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/screens/components/my_button.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section
            Text(
              "Username", // Replace with the username
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with actual profile image URL
                ),
                SizedBox(width: 18),
                Expanded(
                  child: StreamBuilder(
                    stream: FirestoreHelper.firestoreHelper.fetchUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DocumentSnapshot? docSnap = snapshot.data;
                        // String userName = docSnap?.get('name');
                        // String bio = docSnap?.get('bio');

                        int followersCount = docSnap?.get('followers').length;
                        int followingCount = docSnap?.get('following').length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(
                                    count: "132",
                                    label: "Posts",
                                    context: context),
                                _buildStatColumn(
                                    count: "$followersCount",
                                    label: "Followers",
                                    context: context),
                                _buildStatColumn(
                                    count: "$followingCount",
                                    label: "Following",
                                    context: context),
                              ],
                            ),
                            SizedBox(height: 12),
                            MyButton(
                              child: Text("Edit Profile"),
                              onTap: () {},
                            ),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    },
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SizedBox(height: 10),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         _buildStatColumn(
                  //             count: "132", label: "Posts", context: context),
                  //         _buildStatColumn(
                  //             count: "132K",
                  //             label: "Followers",
                  //             context: context),
                  //         _buildStatColumn(
                  //             count: "132",
                  //             label: "Following",
                  //             context: context),
                  //       ],
                  //     ),
                  //     SizedBox(height: 12),
                  //     MyButton(
                  //       child: Text("Edit Profile"),
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Bio Section
            Text(
              "BIO",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 8),
            Text(
              "This is a short bio or description about the user. Add something interesting!",
              style: Theme.of(context).textTheme.labelMedium,
            ),

            SizedBox(height: 24),

            // Post Grid Section
          ],
        ),
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
