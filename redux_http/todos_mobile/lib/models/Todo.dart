class Todo {
  int id;
  String title;
  String description;
  bool isDone;

  Todo({this.id, this.title, this.description, this.isDone});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['is_done'],
    );
  }
}
