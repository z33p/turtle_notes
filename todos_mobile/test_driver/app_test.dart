import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'createTodoWithOnlyTitle.dart';

void main() {
  group("Create Todo", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Check Helth", () async {
      expect((await driver.checkHealth()).status, HealthStatus.ok);
    });
  });

  createTodoWithOnlyTitle();
}
