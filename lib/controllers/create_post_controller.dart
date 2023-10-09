import 'dart:io';

import 'package:astroverse/repo/post_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class CreatePostController extends GetxController {
  Rxn<XFile> image = Rxn();
  final _postRepo = PostRepo();
  Rx<bool> loading = false.obs;

  void pickImage() async {
    final ip = ImagePicker();
    final file = await ip.pickImage(source: ImageSource.gallery);
    image.value = file;
  }

  void savePost(Post post, void Function(Resource<Post>) updateUI) {
    loading.value = true;
    if (image.value == null) {
      post.id = const Uuid().v4();
      _postRepo.savePost(post).then((value) {
        loading.value = false;
        updateUI(value);
      });
    } else {
      post.id = const Uuid().v4();
      File file = File(image.value!.path);
      _postRepo.storePostImage(file, post.id).then((value) {
        if (value.isSuccess) {
          value = value as Success<String>;
          post.imageUrl = value.data;
          _postRepo.savePost(post).then((value) {
            loading.value = false;
            updateUI(value);
          });
        }else{
          loading.value = false;
        }
      });
    }
  }
}
