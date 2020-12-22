import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String name;
  final List<DateTime> dates;

  Activity({this.id, this.name, this.dates}) {
    this._sortDates();
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(id: map['id'] ?? 0, name: map['name'] ?? '', dates: []);
  }

  @override
  List<Object> get props => [id, name, dates];

  @override
  bool get stringify => true;

  Activity copyWith({id, name, dates}) {
    return Activity(
        id: id ?? this.id, name: name ?? this.name, dates: dates ?? this.dates);
  }

  int get days {
    if (this.dates.length > 0) {
      return DateTime.now().difference(this.dates.first).inDays;
    }

    return 0;
  }

  Activity addDate(DateTime date) {
    this.dates.add(date);
    this._sortDates();

    return this;
  }

  Activity removeDate(DateTime date) {
    this.dates.removeWhere((element) =>
        element.millisecondsSinceEpoch == date.millisecondsSinceEpoch);
    this._sortDates();

    return this;
  }

  void _sortDates() {
    this.dates.sort(
          (DateTime d1, DateTime d2) =>
              d1.difference(d2).inSeconds > 0 ? -1 : 1,
        );
  }

  Map<String, dynamic> toMap() {
    return {'id': this.id, 'name': this.name};
  }
}
