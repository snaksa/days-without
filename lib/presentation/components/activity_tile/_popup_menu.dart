import 'package:flutter/material.dart';

class ActivityPopupMenu extends StatelessWidget {
  final List<String> options = [
    'Change Name',
    'Change Category',
    'Delete',
  ];

  ActivityPopupMenu({
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
    );
  }
}
