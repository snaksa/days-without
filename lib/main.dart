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
import 'package:days_without/presentation/screens/activity_screen/activity_screen.dart';
import 'package:days_without/presentation/screens/entry_form_screen.dart';
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
                  NotificationSend(state.message, state.date),
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
      debugShowCheckedModeBanner: false,
      title: 'Days Without',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.lightBlue[400],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.blue[50]),
      home: HomeScreen(),
      routes: {
        ActivityScreen.ROUTE_NAME: (context) => ActivityScreen(),
        ActivityEditScreen.ROUTE_NAME: (context) => ActivityEditScreen(),
        EntryFormScreen.ROUTE_NAME: (context) => EntryFormScreen(),
      },
    );
  }
}
