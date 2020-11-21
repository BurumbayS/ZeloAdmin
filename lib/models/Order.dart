
import 'package:json_annotation/json_annotation.dart';
import 'Address.dart';
import 'OrderItem.dart';

part 'Order.g.dart';

enum OrderStatus {
  NEW,
  COOKING,
  DELIVERING,
  COMPLETED
}

@JsonSerializable()

class Order {
  int id;
  @JsonKey(name: 'place_id')
  int placeID;
  @JsonKey(name: 'status')
  OrderStatus orderStatus;
  @JsonKey(name: 'order_items')
  List<OrderItem> orderItems;
  @JsonKey(name: 'delivery_price')
  int deliveryPrice;
  @JsonKey(name: 'client_id')
  int clientID;
  @JsonKey(name: 'client_name')
  String clientName;
  int price;
  @JsonKey(name: 'delivery_address')
  Address deliveryAddress;
  @JsonKey(name: 'contact_phone')
  String contactPhone;
  String comment;

  Order() {
    orderStatus = OrderStatus.NEW;
    orderItems = new List();
    deliveryAddress = new Address();
    deliveryPrice = 0;
    contactPhone = '';
    comment = '';
  }

  String orderItemsString() {
    String itemsString = "";
    for (var i = 0; i < orderItems.length; i++) {
      itemsString += orderItems[i].name;
      if (i != orderItems.length - 1) { itemsString += ", "; }
    }

    return itemsString;
  }

  int total() {
    int total = 0;

    for (var i = 0; i < orderItems.length; i++) {
      total += orderItems[i].price * orderItems[i].count;
    }

    return total;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}