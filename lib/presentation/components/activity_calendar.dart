import 'package:days_without/data/models/activity.dart';
import 'package:days_without/helpers/category_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class Calendar extends StatelessWidget {
  final Activity activity;

  const Calendar(
    this.activity, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      // onDayPressed: (DateTime date, List<Event> events) {
      //   this.setState(() => _currentDate = date);
      // },
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      //  weekDays: null, /// for pass null when you do not want to render weekDays
      // headerText: 'Custom Header',

      height: 400.0,
      // selectedDateTime: _currentDate,
      daysHaveCircularBorder: null,
      customDayBuilder: (
        /// you can provide your own build function to make custom day containers
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

        this.activity.dates.forEach((DateTime date) {
          if (day.day == date.day &&
              day.month == date.month &&
              day.year == date.year) {
            widget = Center(
              child: Icon(
                  CategoryHelper.findCategory(this.activity.category).icon,
                  color: CategoryHelper.findCategory(this.activity.category)
                      .color),
            );
          }
        });

        return widget;
      },

      /// null for not rendering any border, true for circular border, false for rectangular border
    );
  }
}
