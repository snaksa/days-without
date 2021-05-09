import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/data/models/trophy.dart';
import 'package:days_without/helpers/trophy_helper.dart';
import 'package:days_without/presentation/common/section_title.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/trophies/trophy_item.dart';
import 'package:flutter/material.dart';

class TrophiesTab extends StatelessWidget {
  final Activity activity;

  TrophiesTab(this.activity);

  @override
  Widget build(BuildContext context) {
    Duration latestDuration;
    Duration maxDuration =
        Duration(seconds: this.activity.dates.length > 0 ? 1 : 0);

    if (this.activity.dates.length == 1) {
      maxDuration = DateTime.now().difference(this.activity.dates.first.date);
      latestDuration = maxDuration;
    } else if (this.activity.dates.length > 1) {
      List<ActivityDate> datesWithToday = [
        ActivityDate('0', DateTime.now(), null),
        ...this.activity.dates
      ];

      for (int i = 1; i < datesWithToday.length; i++) {
        Duration datesDifference =
            datesWithToday[i - 1].date.difference(datesWithToday[i].date);

        if (latestDuration == null) {
          latestDuration = datesDifference;
        }

        if (datesDifference > maxDuration) {
          maxDuration = datesDifference;
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('Trophy Room'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...TrophyHelper.trophies
                  .map(
                    (Trophy item) => TrophyItem(
                      item,
                      maxDuration,
                      latestDuration,
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
