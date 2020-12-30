import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ActivityDetailsList extends StatelessWidget {
  final Activity activity;

  ActivityDetailsList(this.activity);

  List<Widget> buildList(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < activity.dates.length; i++) {
      DateTime nextDate =
          i < activity.dates.length - 1 ? activity.dates[i + 1] : null;

      int days = nextDate != null
          ? activity.dates[i].difference(nextDate).inDays
          : null;

      result.add(
        Dismissible(
          key:
              Key("${activity.id}_${activity.dates[i].millisecondsSinceEpoch}"),
          onDismissed: (direction) {
            BlocProvider.of<ActivitiesBloc>(context).add(
              ActivityDeletedDate(this.activity.id, this.activity.dates[i]),
            );
          },
          confirmDismiss: (direction) {
            return showDialog(
                child: AlertDialog(
                  content: Text("Are you sure?"),
                  actions: [
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
                context: context);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          direction: DismissDirection.startToEnd,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: i > 0 ? 1 : 0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.calendar_today_rounded,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(activity.dates[i]),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(days != null
                        ? "+$days " + (days != 1 ? 'days' : 'day')
                        : '',
                          style: TextStyle(fontSize: 18),),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final list = this.buildList(context);
    return list.length > 0
        ? Container(
            margin: EdgeInsets.only(top: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: list,
                ),
              ),
            ),
          )
        : Container(
            child: Text('No records'),
          );
  }
}
