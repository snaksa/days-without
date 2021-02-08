import 'dart:async';

import 'package:days_without/constants/categories.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ActivityTile extends StatefulWidget {
  final Activity activity;

  ActivityTile(this.activity);

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
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

  List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 70),
      new GaugeSegment('Low2', 30),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, int n) => n == 0
            ? charts.MaterialPalette.blue.shadeDefault
            : charts.MaterialPalette.gray.shade200,
        data: data,
      )
    ];
  }

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    const pi = 3.14;
    var chart = charts.PieChart(this._createSampleData(),
        animate: false,
        defaultRenderer: new charts.ArcRendererConfig(
          strokeWidthPx: 0.01,
          arcWidth: 10,
          startAngle: 4 / 5 * pi,
          arcLength: 7 / 5 * pi,
        ));

    return Card(
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  findCategory(this.widget.activity.category)
                                      .icon,
                                  size: 32,
                                  color: findCategory(
                                          this.widget.activity.category)
                                      .color,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  this.widget.activity.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(Icons.menu),
                            elevation: 16,
                            itemBuilder: (BuildContext bc) {
                              return ['1', '2', '3']
                                  .map((day) => PopupMenuItem(
                                        child: Text(day),
                                        value: day,
                                      ))
                                  .toList();
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(children: [
                                Container(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: chart,
                                  ),
                                ),
                                Container(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Center(
                                      child: Text(
                                        '12%',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Container(
                                child: Text('24 hours'),
                                transform:
                                    Matrix4.translationValues(0.0, -30.0, 0.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
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
