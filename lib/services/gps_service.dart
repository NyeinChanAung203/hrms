import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import '../utils/show_message.dart';
import 'auth_service.dart';

class GPSService {
  Position? currentPosition;
  String? currentAddress;

  Future<bool> getCurrentLocation(BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled;
    permission = await Geolocator.checkPermission();
    bool returnValue = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // await Geolocator.openLocationSettings();

      Future.delayed(
          Duration.zero,
          () => showWarningAlertDialog(context,
              imgUrl: 'assets/cheat.png',
              title: 'To avoid cheating!',
              description: 'Please turn on your location',
              btnText: 'Okay'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.delayed(Duration.zero,
            () => showErrorMessage(context, 'Location permissions are denied'));
      }
    }

    if (serviceEnabled) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);

      currentPosition = position;
      final result = await checkInRange();

      if (result) {
        returnValue = true;
      } else {
        Future.delayed(
            Duration.zero,
            () => showWarningAlertDialog(context,
                imgUrl: 'assets/sorry.png',
                title: 'Sorry!',
                description: 'Your current location must be near office area',
                btnText: 'Okay'));
        returnValue = false;
      }
    }
    return returnValue;
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         currentPosition!.latitude, currentPosition!.longitude);

  //     Placemark place = placemarks[0];
  //     print(placemarks);

  //     currentAddress = " $place,";
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<bool> checkInRange() async {
    try {
      final response = await AuthService.getLocation('1');

      if (response.containsKey('message')) {
        return false;
      }

      double predefinedLat = response['latitude'];
      double predefinedLog = response['longitude'];
      // print('lat $predefinedLat');
      // print('lon $predefinedLog');
      // print("${currentPosition!.latitude} ${predefinedLat + 0.0002}");
      // print("${currentPosition!.latitude} ${predefinedLat - 0.0002}");
      // print("${currentPosition!.longitude} ${predefinedLog + 0.0002}");
      // print("${currentPosition!.longitude} ${predefinedLog - 0.0002}");

      if (currentPosition!.latitude <= predefinedLat + 0.0002 &&
          currentPosition!.latitude >= predefinedLat - 0.0002 &&
          currentPosition!.longitude <= predefinedLog + 0.0002 &&
          currentPosition!.longitude >= predefinedLog - 0.0002) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
