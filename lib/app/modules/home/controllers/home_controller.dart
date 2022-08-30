import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var lat = 'Getting lat...'.obs;
  var long = 'Getting long...'.obs;
  late StreamSubscription<Position> streamSubscription;
  @override
  void onInit() {
    _determinePosition();
    super.onInit();
  }

  @override
  void onClose() {}

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    streamSubscription = Geolocator.getPositionStream().listen((position) {
      lat.value = position.latitude.toString();
      long.value = position.latitude.toString();
    });
  }
}
