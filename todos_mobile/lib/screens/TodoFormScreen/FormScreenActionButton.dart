import 'package:flutter/material.dart';

import 'TodoForm/TodoForm.dart';

class FormScreenActionButton extends StatefulWidget {
  final VoidCallback popNavigator;

  FormScreenActionButton(this.popNavigator, {Key key}) : super(key: key);

  @override
  _FormScreenActionButtonState createState() => _FormScreenActionButtonState();
}

class _FormScreenActionButtonState extends State<FormScreenActionButton> {
  bool itWasBeingRead;
  IconData saveOrArrowIcon;

  @override
  void initState() {
    super.initState();
    itWasBeingRead = todoForm.isReadingTodoController.value;
    saveOrArrowIcon = todoForm.isReadingTodoController.value
        ? Icons.save
        : Icons.arrow_forward;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(todoForm.isReadingTodoController.value
          ? Icons.edit
          : saveOrArrowIcon),
      onPressed: () async {
        if (todoForm.isReadingTodoController.value) {
          todoForm.setIsReadingTodo(false);
          return;
        }

        if (todoForm.formKey.currentState.validate()) {
          await todoForm.createOrEditTodo();
          int snackBarDuration = 1;
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: snackBarDuration),
              content: Text(
                todoForm.isUpdatingTodoController.value
                    ? "Tarefa editada!"
                    : "Tarefa criada!",
              )));

          await Future.delayed(
            Duration(seconds: snackBarDuration),
            itWasBeingRead
                ? () => todoForm.setIsReadingTodo(true)
                : widget.popNavigator,
          );
        }
      },
    );
  }
}
