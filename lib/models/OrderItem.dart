
import 'package:json_annotation/json_annotation.dart';
import 'MenuItem.dart';

part 'OrderItem.g.dart';

@JsonSerializable()

class OrderItem {
  int id;
  String name;
  int price;
  int count;

  OrderItem(this.id, this.name, this.price, this.count);

  static OrderItem fromMenuItem(MenuItem item) {
    OrderItem orderItem = new OrderItem(
        item.id, item.name, item.price, 1
    );

    return orderItem;
  }

  int totalPrice() {
    return count * price;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

}