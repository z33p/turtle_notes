import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turtle_notes/models/Todo.dart';

class TimeLeft extends StatefulWidget {
  final Todo todo;

  TimeLeft(this.todo);

  DateTime getTimeDifference(DateTime dateTime) {
    var now = DateTime.now();

    var nowDurationReminder = Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
    );

    return dateTime.subtract(nowDurationReminder);
  }

  String toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  String getTimeLeftForDaily() {
    DateTime timeDifference = getTimeDifference(todo.reminderDateTime);

    if (timeDifference.hour > 0) return "Faltam ${timeDifference.hour} horas";

    return "Faltam ${timeDifference.minute}:${toTwoDigitString(timeDifference.second)} minutos";
  }

  String getTimeLeftForChooseDays() {
    int weekday = DateTime.now().weekday;
    var nextDayToRemind = -1;

    var i = weekday + 1;
    while (i != weekday) {
      if (todo.daysToRemind[i]) {
        nextDayToRemind = i;
        break;
      }

      if (i++ == todo.daysToRemind.length - 1) i = 0;
    }

    return getTimeLeftForWeekly(todoWeekDay: nextDayToRemind);
  }

  String getTimeLeftForWeekly({int todoWeekDay}) {
    todoWeekDay ??=
        todo.daysToRemind.indexWhere((bool isDayToRemind) => isDayToRemind);

    int weekDayDifference = todoWeekDay - DateTime.now().weekday;

    weekDayDifference = weekDayDifference.isNegative
        ? weekDayDifference + 7
        : weekDayDifference;

    if (weekDayDifference != 0) return "Faltam $weekDayDifference dias";
    DateTime timeDifference = getTimeDifference(todo.reminderDateTime);

    if (timeDifference.hour > 0) return "Faltam ${timeDifference.hour} horas";

    return "Faltam ${timeDifference.minute}:${toTwoDigitString(timeDifference.second)} minutos";
  }

  String getTimeLeft() {
    var dateTimeLeft = todo.reminderDateTime.difference(DateTime.now());

    if (dateTimeLeft.inDays > 0) return "Faltam ${dateTimeLeft.inDays} dias";

    if (dateTimeLeft.inHours > 0) return "Faltam ${dateTimeLeft.inHours} horas";

    return "Faltam ${dateTimeLeft.inMinutes} minutos";
  }

  @override
  _TimeLeftState createState() {
    switch (todo.timePeriods) {
      case TimePeriods.NEVER:
        return _TimeLeftState(getTimeLeft: this.getTimeLeft);

      case TimePeriods.DAILY:
        return _TimeLeftState(getTimeLeft: this.getTimeLeftForDaily);

      case TimePeriods.WEEKLY:
        return _TimeLeftState(getTimeLeft: this.getTimeLeftForWeekly);

      case TimePeriods.CHOOSE_DAYS:
        return _TimeLeftState(getTimeLeft: this.getTimeLeftForChooseDays);

      default:
        return _TimeLeftState(getTimeLeft: () => "Error");
    }
  }
}

class _TimeLeftState extends State<TimeLeft> {
  final String Function() getTimeLeft;

  _TimeLeftState({this.getTimeLeft});

  String _timeLeft;
  Timer refreshTimeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = getTimeLeft();
    refreshTimeLeft = Timer.periodic(
      new Duration(seconds: 1),
      (timer) => setState(() => _timeLeft = getTimeLeft()),
    );
  }

  @override
  void deactivate() {
    refreshTimeLeft.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_timeLeft);
  }
}
