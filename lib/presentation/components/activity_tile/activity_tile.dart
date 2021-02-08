import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/components/activity_tile/_popup_menu.dart';
import 'package:days_without/presentation/components/activity_tile/_abstinence.dart';
import 'package:days_without/presentation/components/activity_tile/_header.dart';
import 'package:days_without/presentation/components/gauge_chart.dart';
import 'package:flutter/material.dart';

class ActivityTile extends StatefulWidget {
  final Activity activity;

  ActivityTile(this.activity);

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 12,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActivityTileHeader(widget.activity),
                          ActivityPopupMenu()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ActivityTileAbstinence(widget.activity),
                          GaugeChart(widget.activity.duration),
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
}
