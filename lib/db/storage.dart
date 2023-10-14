import 'dart:io';

import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final _profileImage =
      FirebaseStorage.instance.ref(BackEndStrings.profileImage);

  final _postImage = FirebaseStorage.instance.ref(BackEndStrings.postImage);

  final _serviceImage = FirebaseStorage.instance.ref(BackEndStrings.serviceImage);

  Future<Resource<String>> storeProfileImage(File file, String id) async =>
      await SafeCall().storageCall<String>(() async {
        await _profileImage.child(id).putFile(file);
        final x = await _profileImage.child(id).getDownloadURL();
        return x;
      });

  Future<Resource<String>> storePostImage(File file, String id) async =>
      await SafeCall().storageCall<String>(() async {
        await _postImage.child(id).putFile(file);
        return await _postImage.child(id).getDownloadURL();
      });

  Future<Resource<String>> storeServiceImage(File file, String id) async =>
      await SafeCall().storageCall<String>(() async {
        await _serviceImage.child(id).putFile(file);
        return await _serviceImage.child(id).getDownloadURL();
      });

}
