class Workout {
  String name;
  String animation;
  Duration duration;

  Workout(this.name, this.animation, this.duration);

  void updateDuration(Duration newDuration) {
    duration = newDuration;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'animation': animation,
      'duration': duration.inSeconds,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      map['name'] as String,
      map['animation'] as String,
      Duration(seconds: map['duration'] as int),
    );
  }
}
