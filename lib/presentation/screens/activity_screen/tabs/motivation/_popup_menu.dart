import 'package:days_without/bloc/activities/index.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:days_without/presentation/common/alert_dialog.dart';
import 'package:days_without/presentation/screens/motivation_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MotivationPopupMenu extends StatelessWidget {
  final ActivityMotivation motivation;
  final List<String> options = [
    'Edit',
    'Delete',
  ];

  MotivationPopupMenu(
    this.motivation, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      elevation: 16,
      itemBuilder: (BuildContext bc) {
        return this
            .options
            .map((option) => PopupMenuItem(
                  child: Text(option),
                  value: option,
                ))
            .toList();
      },
      onSelected: (String item) {
        if (item == 'Edit') {
          Navigator.pushNamed(
            context,
            MotivationFormScreen.ROUTE_NAME,
            arguments: MotivationFormProps(this.motivation.id, this.motivation),
          );
        } else if (item == 'Delete') {
          showDialog(
            builder: (ctx) => Alert(
              title: 'Delete Motivation',
              content: 'Are you sure?',
              actions: [
                AlertAction(
                  title: 'No',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AlertAction(
                  title: 'Yes',
                  onPressed: () {
                    BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityDeletedMotivation(
                          this.motivation.id, this.motivation.activityId),
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            context: context,
          );
        }
      },
    );
  }
}
