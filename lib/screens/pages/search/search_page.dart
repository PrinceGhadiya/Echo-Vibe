import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_vibe/utils/helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          decoration: const InputDecoration(
            hintText: "Search by post or username...",
          ),
        ),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: FirestoreHelper.firestoreHelper.searchPosts(searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final searchResults = snapshot.data!;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final post = searchResults[index].data();
                return ListTile(
                  title: Text(post['postDesc'] ?? "No Description"),
                  subtitle: Text("By: ${post['username'] ?? "Unknown"}"),
                );
              },
            );
          }

          return const Center(child: Text("No results found"));
        },
      ),
    );
  }
}
