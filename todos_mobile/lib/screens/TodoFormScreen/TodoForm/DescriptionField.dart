import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;
  final bool isReadingTodo;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  DescriptionField(this.descriptionController, this.isReadingTodo,
      this.setIsReadingTodoState);

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
          if (!isReadingTodo ?? true)
            TextFormField(
              controller: descriptionController,
              enabled: !isReadingTodo ?? true,
              maxLines: 4,
            )
          else
            GestureDetector(
              onTap: () => setIsReadingTodoState(false),
              child: Container(
                color: Colors.transparent,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: descriptionController,
                    enabled: !isReadingTodo ?? true,
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
