import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../themes/styles.dart';

class LeaveCard extends StatelessWidget {
  const LeaveCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.requestDate,
    required this.reason,
    required this.status,
    required this.leaveDays,
  });

  final DateTime startDate, endDate, requestDate;
  final int leaveDays;
  final String reason;
  final bool? status;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 25,
        ),
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
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd, MMM').format(requestDate),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    DateFormat('MMM').format(requestDate),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              width: 1,
              height: 64,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                      text: TextSpan(
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                          children: [
                        const TextSpan(text: 'From '),
                        TextSpan(
                          text: DateFormat('dd/MM').format(startDate),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  textBaseline: TextBaseline.ideographic,
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: ' To ',
                        ),
                        TextSpan(
                          text: DateFormat('dd/MM').format(endDate),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                        ),
                      ])),
                  Text(
                    '$reason, $leaveDays Days',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 0,
                color: status != null
                    ? status == true
                        ? Colors.green
                        : Colors.red
                    : Colors.grey,
                shape: const StadiumBorder(),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      status != null
                          ? status == true
                              ? 'Approved'
                              : 'Declined'
                          : 'Pending',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: status != null ? Colors.white : Colors.black),
                    )),
              ),
            )
          ],
        ));
  }
}
