import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/trophy.dart';
import 'package:flutter/material.dart';
import 'package:days_without/helpers/trophy_helper.dart';

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

class GaugeChart extends StatefulWidget {
  final Activity activity;

  GaugeChart(this.activity);

  @override
  _GaugeChartState createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  Timer timer;
  Trophy currentTrophy;
  double percentage;

  @override
  void initState() {
    super.initState();

    if (this.timer == null) {
      recalculate();
      this.timer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => recalculate());
    }
  }

  void recalculate() {
    Trophy trophy = TrophyHelper.getTrophy(this.widget.activity.duration);
    double result =
        (this.widget.activity.duration.inSeconds / trophy.duration.inSeconds) *
            100;

    if (this.percentage != null && this.percentage.floor() == result.floor()) {
      return;
    }

    setState(() {
      percentage = result;
      currentTrophy = trophy;
    });
  }

  List<charts.Series<GaugeSegment, String>> getValues(Trophy currentTrophy) {
    double passedTime = (this.widget.activity.duration.inSeconds /
            currentTrophy.duration.inSeconds) *
        100;

    final data = [
      new GaugeSegment('Passed', passedTime.toInt()),
      new GaugeSegment('Remaining', (100 - passedTime.toInt())),
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

  @override
  Widget build(BuildContext context) {
    const pi = 3.14;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          Container(
            child: SizedBox(
              width: 120,
              height: 120,
              child: charts.PieChart(
                this.getValues(this.currentTrophy),
                animate: false,
                defaultRenderer: new charts.ArcRendererConfig(
                  strokeWidthPx: 0.01,
                  arcWidth: 10,
                  startAngle: 4 / 5 * pi,
                  arcLength: 7 / 5 * pi,
                ),
              ),
            ),
          ),
          Container(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: Text(
                  "${this.percentage.floor()}%",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
        ]),
        Container(
          child: Text(currentTrophy.name),
          transform: Matrix4.translationValues(0.0, -30.0, 0.0),
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
