import 'package:days_without/bloc/notifications/index.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/presentation/common/section_title.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/overview/calendar.dart';
import 'package:days_without/presentation/components/activity_tile/activity_tile.dart';
import 'package:days_without/presentation/screens/entry_form_screen.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/overview/entries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityOverviewTab extends StatelessWidget {
  final Activity activity;

  ActivityOverviewTab(this.activity);

  void onDateClick(BuildContext context, DateTime date) {
    DateTime now = DateTime.now();
    if (now.difference(date).isNegative) {
      BlocProvider.of<NotificationsBloc>(context).add(
        NotificationSend(
          'The entry can not be in the future',
          now.microsecondsSinceEpoch,
        ),
      );
      return;
    }

    bool hasEntry = false;
    this.activity.dates.forEach((ActivityDate d) {
      if (d.date.day == date.day &&
          d.date.month == date.month &&
          d.date.year == date.year) {
        hasEntry = true;
      }
    });

    if (!hasEntry) {
      Navigator.pushNamed(
        context,
        EntryFormScreen.ROUTE_NAME,
        arguments: EntryFormProps(this.activity.id, date),
      );
    } else {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return EntriesList(this.activity, date);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('Overview'),
          Center(
            child: ActivityTile(this.activity),
          ),
          SectionTitle('Calendar'),
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Calendar(
                this.activity,
                onDateClick: (DateTime date) => this.onDateClick(context, date),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
