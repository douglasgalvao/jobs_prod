import 'package:flutter/cupertino.dart';

@immutable
class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const UserData({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoUrl'],
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };
}