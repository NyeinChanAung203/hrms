import 'package:flutter/material.dart';

import '../themes/styles.dart';
import 'otp_screen.dart';

class ForgotPwScreen extends StatefulWidget {
  const ForgotPwScreen({super.key});

  @override
  State<ForgotPwScreen> createState() => _ForgotPwScreenState();
}

class _ForgotPwScreenState extends State<ForgotPwScreen> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  bool isActive = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                    'Forgot Password?',
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Enter the email address associated with your account and we’ll send you OTP code to reset your password.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) {
                if (emailController.text.isNotEmpty) {
                  setState(() {
                    isActive = true;
                  });
                } else {
                  setState(() {
                    isActive = false;
                  });
                }
              },
              autocorrect: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(fontSize: 14),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            height: 60,
            child: ElevatedButton(
              onPressed: isActive
                  ? () {
                      if (emailController.text.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OTPScreen(
                                  email: emailController.text.trim(),
                                )));
                      }
                    }
                  : null,
              child: const Text('Continue'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Back to'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
