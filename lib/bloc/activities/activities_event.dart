import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:equatable/equatable.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

// Loaded
class ActivitiesLoaded extends ActivitiesEvent {}

// Added
class ActivityAdded extends ActivitiesEvent {
  final Activity activity;

  const ActivityAdded(this.activity);

  @override
  List<Object> get props => [this.activity];

  @override
  String toString() => 'ActivityAdded { activity: ${this.activity} }';
}

// Updated
class ActivityUpdated extends ActivitiesEvent {
  final Activity activity;

  const ActivityUpdated(this.activity);

  @override
  List<Object> get props => [this.activity];

  @override
  String toString() => 'ActivityUpdated { updatedActivity: ${this.activity} }';
}

// Deleted
class ActivityDeleted extends ActivitiesEvent {
  final Activity activity;

  const ActivityDeleted(this.activity);

  @override
  List<Object> get props => [this.activity];

  @override
  String toString() => 'ActivityDeleted { activity: ${this.activity} }';
}

// Add date
class ActivityAddDate extends ActivitiesEvent {
  final String id;
  final DateTime date;
  final String comment;

  const ActivityAddDate(this.id, this.date, this.comment);

  @override
  List<Object> get props => [this.id, this.date, this.comment];

  @override
  String toString() =>
      'ActivityAddDate { addDate: ${this.id}, ${this.date}, ${this.comment} }';
}

// Delete date
class ActivityDeletedDate extends ActivitiesEvent {
  final String id;
  final DateTime date;

  const ActivityDeletedDate(this.id, this.date);

  @override
  List<Object> get props => [this.id, this.date];

  @override
  String toString() =>
      'ActivityDeletedDate { deleteDate: ${this.id}, ${this.date} }';
}

// Add motivation
class ActivityAddMotivation extends ActivitiesEvent {
  final String id;
  final String activityId;
  final String motivation;

  const ActivityAddMotivation(this.id, this.activityId, this.motivation);

  @override
  List<Object> get props => [this.id, this.activityId, this.motivation];

  @override
  String toString() =>
      'ActivityAddMotivation { deleteMotivation: ${this.id}, ${this.activityId}, ${this.motivation} }';
}

// Updated
class ActivityMotivationUpdated extends ActivitiesEvent {
  final ActivityMotivation motivation;

  const ActivityMotivationUpdated(this.motivation);

  @override
  List<Object> get props => [this.motivation];

  @override
  String toString() =>
      'ActivityMotivationUpdated { updatedMotivation: ${this.motivation} }';
}

// Delete motivation
class ActivityDeletedMotivation extends ActivitiesEvent {
  final String id;
  final String activityId;

  const ActivityDeletedMotivation(this.id, this.activityId);

  @override
  List<Object> get props => [this.id];

  @override
  String toString() =>
      'ActivityDeletedMotivation { deleteMotivation: ${this.id} }';
}
