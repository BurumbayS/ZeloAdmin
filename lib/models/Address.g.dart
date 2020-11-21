// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..firstAddress = json['firstAddress'] as String
    ..secondAddress = json['secondAddress'] as String
    ..distance = json['distance'] as int;
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'firstAddress': instance.firstAddress,
      'secondAddress': instance.secondAddress,
      'distance': instance.distance,
    };
