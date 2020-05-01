import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/helpers/NotificationsProvider.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/store.dart';

class TodoForm {
  Todo todo;
  GlobalKey<FormState> formKey;
  TextEditingController titleController = TextEditingController(text: "Hello");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController reminderDateTimeController =
      TextEditingController(text: "");
  ValueNotifier<TimePeriods> selectedTimePeriodController =
      ValueNotifier(TimePeriods.NEVER);
  List<ValueNotifier<bool>> daysToRemindController = new List(7);
  ValueNotifier<bool> isDoneController = ValueNotifier<bool>(false);
  ValueNotifier<bool> isReadingTodoController = ValueNotifier<bool>(false);
  ValueNotifier<bool> isUpdatingTodoController = ValueNotifier<bool>(false);

  TodoForm() {
    this.todo = todo ?? Todo();
    this.formKey = formKey ?? GlobalKey<FormState>();
    this.daysToRemindController.fillRange(0, 7, ValueNotifier<bool>(false));
  }

  void setIsReadingTodo(bool isReadingTodo, {bool isUpdatingTodo}) {
    isReadingTodoController.value = isReadingTodo;
    isUpdatingTodoController.value =
        isUpdatingTodo ?? !isUpdatingTodoController.value;
  }

  void setDaysToRemind({
    int index,
    bool value,
  }) {
    this.daysToRemindController[index].value = value;
  }

  void setRepeatReminder(TimePeriods value) {
    /** It also changes this.reminderDateTimeController
     * to represent DateTime "dd-MM-yyyy HH:mm" for TimePeriods.NEVER
     * And to represent only time "HH:mm" to others
     */
    if (value != TimePeriods.NEVER && value != TimePeriods.MONTHLY) {
      if (this.reminderDateTimeController.text.length != 5) {
        this.reminderDateTimeController.text = DateFormat("HH:mm").format(
            DateFormat("dd-MM-yyyy HH:mm")
                .parse(this.reminderDateTimeController.text));
      }
      this.selectedTimePeriodController.value = value;
    } else {
      if (this.reminderDateTimeController.text.length == 5)
        this.reminderDateTimeController.text = DateFormat("dd-MM-yyyy ")
                .format(this.todo?.reminderDateTime ?? DateTime.now()) +
            this.reminderDateTimeController.text;
      this.selectedTimePeriodController.value = value;
    }
  }

  void clear() {
    this.todo = Todo();
    this.formKey = GlobalKey<FormState>();

    this.titleController.text = "";
    this.descriptionController.text = "";
    this.reminderDateTimeController.text = "";
    this.daysToRemindController.fillRange(0, 7, ValueNotifier<bool>(false));

    this.isDoneController.value = false;
    this.isReadingTodoController.value = false;
    this.isUpdatingTodoController.value = false;

    this.selectedTimePeriodController.value = TimePeriods.NEVER;
  }

  Future<void> createOrEditTodo() async {
    var whenRepeat;
    int amountOfDaysToRemind = daysToRemindController
        .where((ValueNotifier<bool> isDayToRemind) => isDayToRemind.value)
        .length;

    // If none day is to remind set reapeatReminder as never
    if (amountOfDaysToRemind == 0)
      whenRepeat = TimePeriods.NEVER;
    // Default
    else
      whenRepeat = selectedTimePeriodController.value;

    DateTime reminderDateTime = selectedTimePeriodController.value ==
                TimePeriods.NEVER ||
            selectedTimePeriodController.value == TimePeriods.NEVER
        ? DateFormat("dd-MM-yyyy HH:mm").parse(reminderDateTimeController.text)
        : DateTime.parse(DateFormat("yyyy-MM-dd ")
                .format(this.todo?.reminderDateTime ?? DateTime.now()) +
            reminderDateTimeController.text);

    Todo todo = Todo(
      title: titleController.text,
      description: descriptionController.text,
      isDone: isDoneController.value,
      timePeriods: whenRepeat,
      reminderDateTime: reminderDateTime,
      daysToRemind:
          daysToRemindController.map((ValueNotifier<bool> day) => day.value),
    );

    if (isUpdatingTodoController.value) {
      todo.id = this.todo.id;
      todo.createdAt = this.todo.createdAt;
      store.dispatch(updateTodoAction(todo));
      await setNotification(todo);
    } else {
      Todo todoCreated = await TodosProvider.db.insert(todo);

      await setNotification(todoCreated);

      store.dispatch(createTodoAction(todoCreated));
    }
  }

  Future<void> setNotification(Todo todo) async {
    if (isUpdatingTodoController.value)
      await NotificationsProvider.cancelNotification(todo.id);

    switch (todo.timePeriods) {
      case TimePeriods.NEVER:
        return await NotificationsProvider.scheduleNotification(todo);

      case TimePeriods.DAILY:
        return await NotificationsProvider.scheduleNotificationDaily(todo);

      case TimePeriods.WEEKLY:
        return await NotificationsProvider.scheduleNotificationWeekly(todo);

      default:
        return;
    }
  }
}

final todoForm = TodoForm();
