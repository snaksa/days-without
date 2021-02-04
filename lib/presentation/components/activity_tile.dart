import 'dart:async';

import 'package:days_without/constants/categories.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityTile extends StatefulWidget {
  final Activity activity;

  ActivityTile(this.activity);

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  Timer timer;
  String passedTime;

  @override
  void initState() {
    super.initState();

    recalculate();
    this.timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => recalculate());
  }

  final List<double> points = [0.0, 0.7];

  final List<List<Color>> colors = [
    [Colors.red[50], Colors.red],
    [Colors.yellow[50], Colors.yellow],
    [Colors.lightGreen[50], Colors.lightGreen],
    [Colors.green[50], Colors.green],
  ];

  List<Color> getColor() {
    double percent = this.getPercent();

    if (percent < 0.3) return colors[0];
    if (percent < 0.7) return colors[1];
    if (percent < 1) return colors[2];

    return colors[3];
  }

  double getPercent() {
    double percent = this.widget.activity.days == 0
        ? 0
        : this.widget.activity.days / this.widget.activity.goal;

    return percent > 1 ? 1 : percent;
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
    return Card(
      child: Row(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                findCategory(this.widget.activity.category).icon,
                size: 40,
                color: findCategory(this.widget.activity.category).color,
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                List<Color> colors = this.getColor();
                return Stack(
                  children: [
                    Positioned.fill(
                      right: constraints.maxWidth -
                          (constraints.maxWidth * this.getPercent()),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors,
                            stops: points,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                this.widget.activity.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Goal: ${this.widget.activity.goal} " +
                                    (this.widget.activity.goal == 1
                                        ? 'day'
                                        : 'days'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            this.passedTime,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this.timer?.cancel();
    super.dispose();
  }
}
