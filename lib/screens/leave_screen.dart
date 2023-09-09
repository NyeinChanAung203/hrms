import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../themes/styles.dart';
import '../widgets/leave_bottomsheet.dart';
import '../widgets/leave_card.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                'Leave',
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
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, provider, child) {
                return FutureBuilder(
                    future: provider.getLeaveInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ));
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!.isNotEmpty) {
                          if (!snapshot.data!.first.containsKey('message')) {
                            return RefreshIndicator(
                              onRefresh: () => Future.delayed(
                                  Duration.zero, () => provider.notify()),
                              child: ListView.builder(
                                  physics: snapshot.data!.length < 6
                                      ? const AlwaysScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final e = snapshot.data![index];
                                    return LeaveCard(
                                      leaveDays: e['leaveDays'],
                                      requestDate:
                                          DateTime.parse(e['requestDate'])
                                              .toLocal(),
                                      startDate: DateTime.parse(e['startDate'])
                                          .toLocal(),
                                      endDate: DateTime.parse(e['endDate'])
                                          .toLocal(),
                                      reason: e['leaveReason'],
                                      status: e['isApproved'] == e['isDeclined']
                                          ? null
                                          : e['isApproved'],
                                    );
                                  }),
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
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10)),
                onPressed: () async {
                  await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => const LeaveBottomSheet());
                },
                icon: const Icon(Icons.add_circle),
                label: const Text('Add Leave Request')),
          )
        ],
      ),
    );
  }
}
