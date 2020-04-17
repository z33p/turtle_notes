import 'package:cloud_firestore/cloud_firestore.dart';

final String columnId = "id";
final String columnTitle = "title";
final String columnDescription = "description";
final String columnIsDone = "isDone";
final String columnCreatedAt = "createdAt";
final String columnUpdatedAt = "updatedAt";

class Todo {
  String id;
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  DateTime updatedAt;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.isDone,
      this.createdAt,
      this.updatedAt});

  factory Todo.fromDocSnapshot(DocumentSnapshot doc) {
    return Todo(
      id: doc.documentID,
      title: doc[columnTitle],
      description: doc[columnDescription],
      isDone: doc[columnIsDone],
      createdAt: doc[columnCreatedAt].toDate(),
      updatedAt: doc["updatedAt"].toDate(),
    );
  }

  dynamic toDoc() {
    return {
      columnTitle: this.title,
      columnDescription: this.description,
      columnIsDone: this.isDone,
      columnCreatedAt: Timestamp.fromDate(this.createdAt),
      columnUpdatedAt: Timestamp.fromDate(this.updatedAt),
    };
  }
}
