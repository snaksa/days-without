import 'package:days_without/data/models/activity_date.dart';
import 'package:flutter/material.dart';

class StatsItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<ActivityDate> dates;

  StatsItem(this.item, this.dates);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          this.item['icon'],
          color: Colors.red,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              border: this.item.containsKey('hideBorder') &&
                      this.item['hideBorder']
                  ? null
                  : Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade500, width: 0.5),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.item['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(this.item['calculate'](this.dates).toString())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
