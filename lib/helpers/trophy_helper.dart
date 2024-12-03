import 'package:days_without/data/models/trophy.dart';

class TrophyHelper {
  static final List<Trophy> trophies = [
    Trophy(0, 'New life begins!', Duration()),
    Trophy(1, '24 Hours', Duration(hours: 24)),
    Trophy(2, '3 Days', Duration(days: 3)),
    Trophy(3, '1 Week', Duration(days: 7)),
    Trophy(4, '10 Days', Duration(days: 10)),
    Trophy(5, '2 Weeks', Duration(days: 14)),
    Trophy(6, '1 Month', Duration(days: 30)),
    Trophy(7, '3 Months', Duration(days: 30 * 3)),
    Trophy(8, '6 Months', Duration(days: 30 * 6)),
    Trophy(9, '1 Year', Duration(days: 365)),
    Trophy(10, '2 Years', Duration(days: 365 * 2)),
    Trophy(11, '5 Years', Duration(days: 365 * 5)),
    Trophy(12, '10 Years', Duration(days: 365 * 10)),
    Trophy(13, '15 Years', Duration(days: 365 * 15)),
    Trophy(14, '20 Years', Duration(days: 365 * 20)),
    Trophy(15, '25 Years', Duration(days: 365 * 25)),
    Trophy(16, '30 Years', Duration(days: 365 * 30)),
    Trophy(17, '35 Years', Duration(days: 365 * 35)),
    Trophy(18, '40 Years', Duration(days: 365 * 40)),
    Trophy(19, '45 Years', Duration(days: 365 * 45)),
    Trophy(20, '50 Years', Duration(days: 365 * 50)),
  ];

  static Trophy getTrophy(Duration duration) {
    Trophy currentTrophy;

    trophies.forEach((trophy) {
      if (trophy.duration > duration && currentTrophy == null) {
        currentTrophy = trophy;
      }
    });

    return currentTrophy;
  }
}
