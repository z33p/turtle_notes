import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/NotificationsProvider.dart';
import 'package:todos_mobile/screens/MainScreen/MainScreen.dart';
import 'package:todos_mobile/store.dart';

import 'models/Todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationsProvider.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    getTodosAction(store);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Tarefas",
        theme: ThemeData(
          primarySwatch: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
        ),
        home: StoreConnector<AppState, List<Todo>>(
          converter: (store) => store.state.todos,
          builder: (context, todos) => MainScreen(
            todos,
            title: "Tarefas",
          ),
        ),
      ),
    );
  }
}
