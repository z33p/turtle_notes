import 'package:flutter/material.dart';

import 'TodoForm.dart';

class TitleField extends StatelessWidget {
  TitleField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ValueListenableBuilder<bool>(
          valueListenable: todoForm.isReadingTodoController,
          builder: (BuildContext context, bool isReadingTodo, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text("Título"),
                ),
                GestureDetector(
                  onTap: () => todoForm.isReadingTodo = true,
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      ignoring: isReadingTodo,
                      child: TextFormField(
                        key: Key("titleField"),
                        textAlign: TextAlign.center,
                        controller: todoForm.titleController,
                        enabled: !isReadingTodo,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Por favor, insira um título";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
