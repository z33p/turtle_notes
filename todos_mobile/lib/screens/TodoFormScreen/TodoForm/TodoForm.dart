import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/NotificationFields.dart';

import 'DescriptionField.dart';
import 'TitleField.dart';

class TodoForm extends StatelessWidget {
  final Todo todo;
  final bool isReadingTodo;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController reminderController;
  final List<bool> daysToRemind;
  final bool isDoneController;
  final void Function(int index, bool value) setDaysToRemind;
  final void Function(bool value) setIsDone;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  final GlobalKey<FormState> _formKey;

  TodoForm(
    this._formKey,
    this.isReadingTodo,
    this.titleController,
    this.descriptionController,
    this.reminderController,
    this.daysToRemind,
    this.setDaysToRemind,
    this.isDoneController,
    this.setIsDone,
    this.setIsReadingTodoState, {
    this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleField(titleController, isReadingTodo, setIsReadingTodoState),
            DescriptionField(
                descriptionController, isReadingTodo, setIsReadingTodoState),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Completo"),
                Checkbox(
                  value: isDoneController,
                  onChanged: (value) {
                    if (isReadingTodo) setIsReadingTodoState(false);
                    setIsDone(value);
                  },
                ),
              ],
            ),
            NotificationFields(this.reminderController, this.daysToRemind,
                this.setDaysToRemind, isReadingTodo, setIsReadingTodoState)
          ],
        ),
      ),
    );
  }
}
