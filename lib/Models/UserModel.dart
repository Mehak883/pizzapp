// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  String? uid;
  String? email;
  Usermodel({
    this.uid,
    this.email,
  });

  Usermodel copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return Usermodel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
    };
  }

  factory Usermodel.fromDocument(DocumentSnapshot doc) {
    return Usermodel(
      uid: doc.id,
      email: doc['email'] != null ? doc['email'] as String : null,
    );
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Usermodel(uid: $uid, email: $email)';

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
