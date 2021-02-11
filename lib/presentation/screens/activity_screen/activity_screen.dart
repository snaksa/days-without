import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_dialog.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:days_without/presentation/screens/activity_edit_screen.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/overview/overview.dart';
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
            child: ActivityOverviewTab(this._activity),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Overview',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: 'Motivation',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Trophies',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            selectedItemColor: Colors.blue,
            onTap: null,
          ),
        );
      },
    );
  }
}
