import 'package:todos_mobile/helpers/TodosProvider.dart';

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
  TimePeriods repeatReminder;
  DateTime reminderDateTime;
  List<bool> daysToRemind = new List(7);

  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    this.id,
    this.title,
    this.description = "",
    this.isDone = false,
    this.repeatReminder = TimePeriods.NEVER,
    this.reminderDateTime,
    this.daysToRemind = const [false, false, false, false, false, false, false],
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map[columnTitle],
      description: map[columnDescription],
      isDone: map[columnIsDone] == 1,
      repeatReminder: TimePeriods.values
          .firstWhere((value) => value.toString() == map[columnRepeatReminder]),
      reminderDateTime: DateTime.parse(map[columnReminderDateTime]),
      daysToRemind: map[columnDaysToRemind]
          .split(",")
          .map<bool>((bit) => bit == "1")
          .toList(),
      createdAt: DateTime.parse(map[columnCreatedAt]),
      updatedAt: DateTime.parse(map[columnUpdatedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: this.title,
      columnDescription: this.description,
      columnIsDone: this.isDone ? 1 : 0,
      columnRepeatReminder: this.repeatReminder.toString(),
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
