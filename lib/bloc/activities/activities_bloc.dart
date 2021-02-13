import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:days_without/bloc/activities/activities_event.dart';
import 'package:days_without/bloc/activities/activities_state.dart';
import 'package:days_without/data/models/activity.dart';
import 'package:days_without/data/models/activity_date.dart';
import 'package:days_without/data/models/activity_motivation.dart';
import 'package:days_without/data/repositories/activity_repository.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivityRepository repository;

  ActivitiesBloc(this.repository) : super(ActivitiesLoadInProgress());

  @override
  Stream<ActivitiesState> mapEventToState(ActivitiesEvent event) async* {
    if (event is ActivitiesLoaded) {
      yield* _mapActivitiesLoadedToState();
    } else if (event is ActivityAdded) {
      yield* _mapActivityAddedToState(event);
    } else if (event is ActivityUpdated) {
      yield* _mapActivityUpdatedToState(event);
    } else if (event is ActivityDeleted) {
      yield* _mapActivityDeletedToState(event);
    } else if (event is ActivityAddDate) {
      yield* _mapActivityAddDateToState(event);
    } else if (event is ActivityDeletedDate) {
      yield* _mapActivityDeletedDateToState(event);
    } else if (event is ActivityAddMotivation) {
      yield* _mapActivityAddMotivationToState(event);
    } else if (event is ActivityMotivationUpdated) {
      yield* _mapActivityMotivationUpdatedToState(event);
    } else if (event is ActivityDeletedMotivation) {
      yield* _mapActivityDeletedMotivationToState(event);
    }
  }

  Stream<ActivitiesState> _mapActivitiesLoadedToState() async* {
    try {
      List<Activity> activities = await this.repository.list();
      yield ActivitiesLoadSuccess(activities);
    } catch (_) {
      yield ActivitiesLoadFailure();
    }
  }

  Stream<ActivitiesState> _mapActivityAddedToState(ActivityAdded event) async* {
    if (state is ActivitiesLoadSuccess) {
      final List<Activity> updatedActivities =
          List.from((state as ActivitiesLoadSuccess).activities)
            ..add(event.activity);

      yield ActivitiesAddSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);

      this.repository.add(event.activity);
    }
  }

  Stream<ActivitiesState> _mapActivityUpdatedToState(
      ActivityUpdated event) async* {
    if (state is ActivitiesLoadSuccess) {
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map((activity) {
        return activity.id == event.activity.id ? event.activity : activity;
      }).toList();

      yield ActivitiesLoadSuccess(updatedActivities);

      this.repository.update(event.activity);
    }
  }

  Stream<ActivitiesState> _mapActivityDeletedToState(
      ActivityDeleted event) async* {
    if (state is ActivitiesLoadSuccess) {
      final updatedTodos = (state as ActivitiesLoadSuccess)
          .activities
          .where((activity) => activity.id != event.activity.id)
          .toList();

      this.repository.delete(event.activity);

      yield ActivitiesDeleteSuccess();
      yield ActivitiesLoadSuccess(updatedTodos);
    }
  }

  Stream<ActivitiesState> _mapActivityAddDateToState(
    ActivityAddDate event,
  ) async* {
    if (state is ActivitiesLoadSuccess) {
      yield ActivitiesLoadInProgress();
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map(
        (activity) {
          if (activity.id == event.id) {
            activity.addDate(ActivityDate(event.id, event.date, event.comment));
            this.repository.addDate(activity, event.date, event.comment);
            return activity;
          }

          return activity;
        },
      ).toList();

      yield ActivitiesAddDateSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);
    }
  }

  Stream<ActivitiesState> _mapActivityDeletedDateToState(
    ActivityDeletedDate event,
  ) async* {
    if (state is ActivitiesLoadSuccess) {
      yield ActivitiesLoadInProgress();
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map(
        (activity) {
          if (activity.id == event.id) {
            activity.removeDate(event.date);
            this.repository.deleteDate(activity, event.date);
            return activity;
          }

          return activity;
        },
      ).toList();

      yield ActivitiesDeleteDateSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);
    }
  }

  Stream<ActivitiesState> _mapActivityAddMotivationToState(
    ActivityAddMotivation event,
  ) async* {
    if (state is ActivitiesLoadSuccess) {
      yield ActivitiesLoadInProgress();
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map(
        (activity) {
          if (activity.id == event.activityId) {
            activity.addMotivation(
                ActivityMotivation(event.id, activity.id, event.motivation));
            this.repository.addMotivation(activity, event.id, event.motivation);
            return activity;
          }

          return activity;
        },
      ).toList();

      yield ActivitiesAddMotivationSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);
    }
  }

  Stream<ActivitiesState> _mapActivityMotivationUpdatedToState(
      ActivityMotivationUpdated event) async* {
    if (state is ActivitiesLoadSuccess) {
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map((activity) {
        if (activity.id == event.motivation.activityId) {
          List<ActivityMotivation> motivations =
              activity.motivations.map((ActivityMotivation motivation) {
            if (motivation.id == event.motivation.id) {
              return event.motivation;
            }

            return motivation;
          }).toList();

          return activity.copyWith(motivations: motivations);
        }

        return activity;
      }).toList();

      yield ActivitiesUpdatedMotivationSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);

      this.repository.updateMotivation(event.motivation);
    }
  }

  Stream<ActivitiesState> _mapActivityDeletedMotivationToState(
    ActivityDeletedMotivation event,
  ) async* {
    if (state is ActivitiesLoadSuccess) {
      yield ActivitiesLoadInProgress();
      final List<Activity> updatedActivities =
          (state as ActivitiesLoadSuccess).activities.map(
        (activity) {
          if (activity.id == event.activityId) {
            activity.removeMotivation(event.id);
            this.repository.deleteMotivation(activity, event.id);
            return activity;
          }

          return activity;
        },
      ).toList();

      yield ActivitiesDeleteMotivationSuccess();
      yield ActivitiesLoadSuccess(updatedActivities);
    }
  }
}
