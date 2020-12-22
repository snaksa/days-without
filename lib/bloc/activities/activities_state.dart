import 'package:days_without/data/models/activity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

// Loading
class ActivitiesLoadInProgress extends ActivitiesState {}

// Failure
class ActivitiesLoadFailure extends ActivitiesState {}

// Failure
class ActivitiesAddSuccess extends ActivitiesState {}
class ActivitiesAddDateSuccess extends ActivitiesState {}

// Successful
class ActivitiesLoadSuccess extends ActivitiesState {
  final List<Activity> activities;

  const ActivitiesLoadSuccess([this.activities = const []]);

  @override
  List<Object> get props => [this.activities];

  @override
  String toString() => 'ActivitiesLoadSuccess { activities: ${this.activities} }';
}