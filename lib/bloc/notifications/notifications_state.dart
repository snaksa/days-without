import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

// Triggered
class NotificationSent extends NotificationsState {
  final String text;
  final int date;

  NotificationSent(this.text, this.date);

  @override
  List<Object> get props => [this.text, this.date];

  @override
  String toString() =>
      'NotificationSent { text: ${this.text}, date: ${this.date} }';
}
