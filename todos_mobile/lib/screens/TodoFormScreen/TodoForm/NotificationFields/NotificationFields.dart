import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/ReminderDateTimeField.dart';

import 'DaysToRemindField.dart';

class NotificationFields extends StatelessWidget {
  final TimePeriods selectedTimePeriod;
  final void Function(TimePeriods value) setRepeatReminder;
  final TextEditingController reminderDateTimeController;
  final List<bool> daysToRemind;
  final void Function(List<bool> days, {int index, bool value}) setDaysToRemind;
  final bool isReadingTodo;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  NotificationFields(
    this.selectedTimePeriod,
    this.setRepeatReminder,
    this.reminderDateTimeController,
    this.daysToRemind,
    this.setDaysToRemind,
    this.isReadingTodo,
    this.setIsReadingTodoState,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ReminderDateTimeField(
              this.selectedTimePeriod,
              this.reminderDateTimeController,
              setIsReadingTodoState,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DaysToRemindField(
                this.selectedTimePeriod,
                this.setRepeatReminder,
                this.daysToRemind,
                this.setDaysToRemind,
                isReadingTodo,
                setIsReadingTodoState),
          )
        ],
      ),
    );
  }
}
