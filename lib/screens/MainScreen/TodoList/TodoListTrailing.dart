import 'package:flutter/material.dart';
import 'package:turtle_notes/actions/todos_actions.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';

import '../../../store.dart';

enum Options { EDIT, DELETE }

final List<String> options = ["Editar", "Deletar"];

extension OptionsExtension on Options {
  String get label => options[this.index];
}

class TodoListTrailling extends StatelessWidget {
  final Todo todo;

  TodoListTrailling(this.todo);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      onSelected: (Options option) async {
        if (option == Options.DELETE) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Deletar tarefa"),
                    content: Text('Deletar "${todo.title}"?'),
                    actions: [
                      FlatButton(
                        child: Text("Não"),
                        onPressed: () {
                          Navigator.pop(_);
                        },
                      ),
                      FlatButton(
                        child: Text("Sim"),
                        onPressed: () async {
                          store.dispatch(deleteTodoAction(todo.id));
                          Navigator.pop(_);
                        },
                      )
                    ],
                  ));
        } else {
          // It ends the current Snackbar (if there's one) avoiding memory leak warning
          Scaffold.of(context).hideCurrentSnackBar();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoFormScreen(
                title: "Editar Tarefa",
                todo: todo,
                isUpdatingTodo: true,
              ),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return Options.values
            .map((Options option) =>
                PopupMenuItem(value: option, child: Text(option.label)))
            .toList();
      },
    );
  }
}
