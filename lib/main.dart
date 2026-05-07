import 'package:flutter/material.dart';
import 'TaskApiService.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "wszystkie";

  late Future<List<Task>> _tasksFuture;

  List<Task>? _tasks;

  @override
  void initState() {
    super.initState();
    _tasksFuture = TaskApiService.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KrakFlow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (_tasks == null) return;
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: const Text("Potwierdzenie"),
                      content: const Text(
                          "Czy na pewno chcesz usunac wszystkie zadania?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context),
                            child: const Text("Anuluj")),
                        TextButton(
                          onPressed: () {
                            setState(() => _tasks!.clear());
                            Navigator.pop(context);
                          },
                          child: const Text("Usun"),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _tasks == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          }

          _tasks ??= snapshot.data;

          int doneCount = _tasks
              ?.where((t) => t.done)
              .length ?? 0;
          List<Task> filteredTasks = _tasks ?? [];

          if (selectedFilter == "wykonane") {
            filteredTasks = filteredTasks.where((task) => task.done).toList();
          } else if (selectedFilter == "do zrobienia") {
            filteredTasks = filteredTasks.where((task) => !task.done).toList();
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masz dziś ${_tasks?.length ??
                      0} zadania (Wykonane: $doneCount)",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => selectedFilter = "wszystkie"),
                      child: Text(
                          "Wszystkie", style: TextStyle(color: selectedFilter ==
                          "wszystkie" ? Colors.blue : Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => selectedFilter = "do zrobienia"),
                      child: Text("Do zrobienia",
                          style: TextStyle(color: selectedFilter ==
                              "do zrobienia" ? Colors.blue : Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => selectedFilter = "wykonane"),
                      child: Text(
                          "Wykonane", style: TextStyle(color: selectedFilter ==
                          "wykonane" ? Colors.blue : Colors.grey)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Dzisiejsze zadania", style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                        key: ObjectKey(task),
                        onDismissed: (_) {
                          setState(() => _tasks?.remove(task));
                        },
                        child: TaskCard(
                          title: task.title,
                          subtitle: "Termin: ${task
                              .deadline} | Priorytet: ${task.priority}",
                          done: task.done,
                          onChanged: (value) =>
                              setState(() => task.done = value!),
                          onTap: () async {
                            final Task? updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  EditTaskScreen(task: task)),
                            );
                            if (updatedTask != null) {
                              setState(() {
                                int realIndex = _tasks!.indexOf(task);
                                _tasks![realIndex] = updatedTask;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() => _tasks?.add(newTask));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final Task task;
  final TextEditingController titleController;
  final TextEditingController deadlineController;
  final TextEditingController priorityController;

  EditTaskScreen({super.key, required this.task})
      : titleController = TextEditingController(text: task.title),
        deadlineController = TextEditingController(text: task.deadline),
        priorityController = TextEditingController(text: task.priority);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj zadanie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priorityController,
              decoration: const InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updatedTask = Task(
                    title: titleController.text,
                    deadline: deadlineController.text,
                    priority: priorityController.text,
                    done: task.done,
                  );
                  Navigator.pop(context, updatedTask);
                },
                child: const Text("Zapisz zmiany"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nowe zadanie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priorityController,
              decoration: const InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newTask = Task(
                    title: titleController.text,
                    deadline: deadlineController.text,
                    priority: priorityController.text,
                    done: false,
                  );

                  Navigator.pop(context, newTask);
                },
                child: const Text("Zapisz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.title, required this.subtitle, required this.done, this.onChanged, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: done,
          onChanged: onChanged,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
            color: done ? Colors.grey : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}