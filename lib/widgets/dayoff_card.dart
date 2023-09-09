import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayoffCard extends StatelessWidget {
  const DayoffCard({
    super.key,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  final String title, description;
  final DateTime startDate, endDate;

  @override
  Widget build(BuildContext context) {
    final int day = DateTime(endDate.year, endDate.month, endDate.day)
            .difference(
                DateTime(startDate.year, startDate.month, startDate.day))
            .inDays +
        1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 1),
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
            )
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 7,
              )
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                      children: [
                    const TextSpan(text: 'From '),
                    TextSpan(
                      text: DateFormat('dd/MM/yy').format(startDate),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          textBaseline: TextBaseline.ideographic,
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: ' To ',
                    ),
                    TextSpan(
                      text: DateFormat('dd/MM/yy').format(endDate),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    ),
                  ])),
              Text(
                '$day ${day > 1 ? 'Days' : 'Day'}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
