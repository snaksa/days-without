import 'package:days_without/bloc/activities/activities_bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/common/alert_dialog/alert_dialog.dart';
import 'package:days_without/presentation/components/activity_tile/_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityPopupMenu extends StatelessWidget {
  final Activity activity;
  final List<String> options = [
    'Edit',
    'Delete',
  ];

  ActivityPopupMenu(
    this.activity, {
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
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return ActivityEdit(this.activity);
            },
          );
        } else if (item == 'Delete') {
          showDialog(
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
                  onPressed: () {
                    BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityDeleted(this.activity),
                    );

                    Navigator.of(context)
                        .popUntil((t) => t.settings.name == '/');
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
