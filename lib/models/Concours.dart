class Concours {
  String name;
  String author;
  String adress;
  String date;
  List<String> listPeople;
  String userId;

  Concours({
    this.name = "",
    this.author = "",
    this.adress = "",
    this.date = "",
    this.userId = "",
    this.listPeople = const <String>[],
  });

  Concours.fromJson(Map<String, dynamic> json):
      name = json['name'],
      author = json['author'],
      adress = json['adress'],
      date = json['date'],
      listPeople = json['listJson'],
      userId = json['user_Id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'author': author,
    'adress': adress,
    'date': date,
    'listPeople': listPeople,
    'user_id': userId,
  };


}