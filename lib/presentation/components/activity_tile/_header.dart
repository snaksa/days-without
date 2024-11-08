import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/category.dart';
import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';

class ActivityTileHeader extends StatelessWidget {
  final Activity activity;

  ActivityTileHeader(this.activity);

  @override
  Widget build(BuildContext context) {
    Category category = CategoryHelper.findCategory(this.activity.category);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          category.icon,
          size: 32,
          color: category.color,
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 200,
          child: Text(
            this.activity.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
