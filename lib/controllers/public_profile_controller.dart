import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:get/get.dart';

class PublicProfileController extends GetxController {
  final _repo = AuthRepo();
  Rxn<ExtraInfo> info = Rxn();

  getExtraInfo(String uid) {
    _repo.getExtraInfo(uid).then((value) {
      if (value.isSuccess) {
        value as Success<ExtraInfo>;
        info.value = value.data;
      } else {
        info.value = null;
      }
    });
  }
}
