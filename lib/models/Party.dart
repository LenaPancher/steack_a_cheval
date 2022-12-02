import 'package:cloud_firestore/cloud_firestore.dart';

class Party{
  String uid;
  String ownerId;
  String ownerComment;
  String type;
  DateTime eventDate;
  List<dynamic>participants;
  DateTime createdAt;

  Party(this.uid, this.ownerId, this.ownerComment, this.type, this.eventDate, this.participants, this.createdAt);

  Party.fromJson(Map<String, dynamic> json, String uid)
      : ownerId = json['owner'],
        uid = uid,
        ownerComment = json['ownerComment'],
        type = json['type'],
        eventDate = (json['eventDate'] as Timestamp).toDate(),
        participants = json['participants'],
        createdAt = (json['createdAt'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
    'owner': ownerId,
    'ownerComment': ownerComment,
    'type': type,
    'eventDate': eventDate,
    'participants': participants,
    'createdAt': createdAt,
  };

}