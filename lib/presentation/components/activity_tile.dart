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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/activity', arguments: this.activity.id);
      },
      child: Card(
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
                  double percent = this.activity.days == 0
                      ? 0
                      : this.activity.days / this.activity.goal;
                  percent = percent > 1 ? 1 : percent;
                  List<Color> c = [];
                  if (percent < 0.3)
                    c = colors[0];
                  else if (percent < 0.7)
                    c = colors[1];
                  else if (percent < 1)
                    c = colors[2];
                  else
                    c = colors[3];
                  return Stack(
                    children: [
                      Positioned.fill(
                        right: constraints.maxWidth -
                            (constraints.maxWidth * percent),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: c,
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
                                  "Goal: ${this.activity.goal}",
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
      ),
    );
  }
}
