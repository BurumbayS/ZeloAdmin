import 'package:json_annotation/json_annotation.dart';

part 'Place.g.dart';

@JsonSerializable()

class Place {
  int id;
  String name;
  String description;
  String address;
  double latitude;
  double longitude;
  @JsonKey(name: 'delivery_min_price')
  final int deliveryMinPrice;
  Map<String, String> categories;
  String wallpaper;

  Place(this.id, this.name, this.description, this.address, this.longitude, this.latitude, this.deliveryMinPrice, this.wallpaper);

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}