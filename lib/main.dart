import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/bloc/notifications/notifications_bloc.dart';
import 'package:days_without/bloc/notifications/notifications_event.dart';
import 'package:days_without/bloc/notifications/notifications_state.dart';
import 'package:days_without/bloc/simple_block_observer.dart';
import 'package:days_without/data/repositories/activity_repository.dart';
import 'package:days_without/data/repositories/database_helper.dart';
import 'package:days_without/presentation/screens/activity_edit_screen.dart';
import 'package:days_without/presentation/screens/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:days_without/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return NotificationsBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return ActivitiesBloc(new ActivityRepository(new DatabaseHelper()))
              ..add(ActivitiesLoaded());
          },
        ),
      ],
      child: MultiBlocListener(
        child: MyApp(),
        listeners: [
          BlocListener<ActivitiesBloc, ActivitiesState>(
            listener: (ctx, ActivitiesState state) {
              if (state is ActivitiesNotification) {
                BlocProvider.of<NotificationsBloc>(ctx).add(
                  SendNotification(state.message, state.date),
                );
              }
            },
          ),
          BlocListener<NotificationsBloc, NotificationsState>(
            listener: (ctx, NotificationsState state) {
              if (state is NotificationSent) {
                Fluttertoast.showToast(
                  msg: state.text,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
          )
        ],
      ),
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
