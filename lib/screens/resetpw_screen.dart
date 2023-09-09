import 'package:flutter/material.dart';
import 'package:hrms/screens/reset_success.dart';

import '../themes/styles.dart';

class ResetPwScreen extends StatefulWidget {
  const ResetPwScreen({super.key});

  @override
  State<ResetPwScreen> createState() => _ResetPwScreenState();
}

class _ResetPwScreenState extends State<ResetPwScreen> {
  final RegExp passValidator =
      RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  late TextEditingController pwController;
  late TextEditingController cpwController;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isValid = false;
  bool? isStrongPw;
  bool? isMatch;

  @override
  void initState() {
    super.initState();
    pwController = TextEditingController();
    cpwController = TextEditingController();
  }

  @override
  void dispose() {
    pwController.dispose();
    cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      'Reset Password',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: kPrimaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xffd6d6d6),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Text(
                      'At least 8 characters with uppercase, lowercase letters, special characters and numbers.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Text(
                      'Create New Password',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onChanged: (v) {
                        if (passValidator.hasMatch(v) && v.length >= 8) {
                          setState(() {
                            isStrongPw = true;
                          });
                        } else {
                          setState(() {
                            isStrongPw = false;
                          });
                        }
                        if (cpwController.text.isNotEmpty) {
                          if (cpwController.text.trim() ==
                              pwController.text.trim()) {
                            isMatch = true;
                          } else {
                            isMatch = false;
                          }
                          setState(() {});
                        }
                      },
                      autocorrect: false,
                      controller: pwController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Enter New Password',
                          hintStyle: const TextStyle(fontSize: 14),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: isStrongPw == null
                                    ? []
                                    : isStrongPw == true
                                        ? const [
                                            Text(
                                              'Strong',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.sentiment_satisfied_alt,
                                              color: Colors.green,
                                            ),
                                          ]
                                        : const [
                                            Text(
                                              'Weak',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.sentiment_dissatisfied,
                                              color: Colors.red,
                                            ),
                                          ]),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //---------------------
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Text(
                      'Confirm Password',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onChanged: (v) {
                        if (v == pwController.text.trim()) {
                          isMatch = true;
                        } else {
                          isMatch = false;
                        }
                        setState(() {});
                      },
                      autocorrect: false,
                      controller: cpwController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(fontSize: 14),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: isMatch == null
                                    ? []
                                    : isMatch == true
                                        ? const [
                                            Text(
                                              'Match',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.sentiment_satisfied_alt,
                                              color: Colors.green,
                                            ),
                                          ]
                                        : const [
                                            Text(
                                              'Mismatch',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.sentiment_dissatisfied,
                                              color: Colors.red,
                                            ),
                                          ]),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (isMatch != null &&
                              isStrongPw != null &&
                              isMatch == true &&
                              isStrongPw == true &&
                              pwController.text == cpwController.text)
                          ? () {
                              if (pwController.text.isNotEmpty) {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetSuccess()));
                              }
                            }
                          : null,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
