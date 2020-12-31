import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/bloc/notifications/notifications_bloc.dart';
import 'package:days_without/bloc/notifications/notifications_event.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_action.dart';
import 'package:days_without/presentation/components/activity_details_list.dart';
import 'package:days_without/presentation/components/activity_tile.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_dialog.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:days_without/presentation/screens/activity_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key key}) : super(key: key);

  static const String ROUTE_NAME = '/activity';

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Activity _activity;

  void deleteActivity() {
    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityDeleted(this._activity),
    );

    Navigator.of(context).popUntil((t) => t.settings.name == '/');
  }

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then(
      (date) {
        if (date == null) {
          return;
        }
        DateTime midnight = new DateTime(date.year, date.month, date.day);

        bool exists = false;
        this._activity.dates.forEach((element) {
          if (element.millisecondsSinceEpoch ==
              midnight.millisecondsSinceEpoch) {
            exists = true;
          }
        });

        if (exists) {
          BlocProvider.of<NotificationsBloc>(context).add(
            NotificationSend('Date already added', DateTime.now().millisecondsSinceEpoch),
          );
          return;
        }

        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityAddDate(this._activity.id, midnight),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;

    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, state) {
        if (state is ActivitiesLoadSuccess) {
          state.activities.forEach((a) {
            if (a.id == id) {
              this._activity = a;
            }
          });
        } else if (state is ActivitiesLoadInProgress) {
          return Loader();
        }

        if (this._activity == null) {
          return Loader();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(this._activity.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(
                  context,
                  ActivityEditScreen.ROUTE_NAME,
                  arguments: this._activity.id,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog(
                  child: Alert(
                    title: 'Delete Activity',
                    content: 'Are you sure?',
                    actions: [
                      AlertAction(
                        title: 'No',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      AlertAction(
                        title: 'Yes',
                        onPressed: this.deleteActivity,
                      ),
                    ],
                  ),
                  context: context,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ActivityTile(this._activity),
                  ActivityDetailsList(this._activity)
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: this.chooseDate,
            tooltip: 'Add date',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
