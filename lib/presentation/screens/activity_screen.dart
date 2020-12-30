import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/components/activity_details_list.dart';
import 'package:days_without/presentation/components/activity_tile.dart';
import 'package:days_without/presentation/components/alert_dialog.dart';
import 'package:days_without/presentation/components/loader.dart';
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

        return this._activity == null
            ? Loader()
            : Scaffold(
                appBar: AppBar(
                  title: Text(this._activity.name),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/activity-edit',
                        arguments: this._activity.id,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => showDialog(
                        child: Alert(
                          title: 'Delete Activity',
                          content: 'Are you sure?',
                          onPressed: () {
                            BlocProvider.of<ActivitiesBloc>(context).add(
                              ActivityDeleted(this._activity),
                            );

                            Navigator.of(context)
                                .popUntil((t) => t.settings.name == '/');
                          },
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
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: ActivityTile(this._activity),
                        ),
                        ActivityDetailsList(this._activity)
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
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

                        BlocProvider.of<ActivitiesBloc>(context).add(
                          ActivityAddDate(
                            this._activity.id,
                            date,
                          ),
                        );
                      },
                    );
                  },
                  tooltip: 'Add date',
                  child: Icon(Icons.add),
                ),
              );
      },
    );
  }
}
