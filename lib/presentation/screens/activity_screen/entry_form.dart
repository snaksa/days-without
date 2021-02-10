import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryForm extends StatefulWidget {
  static const String ROUTE_NAME = '/activity-new-entry';

  @override
  _EntryFormState createState() => _EntryFormState();
}

class PassedData {
  String id;
  DateTime date;
}

class _EntryFormState extends State<EntryForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final feelingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    this.feelingController.text = '';

    DateTime now = DateTime.now();
    this.timeController.text =
        "${now.hour < 10 ? 0 : ''}${now.hour}:${now.minute < 10 ? 0 : ''}${now.minute}";
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

  void onSave() {
    var args = ModalRoute.of(context).settings.arguments as Passed;

    String id = args.id;
    DateTime date = args.date;

    List<String> split = this.timeController.text.split(':');
    DateTime dateToAdd = DateTime(date.year, date.month, date.day,
        int.parse(split[0]), int.parse(split[1]), 0);

    print(id);
    print(dateToAdd);

    BlocProvider.of<ActivitiesBloc>(context).add(
      ActivityAddDate(id, dateToAdd),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onSave,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: this.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: this.timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'What time was it?',
                ),
                onTap: chooseTime,
              ),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: this.feelingController,
                decoration: InputDecoration(
                  labelText: 'How did you feel?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
