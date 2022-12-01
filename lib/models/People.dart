class People {
  String uid;
  String pseudo;
  String password;
  String email;
  String phone;
  String age;
  String linkFFEProfil;
  String type;

  People({
    this.uid = "",
    this.pseudo = "",
    this.password = "",
    this.email = "",
    this.phone = "",
    this.age = "",
    this.linkFFEProfil = "",
    this.type = "Demi pensionnaire",
  });

  People.fromJson(Map<String, dynamic> json)
      : pseudo = json['pseudo'],
        uid = json['firebase_id'],
        password = json['password'],
        email = json['email'],
        phone = json['phone'],
        age = json['age'],
        linkFFEProfil = json['linkFFEProfil'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'pseudo': pseudo,
        'password': password,
        'firebase_id': uid,
        'email': email,
        'phone': phone,
        'age': age,
        'linkFFEProfil': linkFFEProfil,
        'type': type,
      };
}
