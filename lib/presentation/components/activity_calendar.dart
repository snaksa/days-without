import 'package:days_without/data/models/activity.dart';
import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class Calendar extends StatelessWidget {
  final Activity activity;
  final Function onDateClick;

  const Calendar(
    this.activity, {
    this.onDateClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.onDateClick(date);
      },
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      todayButtonColor: Colors.grey.shade300,
      weekdayTextStyle: TextStyle(color: Colors.blue),

      height: 400.0,
      daysHaveCircularBorder: null,
      customDayBuilder: (
        bool isSelectable,
        int index,
        bool isSelectedDay,
        bool isToday,
        bool isPrevMonthDay,
        TextStyle textStyle,
        bool isNextMonthDay,
        bool isThisMonthDay,
        DateTime day,
      ) {
        Widget widget;

        DateTime now = DateTime.now();
        for (DateTime date in this.activity.dates) {
          if (day.day == date.day &&
              day.month == date.month &&
              day.year == date.year) {
            return Center(
              child: Icon(
                  CategoryHelper.findCategory(this.activity.category).icon,
                  color: CategoryHelper.findCategory(this.activity.category)
                      .color),
            );
          }
        }

        if (day.difference(DateTime(now.year, now.month, now.day)).isNegative) {
          widget = Center(
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          );
        }

        return widget;
      },

      /// null for not rendering any border, true for circular border, false for rectangular border
    );
  }
}
