import 'package:equatable/equatable.dart';

class ActivityDate extends Equatable {
  final String activityId;
  final DateTime date;
  final String comment;

  ActivityDate(this.activityId, this.date, this.comment);

  factory ActivityDate.fromMap(Map<String, dynamic> map) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['activity_date'].toString()) * 1000);

    return ActivityDate(
      map['activity_id'],
      date,
      map['activity_comment'],
    );
  }

  @override
  List<Object> get props => [activityId, date, comment];

  @override
  bool get stringify => true;
}
