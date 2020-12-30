import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/simple_block_observer.dart';
import 'package:days_without/data/repositories/activity_repository.dart';
import 'package:days_without/data/repositories/database_helper.dart';
import 'package:days_without/presentation/screens/activity_edit_screen.dart';
import 'package:days_without/presentation/screens/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:days_without/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) {
        return ActivitiesBloc(new ActivityRepository(new DatabaseHelper()))
          ..add(ActivitiesLoaded());
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Days Without',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        ActivityScreen.ROUTE_NAME: (context) => ActivityScreen(),
        ActivityEditScreen.ROUTE_NAME: (context) => ActivityEditScreen(),
      },
    );
  }
}
