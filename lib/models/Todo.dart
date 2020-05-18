import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/models/Notification.dart';

import '../helpers/TodosProvider.dart';

enum TimePeriods { NEVER, CHOOSE_DAYS, DAILY, WEEKLY, MONTHLY }

List<String> timesPeriodsLabels = [
  "Nunca",
  "Escolher dias",
  "Diariamente",
  "Semanalmente",
  "Mensalmente",
];

extension TimesPeriodsExtension on TimePeriods {
  String get label {
    return timesPeriodsLabels[this.index];
  }
}

class Todo {
  int id;
  String title;
  String description;
  bool isDone;
  List<Notification> notifications;
  TimePeriods timePeriods;
  DateTime reminderDateTime;
  List<bool> daysToRemind = new List(7);

  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    this.id,
    this.title = "",
    this.description = "",
    this.isDone = false,
    this.notifications,
    this.timePeriods = TimePeriods.NEVER,
    this.reminderDateTime,
    this.daysToRemind = const [false, false, false, false, false, false, false],
    this.createdAt,
    this.updatedAt,
  }) {
    this.notifications ??= [];
  }

  factory Todo.fromMap(Map<String, dynamic> todoMapFromDb) {
    todoMapFromDb.keys.forEach((key) {
      print("$key: ${todoMapFromDb[key]}");
    });
    return Todo(
      id: todoMapFromDb[columnId],
      title: todoMapFromDb[columnTitle],
      description: todoMapFromDb[columnDescription],
      isDone: todoMapFromDb[columnIsDone] == 1,
      notifications: todoMapFromDb[tableNotifications]
          .map<Notification>(
              (notification) => Notification.fromMap(notification))
          .toList(),
      timePeriods: TimePeriods.values.firstWhere(
          (value) => value.toString() == todoMapFromDb[columnTimePeriods]),
      reminderDateTime: DateTime.parse(todoMapFromDb[columnReminderDateTime]),
      daysToRemind: todoMapFromDb[columnDaysToRemind]
          .split(",")
          .map<bool>((bit) => bit == "1")
          .toList(),
      createdAt: DateTime.parse(todoMapFromDb[columnCreatedAt]),
      updatedAt: DateTime.parse(todoMapFromDb[columnUpdatedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: this.title,
      columnDescription: this.description,
      columnIsDone: this.isDone ? 1 : 0,
      columnTimePeriods: this.timePeriods.toString(),
      columnReminderDateTime: this.reminderDateTime.toString(),
      columnDaysToRemind:
          this.daysToRemind.map((boolean) => boolean ? 1 : 0).join(","),
      columnCreatedAt: this.createdAt.toString(),
      columnUpdatedAt: this.updatedAt.toString(),
    };

    if (this.id != null) map[columnId] = id;

    return map;
  }
}
