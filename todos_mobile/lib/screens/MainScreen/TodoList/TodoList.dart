import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';

import 'TodoView.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final List<Todo> todosDone = [];
  final List<Todo> todosNotDone = [];

  TodoList(this.todos) {
    todos.forEach((todo) {
      if (todo.isDone)
        todosDone.add(todo);
      else
        todosNotDone.add(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Pendentes",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        if (todosNotDone.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Sem Tarefas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
          )
        else
          Column(
            children: todosNotDone.map((todo) => TodoView(todo)).toList(),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Completas",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        if (todosDone.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Sem Tarefas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
          )
        else
          Column(
            children: todosDone.map((todo) => TodoView(todo)).toList(),
          ),
      ]),
    );
  }
}
