import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/screens/components/comment_section.dart';
import 'package:echo_vibe/screens/components/post_card.dart';
import 'package:echo_vibe/screens/components/profile_screen.dart';
import 'package:echo_vibe/screens/pages/add_post/add_post.dart';
import 'package:echo_vibe/utils/helper/auth_helper.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final commentController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthHelper.authHelper.logoutUser(context: context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _postPage(),
          Center(child: Text('Search Page')),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            PageAnimationTransition(
              page: AddPost(),
              pageAnimationType: RightToLeftTransition(),
            ),
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _postPage() {
    return StreamBuilder(
      stream: FirestoreHelper.firestoreHelper.fetchAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          QuerySnapshot? querySnapshot = snapshot.data;
          List? posts = (querySnapshot == null) ? [] : querySnapshot.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postId = post.id;

              return PostCard(
                post: post.data() as Map<String, dynamic>,
                postId: postId,
                onCommentPressed: () {
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
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
