import "package:flutter/material.dart";
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoForm/NotificationFields/DaysToRemindField.dart';
import '../TodoForm.dart';

enum WeekDays { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }

List<String> weekDaysLabels = [
  "Do",
  "Se",
  "Te",
  "Qu",
  "Qi",
  "Se",
  "Sá",
];

extension WeekDaysExtension on WeekDays {
  String get label {
    return weekDaysLabels[this.index];
  }
}

class TimePeriodsField extends StatelessWidget {
  TimePeriodsField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TimePeriods>(
        valueListenable: todoForm.selectedTimePeriod,
        builder: (BuildContext context, TimePeriods selectedTimePeriod, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Repetir"),
              Center(
                child: DropdownButton<TimePeriods>(
                  elevation: 6,
                  value: todoForm.selectedTimePeriod.value,
                  items: TimePeriods.values.map((TimePeriods timePeriod) {
                    return DropdownMenuItem<TimePeriods>(
                      value: timePeriod,
                      child: Text(timePeriod.label),
                    );
                  }).toList(),
                  onChanged: (TimePeriods value) {
                    if (todoForm.isReadingTodoController.value)
                      todoForm.isReadingTodo = false;

                    if (value == TimePeriods.DAILY)
                      todoForm.daysToRemindController.setAll(
                          0,
                          todoForm.daysToRemindController
                              .map((_) => ValueNotifier(true)));
                    else {
                      var onlyThisDay = [
                        ValueNotifier(false),
                        ValueNotifier(false),
                        ValueNotifier(false),
                        ValueNotifier(false),
                        ValueNotifier(false),
                        ValueNotifier(false),
                        ValueNotifier(false)
                      ];
                      if (value == TimePeriods.WEEKLY) {
                        var weekDay = DateTime.now().weekday;
                        onlyThisDay[weekDay == 7 ? 0 : weekDay].value = true;
                      }
                      todoForm.daysToRemindController.setAll(0, onlyThisDay);
                    }
                    todoForm.selectedTimePeriod = ValueNotifier(
                      TimePeriods.values
                          .firstWhere((timePeriod) => timePeriod == value),
                    );
                  },
                ),
              ),
              if (selectedTimePeriod == TimePeriods.NEVER ||
                  selectedTimePeriod == TimePeriods.MONTHLY)
                Container()
              else
                DaysToRemindField(),
            ],
          );
        });
  }
}
