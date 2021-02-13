import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:days_without/presentation/common/section_title.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/motivation/_item.dart';
import 'package:days_without/presentation/screens/motivation_form_screen.dart';
import 'package:flutter/material.dart';

class ActivityMotivationTab extends StatelessWidget {
  final Activity activity;

  ActivityMotivationTab(this.activity);

  @override
  Widget build(BuildContext context) {
    int position = 0;

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (this.activity.motivations.isEmpty == false)
            SectionTitle('Reasons to Quit'),
          ...this.activity.motivations.map(
            (ActivityMotivation motivation) {
              position++;
              return MotivationItem(motivation, position);
            },
          ).toList(),
          Center(
            child: ElevatedButton(
              child: this.activity.motivations.isEmpty
                  ? Text('Add your first reason to quit')
                  : Text('New reason to quit'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MotivationFormScreen.ROUTE_NAME,
                  arguments: MotivationFormProps(this.activity.id, null),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
