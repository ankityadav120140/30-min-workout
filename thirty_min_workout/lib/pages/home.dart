// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirty_min_workout/pages/customised_wo.dart';
import 'package:thirty_min_workout/pages/start_page.dart';

import '../globals/global.dart';
import '../services/daily_session.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    sessions = loadSessionsFromPrefs();
  }

  List<Session> loadSessionsFromPrefs() {
    final sessionsJson = prefs.getStringList('sessions');
    if (sessionsJson != null) {
      return sessionsJson
          .map((json) => Session.fromMap(jsonDecode(json)))
          .toList();
    }
    return [];
  }

  List<Session> testSession = [
    Session(
      DateTime.parse("2023-08-09 14:30:00"),
      Duration(minutes: 25, seconds: 28),
    ),
    Session(
      DateTime.parse("2023-08-10 15:30:00"),
      Duration(minutes: 20, seconds: 20),
    ),
    Session(
      DateTime.parse("2023-08-11 16:30:00"),
      Duration(minutes: 20, seconds: 20),
    ),
    Session(
      DateTime.parse("2023-08-12 17:00:00"),
      Duration(minutes: 21, seconds: 20),
    ),
    Session(
      DateTime.parse("2023-08-13 17:45:12"),
      Duration(minutes: 22, seconds: 04),
    ),
    Session(
      DateTime.parse("2023-08-14 17:40:00"),
      Duration(minutes: 20, seconds: 20),
    ),
    Session(
      DateTime.parse("2023-08-15 17:30:00"),
      Duration(minutes: 25, seconds: 20),
    ),
    Session(
      DateTime.parse("2023-08-16 18:00:00"),
      Duration(minutes: 20, seconds: 20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Workout Sessions",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomisedWorkoutPage(),
                      ));
                },
                icon: Icon(Icons.edit))
          ],
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.5),
      ),
      body: sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No workout session found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomisedWorkoutPage()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Edit your workout session",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.edit,
                            size: 22,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.done_outline,
                      color: Colors.green,
                    ),
                    title: Text(
                        "${session.dateTime.day}/${session.dateTime.month}/${session.dateTime.year}"),
                    subtitle: Text(
                      session.dateTime.hour > 12
                          ? "${session.dateTime.hour - 12}:${session.dateTime.minute} PM"
                          : "${session.dateTime.hour}:${session.dateTime.minute} AM",
                    ),
                    trailing: Text(
                      session.duration.inMinutes > 60
                          ? "${session.duration.inHours}".padLeft(2, '0') +
                              ":" +
                              "${session.duration.inMinutes % 60}"
                                  .padLeft(2, '0') +
                              ":" +
                              "${session.duration.inSeconds % 3600}"
                                  .padLeft(2, '0')
                          : session.duration.inSeconds > 60
                              ? "00:" +
                                  "${session.duration.inMinutes}"
                                      .padLeft(2, '0') +
                                  ":" +
                                  "${session.duration.inSeconds % 60}"
                                      .padLeft(2, '0')
                              : "00:00:" +
                                  "${session.duration.inSeconds}"
                                      .padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
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
                "Start Workout",
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
