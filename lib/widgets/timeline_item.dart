import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final String title;
  final dynamic description;
  final dynamic time;
  final dynamic icon;
  final bool completed;

  const TimelineItem({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.icon,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      // Simple timeline item with icon
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Icon(icon as IconData, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(time.toString(), style: TextStyle(color: Colors.grey[600])),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        description.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Detailed timeline item with completion status
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? Colors.green : Colors.grey,
                ),
                child: completed
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (completed)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  time.toString(),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      );
    }
  }
}