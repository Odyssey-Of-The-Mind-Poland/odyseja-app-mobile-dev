import 'package:hive/hive.dart';

part 'performance.g.dart';

@HiveType(typeId: 0)
class Performance extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String city;
  @HiveField(2)
  final String team;
  @HiveField(3)
  final String problem;
  @HiveField(4)
  final String age;
  @HiveField(5)
  final String play;
  @HiveField(6)
  final String spontan;
  @HiveField(7)
  final String stage;
  @HiveField(8)
  bool faved;

  Performance({this.faved, this.id, this.city, this.team,
    this.problem, this.age, this.play, this.spontan, this.stage});

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['id'],
      city: json['city'],
      team: json['team'],
      //  TODO json['problem']== "d" ? "J"
      problem: json['problem'] == "d" ? "J" : json['problem'],
      age: json['age'],
      //  TODO json['performance'].length < 5 ?! 
      play: (json['performance'].length < 5)
      ? "0" + json['performance']
      : json['performance'],
      spontan: json['spontan'],
      stage: json['stage'],
      faved: false,
    );
  }
}
