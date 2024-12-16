import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add a new user to Firestore
  Future<void> addUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if the user already exists
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection("Users").doc(user.uid).get();

    // If the user doesn't exist, add them to Firestore
    if (!userDoc.exists) {
      await firestore.collection("Users").doc(user.uid).set({
        "name": user.displayName ?? "No username",
        "email": user.email ?? "No email",
        "bio": "",
        "created_at": FieldValue.serverTimestamp(),
        "followers": [],
        "following": [],
      });
    }
  }

  // Update user bio
  Future<void> updateUserName(String userName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore.collection("Users").doc(user.uid).update({
      "name": userName,
    });
  }

  // Update user bio
  Future<void> updateUserBio(String bio) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore.collection("Users").doc(user.uid).update({
      "bio": bio,
    });
  }

  // Fetch user data
  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No authenticated user");

    return firestore.collection("Users").doc(user.uid).snapshots();
  }

  // Add a follower
  Future<void> addFollower(String currentUserId, String targetUserId) async {
    await firestore.collection("Users").doc(targetUserId).update({
      "followers": FieldValue.arrayUnion([currentUserId]),
    });

    await firestore.collection("Users").doc(currentUserId).update({
      "following": FieldValue.arrayUnion([targetUserId]),
    });
  }

  // Remove a follower
  Future<void> removeFollower(String currentUserId, String targetUserId) async {
    await firestore.collection("Users").doc(targetUserId).update({
      "followers": FieldValue.arrayRemove([currentUserId]),
    });

    await firestore.collection("Users").doc(currentUserId).update({
      "following": FieldValue.arrayRemove([targetUserId]),
    });
  }

  // Add a post
  Future<void> addPost(String postTitle, String postDesc) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await firestore.collection("Posts").add({
      "userId": user.uid,
      "postTitle": postTitle,
      "postDesc": postDesc,
      "timestamp": FieldValue.serverTimestamp(),
      "likes": [],
      "comments": [],
    });
  }

  // Search posts by postId or postDescription
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchPosts(
      String searchTerm) {
    String lowerCaseSearchTerm = searchTerm.toLowerCase();

    return firestore.collection("Posts").snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        String postDesc =
            (doc.data()['postTitle'] ?? "").toString().toLowerCase();
        return postDesc.contains(lowerCaseSearchTerm);
      }).toList();
    });
  }

  // Fetch all posts
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllPosts() {
    return firestore
        .collection("Posts")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Add a like to a post
  Future<void> addLike(String postId, String userId) async {
    await firestore.collection("Posts").doc(postId).update({
      "likes": FieldValue.arrayUnion([userId]),
    });
  }

  // Remove a like from a post
  Future<void> removeLike(String postId, String userId) async {
    await firestore.collection("Posts").doc(postId).update({
      "likes": FieldValue.arrayRemove([userId]),
    });
  }

  // Fetch comments for a post
  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchComments(String postId) {
    return firestore.collection("Posts").doc(postId).snapshots();
  }

  // Add a comment to a post
  Future<void> addComment(String postId, String userId, String comment) async {
    await firestore.collection("Posts").doc(postId).update({
      "comments": FieldValue.arrayUnion([
        {
          "userId": userId,
          "comment": comment,
          "timestamp": Timestamp.now(),
        }
      ]),
    });
  }

  // fetch user by id
  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchUserById(String userId) {
    return firestore.collection("Users").doc(userId).snapshots();
  }

  // New method: fetchPostById
  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchPostById(String postId) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPostsByUserId(
      String userId) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }
}
