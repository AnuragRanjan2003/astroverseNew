import 'dart:async';
import 'dart:developer';

import 'package:astroverse/repo/locarion_repo.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final _locationService = LocationService();
  Rx<bool> serviceEnabled = false.obs;
  Rx<bool> permission = false.obs;
  Rxn<LocationData> location = Rxn();
  StreamSubscription<LocationData>? _locationSub;

  @override
  void onInit() {
    checkPermission();
    super.onInit();
  }

  checkPermission() {
    _locationService.checkPermission().then((value) {
      permission.value = value;
      if (value == true) checkServiceEnabled();
    });
  }

  startListeningLocation(void Function(LatLng) onLocationChanged) {
    _locationSub = _locationService.liveLocation.listen((event) {
      location.value = event;
      log("$event", name: "LOCATION");
      onLocationChanged(LatLng(event.latitude!, event.longitude!));
    });
  }

  checkServiceEnabled() {
    _locationService.checkService().then((value) {
      serviceEnabled.value = value;
      if (value == true) {
        startListeningLocation(
          (p0) async {},
        );
      }
    });
  }

  @override
  void onClose() {
    _locationSub?.cancel();
    super.onClose();
  }
}

class LatLng {
  double lat, lng;

  LatLng(this.lat, this.lng);
}
