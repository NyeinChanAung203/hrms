import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/styles.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.iconData,
    required this.label,
    required this.title,
  });

  final IconData iconData;
  final String label, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffd6d6d6),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 5),
            child: Icon(
              iconData,
              size: 30,
              color: kPrimaryColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kPrimaryColor,
                        fontFamily: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ).fontFamily,
                      )),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ).fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
