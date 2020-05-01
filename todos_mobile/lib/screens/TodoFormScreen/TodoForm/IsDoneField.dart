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
            Checkbox(
              value: value,
              onChanged: (bool value) {
                if (todoForm.isReadingTodoController.value)
                  todoForm.setIsReadingTodo(false);

                todoForm.isDoneController.value = value;
              },
            ),
          ],
        );
      },
    );
  }
}
