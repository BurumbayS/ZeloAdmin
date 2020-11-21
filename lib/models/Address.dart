import 'package:json_annotation/json_annotation.dart';

part 'Address.g.dart';

@JsonSerializable()

class Address {
  double latitude;
  double longitude;
  String firstAddress;
  String secondAddress;
  int distance;

  Address() {
    latitude = 45.015201348779435;
    longitude = 78.3691672004501;
    firstAddress = '';
    secondAddress = '';
  }

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

}