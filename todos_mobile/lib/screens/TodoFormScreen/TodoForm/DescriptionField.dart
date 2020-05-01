import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TodoForm.dart';

class DescriptionField extends StatelessWidget {
  DescriptionField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Descrição"),
          ),
          if (!todoForm.isReadingTodoController.value)
            TextFormField(
              controller: todoForm.descriptionController,
              enabled: !todoForm.isReadingTodoController.value,
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
                    enabled: !todoForm.isReadingTodoController.value,
                    maxLines: 4,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
