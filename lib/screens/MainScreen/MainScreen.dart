import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turtle_notes/actions/todos_actions.dart';
import 'package:turtle_notes/models/Todo.dart';

import '../../store.dart';
import '../TodoFormScreen/TodoFormScreen.dart';
import 'NotificationsView.dart';
import 'TodoList/TodoList.dart';

class MainScreen extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final VoidCallback getTodos;

  MainScreen(this.todos, {Key key, this.title, this.getTodos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(title), NotificationsView(todos)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoFormScreen()),
          );
        }),
        tooltip: "Criar Tarefa",
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getTodosAction(store);
        },
        child: TodoList(todos),
      ),
    );
  }
}
