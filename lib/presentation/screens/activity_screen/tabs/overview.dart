import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/notifications/notifications_bloc.dart';
import 'package:days_without/bloc/notifications/notifications_event.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_action.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_dialog.dart';
import 'package:days_without/presentation/common/section_title.dart';
import 'package:days_without/presentation/components/activity_calendar.dart';
import 'package:days_without/presentation/components/activity_tile/activity_tile.dart';
import 'package:days_without/presentation/screens/activity_screen/activity_screen.dart';
import 'package:days_without/presentation/screens/activity_screen/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Passed {
  String id;
  DateTime date;

  Passed(this.id, this.date);
}

class ActivityOverviewTab extends StatelessWidget {
  final Activity activity;

  ActivityOverviewTab(this.activity);

  void onDateClick(BuildContext context, DateTime date) {
    DateTime now = DateTime.now();
    if (now.difference(date).isNegative) {
      BlocProvider.of<NotificationsBloc>(context).add(
        NotificationSend(
          'The entry cannot be in the future',
          now.microsecondsSinceEpoch,
        ),
      );
      return;
    }

    bool hasEntry = false;
    this.activity.dates.forEach((DateTime d) {
      if (d.day == date.day && d.month == date.month && d.year == date.year) {
        hasEntry = true;
      }
    });

    if (!hasEntry) {
      Navigator.pushNamed(
        context,
        EntryForm.ROUTE_NAME,
        arguments: Passed(this.activity.id, date),
      );
    } else {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 400,
              color: Colors.blue[50],
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'All entries on this day',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...this
                        .activity
                        .dates
                        .where(
                          (DateTime d) => (date.day == d.day &&
                              date.month == d.month &&
                              date.year == d.year),
                        )
                        .map((DateTime d) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  padding: EdgeInsets.all(16),
                                  color: Colors.blue[50],
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.access_time),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    DateFormat('HH:mm')
                                                        .format(d),
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.comment),
                                                  SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      'TODO: implement comments',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: () => showDialog(
                                            child: Alert(
                                              title: 'Delete date',
                                              content: "Are you sure?",
                                              actions: [
                                                AlertAction(
                                                  title: "No",
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                                AlertAction(
                                                  title: "Yes",
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                ActivitiesBloc>(
                                                            context)
                                                        .add(
                                                      ActivityDeletedDate(
                                                        this.activity.id,
                                                        d,
                                                      ),
                                                    );
                                                    Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                        ActivityScreen
                                                            .ROUTE_NAME,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            context: context,
                                          ),
                                          child: Text('Delete'),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time),
                                        SizedBox(width: 8),
                                        Text(
                                          DateFormat('HH:mm').format(d),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    Center(
                      child: ElevatedButton(
                        child: const Text('New Entry'),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            EntryForm.ROUTE_NAME,
                            arguments: Passed(this.activity.id, date),
                          ).then((value) => Navigator.of(context).pop());
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
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
