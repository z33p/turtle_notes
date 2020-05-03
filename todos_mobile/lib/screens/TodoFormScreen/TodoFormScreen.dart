import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/IsDoneField.dart';

import 'FormScreenActionButton.dart';
import 'TodoForm/DescriptionField.dart';
import 'TodoForm/NotificationFields/NotificationFields.dart';
import 'TodoForm/TitleField.dart';
import 'TodoForm/TodoForm.dart';

class TodoFormScreen extends StatefulWidget {
  final String title;
  final Todo todo;
  final bool isUpdatingTodo;
  final bool isReadingTodo;

  TodoFormScreen({
    Key key,
    this.title = "Criar Tarefa",
    this.todo,
    this.isUpdatingTodo = false,
    this.isReadingTodo = false,
  }) : super(key: key);

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState(
      todo: todo, isReadingTodo: isReadingTodo, isUpdatingTodo: isUpdatingTodo);
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final Todo todo;

  TextEditingController titleController;
  TextEditingController descriptionController;
  TimePeriods selectedTimePeriod;
  TextEditingController timePeriodsController;
  List<bool> daysToRemind;
  bool isDoneController;
  bool isReadingTodo;
  bool isUpdatingTodo;

  _TodoFormScreenState({this.todo, this.isReadingTodo, this.isUpdatingTodo}) {
    if (this.todo != null) {
      todoForm.todo = this.todo;

      todoForm.isDoneController.value = this.todo.isDone;
      todoForm.isReadingTodoController.value = isReadingTodo;
    }
    todoForm.reminderDateTimeController.text =
        DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
  }

  @protected
  @mustCallSuper
  void dispose() {
    todoForm.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
            valueListenable: todoForm.isUpdatingTodoController,
            builder: (BuildContext context, bool isUpdatingTodo, _) {
              return todoForm.isReadingTodoController.value
                  ? Text(widget.title)
                  : !isUpdatingTodo
                      ? Text(
                          widget.title,
                          key: Key("appBarTitle"),
                        )
                      : Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.edit),
                            ),
                            Text(widget.title)
                          ],
                        );
            }),
      ),
      floatingActionButton: FormScreenActionButton(
        () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: todoForm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TitleField(),
                DescriptionField(),
                IsDoneField(),
                NotificationFields()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
