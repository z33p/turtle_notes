import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todos_mobile/actions/types.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/store.dart';

void getTodosAction(Store store) async {
  store.dispatch(GetTodosAction(await TodosProvider.db.findAll()));
}

ThunkAction<AppState> createTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    store.dispatch(CreateTodoAction(todo));
  };
}

ThunkAction<AppState> updateTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    todo.updatedAt = DateTime.now();
    await TodosProvider.db.update(todo);
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

ThunkAction<AppState> deleteTodoAction(int id) {
  return (Store<AppState> store) async {
    await TodosProvider.db.remove(id);
    store.dispatch(DeleteTodoAction(id));
  };
}
