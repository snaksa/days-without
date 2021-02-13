import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:days_without/data/repositories/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class ActivityRepository {
  DatabaseHelper _db;

  ActivityRepository(this._db);

  Future<List<Activity>> list() async {
    Database database = await this._db.database;
    List<Map<String, dynamic>> list = await database.rawQuery(
      'SELECT * ' +
          'FROM activities a ' +
          'LEFT JOIN activities_dates d ON a.id = d.activity_id ',
    );
    Map<String, Activity> data = {};

    list.forEach((element) {
      Activity activity;
      if (data.containsKey(element['id'].toString())) {
        activity = data[element['id']];
      } else {
        activity = Activity.fromMap(element);
      }

      if (element['activity_date'] != null) {
        DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(element['activity_date'].toString()) * 1000);
        ActivityDate date = ActivityDate(
            element['activity_id'], parsedDate, element['activity_comment']);
        activity.addDate(date);
      }

      if (element['motivation_id'] != null) {
        ActivityMotivation motivation = ActivityMotivation(
          element['motivation_id'],
          activity.id,
          element['activity_motivation'],
        );

        activity.addMotivation(motivation);
      }

      data[activity.id] = activity;
    });

    List<Map<String, dynamic>> motivations =
        await database.rawQuery('SELECT * FROM activities_motivation m');
    motivations.forEach((element) {
      if (!data.containsKey(element['activity_id'].toString())) {
        return;
      }

      Activity activity = data[element['activity_id']];
      activity.addMotivation(ActivityMotivation(
          element['id'], activity.id, element['activity_motivation']));

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

  Future<void> addDate(Activity activity, DateTime date, String comment) async {
    Database database = await this._db.database;
    await database.insert(
      'activities_dates',
      {
        'activity_id': activity.id,
        'activity_date': date.millisecondsSinceEpoch ~/ 1000,
        'activity_comment': comment,
      },
    );
  }

  Future<void> deleteDate(Activity activity, DateTime date) async {
    Database database = await this._db.database;
    await database.delete(
      'activities_dates',
      where: "activity_id = ? AND activity_date = ?",
      whereArgs: [activity.id, date.millisecondsSinceEpoch ~/ 1000],
    );
  }

  Future<void> addMotivation(
      Activity activity, String id, String motivation) async {
    Database database = await this._db.database;
    await database.insert(
      'activities_motivation',
      {
        'id': id,
        'activity_id': activity.id,
        'activity_motivation': motivation,
      },
    );
  }

  Future<void> updateMotivation(ActivityMotivation motivation) async {
    Database database = await this._db.database;
    await database.update(
      'activities_motivation',
      motivation.toMap(),
      where: "id = ?",
      whereArgs: [motivation.id],
    );
  }

  Future<void> deleteMotivation(Activity activity, String id) async {
    Database database = await this._db.database;
    await database.delete(
      'activities_motivation',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
