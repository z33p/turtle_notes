import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TodoForm.dart';

class DescriptionField extends StatelessWidget {
  DescriptionField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: ValueListenableBuilder<bool>(
          valueListenable: todoForm.isReadingTodoController,
          builder: (BuildContext context, bool isReadingTodo, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text("Descrição"),
                ),
                if (!isReadingTodo)
                  TextFormField(
                    controller: todoForm.descriptionController,
                    enabled: !isReadingTodo,
                    maxLines: 4,
                  )
                else
                  GestureDetector(
                    onTap: () => todoForm.setIsReadingTodo(false),
                    child: Container(
                      color: Colors.transparent,
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: todoForm.descriptionController,
                          enabled: !isReadingTodo,
                          maxLines: 4,
                        ),
                      ),
                    ),
                  )
              ],
            );
          }),
    );
  }
}
