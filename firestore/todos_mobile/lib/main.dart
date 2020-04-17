import 'package:flutter/material.dart';

import 'screens/MainScreen/MainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(title: "Todo App"),
    );
  }
}
