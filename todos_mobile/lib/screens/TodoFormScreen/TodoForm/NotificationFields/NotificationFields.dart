import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/ReminderDateTimeField.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/TimePeriodsField.dart';

class NotificationFields extends StatelessWidget {
  NotificationFields({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ReminderDateTimeField(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TimePeriodsField(),
          )
        ],
      ),
    );
  }
}
