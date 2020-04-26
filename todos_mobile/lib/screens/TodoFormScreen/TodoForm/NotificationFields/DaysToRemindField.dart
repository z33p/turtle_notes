import "package:flutter/material.dart";
import '../../../../models/Todo.dart';

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

class DaysToRemindField extends StatelessWidget {
  final TimePeriods selectedTimePeriod;
  final void Function(TimePeriods value) setRepeatReminder;
  final List<bool> daysToRemind;
  final bool isReadingTodo;
  final void Function(List<bool> days, {int index, bool value}) setDaysToRemind;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  DaysToRemindField(
    this.selectedTimePeriod,
    this.setRepeatReminder,
    this.daysToRemind,
    this.setDaysToRemind,
    this.isReadingTodo,
    this.setIsReadingTodoState,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Repetir"),
        Center(
          child: DropdownButton<String>(
            value: selectedTimePeriod.label,
            items: <String>[
              TimePeriods.NEVER.label,
              TimePeriods.CHOOSE_DAYS.label,
              TimePeriods.DAILY.label,
              TimePeriods.WEEKLY.label,
              TimePeriods.MONTHLY.label,
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String value) {
              if (value == TimePeriods.DAILY.label)
                setDaysToRemind([true, true, true, true, true, true, true]);
              else if (value == TimePeriods.WEEKLY.label) {
                var onlyThisDay = [
                  false,
                  false,
                  false,
                  false,
                  false,
                  false,
                  false
                ];
                var weekDay = DateTime.now().weekday;
                onlyThisDay[weekDay == 7 ? 0 : weekDay] = true;
                setDaysToRemind(onlyThisDay);
              } else
                setDaysToRemind(
                  [false, false, false, false, false, false, false],
                );

              setRepeatReminder(TimePeriods.values
                  .firstWhere((timePeriod) => timePeriod.label == value));
            },
          ),
        ),
        if (selectedTimePeriod == TimePeriods.NEVER)
          Container()
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: WeekDays.values
                  .map((day) => GestureDetector(
                        onTap: () {
                          if (isReadingTodo)
                            setIsReadingTodoState(false, isUpdatingTodo: true);

                          setDaysToRemind(
                            null,
                            index: day.index,
                            value: !daysToRemind[day.index],
                          );

                          if (daysToRemind.every((bool day) => day))
                            setRepeatReminder(TimePeriods.DAILY);
                          else if (selectedTimePeriod == TimePeriods.DAILY &&
                              daysToRemind.any((day) => !day))
                            setRepeatReminder(TimePeriods.CHOOSE_DAYS);
                          else if (selectedTimePeriod == TimePeriods.WEEKLY &&
                              daysToRemind.where((day) => day).length > 1)
                            setRepeatReminder(TimePeriods.CHOOSE_DAYS);
                          else if (selectedTimePeriod ==
                                  TimePeriods.CHOOSE_DAYS &&
                              daysToRemind.where((day) => day).length == 1) {
                            var weekDay = DateTime.now().weekday;
                            weekDay = weekDay == 7 ? 0 : weekDay;
                            if (daysToRemind[weekDay])
                              setRepeatReminder(TimePeriods.WEEKLY);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: daysToRemind[day.index]
                                  ? Colors.teal
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(360)),
                              border:
                                  Border.all(color: Colors.blue, width: 1.0)),
                          child: Text(
                            day.label,
                            style: TextStyle(
                                color: daysToRemind[day.index]
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
