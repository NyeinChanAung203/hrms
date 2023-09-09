import 'dart:developer';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:hrms/services/gps_service.dart';
import 'package:intl/intl.dart';

import '../screens/detail_timesheet.dart';
import '../services/auth_service.dart';
import '../utils/shared_pre_util.dart';
import '../utils/show_message.dart';

class CheckInOutProvider with ChangeNotifier {
  bool isCheckIn = false;

  Future<bool> checkOut() async {
    try {
      final token = await UtilSharedPreferences.getToken();

      await AuthService.checkOut(token ?? '').then((response) async {
        await UtilSharedPreferences.removeCheckId();
        isCheckIn = false;
        notifyListeners();
        log('remove id');
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIn() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      if (token != null) {
        await AuthService.checkIn(token).then((response) async {
          await UtilSharedPreferences.setCheckId(response['id'].toString());
          isCheckIn = true;
          notifyListeners();
        });
        return true;
      } else {
        log('token null');
        return false;
      }
    } catch (e) {
      log('error $e');
      return false;
    }
  }

  Future<bool> isAlreadyCheckIn() async {
    final token = await UtilSharedPreferences.getToken();
    final id = await UtilSharedPreferences.getCheckId();
    log('id $id');
    if (token != null) {
      if (id != null) {
        final result = await AuthService.getCheckIn(token, id);

        if (result['checkoutTime'] == null) {
          // check checkin
          isCheckIn = true;

          notifyListeners();
          return isCheckIn;
        } else {
          isCheckIn = false;
          // remove id because checkout time is not null
          await UtilSharedPreferences.removeCheckId();
          notifyListeners();
        }
      } else {
        isCheckIn = false;
        log('no id , no check in');
      }
    }
    return false;
  }

  Future<bool> onAction(
      BuildContext context, ActionSliderController controller) async {
    controller.loading(); //starts loading animation

    // check GPS
    final gps = GPSService();
    await gps.getCurrentLocation(context).then((result) async {
      if (result) {
        if (isCheckIn) {
          log('checkout ....');
          await checkOut().then((value) async {
            if (value) {
              controller.success();
              await Future.delayed(const Duration(seconds: 1));
              Future.delayed(
                Duration.zero,
                () => showSuccessBottomSheet(context, 'Successfully Check Out',
                    () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailTimesheetScreen(
                            dateTime: DateTime.now(),
                          )));
                }, true, 'View Today\'s Time Sheet'),
              );
            } else {
              controller.failure();
              await Future.delayed(const Duration(seconds: 1));
            }
          });
        } else {
          log('checkIn ....');
          await checkIn().then((value) async {
            if (value) {
              controller.success();
              await Future.delayed(const Duration(seconds: 1));
              Future.delayed(
                Duration.zero,
                () => showSuccessBottomSheet(context, 'Successfully Check In',
                    () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailTimesheetScreen(
                            dateTime: DateTime.now(),
                          )));
                }, true, 'View Today\'s Time Sheet'),
              );
            } else {
              controller.failure();
              await Future.delayed(const Duration(seconds: 1));
            }
          });
        }
      } else {
        log('$result not in range invalid');
      }
    });

    controller.reset();
    return isCheckIn;
  }

  Future<Map<String, dynamic>> getCheckInByDate(DateTime dateTime) async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final Map<String, dynamic> dateResult =
          await AuthService.getCheckInByDate(
                  token!, DateFormat('yyyy-MM-dd').format(dateTime))
              .timeout(const Duration(seconds: 10));
      return dateResult;
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }
}
