import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_mobile/models/Todo.dart';
import 'package:todos_mobile/screens/TodoFormScreen/TodoFormScreen.dart';

import 'TodoListItem.dart';

class MainScreen extends StatelessWidget {
  final String title;

  MainScreen({this.title = "Main Screen"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoFormScreen()),
          );
        }),
        tooltip: "Criar Todo",
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("todos").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");

            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => TodoListItem(
                context,
                Todo.fromDocSnapshot(snapshot.data.documents[index]),
              ),
            );
          }),
    );
  }
}
