import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

// Added
class NotificationSend extends NotificationsEvent {
  final String text;
  final int date;

  const NotificationSend(this.text, this.date);
  @override
  List<Object> get props => [this.text, this.date];

  @override
  String toString() => 'SendNotification { text: ${this.text}, date: ${this.date} }';
}