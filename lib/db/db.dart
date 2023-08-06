import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final _userCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .withConverter<models.User>(
        fromFirestore: (snapshot, options) => models.User.fromJson(snapshot.data()),
        toFirestore: (user, options) => user.toJson(),
      );

  Future<Resource<void>> saveUserData(models.User user) async =>
    await SafeCall().fireStoreCall<void>(() async =>
      await _userCollection.doc(user.uid).set(user)
    );


  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _userCollection.doc(id).snapshots();
}
