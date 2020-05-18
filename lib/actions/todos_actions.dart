import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:turtle_notes/actions/types.dart';
import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/store.dart';

import '../helpers/notifications_provider.dart';
import '../models/Todo.dart';

void getTodosAction(Store store) async {
  store.dispatch(GetTodosAction(await TodosProvider.db.findAll()));
}

ThunkAction<AppState> createTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    Todo todoCreated = await TodosProvider.db.insert(todo);
    todoCreated.notifications = await setNotifications(todoCreated);

    store.dispatch(CreateTodoAction(todoCreated));
  };
}

ThunkAction<AppState> updateTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    todo.updatedAt = DateTime.now();
    await TodosProvider.db.update(todo);
    todo.notifications = await setNotifications(todo, todoUpdated: true);

    store.dispatch(UpdateTodoAction(todo));
  };
}

ThunkAction<AppState> patchTodoAction(Map<String, dynamic> todo) {
  assert(todo.containsKey(columnId));

  return (Store<AppState> store) async {
    var dateTimeNow = DateTime.now();
    todo[columnUpdatedAt] = dateTimeNow.toString();

    await TodosProvider.db.patch(todo[columnId], todo);

    if (todo.containsKey(columnIsDone))
      todo[columnIsDone] = todo[columnIsDone] == 1;
    store.dispatch(PatchTodoAction(todo[columnId], todo));
  };
}

ThunkAction<AppState> deleteTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    await TodosProvider.db.remove(todo);
    store.dispatch(DeleteTodoAction(todo.id));
  };
}
