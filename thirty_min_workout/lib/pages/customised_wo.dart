// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:thirty_min_workout/pages/start_page.dart';
import '../globals/global.dart';
import '../services/workout_class.dart';

class CustomisedWorkoutPage extends StatefulWidget {
  const CustomisedWorkoutPage({super.key});

  @override
  State<CustomisedWorkoutPage> createState() => _CustomisedWorkoutPageState();
}

class _CustomisedWorkoutPageState extends State<CustomisedWorkoutPage> {
  List<Workout> editedWorkouts = [];

  @override
  void initState() {
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

  _editDuration(int index) async {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Duration\n(in Seconds)'),
          content: TextFormField(
            initialValue: editedWorkouts[index].duration.inSeconds.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                editedWorkouts[index].duration =
                    Duration(seconds: int.parse(value));
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    print("NEW DURATION : ${editedWorkouts[index].duration}");

    await saveEditedWorkoutsToPrefs();
  }

  Future<void> saveEditedWorkoutsToPrefs() async {
    final sessionsJson =
        editedWorkouts.map((session) => jsonEncode(session.toMap())).toList();
    await prefs.setStringList('editedWorkouts', sessionsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customize your workouts",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.5),
      ),
      body: Container(
        color: Colors.deepOrange.shade100,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 80),
          itemCount: editedWorkouts.length,
          itemBuilder: (context, index) {
            final workout = editedWorkouts[index];
            return workout.name != "Rest"
                ? Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(workout.animation,
                              height: 100, width: 100),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workout.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${workout.duration.inMinutes.toString().padLeft(2, '0')}:${workout.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editDuration(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => StartWorkoutPage()));
        },
        label: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Continue",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10), // Add some spacing between text and icon
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
