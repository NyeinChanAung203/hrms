import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screens/detail_timesheet.dart';
import '../themes/styles.dart';

class TimesheetListCard extends StatelessWidget {
  const TimesheetListCard({
    super.key,
    required this.day,
    required this.totalHours,
  });

  final DateTime day;
  final String totalHours;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailTimesheetScreen(
                  dateTime: day,
                )));
      },
      child: Container(
          height: 68,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xffd6d6d6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd').format(day),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontSize: 12,
                                  color: (day
                                              .difference(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day))
                                              .inDays ==
                                          0)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .shadow
                                          .withOpacity(1)
                                      : context
                                                  .watch<ThemeProvider>()
                                                  .themeMode ==
                                              ThemeMode.light
                                          ? Colors.black26
                                          : Colors.white38,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            DateFormat('E').format(day),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: (day
                                              .difference(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day))
                                              .inDays ==
                                          0)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .shadow
                                          .withOpacity(1)
                                      : context
                                                  .watch<ThemeProvider>()
                                                  .themeMode ==
                                              ThemeMode.light
                                          ? Colors.black26
                                          : Colors.white38,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                      width: 1,
                      height: 64,
                    ),
                    Expanded(
                      flex: 5,
                      child: RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              children: [
                            const TextSpan(text: 'Daily Total '),
                            TextSpan(
                              text: totalHours,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      textBaseline: TextBaseline.ideographic,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ])),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right)
            ],
          )),
    );
  }
}
