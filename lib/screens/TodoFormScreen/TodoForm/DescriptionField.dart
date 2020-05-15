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
                GestureDetector(
                  onTap: () => todoForm.isReadingTodo = false,
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      ignoring: isReadingTodo,
                      child: TextFormField(
                        key: Key("descriptionField"),
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
