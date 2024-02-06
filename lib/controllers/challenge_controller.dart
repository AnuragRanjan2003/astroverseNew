import 'dart:developer';

import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/repo/challenge_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:get/get.dart';

class ChallengeController extends GetxController {
  final RxList<Challenge> list = <Challenge>[].obs;
  final RxBool isLoading = false.obs;
  final _repo = ChallengeRepo();

  @override
  void onInit() {
    getChallenges();
    super.onInit();
  }

  getChallenges() {
    isLoading.value = true;
    log("getting challenges" , name: "CHALLENGE CONTROLLER");
    _repo.getChallenges().then((value) {
      isLoading.value = false;
      if (value is Success<List<Challenge>>) {
        list.value = value.data;
      } else {
        value as Failure<List<Challenge>>;
        log(value.error, name: "CHALLENGE LIST");
      }
    });
  }


}
