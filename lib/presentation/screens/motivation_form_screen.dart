import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class MotivationFormScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/activity-new-motivation';

  @override
  _MotivationFormScreenState createState() => _MotivationFormScreenState();
}

class MotivationFormProps {
  final String activityId;
  final ActivityMotivation motivation;

  MotivationFormProps(this.activityId, this.motivation);
}

class _MotivationFormScreenState extends State<MotivationFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final motivationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args =
          ModalRoute.of(context).settings.arguments as MotivationFormProps;
      if (args.motivation != null) {
        this.motivationController.text = args.motivation.motivation;
      } else {
        this.motivationController.text = '';
      }
    });
  }

  void onSave() {
    if (this.formKey.currentState.validate()) {
      var args =
          ModalRoute.of(context).settings.arguments as MotivationFormProps;

      if (args.motivation == null) {
        String activityId = args.activityId;
        String motivationId = Uuid().v4();
        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityAddMotivation(
            motivationId,
            activityId,
            this.motivationController.text,
          ),
        );
      } else {
        ActivityMotivation motivation = args.motivation;
        BlocProvider.of<ActivitiesBloc>(context).add(
          ActivityMotivationUpdated(
              motivation.copyWith(motivation: this.motivationController.text)),
        );
      }

      Navigator.of(context).pop();
    }
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
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: this.motivationController,
                decoration: InputDecoration(
                  labelText: 'What motivates you to quit?',
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please insert your motivation'
                      : null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
