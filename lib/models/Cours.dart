class Cours {
  String terrain;
  DateTime trainingDate;
  int duration;
  String discipline;
  String owner;

  Cours(this.duration, this.trainingDate, this.terrain, this.discipline, this.owner);

  Cours.fromJson(Map<String, dynamic> json)
      : terrain = json['terrain'],
        trainingDate = DateTime.parse(json['trainingDate'].toDate().toString()),
        duration = json['duration'],
        discipline = json['discipline'],
        owner = json['firebase_id'];


  Map<String, dynamic> toJson() => {
        'terrain': terrain,
        'trainingDate': trainingDate,
        'duration': duration,
        'discipline': discipline,
        'firebase_id': owner
      };
}
