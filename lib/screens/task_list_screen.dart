import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'completed_task_screen.dart';
import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.incompleteTasks;
          return tasks.isEmpty
              ? Center(child: Text("No tasks available"))
              : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Title Row
                        Row(
                          children: [
                            Icon(Icons.title, color: Colors.blue, size: 24),
                            SizedBox(width: 10),
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Task Description Row
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.green, size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Date Row
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.purple, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Date: ${task.time.year}-${task.time.month}-${task.time.day}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Time Row
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.orange, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Time: ${task.time.hour}:${task.time.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),

                        // Complete Task Button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                            onPressed: () {
                              provider.completeTask(task);
                            },
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }
}


  void _addTask(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay? selectedTime;
    DateTime? selectedDate; // To hold selected time
    final List<String> selectedDays = [];
    String selectedAlertMode = 'Ring'; // Default Alert Mode
    String selectedRingtone = 'Default ringtone'; // Default ringtone
    String snoozeTime = '5 minutes'; // Default snooze time

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? 'Pick Date'
                          : 'Selected Date: ${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                    ),
                  ),

                  // Time Picker (Customized)
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text(
                      selectedTime == null
                          ? 'Pick Time'
                          : 'Selected Time: ${selectedTime!.format(context)}',
                    ),
                  ),

                  // Repeat Days (Weekly)
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map((day) {
                      return FilterChip(
                        label: Text(day),
                        selected: selectedDays.contains(day),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  // Alert Mode Selection
                  ListTile(
                    title: Text('Alert Mode'),
                    subtitle: Text(selectedAlertMode),
                    onTap: () async {
                      List<String> alertModes = ['Ring', 'Vibrate', 'Silent'];
                      String? chosenAlert = await showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Select Alert Mode'),
                          children: alertModes
                              .map((mode) => SimpleDialogOption(
                            child: Text(mode),
                            onPressed: () {
                              Navigator.pop(context, mode);
                            },
                          ))
                              .toList(),
                        ),
                      );
                      if (chosenAlert != null) {
                        setState(() {
                          selectedAlertMode = chosenAlert;
                        });
                      }
                    },
                  ),

                  // Ringtone Selection
                  ListTile(
                    title: Text('Ringtone'),
                    subtitle: Text(selectedRingtone),
                    onTap: () async {
                      List<String> ringtones = [
                        'Default ringtone',
                        'Ringtone 1',
                        'Ringtone 2'
                      ];
                      String? chosenRingtone = await showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Select Ringtone'),
                          children: ringtones
                              .map((ringtone) => SimpleDialogOption(
                            child: Text(ringtone),
                            onPressed: () {
                              Navigator.pop(context, ringtone);
                            },
                          ))
                              .toList(),
                        ),
                      );
                      if (chosenRingtone != null) {
                        setState(() {
                          selectedRingtone = chosenRingtone;
                        });
                      }
                    },
                  ),

                  // Snooze Time Selection
                  ListTile(
                    title: Text('Snooze Time'),
                    subtitle: Text(snoozeTime),
                    onTap: () async {
                      List<String> snoozeTimes = ['5 minutes', '10 minutes', '15 minutes'];
                      String? chosenSnooze = await showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Select Snooze Time'),
                          children: snoozeTimes
                              .map((snooze) => SimpleDialogOption(
                            child: Text(snooze),
                            onPressed: () {
                              Navigator.pop(context, snooze);
                            },
                          ))
                              .toList(),
                        ),
                      );
                      if (chosenSnooze != null) {
                        setState(() {
                          snoozeTime = chosenSnooze;
                        });
                      }
                    },
                  ),

                  // Task Title and Description
                  TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
                  TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),

                  // Buttons for adding tasks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // "Add Another Task" Button
                      ElevatedButton(
                        onPressed: () {
                          if (selectedTime != null) {
                            final taskTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );

                            Provider.of<TaskProvider>(context, listen: false).addTask(
                              Task(
                                title: titleController.text,
                                description: descriptionController.text,
                                time: taskTime,
                                category: selectedAlertMode, // Assuming this is the category
                                repeatDays: selectedDays, // Days for repeating task
                              ),
                              selectedAlertMode, // Pass the alert mode as the second argument
                            );

                            // Clear fields for adding another task
                            titleController.clear();
                            descriptionController.clear();
                            selectedTime = null;
                            selectedDays.clear();
                            setState(() {});
                          }
                        },
                        child: Text('Add Another Task'),
                      ),

                      // "Finish" Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog when done
                        },
                        child: Text('Finish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


