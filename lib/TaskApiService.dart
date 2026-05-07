import 'dart:convert';
import 'package:http/http.dart' as http;

class Task {
  final String title;
  final String deadline;
  bool done;
  final String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];

      return todos.map<Task>((todo) {
        return Task(
          title: todo["todo"],
          deadline: "brak",
          done: todo["completed"],
          priority: "średni",
        );
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}

