import '../helpers/TodosProvider.dart';

/// The available intervals for periodically showing notifications
enum RepeatInterval { EveryMinute, Hourly, Daily, Weekly }

class Notification {
  int id;
  RepeatInterval repeatInterval;

  Notification({this.id, this.repeatInterval});

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map[columnId],
      repeatInterval: map[columnRepeatInterval] == null
          ? null
          : RepeatInterval.values.firstWhere(
              (value) => value.toString() == map[columnRepeatInterval]),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnRepeatInterval: this.repeatInterval.toString(),
    };

    if (this.id != null) map[columnId] = id;

    return map;
  }
}
