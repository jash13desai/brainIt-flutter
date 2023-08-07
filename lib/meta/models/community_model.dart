import 'package:flutter/foundation.dart';

class CommunityModel {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<dynamic> members;
  final List<dynamic> mods;
  CommunityModel({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.mods,
  });

  CommunityModel copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<dynamic>? members,
    List<dynamic>? mods,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'mods': mods,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: List<dynamic>.from((map['members'] as List<dynamic>)),
      mods: List<dynamic>.from((map['mods'] as List<dynamic>)),
    );
  }
  @override
  String toString() {
    return 'CommunityModel(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, mods: $mods)';
  }

  @override
  bool operator ==(covariant CommunityModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        mods.hashCode;
  }
}
