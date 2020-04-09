import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/screens/MainScreen/MainScreen.dart';
import 'package:todos_mobile/store.dart';

import 'models/Todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    getTodosAction(store);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Todo App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreConnector<AppState, List<Todo>>(
          converter: (store) => store.state.todos,
          builder: (context, todos) => MainScreen(
            todos,
            title: "Todo App",
          ),
        ),
      ),
    );
  }
}
