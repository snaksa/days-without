import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_action.dart';
import 'package:days_without/presentation/components/activity_details_list.dart';
import 'package:days_without/presentation/components/activity_tile/activity_tile.dart';
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
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    this.dateController.text =
        "${now.day < 10 ? 0 : ''}${now.day}/${now.month < 10 ? 0 : ''}${now.month}/${now.year}";
    this.timeController.text =
        "${now.hour < 10 ? 0 : ''}${now.hour}:${now.minute < 10 ? 0 : ''}${now.minute}";
  }

  void deleteActivity() {
    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityDeleted(this._activity),
    );

    Navigator.of(context).popUntil((t) => t.settings.name == '/');
  }

  void chooseDate() {
    List<String> split = this.dateController.text.split('/');
    showDatePicker(
      context: context,
      initialDate: DateTime(
        int.parse(split[2]),
        int.parse(split[1]),
        int.parse(split[0]),
      ),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then(
      (date) {
        if (date == null) {
          return;
        }
        this.dateController.text =
            "${date.day < 10 ? 0 : ''}${date.day}/${date.month < 10 ? 0 : ''}${date.month}/${date.year}";
      },
    );
  }

  void chooseTime() {
    List<String> split = this.timeController.text.split(':');
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(split[0]),
        minute: int.parse(split[1]),
      ),
    ).then(
      (date) {
        if (date == null) {
          return;
        }
        this.timeController.text =
            "${date.hour < 10 ? 0 : ''}${date.hour}:${date.minute < 10 ? 0 : ''}${date.minute}";
      },
    );
  }

  void chooseDateTime() async {
    await showDialog(
        context: context,
        child: Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => this.chooseDate(),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      controller: dateController,
                      enabled: false,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => this.chooseTime(),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Time',
                      ),
                      controller: this.timeController,
                      enabled: false,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      this.addDateTime();
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void addDateTime() {
    List<String> splitDate = this.dateController.text.split('/');
    List<String> splitTime = this.timeController.text.split(':');
    DateTime date = DateTime(
      int.parse(splitDate[2]),
      int.parse(splitDate[1]),
      int.parse(splitDate[0]),
      int.parse(splitTime[0]),
      int.parse(splitTime[1]),
      DateTime.now().second,
    );
    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityAddDate(this._activity.id, date),
    );

    DateTime now = DateTime.now();
    this.dateController.text =
        "${now.day < 10 ? 0 : ''}${now.day}/${now.month < 10 ? 0 : ''}${now.month}/${now.year}";
    this.timeController.text =
        "${now.hour < 10 ? 0 : ''}${now.hour}:${now.minute < 10 ? 0 : ''}${now.minute}";
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
            onPressed: this.chooseDateTime,
            tooltip: 'Add date',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
