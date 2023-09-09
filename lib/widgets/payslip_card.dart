import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../themes/styles.dart';

class PayslipCard extends StatelessWidget {
  const PayslipCard({
    super.key,
    required this.basicSalary,
    required this.attendanceBonus,
    required this.allowance,
    required this.overtimeBonus,
    required this.totalPayment,
    required this.year,
    required this.month,
  });

  final int basicSalary;
  final int attendanceBonus;
  final int allowance;
  final int overtimeBonus;
  final int totalPayment;
  final int year, month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(
          color: context.watch<ThemeProvider>().themeMode == ThemeMode.light
              ? Colors.black.withOpacity(0.25)
              : Colors.white.withOpacity(0.7),
          offset: const Offset(
            0,
            0,
          ),
          blurRadius: 4,
          spreadRadius: 1,
          blurStyle: BlurStyle.outer,
        )
      ]),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor:
              Theme.of(context).colorScheme.shadow.withOpacity(1),
          iconColor: kPrimaryColor,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              DateFormat('MMMM').format(DateTime(year, month)),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Row(children: [
              Text(
                '$totalPayment MMK',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 26,
              ),
            ])
          ]),
          children: [
            Divider(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          buildCategoryTitle(context, 'Basic Salary'),
                          buildCategoryTitle(context, 'Attendance Bonus'),
                          buildCategoryTitle(context, 'Allowance'),
                          buildCategoryTitle(context, 'Over Time'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildFee(context, '$basicSalary'),
                          buildFee(context, '$attendanceBonus',
                              color: attendanceBonus < 0
                                  ? Colors.red
                                  : Colors.green),
                          buildFee(context, '$allowance',
                              color: allowance < 0 ? Colors.red : Colors.green),
                          buildFee(context, '$overtimeBonus',
                              color: Colors.green),
                        ],
                      ),
                    ),
                  ]),
            ),
            Divider(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          buildCategoryTitle(context, 'Total Payment'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            buildFee(
                              context,
                              '$totalPayment',
                            ),
                          ]),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFee(
    BuildContext context,
    String fee, {
    Color? color,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text('$fee MMK',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w500, color: color)),
      );

  Padding buildCategoryTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w400)),
          const Text(':')
        ],
      ),
    );
  }
}
