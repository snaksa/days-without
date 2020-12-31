import 'package:days_without/data/models/activity.dart';
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

  const ActivityAddDate(this.id, this.date);

  @override
  List<Object> get props => [this.id, this.date];

  @override
  String toString() => 'ActivityAddDate { addDate: ${this.id}, ${this.date} }';
}

// Add date
class ActivityDeletedDate extends ActivitiesEvent {
  final String id;
  final DateTime date;

  const ActivityDeletedDate(this.id, this.date);

  @override
  List<Object> get props => [this.id, this.date];

  @override
  String toString() => 'ActivityAddDate { addDate: ${this.id}, ${this.date} }';
}