class Session {
  DateTime dateTime;
  Duration duration;

  Session(
    this.dateTime,
    this.duration,
  );

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      DateTime.parse(map['dateTime'] as String),
      Duration(seconds: map['duration'] as int),
    );
  }
}
