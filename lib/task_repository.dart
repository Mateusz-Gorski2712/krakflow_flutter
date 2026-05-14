class Task {
  final int id;
  final String title;
  final String deadline;
  final String priority;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    this.done = false,
  });

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      deadline: map['deadline'],
      priority: map['priority'],
      done: map['done'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "priority": priority,
      "done": done,
    };
  }
}

class TaskRepository {
  static List<Task> tasks = [
    Task(id: 1,title: "Iść na pociąg", deadline: "dziś", done: true, priority: "Wysoki"),
    Task(id: 2,title: "Poskakać w miejscu", deadline: "Jutro", done: false, priority: "Niski"),
    Task(id: 3,title: "Zadanie z wczoraj", deadline: "Do końca tygodnia", done: false, priority: "Średni"),
    Task(id: 4,title: "Ugotowanie śniadania", deadline: "Do południa", done: true, priority: "Wysoki"),
  ];
}