import 'dart:async';
import 'package:days_without/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:days_without/data/models/activity.dart';

class ActivityTileAbstinence extends StatefulWidget {
  final Activity activity;

  ActivityTileAbstinence(this.activity);

  @override
  _ActivityTileAbstinenceState createState() => _ActivityTileAbstinenceState();
}

class _ActivityTileAbstinenceState extends State<ActivityTileAbstinence> {
  Timer timer;
  String passedTime;

  @override
  void initState() {
    super.initState();

    recalculate();
    this.timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => recalculate());
  }

  void recalculate() {
    String passed =
        DateHelper.convertDurationToString(this.widget.activity.duration);

    setState(() {
      passedTime = passed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abstinence',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 18,
          ),
        ),
        Text(
          this.passedTime,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  void dispose() {
    this.timer?.cancel();
    super.dispose();
  }
}
