import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller and tween for moving text back and forth
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween<double>(begin: -50, end: 50).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _animationController!.repeat(reverse: true);

    // Delay for 4 seconds before navigating to TaskListScreen
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/taskList'); // Navigate to TaskListScreen
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clock Icon
            Icon(
              Icons.access_time, // Clock Icon
              size: 100.0,
              color: Colors.blue, // Icon color
            ),
            SizedBox(height: 20), // Space between icon and text

            // Animated Text for "Real Time Application"
            AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation!.value, 0), // Horizontal movement
                  child: Text(
                    'Real Time Application',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
