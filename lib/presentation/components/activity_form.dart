import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';

class ActivityFormModel {
  String name;
  int goal;
  int category;
}

class ActivityForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String name;
  final int goal;
  final int category;
  final ActivityFormModel model;

  ActivityForm({
    this.name,
    this.goal,
    this.category,
    this.formKey,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            autofocus: true,
            initialValue: this.name,
            validator: (val) {
              return val.trim().isEmpty ? 'Please insert activity name' : null;
            },
            onSaved: (value) => model.name = value,
          ),
          TextFormField(
            initialValue: this.goal != null ? this.goal.toString() : '7',
            decoration: InputDecoration(
              labelText: 'Goal (days)',
            ),
            keyboardType: TextInputType.number,
            validator: (val) {
              return val.trim().isEmpty
                  ? 'Please insert desired goal'
                  : int.tryParse(val) == null
                      ? "Please insert valid number"
                      : null;
            },
            onSaved: (value) => model.goal = int.parse(value),
          ),
          DropdownButtonFormField(
            value: this.category ?? 0,
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
              model.category = value;
            },
            onSaved: (value) {
              model.category = value;
            },
          ),
        ],
      ),
    );
  }
}
