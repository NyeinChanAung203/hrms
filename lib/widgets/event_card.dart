import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.description,
    this.dateTime,
    required this.color,
  });

  final String title, description;
  final DateTime? dateTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              CircleAvatar(
                backgroundColor: color,
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
          if (dateTime != null) ...[
            const SizedBox(
              height: 14,
            ),
            Text(
              dateTime!.day == DateTime.now().day
                  ? 'Today  ${DateFormat().add_jm().format(dateTime!)}'
                  : DateFormat('E  ').add_jm().format(dateTime!),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ]
        ]),
      ),
    );
  }
}
