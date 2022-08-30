import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var lat = 'Getting lat...'.obs;
  var long = 'Getting long...'.obs;
  var address = 'Getting Address...'.obs;
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
      long.value = position.longitude.toString();
      print("${lat.value} - ${long.value}");
      getAddress(position);
    });
  }

  Future<dynamic> getAddress(Position position) async {
    List<Placemark> placemarkList =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarkList[0];
    address.value = "${placemark.locality},${placemark.country}";
    print(placemark);
  }
}
