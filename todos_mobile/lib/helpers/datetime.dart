String swapDayFieldAndYearField(String datetime) {
  List<String> dateTimeSplited = datetime.split("-");
  String dayOrYear = dateTimeSplited[0];
  String month = dateTimeSplited[1];

  List<String> yearTimeSplited = dateTimeSplited[2].split(" ");

  String yearOrday = yearTimeSplited[0];
  String time = yearTimeSplited[1];

  return "$yearOrday-$month-$dayOrYear $time";
}
