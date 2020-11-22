
import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()

class User {
  int id;
  String email = '';
  String name = '';

  User(this.id, this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}