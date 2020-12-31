import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:days_without/bloc/notifications/notifications_event.dart';
import 'package:days_without/bloc/notifications/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationSent('', 0));

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is SendNotification) {
      yield* _mapSendNotificationToState(event);
    }
  }

  Stream<NotificationsState> _mapSendNotificationToState(
      SendNotification event) async* {
    if (event.text.length > 0) {
      yield NotificationSent(event.text, event.date);
    }
  }
}
