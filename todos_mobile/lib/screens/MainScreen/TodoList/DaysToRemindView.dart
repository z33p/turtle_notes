import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/TimePeriodsField.dart';

class DaysToRemindView extends StatelessWidget {
  final Todo todo;

  DaysToRemindView(this.todo);

  Widget chooseTimePeriodView() {
    switch (todo.timePeriods) {
      case TimePeriods.NEVER:
        return Text(
          DateFormat("dd-MM-yyyy HH:mm").format(todo.reminderDateTime),
        );
      case TimePeriods.DAILY:
        return Container(
          padding: EdgeInsets.only(top: 2.0),
          alignment: Alignment.centerRight,
          child: Text(
            TimePeriods.DAILY.label +
                " as " +
                DateFormat("HH:mm").format(todo.reminderDateTime),
          ),
        );

      case TimePeriods.MONTHLY:
        return Container(
          padding: EdgeInsets.only(top: 2.0),
          alignment: Alignment.centerRight,
          child: Text(
            "${TimePeriods.MONTHLY.label} dia ${todo.reminderDateTime.day}",
          ),
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: todo.daysToRemind
              .asMap()
              .entries
              .map(
                (day) => Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      color: todo.daysToRemind[day.key]
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue, width: 1.0)),
                  child: Text(
                    weekDaysLabels[day.key],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        color: todo.daysToRemind[day.key]
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              )
              .toList(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: chooseTimePeriodView());
  }
}
