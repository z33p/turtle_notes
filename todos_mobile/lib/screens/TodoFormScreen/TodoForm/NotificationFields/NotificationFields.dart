import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/ReminderField.dart';

import 'DaysToRemindField.dart';

class NotificationFields extends StatelessWidget {
  final TextEditingController reminderController;
  final List<bool> daysToRemind;
  final void Function(int index, bool value) setDaysToRemind;

  NotificationFields(
      this.reminderController, this.daysToRemind, this.setDaysToRemind);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ReminderField(this.reminderController),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DaysToRemindField(this.daysToRemind, this.setDaysToRemind),
          )
        ],
      ),
    );
  }
}
