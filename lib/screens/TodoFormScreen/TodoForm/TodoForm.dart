import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/actions/todos_actions.dart';
import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/store.dart';

class TodoForm {
  Todo _todo;
  GlobalKey<FormState> formKey;
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController reminderDateTimeController =
      TextEditingController(text: "");
  ValueNotifier<TimePeriods> _selectedTimePeriodController =
      ValueNotifier(TimePeriods.NEVER);
  List<ValueNotifier<bool>> daysToRemindController = new List(7);
  ValueNotifier<bool> isDoneController = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isReadingTodoController = ValueNotifier<bool>(false);
  ValueNotifier<bool> isUpdatingTodoController = ValueNotifier<bool>(false);
  FlutterLocalNotificationsPlugin notifications;

  TodoForm() {
    this.formKey = formKey ?? GlobalKey<FormState>();
    reminderDateTimeController.text =
        DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
    this.daysToRemindController.fillRange(0, 7, ValueNotifier<bool>(false));
  }

  set todo(Todo todo) {
    this._todo = todo;
    this.titleController.text = _todo.title;
    this.descriptionController.text = _todo.description;
    this.reminderDateTimeController.text =
        DateFormat("dd-MM-yyyy HH:mm").format(_todo.reminderDateTime);
    this.daysToRemindController.setAll(
        0, _todo.daysToRemind.map((bool day) => ValueNotifier<bool>(day)));
    this.selectedTimePeriod = ValueNotifier(_todo.timePeriods);
  }

  ValueNotifier<bool> get isReadingTodoController => _isReadingTodoController;

  set isReadingTodo(bool isReadingTodo) {
    _isReadingTodoController.value = isReadingTodo;
    isUpdatingTodoController.value = !isReadingTodo;
  }

  void setDaysToRemind({int index, bool value}) {
    switch (todoForm.selectedTimePeriod.value) {
      case TimePeriods.DAILY:
        if (todoForm.daysToRemindController
            .any((ValueNotifier<bool> isDayToRemind) => !isDayToRemind.value))
          todoForm.selectedTimePeriod = ValueNotifier(TimePeriods.CHOOSE_DAYS);
        break;

      case TimePeriods.WEEKLY:
        int currentDayToRemindIndex = todoForm.daysToRemindController
            .indexWhere((ValueNotifier<bool> dayToRemind) => dayToRemind.value);

        if (currentDayToRemindIndex != -1)
          this.daysToRemindController[currentDayToRemindIndex].value = false;

        break;

      // case TimePeriods.CHOOSE_DAYS:
      //   break;

      default:
        if (todoForm.daysToRemindController
            .every((ValueNotifier<bool> isDayToRemind) => isDayToRemind.value))
          todoForm.selectedTimePeriod = ValueNotifier(TimePeriods.DAILY);
    }

    this.daysToRemindController[index].value = value;
  }

  ValueNotifier<TimePeriods> get selectedTimePeriod =>
      _selectedTimePeriodController;

  set selectedTimePeriod(ValueNotifier<TimePeriods> valueController) {
    /** It also changes [this.reminderDateTimeController]
     * to represent [DateFormat("dd-MM-yyyy HH:mm")] for [TimePeriods.NEVER]
     * And to represent only time [DateFormat("HH:mm")] to others
     */
    if (valueController.value != TimePeriods.NEVER &&
        valueController.value != TimePeriods.MONTHLY) {
      if (this.reminderDateTimeController.text.length != 5) {
        this.reminderDateTimeController.text = DateFormat("HH:mm").format(
            DateFormat("dd-MM-yyyy HH:mm")
                .parse(this.reminderDateTimeController.text));
      }
      this._selectedTimePeriodController.value = valueController.value;
    } else if (this.reminderDateTimeController.text.length == 5)
      this.reminderDateTimeController.text = DateFormat("dd-MM-yyyy ")
              .format(this._todo?.reminderDateTime ?? DateTime.now()) +
          this.reminderDateTimeController.text;
    this._selectedTimePeriodController.value = valueController.value;
  }

  void clear() {
    this._todo = Todo();
    this.formKey = GlobalKey<FormState>();

    this.titleController.text = "";
    this.descriptionController.text = "";
    this.reminderDateTimeController.text = "";
    this.daysToRemindController.fillRange(0, 7, ValueNotifier<bool>(false));

    this.isDoneController.value = false;
    this._isReadingTodoController.value = false;
    this.isUpdatingTodoController.value = false;

    this._selectedTimePeriodController.value = TimePeriods.NEVER;
  }

  Todo extractTodoFromFields() {
    int amountOfDaysToRemind = daysToRemindController
        .where((ValueNotifier<bool> isDayToRemind) => isDayToRemind.value)
        .length;

    TimePeriods whenRepeat;

    // If none day is to remind set reapeatReminder as never
    if (amountOfDaysToRemind == 0)
      whenRepeat = TimePeriods.NEVER;
    else
      whenRepeat = _selectedTimePeriodController.value;

    DateTime reminderDateTime;

    if (_selectedTimePeriodController.value == TimePeriods.NEVER ||
        _selectedTimePeriodController.value == TimePeriods.MONTHLY)
      reminderDateTime =
          DateFormat("dd-MM-yyyy HH:mm").parse(reminderDateTimeController.text);
    else
      reminderDateTime = DateTime.parse(DateFormat("yyyy-MM-dd ")
              .format(this._todo?.reminderDateTime ?? DateTime.now()) +
          reminderDateTimeController.text);

    return Todo(
      title: titleController.text,
      description: descriptionController.text,
      isDone: isDoneController.value,
      timePeriods: whenRepeat,
      reminderDateTime: reminderDateTime,
      daysToRemind: daysToRemindController
          .map<bool>((ValueNotifier<bool> day) => day.value)
          .toList(),
    );
  }

  Future<void> createOrEditTodo() async {
    var todoFromFields = extractTodoFromFields();

    if (isUpdatingTodoController.value) {
      todoFromFields.id = _todo.id;
      todoFromFields.createdAt = _todo.createdAt;
      store.dispatch(updateTodoAction(todoFromFields));
      setNotification(todoFromFields);
    } else {
      Todo todoCreated = await TodosProvider.db.insert(todoFromFields);

      store.dispatch(createTodoAction(todoCreated));
      setNotification(todoCreated);
    }
  }

  void setNotification(Todo todo) {
    if (isUpdatingTodoController.value) cancelNotification(todo.id);

    switch (todo.timePeriods) {
      case TimePeriods.NEVER:
        if (todo.reminderDateTime.difference(DateTime.now()).isNegative) return;
        return scheduleNotification(todo);

      case TimePeriods.DAILY:
        return scheduleNotificationDaily(todo);

      case TimePeriods.WEEKLY:
        return scheduleNotificationWeekly(todo);

      default:
        return;
    }
  }
}

final todoForm = TodoForm();
