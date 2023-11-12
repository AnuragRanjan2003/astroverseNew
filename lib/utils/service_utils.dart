import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/utils/postable.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../res/strings/backend_strings.dart';

final _serviceCollection = FirebaseFirestore.instance
    .collection(BackEndStrings.serviceCollection)
    .withConverter<Service>(
      fromFirestore: (snapshot, options) => Service.fromJson(snapshot.data()),
      toFirestore: (item, options) => item.toJson(),
    );

CollectionReference<SaveService> _usedServiceCollection(String uid) =>
    FirebaseFirestore.instance
        .collection(BackEndStrings.userCollection)
        .doc(uid)
        .collection(BackEndStrings.usedServiceCollection)
        .withConverter<SaveService>(
          fromFirestore: (snapshot, options) =>
              SaveService.fromJson(snapshot.data()),
          toFirestore: (value, options) => value.toJson(),
        );

const _limit = 20;

class ServiceUtils extends Postable<Service, SaveService> {
  String uid;

  ServiceUtils(this.uid)
      : super(_serviceCollection, _usedServiceCollection(uid));

  @override
  Future<Resource<int>> dislike(String id) async {
    try {
      await ref.doc(id).update({"upVotes": FieldValue.increment(-1)});
      await likeRef?.doc(id).delete();
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchByGenreAndPage(
      List<String> genre, String uid) async {
    try {
      QuerySnapshot<Service> res = await ref
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
          .orderBy("date", descending: true)
          .get();
      final data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  @override
  Future<Resource<int>> like(String id) async {
    try {
      await ref.doc(id).update({"upVotes": FieldValue.increment(1)});
      await likeRef?.doc(id).set(SaveService(id, DateTime.now().toString()));
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMore(
      QueryDocumentSnapshot<Service> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await ref
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
          .orderBy("date", descending: true)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  @override
  Stream<QuerySnapshot<SaveService>> likedStream(String uid) =>
      likeRef!.snapshots();

  @override
  Future<Resource<Service>> savePost(Service post) async {
    try {
      await ref.doc(post.id).set(post);
      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
    }
  }

  @override
  Future<Resource<Json>> update(Json data, String id)async {
    try {
      await ref.doc(id).update(data);
      return Success<Json>(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }

  }
}
