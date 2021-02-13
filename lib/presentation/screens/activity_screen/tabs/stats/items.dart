import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final List<Map<String, dynamic>> stats = [
  {
    'title': 'The day you quit',
    'icon': Icons.calendar_today,
    'calculate': (List<ActivityDate> dates) {
      DateTime firstDate = dates.length > 0 ? dates.last.date : null;
      if (firstDate != null) {
        return DateFormat.yMMMd().format(firstDate);
      }

      return '-';
    }
  },
  {
    'title': 'Max abstinence period',
    'icon': Icons.hourglass_bottom,
    'calculate': (List<ActivityDate> dates) {
      if (dates.length == 0) {
        return '-';
      }

      Duration maxDuration = Duration();

      if (dates.length == 1) {
        maxDuration = DateTime.now().difference(dates.first.date);
      } else {
        List<ActivityDate> datesWithToday = [
          ActivityDate('0', DateTime.now(), null),
          ...dates
        ];
        for (int i = 1; i < datesWithToday.length; i++) {
          Duration datesDifference =
              datesWithToday[i - 1].date.difference(datesWithToday[i].date);

          if (datesDifference > maxDuration) {
            maxDuration = datesDifference;
          }
        }
      }

      return DateHelper.convertDurationToString(maxDuration);
    }
  },
  {
    'title': 'Min abstinence period',
    'icon': Icons.hourglass_top,
    'calculate': (List<ActivityDate> dates) {
      if (dates.length == 0) {
        return '-';
      }

      Duration minDuration;

      if (dates.length == 1) {
        minDuration = DateTime.now().difference(dates.first.date);
      } else {
        List<ActivityDate> datesWithToday = [
          ActivityDate('0', DateTime.now(), null),
          ...dates
        ];
        for (int i = 1; i < datesWithToday.length; i++) {
          Duration datesDifference =
              datesWithToday[i - 1].date.difference(datesWithToday[i].date);
          if (minDuration == null || datesDifference < minDuration) {
            minDuration = datesDifference;
          }
        }
      }

      return DateHelper.convertDurationToString(minDuration);
    }
  },
  {
    'title': 'Average abstinence period',
    'icon': Icons.hourglass_empty,
    'calculate': (List<ActivityDate> dates) {
      if (dates.length == 0) {
        return '-';
      }

      Duration totalDuration = Duration();
      List<ActivityDate> datesWithToday = [
        ActivityDate('0', DateTime.now(), null),
        ...dates
      ];
      for (int i = 1; i < datesWithToday.length; i++) {
        Duration datesDifference =
            datesWithToday[i - 1].date.difference(datesWithToday[i].date);
        totalDuration += datesDifference;
      }

      int averageDurationSeconds =
          (totalDuration.inSeconds / datesWithToday.length).ceil();

      return DateHelper.convertDurationToString(
          Duration(seconds: averageDurationSeconds));
    }
  },
  {
    'title': 'Previous abstinence period',
    'icon': Icons.access_time,
    'calculate': (List<ActivityDate> dates) {
      if (dates.length <= 1) {
        return '-';
      }
      Duration datesDifference = dates[0].date.difference(dates[1].date);
      return DateHelper.convertDurationToString(datesDifference);
    }
  },
  {
    'title': 'Number of resets',
    'icon': Icons.loop,
    'hideBorder': true,
    'calculate': (List<ActivityDate> dates) {
      return dates.length;
    }
  }
];
