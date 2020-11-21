// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) {
  return MenuItem(
    json['id'] as int,
    json['name'] as String,
    json['description'] as String,
    json['price'] as int,
    json['place_id'] as int,
    json['image'] as String,
  );
}

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'place_id': instance.placeID,
      'image': instance.image,
    };
