import 'package:days_without/data/models/activity_motivation.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/motivation/_popup_menu.dart';
import 'package:flutter/material.dart';

class MotivationItem extends StatelessWidget {
  final ActivityMotivation motivation;
  final int position;

  MotivationItem(this.motivation, this.position);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Motivation #${this.position}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          this.motivation.motivation,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MotivationPopupMenu(this.motivation),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
