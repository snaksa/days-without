import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/presentation/common/no_records.dart';
import 'package:days_without/presentation/components/activity_form.dart';
import 'package:days_without/presentation/components/activity_tile/activity_tile.dart';
import 'package:days_without/presentation/components/loader.dart';
import 'package:days_without/presentation/screens/activity_screen/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days Without'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return ActivityEdit();
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, state) {
          if (state is ActivitiesLoadSuccess) {
            return state.activities.length == 0
                ? NoRecords(withImage: true)
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ActivityScreen.ROUTE_NAME,
                          arguments: state.activities[index].id,
                        ),
                        child: ActivityTile(
                          state.activities[index],
                        ),
                      );
                    },
                  );
          }

          return Loader();
        },
      ),
    );
  }
}
