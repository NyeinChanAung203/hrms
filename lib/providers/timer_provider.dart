import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/shared_pre_util.dart';
import 'package:intl/intl.dart' as intl;

class TimerProvider with ChangeNotifier {
  Duration duration = const Duration();
  Timer? timer;
  DateTime? startTime;
  String totalWorkHours = '00:00:00';

  bool isStart = false;

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String get seconds => twoDigits(duration.inSeconds.remainder(60));
  String get minutes => twoDigits(duration.inMinutes.remainder(60));
  String get hours => twoDigits(duration.inHours);

  Future<void> isAlreadyStartTimer() async {
    final token = await UtilSharedPreferences.getToken();
    final id = await UtilSharedPreferences.getCheckId();
    log('id $id');
    if (token != null) {
      final Map<String, dynamic> dateResult =
          await AuthService.getCheckInByDate(
              token, intl.DateFormat('yyyy-MM-dd').format(DateTime.now()));

      if (dateResult.containsKey('message')) {
        timerCancel();
      }
      if (dateResult['totalWorkHours'] == null) {
        reset();
      } else {
        Map<String, dynamic> latestStartTime = dateResult['attendances'].last;
        startTime = DateTime.parse(latestStartTime['checkinTime']).toLocal();
        totalWorkHours = dateResult['totalWorkHours'];
        notifyListeners();
      }
      if (id != null) {
        final result = await AuthService.getCheckIn(token, id);
        if (result['checkoutTime'] == null) {
          // check checkin
          final checkinTime = result['checkinTime'];
          if (checkinTime != null) {
            startTime = DateTime.parse(checkinTime).toLocal();

            duration = DateTime.now().toLocal().difference(startTime!);

            if (duration.isNegative) {
              duration = Duration.zero;
            }

            startTimer();
          }
        }
      } else {
        timerCancel();
        log('no id , no check in, cancel timer');
      }
    }
  }

  void startTimer() {
    if (!isStart) {
      // start the timer cus not already started
      isStart = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        addTime();
      });
    }
  }

  void addTime() {
    const addSeconds = 1;
    final seconds = duration.inSeconds + addSeconds;
    duration = Duration(seconds: seconds);
    notifyListeners();
  }

  void reset() {
    duration = const Duration();
    startTime = null;
    totalWorkHours = "00:00:00";
    notifyListeners();
  }

  void timerCancel() {
    if (isStart) {
      timer?.cancel();
      isStart = false;
      duration = const Duration();
      notifyListeners();
    }
  }
}
