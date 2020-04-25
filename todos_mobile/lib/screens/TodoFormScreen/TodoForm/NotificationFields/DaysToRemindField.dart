import 'package:flutter/material.dart';

final sunday = "Sunday";
final monday = "Monday";
final tuesday = "Tuesday";
final wednesday = "Wednesday";
final thursday = "Thursday";
final friday = "Friday";
final saturday = "Saturday";

final isToAlert = "isToAlert";
final label = "label";
final labelIndex = "labelIndex";

class DaysToRemindField extends StatefulWidget {
  final List<bool> daysToRemind;
  final void Function(int index, bool value) setDaysToRemind;
  final void Function(bool isReadingTodo, {bool isUpdatingTodo})
      setIsReadingTodoState;

  DaysToRemindField(
      this.daysToRemind, this.setDaysToRemind, this.setIsReadingTodoState);

  @override
  _DaysToRemindFieldState createState() => _DaysToRemindFieldState();
}

class _DaysToRemindFieldState extends State<DaysToRemindField> {
  Map<String, Map<String, dynamic>> week;

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    week = {
      sunday: {
        label: "Do",
        labelIndex: 0,
      },
      monday: {
        label: "Se",
        labelIndex: 1,
      },
      tuesday: {
        label: "Te",
        labelIndex: 2,
      },
      wednesday: {
        label: "Qu",
        labelIndex: 3,
      },
      thursday: {
        label: "Qi",
        labelIndex: 4,
      },
      friday: {
        label: "Se",
        labelIndex: 5,
      },
      saturday: {
        label: "Sá",
        labelIndex: 6,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Repetir"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: week.entries
                .map((day) => GestureDetector(
                      onTap: () {
                        widget.setIsReadingTodoState(false,
                            isUpdatingTodo: false);
                        widget.setDaysToRemind(day.value[labelIndex],
                            !widget.daysToRemind[day.value[labelIndex]]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: widget.daysToRemind[day.value[labelIndex]]
                                ? Colors.teal
                                : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(360)),
                            border: Border.all(color: Colors.blue, width: 1.0)),
                        child: Text(
                          day.value[label],
                          style: TextStyle(
                              color: widget.daysToRemind[day.value[labelIndex]]
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
