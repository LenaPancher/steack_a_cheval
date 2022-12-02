class Concours {
  String name;
  String author;
  String adress;
  DateTime date;
  List<dynamic> listPeople;
  String userId;
  String firebaseId;

  Concours({
    this.name = "",
    this.author = "",
    this.adress = "",
    required this.date,
    this.userId = "",
    this.listPeople = const <String>[],
    this.firebaseId = "",
  });

  Concours.fromJson(Map<String, dynamic> json):
      name = json['name'],
      adress = json['adresse'],
      author = json['author'],
      date = DateTime.parse(json['date'].toDate().toString()),
      listPeople = json['listParticipant'],
      userId = json['id_user'],
      firebaseId = json['firebase_id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'adresse': adress,
    'author': author,
    'date': date,
    'listParticipant': listPeople,
    'id_user': userId,
    'firebase_id': firebaseId
  };


}

