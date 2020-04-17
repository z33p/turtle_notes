import 'package:todos_mobile/helpers/TodosProvider.dart';

class Todo {
  int id;
  String title;
  String description;
  bool isDone;

  String createdAt;
  String updatedAt;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.isDone = false,
      this.createdAt,
      this.updatedAt});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map[columnTitle],
      description: map[columnDescription],
      isDone: map[columnIsDone] == 1,
      createdAt: map[columnCreatedAt],
      updatedAt: map[columnUpdatedAt],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: this.title,
      columnDescription: this.description,
      columnIsDone: this.isDone ? 1 : 0,
      columnCreatedAt: this.createdAt,
      columnUpdatedAt: this.updatedAt,
    };

    if (this.id != null) map[columnId] = id;

    return map;
  }
}
