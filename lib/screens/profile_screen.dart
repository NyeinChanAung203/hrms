import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../themes/styles.dart';
import '../widgets/profile_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              'Profile',
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
          child: FutureBuilder(
              future: AuthService.getProfileInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (!snapshot.data!.containsKey('message')) {
                      return SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FadeInImage(
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                      'assets/avatar.jpg',
                                    ),
                                    image: NetworkImage(
                                      snapshot.data?['imgUrl'],
                                    ),
                                    imageErrorBuilder: (context, error, _) {
                                      return Image.asset(
                                        'assets/avatar.jpg',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              //     CircleAvatar(
                              //   backgroundImage: NetworkImage(
                              //     snapshot.data?['imgUrl'],
                              //   ),
                              //   radius: 50,
                              // ),
                            ),
                            ProfileInfoCard(
                              iconData: Icons.account_box,
                              label: 'Name',
                              title: snapshot.data?['name'],
                            ),
                            ProfileInfoCard(
                              iconData: Icons.badge,
                              label: 'NRC',
                              title: snapshot.data?['nrcNumber'],
                            ),
                            ProfileInfoCard(
                              iconData: Icons.work,
                              label: 'Position',
                              title: snapshot.data?['department']['position']
                                  ['name'],
                            ),
                            ProfileInfoCard(
                              iconData: Icons.phone,
                              label: 'Phone Number',
                              title: snapshot.data?['mobileNumber'],
                            ),
                            ProfileInfoCard(
                              iconData: Icons.email,
                              label: 'Email Address',
                              title: snapshot.data?['email'],
                            ),
                            ProfileInfoCard(
                              iconData: Icons.calendar_month,
                              label: 'Starting Date',
                              title: snapshot.data!['startDate'].toString(),
                            ),
                            ProfileInfoCard(
                              iconData: Icons.paid,
                              label: 'Basic Pay',
                              title: snapshot.data!['basicSalary'].toString(),
                            ),
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<AuthProvider>()
                                        .logout(context);
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Logout')),
                            ),
                          ],
                        ),
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
              }),
        ),
      ]),
    );
  }
}
