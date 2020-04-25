import 'package:flutter/material.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../../store.dart';
import 'FormScreenActionButton.dart';
import 'TodoForm/TodoForm.dart';

class TodoFormScreen extends StatefulWidget {
  final String title;
  final Todo todo;
  final bool isUpdatingTodo;
  final bool isReadingTodo;

  TodoFormScreen({
    this.title = "Criar Tarefa",
    this.todo,
    this.isUpdatingTodo = false,
    this.isReadingTodo = false,
  });

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState(todo: todo);
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Todo todo;

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController reminderController;
  List<bool> daysToRemind;
  bool isDoneController;
  bool isReadingTodoState;
  bool isUpdatingTodoState;

  _TodoFormScreenState({this.todo}) {
    titleController = TextEditingController(text: this.todo?.title ?? "");
    descriptionController =
        TextEditingController(text: this.todo?.description ?? "");
    var tomorrowDateTime = DateTime.now().add(Duration(days: 1));
    reminderController = TextEditingController(
        text: this.todo?.reminder?.toString()?.substring(0, 16) ??
            "${tomorrowDateTime.day > 10 ? tomorrowDateTime.day : "0" + tomorrowDateTime.day.toString()}-${tomorrowDateTime.month > 10 ? tomorrowDateTime.month : "0" + tomorrowDateTime.month.toString()}-${tomorrowDateTime.year} ${tomorrowDateTime.hour > 10 ? tomorrowDateTime.hour : "0" + tomorrowDateTime.hour.toString()}:${tomorrowDateTime.minute > 10 ? tomorrowDateTime.minute : "0" + tomorrowDateTime.minute.toString()}");
  }

  @override
  void initState() {
    super.initState();
    daysToRemind = this.todo?.daysToRemind != null
        ? [...this.todo?.daysToRemind] // Copy
        : [false, false, false, false, false, false, false];
    isDoneController = this.todo?.isDone ?? false;
    isReadingTodoState = widget.isReadingTodo;
    isUpdatingTodoState = widget.isUpdatingTodo ?? false;
  }

  @protected
  @mustCallSuper
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    reminderController.dispose();
    super.dispose();
  }

  void setDaysToRemind(int index, bool value) =>
      setState(() => daysToRemind[index] = value);

  void setIsDone(bool value) => setState(() => isDoneController = value);

  void setIsReadingTodoState(bool isReadingTodo, {bool isUpdatingTodo}) {
    setState(() {
      isReadingTodoState = isReadingTodo;
      isUpdatingTodoState = isUpdatingTodo ?? !isReadingTodoState;
    });
  }

  Future<void> createOrEditTodo() async {
    var dateTimeSplited = reminderController.text.split("-");
    var day = dateTimeSplited[0];
    var month = dateTimeSplited[1];

    var yearTimeSplited = dateTimeSplited[2].split(" ");

    var year = yearTimeSplited[0];
    var time = yearTimeSplited[1];

    Todo todo = Todo(
        title: titleController.text,
        description: descriptionController.text,
        isDone: isDoneController,
        reminder: DateTime.parse("$year-$month-$day $time"),
        daysToRemind: daysToRemind);

    if (isUpdatingTodoState) {
      todo.id = this.todo.id;
      todo.createdAt = this.todo.createdAt;
      store.dispatch(updateTodoAction(todo));
    } else {
      Todo created = await TodosProvider.db.insert(todo);
      store.dispatch(createTodoAction(created));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isReadingTodoState
              ? Text(widget.title)
              : Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.edit),
                    ),
                    Text(widget.title)
                  ],
                )),
      floatingActionButton: FormScreenActionButton(
        _formKey,
        createOrEditTodo,
        isUpdatingTodoState,
        isReadingTodoState,
        setIsReadingTodoState,
        () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: TodoForm(
          _formKey,
          isReadingTodoState,
          titleController,
          descriptionController,
          reminderController,
          daysToRemind,
          setDaysToRemind,
          isDoneController,
          setIsDone,
          setIsReadingTodoState,
        ),
      ),
    );
  }
}
