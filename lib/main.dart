import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  List<Task> tasks = [
    Task(title: "Isc na pociag", deadline: "dzis"),
    Task(title: "Poskakac w miejscu", deadline: "Jutro"),
    Task(title: "Zadanie z wczoraj", deadline: "Do konca tygodnia"),
    Task(title: "Ugotowanie sniadania", deadline: "Do poludnia")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("KrakFlow"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masz dziś ${tasks.length} zadania",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Dzisiejsze zadania",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      title: tasks[index].title,
                      subtitle: "Termin: ${tasks[index].deadline}",
                      icon: Icons.eighteen_mp,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;

  Task({required this.title, required this.deadline});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon; // optional

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon, // optional
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(subtitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}