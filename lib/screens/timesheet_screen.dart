import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';

import '../services/auth_service.dart';
import '../themes/styles.dart';
import '../widgets/timesheet_card.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  DateTime today = DateTime.now();

  decreaseMonth() {
    setState(() {
      today = DateTime(today.year, today.month - 1);
    });
  }

  increaseMonth() {
    setState(() {
      today = DateTime(today.year, today.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                'Time Sheet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: kPrimaryColor,
                    ),
              ),
            ),
          ),
          const Divider(
            color: Color(0xffd6d6d6),
            height: 2,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      decreaseMonth();
                    },
                    color: kPrimaryColor,
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 30,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6 > 220
                      ? 220
                      : MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    DateFormat('MMMM, y').format(today),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      increaseMonth();
                    },
                    color: kPrimaryColor,
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 30,
                    )),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: AuthService.getMonthlyTimesheet(
                    today.year.toString(), today.month.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        if (!snapshot.data![0].containsKey('message')) {
                          return Column(children: [
                            snapshot.data!.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24, horizontal: 12),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total leaves in this month',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                        Text(
                                          '${snapshot.data![0]['leaveDays']} Days',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Expanded(
                              child: snapshot.data!.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final e = snapshot.data![index];
                                        return TimesheetListCard(
                                          day: DateTime.parse(e['date'])
                                              .toLocal(),
                                          totalHours:
                                              e['totalWorkHours'] ?? '---',
                                        );
                                      })
                                  : const Center(
                                      child: Text('No data available')),
                            ),
                          ]);
                        }
                      }
                    }
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/empty.svg',
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'No data available',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
