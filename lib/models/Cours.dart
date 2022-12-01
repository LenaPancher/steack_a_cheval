class Cours {
  String terrain;
  DateTime trainingDate;
  int duration;
  String discipline;
  String owner;

  Cours(this.duration, this.trainingDate, this.terrain, this.discipline, this.owner);

  Cours.fromJson(Map<String, dynamic> json)
      : terrain = json['terrain'],
        trainingDate = json['trainingDate'],
        duration = json['duration'],
        discipline = json['discipline'],
        owner = json['owner'];


  Map<String, dynamic> toJson() => {
        'terrain': terrain,
        'trainingDate': trainingDate,
        'duration': duration,
        'discipline': discipline,
        'owner': owner
      };
}
