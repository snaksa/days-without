import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_date.dart';
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
      todayButtonColor: Theme.of(context).accentColor.withOpacity(0.2),
      todayTextStyle: TextStyle(color: Colors.black),
      weekdayTextStyle: TextStyle(color: Theme.of(context).accentColor),
      height: 400.0,
      daysHaveCircularBorder: null,
      minSelectedDate: DateTime(1980),
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
        if (this.activity.dates.length > 0) {
          DateTime startDate = this.activity.dates.last.date;
          if (day.day == startDate.day &&
              day.month == startDate.month &&
              day.year == startDate.year) {
            return Center(
              child: Icon(
                Icons.api,
                color: Colors.red,
              ),
            );
          }
        }

        for (ActivityDate activityDate in this.activity.dates) {
          if (day.day == activityDate.date.day &&
              day.month == activityDate.date.month &&
              day.year == activityDate.date.year) {
            return Center(
              child: Icon(
                  CategoryHelper.findCategory(this.activity.category).icon,
                  color: CategoryHelper.findCategory(this.activity.category)
                      .color),
            );
          }
        }

        Widget widget;
        DateTime now = DateTime.now();
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
    );
  }
}
