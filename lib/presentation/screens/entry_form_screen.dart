import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryFormScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/activity-new-entry';

  @override
  _EntryFormScreenState createState() => _EntryFormScreenState();
}

class EntryFormProps {
  String id;
  DateTime date;

  EntryFormProps(this.id, this.date);
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    this.commentController.text = '';

    DateTime now = DateTime.now();
    this.timeController.text =
        DateHelper.convertTimeToString(now.hour, now.minute);
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
            DateHelper.convertTimeToString(date.hour, date.minute);
      },
    );
  }

  void onSave() {
    var args = ModalRoute.of(context).settings.arguments as EntryFormProps;

    String id = args.id;
    DateTime date = args.date;

    List<String> split = this.timeController.text.split(':');
    DateTime dateToAdd = DateTime(date.year, date.month, date.day,
        int.parse(split[0]), int.parse(split[1]), 0);

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
                controller: this.commentController,
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
