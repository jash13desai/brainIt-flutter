// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profileAvatar;
  final String profileBanner;
  final String uid;
  final bool isGuest;
  final int karma;
  final List<dynamic> awards;
  UserModel({
    required this.name,
    required this.profileAvatar,
    required this.profileBanner,
    required this.uid,
    required this.isGuest,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? profileAvatar,
    String? profileBanner,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profileAvatar: profileAvatar ?? this.profileAvatar,
      profileBanner: profileBanner ?? this.profileBanner,
      uid: uid ?? this.uid,
      isGuest: isGuest ?? this.isGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profileAvatar,
      'profileBanner': profileBanner,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profileAvatar: map['profilePic'] as String,
      profileBanner: map['profileBanner'] as String,
      uid: map['uid'] as String,
      isGuest: map['isGuest'] as bool,
      karma: map['karma'] as int,
      awards: List<dynamic>.from((map['awards'] as List<dynamic>)),
    );
  }
  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profileAvatar, profileBanner: $profileBanner, uid: $uid, isGuest: $isGuest, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profileAvatar == profileAvatar &&
        other.profileBanner == profileBanner &&
        other.uid == uid &&
        other.isGuest == isGuest &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profileAvatar.hashCode ^
        profileBanner.hashCode ^
        uid.hashCode ^
        isGuest.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}
