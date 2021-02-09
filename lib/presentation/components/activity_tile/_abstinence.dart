import 'dart:async';
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
    List<String> passed = [];
    Duration duration = this.widget.activity.duration;
    int days = duration.inDays;
    int hours = duration.inHours - (days * 24);
    int minutes = duration.inMinutes - (days * 24 * 60 + hours * 60);
    int seconds = duration.inSeconds -
        (days * 24 * 60 * 60 + hours * 60 * 60 + minutes * 60);
    if (days > 0) {
      passed.add('${days}d');
    }
    if (hours > 0 || days > 0) {
      passed.add('${hours}h');
    }
    if (minutes > 0 || days + hours > 0) {
      passed.add('${minutes}m');
    }
    if (seconds > 0 || days + hours + minutes > 0) {
      passed.add('${seconds < 10 ? 0 : ""}${seconds}s');
    }

    setState(() {
      passedTime = passed.join(' ');
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
