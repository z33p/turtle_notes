import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/NotificationsProvider.dart';
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
  TimePeriods selectedTimePeriod;
  TextEditingController reminderDateTimeController;
  List<bool> daysToRemind;
  bool isDoneController;
  bool isReadingTodoState;
  bool isUpdatingTodoState;

  _TodoFormScreenState({this.todo});

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: this.todo?.title ?? "");
    descriptionController =
        TextEditingController(text: this.todo?.description ?? "");
    reminderDateTimeController = TextEditingController(
        text: this.todo?.reminderDateTime != null
            ? DateFormat("dd-MM-yyyy hh:mm").format(this.todo.reminderDateTime)
            : DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()));

    selectedTimePeriod = TimePeriods.NEVER;
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
    reminderDateTimeController.dispose();
    super.dispose();
  }

  void setRepeatReminder(TimePeriods value) {
    /** It also changes reminderDateTimeController
     * to represent DateTime "dd-MM-yyyy HH:mm" for TimePeriods.NEVER
     * And to represent only time "HH:mm" to others
     */
    if (value != TimePeriods.NEVER && value != TimePeriods.MONTHLY) {
      if (reminderDateTimeController.text.length != 5) {
        reminderDateTimeController.text = DateFormat("HH:mm").format(
            DateFormat("dd-MM-yyyy HH:mm")
                .parse(reminderDateTimeController.text));
      }
      setState(() {
        return selectedTimePeriod = value;
      });
    } else {
      if (reminderDateTimeController.text.length == 5)
        reminderDateTimeController.text = DateFormat("dd-MM-yyyy ")
                .format(this.todo?.reminderDateTime ?? DateTime.now()) +
            reminderDateTimeController.text;
      setState(() {
        return selectedTimePeriod = value;
      });
    }
  }

  void setDaysToRemind(
    List<bool> days, {
    int index,
    bool value,
  }) {
    if (days != null) return setState(() => daysToRemind = days);
    return setState(() => daysToRemind[index] = value);
  }

  void setIsDone(bool value) => setState(() => isDoneController = value);

  void setIsReadingTodoState(bool isReadingTodo, {bool isUpdatingTodo}) {
    setState(() {
      isReadingTodoState = isReadingTodo;
      isUpdatingTodoState = isUpdatingTodo ?? !isReadingTodoState;
    });
  }

  Future<void> createOrEditTodo() async {
    var whenRepeat;
    int amountOfDaysToRemind =
        daysToRemind.where((bool isDayToRemind) => isDayToRemind).length;

    // If none day is to remind set reapeatReminder as never
    if (amountOfDaysToRemind == 0)
      whenRepeat = TimePeriods.NEVER;
    // Default
    else
      whenRepeat = selectedTimePeriod;

    DateTime reminderDateTime = selectedTimePeriod == TimePeriods.NEVER ||
            selectedTimePeriod == TimePeriods.NEVER
        ? DateFormat("dd-MM-yyyy hh:mm").parse(reminderDateTimeController.text)
        : DateTime.parse(DateFormat("yyyy-MM-dd ")
                .format(this.todo?.reminderDateTime ?? DateTime.now()) +
            reminderDateTimeController.text);

    Todo todo = Todo(
      title: titleController.text,
      description: descriptionController.text,
      isDone: isDoneController,
      repeatReminder: whenRepeat,
      reminderDateTime: reminderDateTime,
      daysToRemind: daysToRemind,
    );

    if (isUpdatingTodoState) {
      todo.id = this.todo.id;
      todo.createdAt = this.todo.createdAt;
      store.dispatch(updateTodoAction(todo));
    } else {
      Todo todoCreated = await TodosProvider.db.insert(todo);

      await setNotification(todoCreated);

      store.dispatch(createTodoAction(todoCreated));
    }
  }

  Future<void> setNotification(Todo todo) async {
    switch (todo.repeatReminder) {
      case TimePeriods.NEVER:
        return await NotificationsProvider.scheduleNotification(todo);

      case TimePeriods.DAILY:
        return await NotificationsProvider.scheduleNotificationDaily(todo);
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isReadingTodoState
              ? Text(widget.title)
              : !isUpdatingTodoState
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
          selectedTimePeriod,
          setRepeatReminder,
          reminderDateTimeController,
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
