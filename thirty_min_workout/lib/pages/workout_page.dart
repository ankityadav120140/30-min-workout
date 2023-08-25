// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirty_min_workout/globals/global.dart';
import 'package:thirty_min_workout/services/workout_class.dart';

import '../services/daily_session.dart';
import 'workout_completed_page.dart';

class WorkoutPage extends StatefulWidget {
  final List<Workout> workouts;

  WorkoutPage({required this.workouts});

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int _currentWorkoutIndex = 0;
  int _countdown = 0;
  int _totalSeconds = 0;

  void _restartWorkout() {
    setState(() {
      _countdown = widget.workouts[_currentWorkoutIndex].duration.inSeconds;
    });
  }

  void _add10Seconds() {
    setState(() {
      _countdown += 10;
    });
  }

  void _reduce10Seconds() {
    setState(() {
      if (_countdown >= 10) {
        _countdown -= 10;
      } else {
        _countdown = 0;
      }
    });
  }

  void _skipWorkout() {
    setState(() {
      _countdown = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    speak("Jumping jacks for ${widget.workouts[0].duration.inSeconds} seconds");
    startCountdown();
  }

  void startCountdown() {
    setState(() {
      _countdown = widget.workouts[_currentWorkoutIndex].duration.inSeconds;
      _startTimer();
    });
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
          if (_countdown < 4) {
            speak(_countdown.toString());
          }
          if (widget.workouts[_currentWorkoutIndex].name == "Rest" &&
              _countdown == 6) {
            speak(
                "${widget.workouts[_currentWorkoutIndex + 1].name} starts in");
          }
          if (widget.workouts[_currentWorkoutIndex].name != "Rest") {
            _totalSeconds++;
          }
          _startTimer();
        } else {
          _startNextWorkout();
        }
      });
    });
  }

  void _startNextWorkout() {
    if (_currentWorkoutIndex + 1 >= widget.workouts.length) {
      final newSession = Session(
        DateTime.now(),
        Duration(seconds: _totalSeconds),
      );

      sessions.add(newSession);
      saveSessionsToPrefs();
    }
    setState(() async {
      if (_currentWorkoutIndex + 1 >= widget.workouts.length) {
        speak("Well Done");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutCompletedPage(),
          ),
        );
      } else {
        _currentWorkoutIndex =
            (_currentWorkoutIndex + 1) % widget.workouts.length;
        speak(
            "${widget.workouts[_currentWorkoutIndex].name} for ${widget.workouts[_currentWorkoutIndex].duration.inMinutes > 0 ? widget.workouts[_currentWorkoutIndex].duration.inMinutes : ""} ${widget.workouts[_currentWorkoutIndex].duration.inMinutes > 0 ? "minutes" : ""}${widget.workouts[_currentWorkoutIndex].duration.inSeconds.remainder(60) > 0 ? widget.workouts[_currentWorkoutIndex].duration.inSeconds.remainder(60) : ""} ${widget.workouts[_currentWorkoutIndex].duration.inSeconds.remainder(60) > 0 ? "seconds" : ""}");
        await Future.delayed(Duration(seconds: 2));
        if (widget.workouts[_currentWorkoutIndex].name == "Rest") {
          speak(
              "Next exercise, ${widget.workouts[_currentWorkoutIndex + 1].name}");
        }
        startCountdown();
      }
    });
  }

  Future<void> saveSessionsToPrefs() async {
    final sessionsJson =
        sessions.map((session) => jsonEncode(session.toMap())).toList();
    await prefs.setStringList('sessions', sessionsJson);
  }

  @override
  Widget build(BuildContext context) {
    final currentWorkout = widget.workouts[_currentWorkoutIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Workout Session",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              "${_currentWorkoutIndex + 1}/${widget.workouts.length}",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.5),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(currentWorkout.animation),
              Text(
                currentWorkout.name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _countdown > 0
                    ? _countdown > 60
                        ? "${_countdown ~/ 60}".padLeft(2, '0') +
                            ":" +
                            "${_countdown % 60}".padLeft(2, '0')
                        : "00:" + "${_countdown}".padLeft(2, '0')
                    : "Go!",
                style: TextStyle(fontSize: 30),
              ),
              currentWorkout.name == "Rest"
                  ? Container(
                      child: Text(
                        "Next Workout : ${widget.workouts[_currentWorkoutIndex + 1].name}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _restartWorkout,
                child: Text(
                  "Restart",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _add10Seconds,
                      child: Text(
                        "+10",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _reduce10Seconds,
                      child: Text(
                        "-10",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _skipWorkout,
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
