import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms/utils/shared_pre_util.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static get _baseUrl => "http://192.168.0.113";
  static get _port => "8080";

  static Future<Map<String, dynamic>> setFcmToken(String token) async {
    try {
      final fcmtoken = await FirebaseMessaging.instance.getToken();
      final response = await http.put(
          Uri.parse("$_baseUrl:$_port/api/notification"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({"token": fcmtoken}));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http
          .post(Uri.parse("$_baseUrl:$_port/api/auth/user/login"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({"email": email, "password": password}))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> checkIn(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl:$_port/api/attendance"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> getCheckIn(
      String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/attendance/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> getCheckInByDate(
      String token, String date) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/attendance?date=$date"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> checkOut(String token) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl:$_port/api/attendance"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> getLocation(String id) async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/location/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> getProfileInfo() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/employee/current"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<List<dynamic>> getLeaveInfo() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/leave/current"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<Map<String, dynamic>> createLeave(
      String reason, String startDate, String endDate, int leaveDays) async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http
          .post(Uri.parse("$_baseUrl:$_port/api/leave/"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: jsonEncode({
                "leaveReason": reason,
                "startDate": startDate,
                "endDate": endDate,
                "leaveDays": leaveDays
              }))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return {'message': 'Something went wrong'};
    }
  }

  static Future<List<dynamic>> getMonthlyTimesheet(
      String year, String month) async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/timesheet?year=$year&month=$month"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      log('error?');
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<List<dynamic>> getPayslipByYear(String year) async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/payslip/user?year=$year"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<List<dynamic>> getOvertimeRequest() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/overtime/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<List<dynamic>> getTodayEvents() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/event/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<List<dynamic>> getDayoff() async {
    try {
      final token = await UtilSharedPreferences.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl:$_port/api/dayoff/upcoming"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        return result;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return [
        {'message': 'Something went wrong'}
      ];
    }
  }

  static Future<Map<String, List>> getAllEvents() async {
    try {
      final overtimes = await getOvertimeRequest();

      final events = await getTodayEvents();

      final dayoff = await getDayoff();
      // log(overtimes.toString());
      // log(events.toString());
      // log(dayoff.toString());
      return {
        'overtime': overtimes,
        'events': events,
        'dayoff': dayoff,
      };
    } catch (e) {
      // print('event & ot error $e');
      return {'message': []};
    }
  }
}
