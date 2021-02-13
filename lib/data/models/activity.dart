import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String name;
  final int goal;
  final int category;
  final List<ActivityDate> dates;
  final List<ActivityMotivation> motivations;

  Activity({
    this.id,
    this.name,
    this.goal,
    this.category,
    this.dates,
    this.motivations,
  }) {
    this._sortDates();
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      goal: map['goal'] ?? 0,
      category: map['category'] ?? 0,
      dates: [],
      motivations: [],
    );
  }

  @override
  List<Object> get props => [id, name, goal, category, dates, motivations];

  @override
  bool get stringify => true;

  Activity copyWith({id, name, goal, category, dates, motivations}) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      category: category ?? this.category,
      dates: dates ?? this.dates,
      motivations: motivations ?? this.motivations,
    );
  }

  int get days {
    if (this.dates.length > 0) {
      return DateTime.now().difference(this.dates.first.date).inDays;
    }

    return 0;
  }

  Duration get duration {
    if (this.dates.length > 0) {
      return DateTime.now().difference(this.dates.first.date);
    }

    return Duration();
  }

  Activity addDate(ActivityDate date) {
    this.dates.add(date);
    this._sortDates();

    return this;
  }

  Activity removeDate(DateTime date) {
    this.dates.removeWhere((element) =>
        element.date.millisecondsSinceEpoch == date.millisecondsSinceEpoch);
    this._sortDates();

    return this;
  }

  Activity addMotivation(ActivityMotivation motivation) {
    this.motivations.add(motivation);

    return this;
  }

  Activity removeMotivation(String id) {
    this
        .motivations
        .removeWhere((ActivityMotivation motivation) => motivation.id == id);

    return this;
  }

  void _sortDates() {
    this.dates.sort(
          (ActivityDate d1, ActivityDate d2) =>
              d1.date.difference(d2.date).inSeconds > 0 ? -1 : 1,
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'goal': this.goal,
      'category': this.category
    };
  }
}
