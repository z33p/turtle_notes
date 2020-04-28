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
          child: DropdownButton<TimePeriods>(
            value: selectedTimePeriod,
            items: TimePeriods.values.map((TimePeriods timePeriod) {
              return DropdownMenuItem<TimePeriods>(
                value: timePeriod,
                child: Text(timePeriod.label),
              );
            }).toList(),
            onChanged: (TimePeriods value) {
              if (value == TimePeriods.DAILY)
                setDaysToRemind([true, true, true, true, true, true, true]);
              else if (value == TimePeriods.WEEKLY) {
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
                  .firstWhere((timePeriod) => timePeriod == value));
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

                          switch (selectedTimePeriod) {
                            case TimePeriods.DAILY:
                              if (daysToRemind
                                  .any((bool isDayToRemind) => !isDayToRemind))
                                setRepeatReminder(TimePeriods.CHOOSE_DAYS);
                              break;

                            case TimePeriods.WEEKLY:
                              if (daysToRemind
                                      .where(
                                          (bool isDayToRemind) => isDayToRemind)
                                      .length >
                                  1) {
                                int dayToNotRemindIndex = daysToRemind
                                    .asMap()
                                    .keys
                                    .firstWhere((int index) =>
                                        daysToRemind[index] &&
                                        index != day.index);
                                setDaysToRemind(
                                  null,
                                  index: dayToNotRemindIndex,
                                  value: false,
                                );
                              }
                              break;

                            // case TimePeriods.CHOOSE_DAYS:
                            //   break;

                            default:
                              if (daysToRemind
                                  .every((bool isDayToRemind) => isDayToRemind))
                                setRepeatReminder(TimePeriods.DAILY);
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
