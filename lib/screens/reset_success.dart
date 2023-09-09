import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../themes/styles.dart';

class ResetSuccess extends StatelessWidget {
  const ResetSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 50,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Your password has been changed successfully!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w100,
                    fontFamily: GoogleFonts.poppins(
                      fontWeight: FontWeight.w200,
                    ).fontFamily),
                textAlign: TextAlign.center,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      },
                      child: const Text('Done')))
            ]),
      ),
    );
  }
}
