import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/repositories/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class ActivityRepository {
  DatabaseHelper _db;

  ActivityRepository(this._db);

  Future<List<Activity>> list() async {
    Database database = await this._db.database;
    List<Map<String, dynamic>> list = await database.rawQuery(
        'SELECT * FROM activities a LEFT JOIN activities_dates d ON a.id = d.activity_id');
    Map<String, Activity> data = {};

    list.forEach((element) {
      Activity activity;
      if (data.containsKey(element['id'].toString())) {
        activity = data[element['id']];
      } else {
        activity = Activity.fromMap(element);
      }

      if (element['activity_date'] != null) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(element['activity_date'].toString()) * 1000);
        activity.addDate(date);
      }

      data[activity.id] = activity;
    });

    List<Activity> result = [];
    data.forEach((key, value) {
      result.add(value);
    });

    return result;
  }

  Future<void> add(Activity activity) async {
    Database database = await this._db.database;
    await database.insert('activities', activity.toMap());
  }

  Future<void> update(Activity activity) async {
    Database database = await this._db.database;

    database.update(
      'activities',
      activity.toMap(),
      where: "id = ?",
      whereArgs: [activity.id],
    );
  }

  Future<void> delete(Activity activity) async {
    Database database = await this._db.database;
    await database.delete(
      // delete dates records
      'activities_dates',
      where: "activity_id = ?",
      whereArgs: [activity.id],
    );

    // delete activity
    await database.delete(
      'activities',
      where: "id = ?",
      whereArgs: [activity.id],
    );
  }

  Future<void> addDate(Activity activity, DateTime date) async {
    Database database = await this._db.database;
    print(date.millisecondsSinceEpoch ~/ 1000);
    await database.insert(
      'activities_dates',
      {
        'activity_id': activity.id,
        'activity_date': date.millisecondsSinceEpoch ~/ 1000
      },
    );
  }

  Future<void> deleteDate(Activity activity, DateTime date) async {
    Database database = await this._db.database;
    print(date.millisecondsSinceEpoch ~/ 1000);
    await database.delete(
      'activities_dates',
      where: "activity_id = ? AND activity_date = ?",
      whereArgs: [activity.id, date.millisecondsSinceEpoch ~/ 1000],
    );
  }
}
