import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';

import 'DescriptionField.dart';
import 'TitleField.dart';

class TodoForm extends StatelessWidget {
  final Todo todo;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isDoneController;
  final void Function(bool value) setIsDone;

  final GlobalKey<FormState> _formKey;

  TodoForm(this._formKey, this.titleController, this.descriptionController,
      this.isDoneController, this.setIsDone,
      {this.todo,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleField(titleController),
            DescriptionField(descriptionController),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Completo"),
                Checkbox(
                  value: isDoneController,
                  onChanged: (value) => setIsDone(value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
