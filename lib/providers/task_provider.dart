// lib/providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  TaskProvider() {
    loadTasks();
  }

  void addTask(Task task, String alertMode) {  // Add alertMode parameter
    _tasks.add(task);
    NotificationService.scheduleNotification(task, alertMode); // Pass both task and alertMode
    saveTasks();
    notifyListeners();
  }

  void completeTask(Task task) {
    task.isCompleted = true;
    NotificationService.cancelNotification(task);
    saveTasks();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskJsonList = _tasks.map((task) => task.toJson()).toList();
    await prefs.setStringList('tasks', taskJsonList);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskJsonList = prefs.getStringList('tasks');
    if (taskJsonList != null) {
      _tasks = taskJsonList.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }
  void deleteTask(Task task) {
    _tasks.remove(task);
    saveTasks();
    notifyListeners();
  }

}
