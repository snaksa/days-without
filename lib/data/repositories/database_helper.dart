import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  final int _version = 2;
  final String _name = "DaysWithoutDB.db";

  Map<int, List<String>> _migrations = {
    1: [
      "CREATE TABLE activities(id STRING PRIMARY KEY, name TEXT NOT NULL, goal INT NOT NULL, category INT NOT NULL)", // create activities table
      "CREATE TABLE activities_dates(activity_id STRING NOT NULL, activity_date INT NOT NULL)", // create dates table
      "CREATE TABLE user_preferences(name STRING NOT NULL, value INT NOT NULL)", // create user preferences table
    ],
    2: [
      "ALTER TABLE activities_dates ADD COLUMN activity_comment STRING NULL",
    ]
  };

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return this._database;
    }

    this._database = await this._initDatabase();

    return this._database;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), this._name),
      version: this._version,
      onCreate: (Database db, int version) async {
        for (int i = 1; i <= this._version; i++) {
          for (int j = 0; j < this._migrations[i].length; j++) {
            await db.execute(this._migrations[i][j]);
          }
        }
      },

      /// if the database exists but the version of the database is different
      /// from the version defined in parameter, onUpgrade will execute all sql requests greater than the old version
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          for (int j = 0; j < this._migrations[i].length; j++) {
            await db.execute(this._migrations[i][j]);
          }
        }
      },
    );
  }
}
