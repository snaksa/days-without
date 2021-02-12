import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/presentation/common/alert_dialog.dart';
import 'package:days_without/presentation/screens/activity_screen/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EntryDetails extends StatelessWidget {
  final String activityId;
  final DateTime date;

  EntryDetails(this.activityId, this.date);

  Future deleteEntry(BuildContext context) {
    return showDialog(
      builder: (ctx) => Alert(
        title: 'Delete entry',
        content: "Are you sure?",
        actions: [
          AlertAction(
            title: "No",
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          AlertAction(
            title: "Yes",
            onPressed: () {
              BlocProvider.of<ActivitiesBloc>(context).add(
                ActivityDeletedDate(
                  this.activityId,
                  this.date,
                ),
              );

              Navigator.popUntil(
                context,
                ModalRoute.withName(
                  ActivityScreen.ROUTE_NAME,
                ),
              );
            },
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(this.date),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            child: ElevatedButton(
              onPressed: () => this.deleteEntry(context),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Delete',
              ),
            ),
          )
        ],
      ),
    );
  }
}
