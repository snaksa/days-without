import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/components/activity_form.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ActivityEditScreen extends StatefulWidget {
  ActivityEditScreen({Key key}) : super(key: key);

  static const String ROUTE_NAME = '/activity-edit';

  @override
  _ActivityEditScreenState createState() => _ActivityEditScreenState();
}

class _ActivityEditScreenState extends State<ActivityEditScreen> {
  final ActivityFormModel model = ActivityFormModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Activity _activity;

  void saveActivity(String name, int goal, int category) {
    if (this._activity.id != null) {
      BlocProvider.of<ActivitiesBloc>(context).add(
        ActivityUpdated(
          this._activity.copyWith(
                name: name,
                goal: goal,
                category: category,
              ),
        ),
      );
    } else {
      BlocProvider.of<ActivitiesBloc>(context).add(
        ActivityAdded(
          Activity(
            id: Uuid().v4(),
            name: name,
            goal: goal,
            category: category,
            dates: [],
          ),
        ),
      );
    }
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

          if (this._activity == null) {
            this._activity = new Activity(dates: []);
          }
        } else if (state is ActivitiesLoadInProgress) {
          return Loader();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(this._activity.name ?? 'New Activity'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    this.saveActivity(model.name, model.goal, model.category);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: ActivityForm(
                    name: this._activity.name,
                    goal: this._activity.goal,
                    category: this._activity.category,
                    formKey: this.formKey,
                    model: this.model,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
