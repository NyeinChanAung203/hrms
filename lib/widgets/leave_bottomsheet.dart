import 'package:flutter/material.dart';
import 'package:hrms/utils/show_message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../themes/styles.dart';

class LeaveBottomSheet extends StatefulWidget {
  const LeaveBottomSheet({super.key});

  @override
  State<LeaveBottomSheet> createState() => _LeaveBottomSheetState();
}

class _LeaveBottomSheetState extends State<LeaveBottomSheet> {
  bool isValid = DateFormat('EEEE').format(DateTime.now()) != 'Saturday' ||
      DateFormat('EEEE').format(DateTime.now()) != 'Sunday';

  String reason = 'Vacation';
  DateTime fromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime toDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  int totalDays = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.watch<ThemeProvider>().themeMode == ThemeMode.light
              ? Colors.white
              : const Color(0xff242424),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Leave Request',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
            ),
            const Divider(
              color: Color(0xffa1a1a1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reason',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                    GestureDetector(
                      onTap: () async {
                        final String? selectedItemName =
                            await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => buildReasonModalSheet(),
                        );

                        setState(() {
                          reason = selectedItemName ?? reason;
                        });
                      },
                      child: Text(reason,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  )),
                    ),
                  ]),
            ),
            const Divider(
              color: Color(0xffa1a1a1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                            builder: (context, child) => Theme(
                                  data: ThemeData(
                                      colorScheme: context
                                                  .watch<ThemeProvider>()
                                                  .themeMode ==
                                              ThemeMode.light
                                          ? const ColorScheme.light(
                                              primary: kPrimaryColor,
                                            )
                                          : const ColorScheme.dark(
                                              primary: kPrimaryColor,
                                            )),
                                  child: child!,
                                ),
                            context: context,
                            initialDate: fromDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(
                              DateTime.now().year + 2,
                            ));
                        setState(() {
                          fromDate = selectedDate ?? fromDate;

                          totalDays = toDate.difference(fromDate).inDays;

                          totalDays += 1;

                          if (totalDays < 1) {
                            toDate = fromDate;
                            totalDays = toDate.difference(fromDate).inDays;
                            totalDays += 1;
                          }
                          /* Check selected day is holiday, true => Not valid */
                          final fromCondition =
                              DateFormat('EEEE').format(fromDate);
                          final toCondition = DateFormat('EEEE').format(toDate);
                          if (fromCondition == 'Saturday' ||
                              fromCondition == 'Sunday' ||
                              toCondition == 'Saturday' ||
                              toCondition == 'Sunday') {
                            isValid = false;
                          } else {
                            isValid = true;
                          }
                          /* Check there is holiday in selected date range */
                          // if true, subtract for holidays
                          int tempDay = 0;
                          for (int i = 0; i < totalDays; i++) {
                            final tempDate = DateFormat('EEEE')
                                .format(fromDate.add(Duration(days: i)));
                            if (tempDate == 'Saturday' ||
                                tempDate == 'Sunday') {
                              tempDay -= 1;
                            }
                          }
                          totalDays += tempDay;
                          //----------
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: const Color(0xffa1a1a1),
                        )),
                        child: Text(DateFormat('dd/MM/yy').format(fromDate),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                )),
                      ),
                    ),
                    Text('To',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                            builder: (context, child) => Theme(
                                  data: ThemeData(
                                      colorScheme: context
                                                  .watch<ThemeProvider>()
                                                  .themeMode ==
                                              ThemeMode.light
                                          ? const ColorScheme.light(
                                              primary: kPrimaryColor,
                                            )
                                          : const ColorScheme.dark(
                                              primary: kPrimaryColor,
                                            )),
                                  child: child!,
                                ),
                            context: context,
                            initialDate: toDate,
                            firstDate: fromDate,
                            lastDate: DateTime(
                              DateTime.now().year + 2,
                            ));
                        setState(() {
                          toDate = selectedDate ?? toDate;
                          totalDays = toDate.difference(fromDate).inDays;
                          totalDays += 1;

                          /* Check selected day is holiday, true => Not valid */
                          final fromCondition =
                              DateFormat('EEEE').format(fromDate);
                          final toCondition = DateFormat('EEEE').format(toDate);
                          if (fromCondition == 'Saturday' ||
                              fromCondition == 'Sunday' ||
                              toCondition == 'Saturday' ||
                              toCondition == 'Sunday') {
                            isValid = false;
                          } else {
                            isValid = true;
                          }
                          /* Check there is holiday in selected date range */
                          // if true, subtract for holidays
                          int tempDay = 0;
                          for (int i = 0; i < totalDays; i++) {
                            final tempDate = DateFormat('EEEE')
                                .format(fromDate.add(Duration(days: i)));
                            if (tempDate == 'Saturday' ||
                                tempDate == 'Sunday') {
                              tempDay -= 1;
                            }
                          }
                          totalDays += tempDay;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: const Color(0xffa1a1a1),
                        )),
                        child: Text(DateFormat('dd/MM/yy').format(toDate),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                )),
                      ),
                    ),
                  ]),
            ),
            const Divider(
              color: Color(0xffa1a1a1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Leave Day',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                    Text('$totalDays ${totalDays > 1 ? 'Days' : 'Day'}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            )),
                  ]),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
                child: isValid
                    ? Text(
                        'Leave request need manager approval',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: const Color(0xffaeaeae)),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text('Your selected date is already dayoff',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.red)),
                        ],
                      )),
            Container(
                height: 50,
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.white,
                    ),
                    onPressed: isLoading
                        ? null
                        : !isValid
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });

                                await context
                                    .read<AuthProvider>()
                                    .createLeave(
                                        reason, fromDate, toDate, totalDays)
                                    .then((value) {
                                  if (value) {
                                    Navigator.of(context).pop();
                                    showSuccessBottomSheet(
                                        context,
                                        "Your leave request was sent for your mananger's approval",
                                        null,
                                        true,
                                        "I'm done");
                                    context.read<AuthProvider>().notify();
                                  } else {
                                    Navigator.of(context).pop();
                                    showSuccessBottomSheet(
                                        context,
                                        "Your leave request for selected date is already approved",
                                        null,
                                        false,
                                        "Add New One");
                                    // Future.delayed(
                                    //     const Duration(seconds: 1),
                                    //     () =>);
                                  }
                                });
                              },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: kPrimaryColor,
                          )
                        : const Text('Send for Approval'))),
            SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'))),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReasonModalSheet() {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        // height: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 15),
                child: Center(
                  child: Text('Select Reason',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          )),
                ),
              ),
              const Divider(
                color: Color(0xffa1a1a1),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop('Vacation');
                },
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.surfing,
                        color: kPrimaryColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Vacation',
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffa1a1a1),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop('Sick');
                },
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sick,
                        color: kPrimaryColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Sick',
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffa1a1a1),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop('Emergency');
                },
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emergency,
                        color: kPrimaryColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Emergency',
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffa1a1a1),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop('Other');
                },
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.accessibility,
                        color: kPrimaryColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Other',
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffa1a1a1),
              ),
              Container(
                  height: 50,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')))
            ],
          ),
        ));
  }
}
