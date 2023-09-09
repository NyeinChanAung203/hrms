import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/providers/checkinout_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../themes/styles.dart';

class DetailTimesheetScreen extends StatelessWidget {
  const DetailTimesheetScreen({super.key, required this.dateTime});
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: kPrimaryColor,
                        )),
                  ),
                ),
                Center(
                  child: Text(
                    DateFormat('E, MMM d').format(dateTime),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xffd6d6d6),
          ),
          FutureBuilder(
              future:
                  context.read<CheckInOutProvider>().getCheckInByDate(dateTime),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: kPrimaryColor)),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (!snapshot.data!.containsKey('message')) {
                      return Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Text('Today\'s shifts',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          buildTimesheetTitleBar(context),
                          /* Data Table */
                          ...snapshot.data!['attendances']
                              .map(
                                (e) => buildTimesheetBox(context,
                                    type: e['isOvertime']
                                        ? 'Over Time'
                                        : 'Regular time',
                                    isOvertime: e['isOvertime'],
                                    checkIn: DateFormat().add_jm().format(
                                        DateTime.parse(e['checkinTime'])
                                            .toLocal()),
                                    checkout: e['checkoutTime'] != null
                                        ? DateFormat().add_jm().format(
                                            DateTime.parse(e['checkoutTime'])
                                                .toLocal())
                                        : null,
                                    total: e['totalTime']),
                              )
                              .toList(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Text('Today\'s Totals',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Container(
                            padding: const EdgeInsets.all(24),
                            margin: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Total work hours',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          // fontSize: 16,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Center(
                                  child: Text(
                                    snapshot.data!['totalWorkHours'] ?? "---",
                                    // '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )));
                    }
                  }
                }

                return const Expanded(
                    child: Center(child: Text('No data available')));
              })
        ]),
      ),
    );
  }

  Padding buildTimesheetBox(BuildContext context,
      {required String type,
      required String checkIn,
      required bool isOvertime,
      String? checkout,
      String? total}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffd6d6d6),
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  type,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isOvertime
                            ? Colors.orange
                            : context.watch<ThemeProvider>().themeMode ==
                                    ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                      ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(checkIn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ).fontFamily,
                        )),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(checkout ?? '---',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ).fontFamily,
                        )),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(total ?? '---',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ).fontFamily,
                        )),
              ),
            ],
          )),
    );
  }

  Padding buildTimesheetTitleBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 20, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Text('Type',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          color: const Color(0xff908f8f),
                        ))),
            Expanded(
              flex: 2,
              child: Text('Check In',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        color: const Color(0xff908f8f),
                      )),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 2,
              child: Text('Check Out',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        color: const Color(0xff908f8f),
                      )),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 2,
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        color: const Color(0xff908f8f),
                      )),
            ),
          ],
        ));
  }
}
