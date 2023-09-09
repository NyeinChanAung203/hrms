import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/timer_provider.dart';
import '../themes/styles.dart';

class TimerCount extends StatefulWidget {
  const TimerCount({super.key});

  @override
  State<TimerCount> createState() => _TimerCountState();
}

class _TimerCountState extends State<TimerCount> {
  late final Future<void> checkStartTime;
  @override
  void initState() {
    super.initState();
    checkStartTime = context.read<TimerProvider>().isAlreadyStartTimer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkStartTime,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Container(
          //     height: 100,
          //     width: 100,
          //     color: kPrimaryColor,
          //   );
          // }
          // if (snapshot.connectionState == ConnectionState.done) {
          //   print('done');
          //   if (snapshot.hasData) {
          //     print(' no data');
          //     timerProvider.timerCancel();
          //   }
          // }
          return Consumer<TimerProvider>(
            builder: (context, timerProvider, child) {
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Started Time ${timerProvider.startTime == null ? '---' : DateFormat().add_jm().format(timerProvider.startTime!)}',
                        // 'Started Time: ${timerProvider.startTime == null ? '---' : "${timerProvider.startTime!.hour}:${timerProvider.startTime!.minute}"}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${timerProvider.hours}:${timerProvider.minutes}:${timerProvider.seconds}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    const SizedBox(
                      height: 9,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total hours:',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 16,
                                ),
                          ),
                          Text(
                            timerProvider.totalWorkHours,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ]),
                  ],
                ),
              );
            },
          );
        });
  }
}
