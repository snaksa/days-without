import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityEdit extends StatefulWidget {
  final Activity activity;
  ActivityEdit(this.activity);

  @override
  _ActivityEditState createState() => _ActivityEditState();
}

class _ActivityEditState extends State<ActivityEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    this.nameController.text = this.widget.activity.name;
    this.categoryController.text = this.widget.activity.category.toString();
  }

  void onSave() {
    if (this.formKey.currentState.validate()) {
      BlocProvider.of<ActivitiesBloc>(context).add(
        ActivityUpdated(
          widget.activity.copyWith(
            name: this.nameController.text,
            category: int.parse(categoryController.text),
          ),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 300,
        padding: EdgeInsets.all(16),
        color: Colors.blue[50],
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
                  value: this.widget.activity.category ?? 0,
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
                SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                      child: const Text('Save'), onPressed: this.onSave),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
