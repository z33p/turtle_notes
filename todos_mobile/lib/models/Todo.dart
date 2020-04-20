import 'package:todos_mobile/helpers/TodosProvider.dart';

class Todo {
  int id;
  String title;
  String description;
  bool isDone;
  DateTime reminder;
  List<bool> daysToRemind = new List(7);

  DateTime createdAt;
  DateTime updatedAt;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.isDone = false,
      this.reminder,
      this.daysToRemind,
      this.createdAt,
      this.updatedAt});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map[columnTitle],
      description: map[columnDescription],
      isDone: map[columnIsDone] == 1,
      reminder: DateTime.parse(map[columnReminder]),
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
      columnReminder: this.reminder.toString(),
      columnDaysToRemind:
          this.daysToRemind.map((boolean) => boolean ? 1 : 0).join(","),
      columnCreatedAt: this.createdAt.toString(),
      columnUpdatedAt: this.updatedAt.toString(),
    };

    if (this.id != null) map[columnId] = id;

    return map;
  }
}
