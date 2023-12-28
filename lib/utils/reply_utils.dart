import 'package:astroverse/models/comment.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

CollectionReference<Comment> getReplyCollection(
        String postId, String commentId) =>
    FirebaseFirestore.instance
        .collection(BackEndStrings.postCollection)
        .doc(postId)
        .collection(BackEndStrings.comments)
        .doc(commentId)
        .collection(BackEndStrings.replyCollection)
        .withConverter<Comment>(
          fromFirestore: (snapshot, options) =>
              Comment.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

class ReplyUtil {
  Future<Resource<List<Comment>>> fetchReplies(
      String postId, String commentId) async {
    final Query<Comment> q = getReplyCollection(postId, commentId)
        .orderBy("astro")
        .orderBy("date", descending: true);
    try {
      final res = await q.get();
      return Success<List<Comment>>(res.docs.map((e) => e.data()).toList());
    } on FirebaseException catch (e) {
      return Failure<List<Comment>>(e.message.toString());
    } catch (e) {
      return Failure<List<Comment>>(e.toString());
    }
  }

  Future<Resource<Comment>> postReply(
      Comment c, String postId, String commentId) async {
    try {
      final String id = const Uuid().v4();
      c.id = id;
      await getReplyCollection(postId, commentId).doc(id).set(c);
      return Success<Comment>(c);
    } on FirebaseException catch (e) {
      return Failure<Comment>(e.message.toString());
    } catch (e) {
      return Failure<Comment>(e.toString());
    }
  }
}
