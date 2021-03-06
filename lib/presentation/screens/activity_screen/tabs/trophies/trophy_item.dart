import 'package:days_without/data/models/trophy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrophyItem extends StatelessWidget {
  final Trophy trophy;
  final Duration duration;
  final Duration latestDuration;

  TrophyItem(this.trophy, this.duration, this.latestDuration);

  double get completionPercentage {
    if (this.trophy.duration.inSeconds == 0) {
      return this.duration.inSeconds > 0 ? 100 : 0;
    }
    double percentage =
        (this.duration.inSeconds / this.trophy.duration.inSeconds);

    percentage = percentage < 1 ? percentage : 1;
    if (percentage != 1) {
      percentage =
          (this.latestDuration.inSeconds / this.trophy.duration.inSeconds);
    }

    return percentage < 1 ? percentage : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/trophy.png',
              color: this.trophy.duration > duration || duration.inSeconds == 0
                  ? Colors.grey
                  : null,
              height: 100,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      this.trophy.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red.shade50,
                                ),
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: this.completionPercentage < 1
                                      ? Colors.red
                                      : Colors.green.withOpacity(0.8),
                                ),
                                height: 10,
                                width: constraints.maxWidth *
                                    this.completionPercentage,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      this.completionPercentage < 1
                          ? DateFormat.yMMMd().format(DateTime.now().add(
                              Duration(
                                  seconds: this.trophy.duration.inSeconds -
                                      this.latestDuration.inSeconds)))
                          : 'Achieved!',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
