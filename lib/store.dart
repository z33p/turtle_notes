import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:turtle_notes/reducers/todosReducer.dart';

import 'models/Todo.dart';

class AppState {
  final List<Todo> todos;

  AppState({this.todos});

  factory AppState.initialState() {
    return AppState(todos: []);
  }

  AppState copyWith({List<Todo> todos}) {
    return AppState(todos: todos ?? this.todos);
  }
}

// Logging middleware
loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');

  next(action);
}

var state = AppState.initialState();
var store = Store<AppState>(
  todosReducer,
  initialState: state,
  middleware: [loggingMiddleware, thunkMiddleware],
);
