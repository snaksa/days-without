import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/components/activity_form.dart';
import 'package:days_without/presentation/components/activity_tile.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void saveActivity(String name) {
    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityAdded(
        Activity(
          id: Uuid().v4(),
          name: name,
          dates: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days Without'),
      ),
      body: Center(
        child: BlocConsumer<ActivitiesBloc, ActivitiesState>(
          listener: (ctx, ActivitiesState state) {
            if (state is ActivitiesAddSuccess) {
              Scaffold.of(ctx)
                  .showSnackBar(SnackBar(content: Text('Activity added')));
            }
          },
          builder: (context, state) {
            if (state is ActivitiesLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ActivityTile(state.activities[index]);
                  },
                ),
              );
            }

            return Loader();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            child: ActivityForm(onSave: this.saveActivity),
            context: context,
          );
        },
        tooltip: 'Add activity',
        child: Icon(Icons.add),
      ),
    );
  }
}
