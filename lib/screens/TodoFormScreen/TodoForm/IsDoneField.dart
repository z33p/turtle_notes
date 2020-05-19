import 'package:flutter/material.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/TodoForm.dart';

class IsDoneField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: todoForm.isDoneController,
      builder: (BuildContext context, bool value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Completo"),
            ValueListenableBuilder<bool>(
                valueListenable: todoForm.isReadingTodoController,
                builder: (BuildContext context, bool isReadingTodo, _) {
                  return Checkbox(
                    key: Key("isDoneField"),
                    value: value,
                    onChanged: (bool isChecked) {
                      if (isReadingTodo) todoForm.isReadingTodo = false;

                      todoForm.isDoneController.value = isChecked;
                    },
                  );
                }),
          ],
        );
      },
    );
  }
}
