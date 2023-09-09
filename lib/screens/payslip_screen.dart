import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/auth_service.dart';
import '../themes/styles.dart';
import '../widgets/payslip_card.dart';

class PaySlipScreen extends StatefulWidget {
  const PaySlipScreen({super.key});

  @override
  State<PaySlipScreen> createState() => _PaySlipScreenState();
}

class _PaySlipScreenState extends State<PaySlipScreen> {
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              'Paid Slip',
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
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      year -= 1;
                    });
                  },
                  color: kPrimaryColor,
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  )),
              SizedBox(
                width: 100,
                child: Text(
                  year.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      year += 1;
                    });
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
                future: AuthService.getPayslipByYear(year.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty &&
                          !snapshot.data?.first.containsKey('message')) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return PayslipCard(
                              basicSalary: data['basic_salary'],
                              allowance: data['allowance'],
                              overtimeBonus: data['overtime_bonus'],
                              totalPayment: data['total_payment'],
                              attendanceBonus: data['attendance_bonus'],
                              year: data['year'],
                              month: data['month'],
                            );
                          },
                        );
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
                }))
      ]),
    );
  }
}
