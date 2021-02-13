import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/helpers/category_helper.dart';
import 'package:days_without/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ActivityEdit extends StatefulWidget {
  final Activity activity;
  ActivityEdit({this.activity});

  @override
  _ActivityEditState createState() => _ActivityEditState();
}

class _ActivityEditState extends State<ActivityEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.activity != null) {
      this.nameController.text = this.widget.activity?.name;
      this.categoryController.text = this.widget.activity.category.toString();
    } else {
      this.nameController.text = '';
      this.categoryController.text = '0';

      DateTime now = DateTime.now();
      this.dateController.text = DateFormat("d\\MM\\y").format(now);
      this.timeController.text =
          DateHelper.convertTimeToString(now.hour, now.minute);

      this.dateTimeController.text =
          "${this.dateController.text} ${this.timeController.text}";
    }
  }

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    ).then(
      (date) {
        if (date == null) {
          return;
        }

        this.dateController.text = DateFormat("d\\MM\\y").format(date);
        this.chooseTime();
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
            DateHelper.convertTimeToString(date.hour, date.minute);

        this.dateTimeController.text =
            "${this.dateController.text} ${this.timeController.text}";
      },
    );
  }

  void onSave() {
    if (this.formKey.currentState.validate()) {
      if (widget.activity != null) {
        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityUpdated(
            widget.activity.copyWith(
              name: this.nameController.text,
              category: int.parse(categoryController.text),
            ),
          ),
        );
      } else {
        String activityId = Uuid().v4();

        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityAdded(
            Activity(
              id: activityId,
              name: this.nameController.text,
              goal: 7,
              category: int.parse(this.categoryController.text),
              dates: [],
              motivations: [],
            ),
          ),
        );

        List<String> splitDate = this.dateController.text.split('\\');
        List<String> splitTime = this.timeController.text.split(':');
        DateTime dateToAdd = DateTime(
            int.parse(splitDate[2]),
            int.parse(splitDate[1]),
            int.parse(splitDate[0]),
            int.parse(splitTime[0]),
            int.parse(splitTime[1]));

        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityAddDate(activityId, dateToAdd, null),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Form(
          key: this.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: this.nameController,
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please insert activity name'
                      : null;
                },
              ),
              DropdownButtonFormField(
                value: int.parse(this.categoryController.text),
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                items: CategoryHelper.categories
                    .map(
                      (category) => DropdownMenuItem<int>(
                        value: category.id,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              color: category.color,
                            ),
                            Container(
                              child: Text(category.name),
                              margin: EdgeInsets.only(left: 4),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  this.categoryController.text = value.toString();
                },
              ),
              if (widget.activity == null)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'When was the last time?',
                  ),
                  readOnly: true,
                  onTap: this.chooseDate,
                  controller: this.dateTimeController,
                ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: this.onSave,
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    onPrimary: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
