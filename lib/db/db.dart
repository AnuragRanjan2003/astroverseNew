import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final _userCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .withConverter<models.User>(
        fromFirestore: (snapshot, options) =>
            models.User.fromJson(snapshot.data()),
        toFirestore: (user, options) => user.toJson(),
      );

  Future<Resource<void>> saveUserData(models.User user) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _userCollection.doc(user.uid).set(user));

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _userCollection.doc(id).snapshots();

  Future<bool> checkForUserData(String uid) async {
    final res =
        await _userCollection.where('uid', isEqualTo: uid).count().get();
    if (res.count == 0) return false;
    return true;
  }
}
