import 'dart:developer';

import 'package:astroverse/models/service.dart';
import 'package:astroverse/repo/orders_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final _repo = OrderRepo();

  Rxn<Service> service = Rxn();

  @override
  void onClose() {
    service.value = null;
  }

  fetchService(String uid, String serviceId) {
    _repo.fetchService(uid, serviceId).then((value) {
      if (value.isSuccess) {
        value = value as Success<Service>;
        service.value = value.data;
        log(value.data.toString() ,name : "SERVICE FETCH");
      } else {
        value = value as Failure<Service>;
        service.value = null;
        log(value.error ,name : "SERVICE FETCH");
      }
    });
  }
}
