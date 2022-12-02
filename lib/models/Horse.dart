class Horse {
  String name;
  String age;
  String sexe;
  String robe;
  String race;
  String speciality;
  String userId;
  String horseId;
  String urlImage;

  Horse({
    this.name = "",
    this.age = "",
    this.sexe = "",
    this.robe = "",
    this.race = "",
    this.speciality = "",
    this.userId = "",
    this.horseId = "",
    this.urlImage = "",
  });

  Horse.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'],
        sexe = json['sexe'],
        robe = json['robe'],
        race = json['race'],
        speciality = json['speciality'],
        userId = json['user_id'],
        urlImage = json['urlImage'],
        horseId = json['horse_id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'sexe': sexe,
    'robe': robe,
    'race': race,
    'speciality': speciality,
    'user_id': userId,
    'horse_id': horseId,
    'urlImage': urlImage,
  };
}
