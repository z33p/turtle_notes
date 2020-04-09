import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String description;
  bool isDone;

  Todo({this.id, this.title, this.description, this.isDone});

  factory Todo.fromDocSnapshot(DocumentSnapshot doc) {
    return Todo(
      id: doc.documentID,
      title: doc['title'],
      description: doc['description'],
      isDone: doc['isDone'],
    );
  }

  dynamic toDoc() {
    return {
      "title": this.title,
      "description": this.description,
      "isDone": this.isDone
    };
  }
}
