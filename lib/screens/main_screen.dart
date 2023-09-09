import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/bottomnav_provider.dart';
import '../themes/styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<BottomNavProvider>().index != 0) {
          context.read<BottomNavProvider>().changeIndex(0);
        } else {
          final result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: const Text('Are you sure you want to exit?'),
                    actions: [
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Yes'))),
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No',
                                style: TextStyle(color: Colors.grey))),
                      ),
                    ],
                  ));
          return Future.value(result);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Consumer<BottomNavProvider>(builder: (context, bottomNav, child) {
          return bottomNav.pages[bottomNav.index];
        }),
        bottomNavigationBar: Consumer<BottomNavProvider>(
          builder: (context, bottomNav, child) {
            return Container(
              height: 70,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                )
              ]),
              child: BottomNavigationBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 20,
                  currentIndex: bottomNav.index,
                  onTap: bottomNav.changeIndex,
                  selectedItemColor: kPrimaryColor,
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_filled), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle), label: 'Leave'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.pending_actions), label: 'Timesheet'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.monetization_on), label: 'Payslip'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle), label: 'Profile'),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
