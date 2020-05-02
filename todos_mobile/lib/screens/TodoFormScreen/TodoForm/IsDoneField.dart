import 'package:flutter/material.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/TodoForm.dart';

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
                    value: value,
                    onChanged: (bool value) {
                      if (isReadingTodo) todoForm.setIsReadingTodo(false);

                      todoForm.isDoneController.value = value;
                    },
                  );
                }),
          ],
        );
      },
    );
  }
}
