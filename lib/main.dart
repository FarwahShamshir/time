import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time/services/notification_service.dart';
import 'package:time/splash_screen.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/taskList': (context) => TaskListScreen(),
        },
      ),
    );
  }
}
