// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order()
    ..id = json['id'] as int
    ..placeID = json['place_id'] as int
    ..orderStatus = _$enumDecodeNullable(_$OrderStatusEnumMap, json['status'])
    ..orderItems = (json['order_items'] as List)
        ?.map((e) =>
            e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..deliveryPrice = json['delivery_price'] as int
    ..clientID = json['client_id'] as int
    ..clientName = json['client_name'] as String
    ..price = json['price'] as int
    ..deliveryAddress = json['delivery_address'] == null
        ? null
        : Address.fromJson(json['delivery_address'] as Map<String, dynamic>)
    ..contactPhone = json['contact_phone'] as String
    ..comment = json['comment'] as String;
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'place_id': instance.placeID,
      'status': _$OrderStatusEnumMap[instance.orderStatus],
      'order_items': instance.orderItems,
      'delivery_price': instance.deliveryPrice,
      'client_id': instance.clientID,
      'client_name': instance.clientName,
      'price': instance.price,
      'delivery_address': instance.deliveryAddress,
      'contact_phone': instance.contactPhone,
      'comment': instance.comment,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$OrderStatusEnumMap = {
  OrderStatus.NEW: 'NEW',
  OrderStatus.COOKING: 'COOKING',
  OrderStatus.DELIVERING: 'DELIVERING',
  OrderStatus.COMPLETED: 'COMPLETED',
};
