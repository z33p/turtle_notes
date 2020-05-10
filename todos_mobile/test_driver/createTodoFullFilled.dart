import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

createTodoFullFilled() {
  group("Create Todo Full Filled", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    final appBarTitle = find.byValueKey("appBarTitle");
    final floatButton = find.byType("FloatingActionButton");
    final titleField = find.byValueKey("titleField");
    final descriptionField = find.byValueKey("descriptionField");
    final isDoneField = find.byValueKey("isDoneField");
    // final reminderDateTimeField = find.byValueKey("reminderDateTimeField");

    final textSnackBar = find.byValueKey("textSnackBar");

    test("Create Todo", () async {
      await driver.tap(floatButton);
      expect(await driver.getText(appBarTitle), "Criar Tarefa");

      var textTitleField = "Basic Todo with only title";
      var textDescriptionField = "Just a little description about this todo";

      await driver.tap(titleField);
      await driver.enterText(textTitleField);

      await driver.tap(descriptionField);
      await driver.enterText(textDescriptionField);

      await driver.tap(isDoneField);

      // await driver.tap(titleField);
      // await driver.enterText(textTitleField);

      await driver.tap(floatButton);
      await driver.waitFor(textSnackBar);

      expect(await driver.getText(textSnackBar), "Tarefa criada!");
      await driver.waitForAbsent(textSnackBar);
    });
  });
}
