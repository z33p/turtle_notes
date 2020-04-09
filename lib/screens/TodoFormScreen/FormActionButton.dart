import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';

class FormActionButton extends StatelessWidget {
  final Todo todo;
  final bool isUpdatingTodo;
  final GlobalKey<FormState> _formKey;

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isDoneController;

  final db = Firestore.instance.collection("todos");

  FormActionButton(this._formKey, this.todo, this.titleController,
      this.descriptionController, this.isDoneController, this.isUpdatingTodo);

  void createTodo() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      dynamic todo = {
        "title": titleController.text,
        "description": descriptionController.text,
        "isDone": isDoneController
      };

      await db.add(todo);
    }
  }

  void updateTodo(Todo todo) async {
    await db.document(todo.id).updateData(todo.toDoc());
  }

  void createOrEditTodo(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      Todo todo = Todo(
          title: titleController.text,
          description: descriptionController.text,
          isDone: isDoneController);

      if (isUpdatingTodo) {
        todo.id = this.todo.id;
        updateTodo(todo);
      }

      createTodo();

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(isUpdatingTodo ? "Todo editado!" : "Todo criado!")));

      await Future.delayed(
        Duration(seconds: 1),
        () => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward),
      onPressed: () => createOrEditTodo(context),
    );
  }
}
