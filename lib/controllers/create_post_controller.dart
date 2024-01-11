import 'dart:io';

import 'package:astroverse/repo/post_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class CreatePostController extends GetxController {
  Rxn<XFile> image = Rxn();
  final _postRepo = PostRepo();
  Rx<bool> loading = false.obs;
  Rx<int> selectedItem = 0.obs;
  RxBool formValid = false.obs;


  Future<void> pickImage() async {
    final ip = ImagePicker();
    final file =
        await ip.pickImage(source: ImageSource.gallery, imageQuality: 30);
    image.value = file;
  }

  void savePost(Post post, void Function(Resource<Post>) updateUI, String uid) {
    loading.value = true;
    if (image.value == null) {
      post.id = const Uuid().v4();
      _postRepo.savePost(post).then((it) {
        loading.value = false;
        if (it.isSuccess) {
          _postRepo.updateExtraInfo(
              {"posts": FieldValue.increment(1)}, uid).then((value) {
            updateUI(it);
          });
        } else {
          updateUI(it);
        }
      });
    } else {
      post.id = const Uuid().v4();
      File file = File(image.value!.path);
      _postRepo.storePostImage(file, post.id).then((value) {
        if (value.isSuccess) {
          value = value as Success<String>;
          post.imageUrl = value.data;
          _postRepo.savePost(post).then((it) {
            loading.value = false;
            if (it.isSuccess) {
              _postRepo.updateExtraInfo(
                  {"posts": FieldValue.increment(1)}, uid).then((value) {
                updateUI(it);
              });
            } else {
              updateUI(it);
            }
          });
        } else {
          loading.value = false;
        }
      });
    }
  }


}

bool areDatesSame(DateTime lastPosted) {
  final now = DateTime.now();
  return (lastPosted.year==now.year && lastPosted.month==now.month && lastPosted.day==now.day);
}
