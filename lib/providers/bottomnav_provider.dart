import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/leave_screen.dart';
import '../screens/payslip_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/timesheet_screen.dart';

class BottomNavProvider with ChangeNotifier {
  final pages = const [
    HomeScreen(),
    LeaveScreen(),
    TimeSheetScreen(),
    PaySlipScreen(),
    ProfileScreen(),
  ];

  int index = 0;

  void changeIndex(int value) {
    index = value;
    notifyListeners();
  }

  void reset() {
    index = 0;
    notifyListeners();
  }
}
