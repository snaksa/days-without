import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/components/activity_details_list.dart';
import 'package:days_without/presentation/components/activity_details_title.dart';
import 'package:days_without/presentation/components/activity_form.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Activity _activity;

  void updateActivity(String name) {
    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityUpdated(this._activity.copyWith(name: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments ?? '1';
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
                      onPressed: () => showDialog(
                        child: ActivityForm(
                          onSave: this.updateActivity,
                          name: this._activity.name,
                        ),
                        context: context,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => showDialog(
                        child: AlertDialog(
                            content: Text("Are you sure?"),
                            actions: [
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  BlocProvider.of<ActivitiesBloc>(context).add(
                                    ActivityDeleted(this._activity),
                                  );

                                  Navigator.of(context)
                                      .popUntil((t) => t.settings.name == '/');
                                },
                              ),
                            ]),
                        context: context,
                      ),
                    ),
                  ],
                ),
                body: BlocListener(
                  cubit: BlocProvider.of<ActivitiesBloc>(context),
                  listener: (ctx, ActivitiesState state) {
                    if (state is ActivitiesAddDateSuccess) {
                      Scaffold.of(ctx)
                          .showSnackBar(SnackBar(content: Text('Date added')));
                    }
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: ActivityDetailsTitle(this._activity),
                          ),
                          ActivityDetailsList(this._activity)
                        ],
                      ),
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
