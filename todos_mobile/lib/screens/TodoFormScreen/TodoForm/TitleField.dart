import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final TextEditingController titleController;
  final bool isReadingTodo;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  TitleField(
      this.titleController, this.isReadingTodo, this.setIsReadingTodoState);

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
          if (!isReadingTodo ?? true)
            TextFormField(
              textAlign: TextAlign.center,
              controller: titleController,
              enabled: !isReadingTodo ?? true,
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
              onTap: () => setIsReadingTodoState(false),
              child: Container(
                color: Colors.transparent,
                child: IgnorePointer(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: titleController,
                    enabled: !isReadingTodo ?? true,
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
