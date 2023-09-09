import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hrms/providers/auth_provider.dart';
import 'package:hrms/providers/bottomnav_provider.dart';
import 'package:hrms/providers/checkinout_provider.dart';
import 'package:hrms/providers/theme_provider.dart';
import 'package:hrms/providers/timer_provider.dart';

import 'package:hrms/screens/login_screen.dart';
import 'package:hrms/screens/main_screen.dart';
import 'package:hrms/services/notification_service.dart';

import 'package:hrms/themes/my_theme.dart';
import 'package:hrms/utils/shared_pre_util.dart';
import 'package:hrms/utils/show_message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// TODO: Noti, Reminder

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print('${message.data}');
  if (message.data.isNotEmpty) {
    print('message data is not empty');
    NotificationService.sendNotification('Test Test Title', 'helibici icdiowi');
    NotificationService.showDefinedScheduleNotification(
        DateTime.parse(message.data['date_time']).toLocal(),
        'Reminder',
        'You have ${message.data['title']} at ${DateFormat().add_jm().format(DateTime.parse(message.data['date_time']).toLocal())}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.initializeNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Status Bar Theme
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Error Widget
  ErrorWidget.builder = (FlutterErrorDetails detail) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          'Error \n${detail.exception}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  };

  // FCM
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('token = $fcmToken');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message);
    print(message.notification);
    print(message.notification?.title);
    print(message.notification?.body);
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    NotificationService.sendNotification(
        message.data['title'], message.data['message']);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print(message.notification!.title);
      print(message.notification!.body);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => CheckInOutProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()..getThemeMode()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'HRMS',
            debugShowCheckedModeBanner: false,
            // debugShowMaterialGrid: true,
            theme: MyTheme.lightTheme(),
            darkTheme: MyTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: const Wrapper(),
          );
        },
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({
    super.key,
  });

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showMessage(context, 'No Internet Connection');
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showSuccessMessage(context, 'Connected');
      }
    });
    Future.delayed(
        Duration.zero,
        () => Connectivity().checkConnectivity().then((result) {
              if (result == ConnectivityResult.none) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                showMessage(context, 'No Internet Connection');
              } else if (result == ConnectivityResult.mobile ||
                  result == ConnectivityResult.wifi) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                showSuccessMessage(context, 'Connected');
              }
            }));
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: UtilSharedPreferences.getToken(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const LoginScreen();
              } else {
                return const MainScreen();
              }
            }));
  }
}
