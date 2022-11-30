class People {
  String uid;
  String pseudo;
  String password;
  String email;

  People({
    this.uid = "",
    this.pseudo = "",
    this.password = "",
    this.email = "",
  });

  People.fromJson(Map<String, dynamic> json)
      : pseudo = json['pseudo'],
        uid = json['firebase_id'],
        password = json['password'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'pseudo': pseudo,
        'password': password,
        'firebase_id': uid,
        'email': email,
      };
}
