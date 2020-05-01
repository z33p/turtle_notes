import 'package:flutter/material.dart';

import 'TodoForm.dart';

class TitleField extends StatelessWidget {
  TitleField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Título"),
          ),
          if (!todoForm.isReadingTodoController.value)
            TextFormField(
              textAlign: TextAlign.center,
              controller: todoForm.titleController,
              enabled: !todoForm.isReadingTodoController.value,
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor, insira um título";
                }
                return null;
              },
            )
          else
            GestureDetector(
              onTap: () => todoForm.setIsReadingTodo(false),
              child: Container(
                color: Colors.transparent,
                child: IgnorePointer(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: todoForm.titleController,
                    enabled: !todoForm.isReadingTodoController.value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Por favor, insira um título";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
