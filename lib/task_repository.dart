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

class TaskRepository {
  static List<Task> tasks = [
    Task(title: "Iść na pociąg", deadline: "dziś", done: true, priority: "Wysoki"),
    Task(title: "Poskakać w miejscu", deadline: "Jutro", done: false, priority: "Niski"),
    Task(title: "Zadanie z wczoraj", deadline: "Do końca tygodnia", done: false, priority: "Średni"),
    Task(title: "Ugotowanie śniadania", deadline: "Do południa", done: true, priority: "Wysoki"),
  ];
}