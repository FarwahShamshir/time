import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CompletedTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.completedTasks;
          return tasks.isEmpty
              ? Center(
            child: Text(
              'No completed tasks yet!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 30, // Icon to indicate task completion
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough, // Strike-through to indicate completion
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check, // Checkmark to symbolize completion
                          color: Colors.green,
                          size: 25,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete, // Delete icon
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Task'),
                                content: Text(
                                    'Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      provider.deleteTask(task); // Delete the task
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
