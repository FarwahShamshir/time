// lib/models/task.dart
import 'dart:convert';

class Task {
  final String title;
  final String description;
  final DateTime time;
  bool isCompleted;
  final String category;
  final List<String> repeatDays; // Days of the week for weekly reminders

  Task({
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    required this.category,
    required this.repeatDays,
  });

  String toJson() {
    return jsonEncode({
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category,
      'repeatDays': repeatDays,
    });
  }

  factory Task.fromJson(String jsonString) {
    final data = jsonDecode(jsonString);
    return Task(
      title: data['title'],
      description: data['description'],
      time: DateTime.parse(data['time']),
      isCompleted: data['isCompleted'],
      category: data['category'],
      repeatDays: List<String>.from(data['repeatDays']),
    );
  }
}
