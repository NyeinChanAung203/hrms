import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:hrms/screens/main_screen.dart';
import 'package:hrms/services/auth_service.dart';
import 'package:hrms/utils/shared_pre_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../utils/show_message.dart';
import 'bottomnav_provider.dart';

class AuthProvider with ChangeNotifier {
  bool _isRememberme = false;
  String? email;
  String? password;

  bool get isRememberme => _isRememberme;

  Future<void> _getRememberMe() async {
    final data = await UtilSharedPreferences.getFormData();
    if (data.containsKey('email')) {
      _isRememberme = true;
    } else {
      _isRememberme = false;
    }
  }

  toggleCheckbox() {
    _isRememberme = !_isRememberme;
    notifyListeners();
  }

  Future<void> getFormDataAndCheckBox() async {
    await Future.wait([_getRememberMe(), _getFormData()]);
  }

  Future<void> setFormData(String email, String password) async {
    if (_isRememberme) {
      await UtilSharedPreferences.setFormData(email, password);
    } else {
      await UtilSharedPreferences.removeFormData();
    }
  }

  Future<void> _getFormData() async {
    final data = await UtilSharedPreferences.getFormData();

    email = data['email'];
    password = data['password'];
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    turnOnbtnLoading();
    await setFormData(email, password);
    log('set form data');
    await AuthService.login(email, password).then((data) async {
      if (data.containsKey('token')) {
        if (data['checkin_id'] != 0) {
          await UtilSharedPreferences.setCheckId(data['checkin_id'].toString());
        } else {
          await UtilSharedPreferences.removeCheckId();
        }
        await UtilSharedPreferences.setToken(data['token'])
            .then((value) => showSuccessMessage(context, 'Success'))
            .then((value) {
          context.read<BottomNavProvider>().reset();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        });
        log('seted token');
      } else {
        showErrorMessage(context, data['message']);
        log(data['message']);
      }
    });
    turnOffbtnLoading();
  }

  bool btnLoading = false;
  turnOnbtnLoading() {
    btnLoading = true;
    notifyListeners();
  }

  turnOffbtnLoading() {
    btnLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await UtilSharedPreferences.removeToken('token').then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  Future<List<dynamic>> getLeaveInfo() async {
    final result = await AuthService.getLeaveInfo();
    return result;
  }

  void notify() {
    notifyListeners();
  }

  Future<bool> createLeave(String reason, DateTime startDate, DateTime endDate,
      int leaveDays) async {
    log(DateFormat('y-MM-d').format(startDate));

    final Map<String, dynamic> result = await AuthService.createLeave(
        reason,
        DateFormat('y-MM-d').format(startDate),
        DateFormat('y-MM-d').format(endDate),
        leaveDays);
    if (result.containsKey('message')) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<dynamic>> getPayslipByYear(String year) async {
    final result = await AuthService.getPayslipByYear(year);

    return result;
  }
}
