import 'package:days_without/constants/categories.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;

  ActivityTile(this.activity);

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
    double percent =
        this.activity.days == 0 ? 0 : this.activity.days / this.activity.goal;

    return percent > 1 ? 1 : percent;
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
                findCategory(this.activity.category).icon,
                size: 40,
                color: findCategory(this.activity.category).color,
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
                                this.activity.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Goal: ${this.activity.goal} " +
                                    (this.activity.goal == 1 ? 'day' : 'days'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            this.activity.days.toString(),
                            style: TextStyle(
                              fontSize: 24,
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
}
