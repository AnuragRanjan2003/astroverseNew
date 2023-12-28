import 'package:astroverse/components/post_item.dart';
import 'package:astroverse/models/post.dart';
import 'package:flutter/material.dart';

class PersonPosts extends StatelessWidget {
  final List<Post> list;

  const PersonPosts({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const Text("no posts");
    return ListView.separated(
        itemBuilder: (context, index) => PostItem(post: list[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: list.length);
  }
}
