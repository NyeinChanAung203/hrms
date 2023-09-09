import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkinout_provider.dart';
import '../providers/timer_provider.dart';

class CheckSlider extends StatelessWidget {
  const CheckSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CheckInOutProvider>().isAlreadyCheckIn(),
        builder: (context, snapshot) {
          return Consumer<CheckInOutProvider>(
            builder: (context, ciprovider, child) {
              return ActionSlider.standard(
                direction: ciprovider.isCheckIn
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                actionThreshold: 0.95,
                height: 70,
                backgroundColor: const Color(0xffdfe3e2),
                boxShadow: const [],
                toggleColor: Colors.white,
                icon: Icon(
                  ciprovider.isCheckIn ? Icons.arrow_back : Icons.arrow_forward,
                  color: ciprovider.isCheckIn ? Colors.red : Colors.green,
                ),
                loadingIcon: const CircularProgressIndicator(
                  color: Colors.green,
                ),
                successIcon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                failureIcon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                actionThresholdType: ThresholdType.release,
                action: (controller) async {
                  await ciprovider
                      .onAction(context, controller)
                      .then((value) async {
                    if (value) {
                      await context.read<TimerProvider>().isAlreadyStartTimer();
                    } else {
                      context.read<TimerProvider>().timerCancel();
                      await context.read<TimerProvider>().isAlreadyStartTimer();
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Swipe to ',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.black,
                            )),
                    Text(
                      ciprovider.isCheckIn ? 'CHECK OUT' : 'CHECK IN',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
