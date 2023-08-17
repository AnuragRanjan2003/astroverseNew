import 'dart:io';

import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final _profileImage =
      FirebaseStorage.instance.ref(BackEndStrings.profileImage);

  final _itemImage = FirebaseStorage.instance.ref(BackEndStrings.itemImage);

  Future<Resource<String>> storeProfileImage(File file, String id) async =>
      await SafeCall().storageCall<String>(() async {
        await _profileImage.child(id).putFile(file);
        final x = await _profileImage.child(id).getDownloadURL();
        return x;
      });

  Future<Resource<String>> storeItemImage(File file, String id) async =>
      await SafeCall().storageCall<String>(() async {
        await _itemImage.child(id).putFile(file);
        return await _itemImage.child(id).getDownloadURL();
      });
}
