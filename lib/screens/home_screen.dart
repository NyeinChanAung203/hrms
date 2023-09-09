import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/services/notification_service.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

import '../services/auth_service.dart';
import '../themes/styles.dart';
import '../widgets/check_slider.dart';
import '../widgets/dayoff_card.dart';
import '../widgets/event_card.dart';
import '../widgets/timer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                splashRadius: 20,
                icon:
                    context.watch<ThemeProvider>().themeMode == ThemeMode.light
                        ? const Icon(
                            Icons.light_mode,
                            size: 30,
                            color: Color(0xffFCE570),
                          )
                        : const Icon(
                            Icons.dark_mode,
                            size: 30,
                            color: Color(0xffD8d6cb),
                          ),
                onPressed: () {
                  context
                      .read<ThemeProvider>()
                      .changeThemeMode(context.read<ThemeProvider>().themeMode);
                },
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              child: TimerCount()),
          const Padding(
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 15),
            child: CheckSlider(),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 0,
                    right: 0,
                  ),
                  decoration: const BoxDecoration(
                      color: Color(0xffb3b3b3),
                      // border: Border.all(color: Color(0xffb3b3b3)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // color: Color(0xffb3b3b3),
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(1),
                      // border: Border.all(color: Color(0xffb3b3b3)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: const OvertimeWidget(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OvertimeWidget extends StatefulWidget {
  const OvertimeWidget({
    super.key,
  });

  @override
  State<OvertimeWidget> createState() => _OvertimeWidgetState();
}

class _OvertimeWidgetState extends State<OvertimeWidget> {
  late Future getRequests;

  @override
  void initState() {
    super.initState();
    getRequests = AuthService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty &&
                  !snapshot.data!.containsKey('message')) {
                final List overtimes = snapshot.data!['overtime'];
                final List events = snapshot.data!['events'];
                final List dayoff = snapshot.data!['dayoff'];
                final requestLength = overtimes.length + events.length;
                //send reminder
                if (events.isNotEmpty && !events.first.containsKey('message')) {
                  for (var element in events) {
                    print(DateTime.parse(element['date_time']).toLocal());
                    NotificationService.showDefinedScheduleNotification(
                        DateTime.parse(element['date_time']).toLocal(),
                        'Reminder',
                        'You have ${element['title']} at ${DateFormat().add_jm().format(DateTime.parse(element['date_time']).toLocal())}');
                    print('send noti');
                  }
                }

                if (overtimes.isNotEmpty &&
                        !overtimes.first.containsKey('message') ||
                    events.isNotEmpty && !events.first.containsKey('message') ||
                    dayoff.isNotEmpty && !dayoff.first.containsKey('message')) {
                  return RefreshIndicator(
                    displacement: 30,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {
                      setState(() {
                        getRequests = AuthService.getAllEvents();
                      });
                    },
                    child: ListView(
                      physics: requestLength < 3
                          ? const AlwaysScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      children: [
                        ...events
                            .map((e) => EventCard(
                                  title: e['title'],
                                  color: Colors.red,
                                  description: e['description'],
                                  dateTime:
                                      DateTime.parse(e['date_time']).toLocal(),
                                ))
                            .toList()
                            .reversed
                            .toList(),
                        ...overtimes
                            .map((e) => EventCard(
                                title: 'Overtime Request',
                                color: Colors.orange,
                                description: e['description']))
                            .toList(),
                        ...dayoff.map((e) => DayoffCard(
                              title: e['title'],
                              description: e['description'],
                              startDate:
                                  DateTime.parse(e['start_date']).toLocal(),
                              endDate: DateTime.parse(e['end_date']).toLocal(),
                            ))
                      ],
                    ),
                    // ListView.builder(
                    //   itemCount: overtimes!.length,
                    //   itemBuilder: (context, index) {
                    //     final data = overtimes[index];
                    //     return EventCard(
                    //       title: 'Overtime Request',
                    //       description: data['description'],
                    //     );
                    //   },
                    //   physics:
                    //       // snapshot.data < 3
                    //       // ? const AlwaysScrollableScrollPhysics()
                    //       // :
                    //       const BouncingScrollPhysics(),
                    // ),
                  );
                }
              }
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/event.svg',
                height: 180,
                width: 180,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'No Upcoming Events',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          );
        });
  }
}
