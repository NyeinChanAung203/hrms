import 'package:flutter/material.dart';
import 'package:hrms/screens/resetpw_screen.dart';
import 'package:pinput/pinput.dart';
import '../themes/styles.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.email});

  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late TextEditingController otpController;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                    'Verification',
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
            child: RichText(
              text: TextSpan(
                  text: 'Enter OTP code from your email\n',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: 'Your email: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: widget.email,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
          Pinput(
            length: 6,
            controller: otpController,
            defaultPinTheme: const PinTheme(
                width: 50,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 2),
                textStyle: TextStyle(color: Colors.black),
                decoration: BoxDecoration(
                    color: Color(0xffd6d6d6), shape: BoxShape.circle)),
            onChanged: (v) {
              if (otpController.text.length == 6) {
                setState(() {
                  isValid = true;
                });
              } else {
                setState(() {
                  isValid = false;
                });
              }
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            height: 60,
            child: ElevatedButton(
              onPressed: isValid
                  ? () {
                      // FocusScope.of(context).unfocus();
                      // Navigator.of(context).popUntil((route) => route.isFirst);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResetPwScreen()));
                    }
                  : null,
              child: const Text('Verify'),
            ),
          ),
        ]),
      ),
    );
  }
}
