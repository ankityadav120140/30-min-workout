// ignore_for_file: prefer_const_constructors

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirty_min_workout/services/daily_session.dart';

import '../services/workout_class.dart';

FlutterTts flutterTts = FlutterTts();

Future<void> speak(String text) async {
  await flutterTts.setLanguage('en-US'); // Set the desired language
  await flutterTts.setPitch(1.0); // Set the pitch (1.0 is the default)
  await flutterTts.speak(text);
}

late SharedPreferences prefs;
List<Session> sessions = [];
List<Workout> sampleWorkouts = [
  Workout(
    "Jumping Jacks",
    "assets/jumping_jacks.gif",
    Duration(minutes: 1),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "High Knees",
    "assets/high_knees.gif",
    Duration(minutes: 1),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Bent Over Twist",
    "assets/bent_over_twist.gif",
    Duration(minutes: 1),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(minutes: 1),
  ),
  Workout(
    "Bodyweight Squats",
    "assets/squat.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Push-Ups",
    "assets/push_up.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Lunges",
    "assets/lunges.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Leg Raises",
    "assets/leg_raises.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Plank",
    "assets/plank.jpeg",
    Duration(minutes: 1),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Bodyweight Squats",
    "assets/squat.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Push-Ups",
    "assets/push_up.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Lunges",
    "assets/lunges.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Leg Raises",
    "assets/leg_raises.gif",
    Duration(minutes: 2),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Plank",
    "assets/plank.jpeg",
    Duration(minutes: 1),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Hamstring Stretch (Left)",
    "assets/hamstring_stretch.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 10),
  ),
  Workout(
    "Hamstring Stretch (Right)",
    "assets/hamstring_stretch.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 10),
  ),
  Workout(
    "Quad Stretch (Left)",
    "assets/quad_stretch_left.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 10),
  ),
  Workout(
    "Quad Stretch (Right)",
    "assets/quad_stretch_right.gif",
    Duration(seconds: 30),
  ),
  Workout(
    "Rest",
    "assets/rest.gif",
    Duration(seconds: 10),
  ),
  Workout(
    "Chest Stretch",
    "assets/chest_stretch.jpg",
    Duration(seconds: 30),
  ),
];
