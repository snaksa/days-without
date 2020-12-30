import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String content;

  Alert({
    @required this.onPressed,
    @required this.title,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: [
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: this.onPressed,
        ),
      ],
    );
  }
}
