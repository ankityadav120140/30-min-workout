import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirty_min_workout/services/workout_class.dart';

import '../globals/global.dart';

class WorkoutTile extends StatefulWidget {
  final Workout workout;

  WorkoutTile(this.workout);

  @override
  _WorkoutTileState createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  List<Workout> editedWorkouts = [];
  Duration editedDuration = Duration();

  @override
  void initState() {
    super.initState();
    editedDuration = widget.workout.duration;
  }

  Future<void> _editDuration() async {
    // Show a dialog to edit the duration
    final newDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Duration'),
          content: TextFormField(
            initialValue: editedDuration.inSeconds.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                editedDuration = Duration(seconds: int.parse(value));
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
                Navigator.of(context).pop(editedDuration);
              },
            ),
          ],
        );
      },
    );

    if (newDuration != null) {
      setState(() {
        widget.workout.duration = newDuration;
        // Update the editedWorkouts list with the changes
        final workoutIndex = editedWorkouts.indexOf(widget.workout);
        editedWorkouts[workoutIndex] = widget.workout;
      });

      // Save the updated workouts to shared preferences
      await saveEditedWorkoutsToPrefs();
    }
  }

  Future<void> saveEditedWorkoutsToPrefs() async {
    final editedWorkoutsJson =
        editedWorkouts.map((workout) => jsonEncode(workout.toMap())).toList();
    await prefs.setStringList('editedWorkouts', editedWorkoutsJson);
  }

  @override
  Widget build(BuildContext context) {
    return widget.workout.name != "Rest"
        ? Card(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(widget.workout.animation,
                      height: 100, width: 100),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.workout.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.workout.duration.inMinutes.toString().padLeft(2, '0')}:${widget.workout.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _editDuration,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
