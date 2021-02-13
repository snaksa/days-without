import 'package:equatable/equatable.dart';

class ActivityMotivation extends Equatable {
  final String id;
  final String activityId;
  final String motivation;

  ActivityMotivation(this.id, this.activityId, this.motivation);

  ActivityMotivation copyWith({id, activityId, motivation}) {
    return ActivityMotivation(
      id ?? this.id,
      activityId ?? this.activityId,
      motivation ?? this.motivation,
    );
  }

  @override
  List<Object> get props => [id, activityId, motivation];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'activity_id': this.activityId,
      'activity_motivation': this.motivation,
    };
  }
}
