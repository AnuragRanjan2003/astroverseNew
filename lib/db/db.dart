import 'package:astroverse/models/item.dart';
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

  final _itemCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.itemsCollection)
      .withConverter<Item>(
        fromFirestore: (snapshot, options) => Item.fromJson(snapshot.data()!),
        toFirestore: (item, options) => item.toJson(),
      );

  Future<Resource<void>> saveUserData(models.User user) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _userCollection.doc(user.uid).set(user));

  Future<Resource<void>> saveItemData(Item item) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _itemCollection.doc(item.id).set(item));

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _userCollection.doc(id).snapshots();

  getMoreItems(DocumentSnapshot ds, List<String> cat) =>
      _itemCollection.startAfterDocument(ds).limit(20).where(
        "category",
        whereIn: [cat],
      );

  Future<bool> checkForUserData(String uid) async {
    final res =
        await _userCollection.where('uid', isEqualTo: uid).count().get();
    if (res.count == 0) return false;
    return true;
  }
}
