import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/section_title.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/stats/items.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/stats/stats_item.dart';
import 'package:flutter/material.dart';

class ActivityStatsTab extends StatelessWidget {
  final Activity activity;

  ActivityStatsTab(this.activity);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('Stats'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...stats
                      .map(
                        (Map<String, dynamic> item) =>
                            StatsItem(item, this.activity.dates),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
