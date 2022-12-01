class Party{
  String ownerId;
  String ownerComment;
  String type;
  DateTime eventDate;
  List<String>participants;

  Party(this.ownerId, this.ownerComment, this.type, this.eventDate, this.participants);

  Party.fromJson(Map<String, dynamic> json)
      : ownerId = json['owner'],
        ownerComment = json['ownerComment'],
        type = json['type'],
        eventDate = json['eventDate'],
        participants = json['participants'];

  Map<String, dynamic> toJson() => {
    'owner': ownerId,
    'ownerComment': ownerComment,
    'type': type,
    'eventDate': eventDate,
    'participants': participants,
  };

}