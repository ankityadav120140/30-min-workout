// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirty_min_workout/globals/global.dart';
import 'package:thirty_min_workout/pages/workout_page.dart';

import '../services/workout_class.dart';

class StartWorkoutPage extends StatefulWidget {
  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  String _centerText = "Start";
  int _countdown = 4;
  List<Workout> editedWorkouts = [];

  void startCountdown() {
    if (_countdown > 1) {
      setState(() {
        _countdown--;
        _centerText = _countdown.toString();
        speak(_centerText);
      });
      Future.delayed(Duration(seconds: 1), () {
        startCountdown();
      });
    } else if (_countdown == 1) {
      setState(() {
        _centerText = "GO";
        speak(_centerText);
      });
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WorkoutPage(
                      workouts: editedWorkouts,
                    )));
      });
    }
  }

  @override
  void initState() {
    speak("Welcome!, Press start when you're ready.");
    loadEditedWorkoutsFromPrefs();
    super.initState();
  }

  void loadEditedWorkoutsFromPrefs() async {
    setState(() {
      final editedWorkoutsJson = prefs.getStringList('editedWorkouts');
      editedWorkouts = editedWorkoutsJson != null
          ? editedWorkoutsJson
              .map((json) => Workout.fromMap(jsonDecode(json)))
              .toList()
          : List.from(sampleWorkouts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Let's Start",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.5),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await speak("Jumping Jacks Starts in");
                await Future.delayed(
                    Duration(seconds: 2)); // Adjust the duration as needed
                startCountdown();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${_centerText}",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Start when you are ready",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
