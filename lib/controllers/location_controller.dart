import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:astroverse/repo/location_repo.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final _locationService = LocationService();
  Rx<bool> serviceEnabled = false.obs;
  Rx<bool> permission = false.obs;
  Rxn<LocationData> location = Rxn();
  StreamSubscription<LocationData>? _locationSub;
  RxString address = "fetching address..".obs;

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

  getAddress(double? lat, double? lng) async {
    if (lat == null || lng == null) return address.value = "invalid location";
    address.value=  "fetching address..";
    final geoCode = GeoCode();
    try{
      Address address =
      await geoCode.reverseGeocoding(latitude: lat, longitude: lng);
      if(address.streetAddress == null || address.postal==null){
          return this.address.value = "could not fetch";
      }
      return  this.address.value = "${address.streetAddress} , ${address.postal}";

    } on GeocodeException catch(e){
      return address.value = "Error!Please refresh[${lat.toStringAsFixed(2)},${lng.toStringAsFixed(2)}]";
    }catch(e){
      return address.value = "Error!Please refresh[${lat.toStringAsFixed(2)},${lng.toStringAsFixed(2)}]";
    }

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
