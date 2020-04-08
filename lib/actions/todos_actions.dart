import 'dart:convert';
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todos_mobile/actions/types.dart';
import 'package:http/http.dart' as http;
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/store.dart';

const serverHost = "10.0.2.2";
const serverPort = "3000";
const apiVersion = "api/v1";

var rootUrl = "http://$serverHost:$serverPort/$apiVersion/todos";

void getTodosAction(Store store) async {
  final res = await http.get(rootUrl);

  if (res.statusCode != 200)
    print(res.statusCode);
  else {
    List<Todo> todos = [];
    for (var todo in json.decode(res.body)) {
      todos.add(Todo.fromJson(todo));
    }

    store.dispatch(GetTodosAction(todos));
  }
}

Future<Todo> createTodoRequest(Todo todo) async {
  var res = await http.post(rootUrl,
      body: json.encode({
        "title": todo.title,
        "description": todo.description,
        "is_done": todo.isDone
      }),
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  if (res.statusCode != 201) print(res.statusCode);

  return Todo.fromJson(json.decode(res.body));
}

ThunkAction<AppState> createTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    store.dispatch(CreateTodoAction(todo));
  };
}

Future<bool> updateTodoRequest(Todo todo) async {
  var url = "$rootUrl/${todo.id}";

  var res = await http.patch(url,
      body: json.encode({
        "title": todo.title,
        "description": todo.description,
        "is_done": todo.isDone
      }),
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  bool update = res.statusCode == 200;
  if (!update) print(res.statusCode);

  return update;
}

ThunkAction<AppState> updateTodoAction(Todo todo) {
  return (Store<AppState> store) async {
    store.dispatch(UpdateTodoAction(todo));
  };
}

ThunkAction<AppState> patchTodoAction(int id, dynamic todo) {
  return (Store<AppState> store) async {
    var url = "$rootUrl/$id";

    var res = await http.patch(url,
        body: json.encode(todo),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    if (res.statusCode != 200)
      print(res.statusCode);
    else {
      store.dispatch(PatchTodoAction(id, todo));
    }
  };
}

ThunkAction<AppState> deleteTodoAction(int id) {
  return (Store<AppState> store) async {
    var url = "$rootUrl/$id";

    var res = await http.delete(url);

    if (res.statusCode != 204)
      print(res.statusCode);
    else {
      store.dispatch(DeleteTodoAction(id));
    }
  };
}
