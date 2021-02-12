import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';

class ActivityFormModel {
  String name;
  int goal;
  int category;
}

class ActivityForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ActivityFormModel model;

  ActivityForm({
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
              labelText: 'Activity',
            ),
            autofocus: true,
            initialValue: '',
            validator: (val) {
              return val.trim().isEmpty ? 'Please insert activity name' : null;
            },
            onSaved: (value) => model.name = value,
          ),
          DropdownButtonFormField(
            value: 0,
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
