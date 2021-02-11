import 'package:flutter/material.dart';

class AlertAction {
  final String title;
  final Function onPressed;

  AlertAction({this.title, this.onPressed});
}

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final List<AlertAction> actions;

  Alert({
    @required this.title,
    @required this.content,
    @required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: this
          .actions
          .map(
            (AlertAction action) => FlatButton(
              child: Text(action.title),
              onPressed: action.onPressed,
            ),
          )
          .toList(),
    );
  }
}
