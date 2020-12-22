import 'package:flutter/material.dart';

class ActivityFormModel {
  String name;
}

class ActivityForm extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Function onSave;
  final String name;
  final ActivityFormModel model = ActivityFormModel();

  ActivityForm({@required this.onSave, this.name});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                initialValue: this.name,
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please insert activity name'
                      : null;
                },
                onSaved: (value) => model.name = value,
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    this.onSave(model.name);              
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
