import 'package:days_without/data/models/activity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

class ActivitiesNotification extends ActivitiesState {
  final String message;
  final int date = DateTime.now().millisecondsSinceEpoch;

  ActivitiesNotification(this.message);
}

// Loading
class ActivitiesLoadInProgress extends ActivitiesState {}

// Failure
class ActivitiesLoadFailure extends ActivitiesState {}

// Add New Success
class ActivitiesAddSuccess extends ActivitiesNotification {
  ActivitiesAddSuccess() : super('Activity added');
}

// Delete Success
class ActivitiesDeleteSuccess extends ActivitiesNotification {
  ActivitiesDeleteSuccess() : super('Activity deleted');
}

// Add New Date Success
class ActivitiesAddDateSuccess extends ActivitiesNotification {
  ActivitiesAddDateSuccess() : super('Date added');
}

// Delete Date Success
class ActivitiesDeleteDateSuccess extends ActivitiesNotification {
  ActivitiesDeleteDateSuccess() : super('Date deleted');
}

// Successful
class ActivitiesLoadSuccess extends ActivitiesState {
  final List<Activity> activities;

  const ActivitiesLoadSuccess([this.activities = const []]);

  @override
  List<Object> get props => [this.activities];

  @override
  String toString() =>
      'ActivitiesLoadSuccess { activities: ${this.activities} }';
}
