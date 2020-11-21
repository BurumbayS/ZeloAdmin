import 'dart:async';
import 'dart:convert';

import 'package:ZeloBusiness/models/Order.dart';
import 'package:ZeloBusiness/models/OrderItem.dart';
import 'package:ZeloBusiness/service/Network.dart';
import 'package:ZeloBusiness/service/PushNotificationPlugin.dart';
import 'package:ZeloBusiness/service/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_manager/websocket_manager.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() => _OrdersPageState();

}

class _OrdersPageState extends State<OrdersPage> {
  WebSocketChannel channel;
  List<Order> newOrders = new List<Order>();
  List<Order> completedOrders = new List<Order>();
//  NotificationPlugin notification = new NotificationPlugin();
  PushNotificationPlugin _pushNotificationPlugin;

  Timer timer;

  final Map<int, Widget> segments = const<int, Widget>{
    0: Text('Текущие'),
    1: Text('Завершенные')
  };
  var _selectedSegmentIndex = 0;

  final GlobalKey<AnimatedListState> newOrdersListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> completedOrdersListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _pushNotificationPlugin = new PushNotificationPlugin((order) => _addNewOrder(order));

    _loadOrders();
  }

  void _loadOrders() async {
    var user = Storage.shared.getItem('user_data');
    var userJson = json.decode(user);
    var placeID = userJson['place_id'];

    String url = Network.api + '/$placeID/orders/';
    var response = await http.get(url);

    var ordersJson = json.decode(response.body).cast<Map<String, dynamic>>();

    var ordersList = new List<Order>();

    ordersJson.forEach((element) {
      var place = Order.fromJson(element);
      ordersList.add(place);
    });

    _sortOrders(ordersList);
  }

  void _sortOrders(List<Order> ordersList) {
    var newOrders = new List<Order>();
    var completedOrders = new List<Order>();

    for (var order in ordersList) {
      if (order.orderStatus == OrderStatus.NEW) {
        newOrders.add(order);
      }
      if (order.orderStatus == OrderStatus.DELIVERING) {
        completedOrders.add(order);
      }
    }

    setState(() {
      this.newOrders = newOrders;
      this.completedOrders = completedOrders;
    });
  }

  void _connectSocket() {
    var token = Storage.shared.getItem("token");
    final socket = WebsocketManager('wss://zelodostavka.me/ws/?token='+token);
    socket.connect();
    socket.onMessage((dynamic message) {
//      _addNewOrder(message);
    });
    socket.onClose((dynamic message) {
      print('disconnected');
      socket.connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Zelo',
              style: GoogleFonts.yellowtail(
                fontSize: 40,
                color: Colors.white,
              )
          ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: CupertinoSegmentedControl<int>(
              children: segments,
              padding: EdgeInsets.all(20),
              onValueChanged: (int val) {
                setState(() {
                  _selectedSegmentIndex = val;
                });
              },
              groupValue: _selectedSegmentIndex,
            ),
          ),

          Expanded(
            child: AnimatedList(
                key: (_selectedSegmentIndex == 0) ? newOrdersListKey : completedOrdersListKey,
                initialItemCount: (_selectedSegmentIndex == 0) ? newOrders.length : completedOrders.length,
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                itemBuilder: (context, i, animation) {
                  var order = (_selectedSegmentIndex == 0) ? newOrders[i] : completedOrders[i];
                  return _orderItem(context, order, animation);
                }
            ),
          ),

        ],
      )
    );
  }

  Widget _orderItem(context, Order order, animation) {
    return SlideTransition(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc) => _orderFullInfoModal(order));
        },

        child: Padding(
          padding: EdgeInsets.only(bottom: 10, right: 20),
          child: Row(
            children: <Widget>[
              Container(
                width: 10,
                height: 80,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: (order.orderStatus == OrderStatus.NEW) ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
              ),

              Expanded(
                child: Column(
                  children: <Widget>[
                    //client Name
                    Row(
                      children: <Widget>[
                        Text(
                          'Клиент: ',
                          style: GoogleFonts.openSans(fontSize: 18),
                        ),
                        Text(
                            order.clientName,
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),

                    //client order
                    Row(
                      children: <Widget>[
                        Text(
                          'Заказ: ',
                          style: GoogleFonts.openSans(fontSize: 18),
                        ),
                        Expanded (
                          child: Text(
                              order.orderItemsString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        )

                      ],
                    ),

                    //total sum
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Итого: ',
                            style: GoogleFonts.openSans(fontSize: 18),
                          ),
                          Expanded (
                            child: Text(
                                order.total().toString() + ' KZT',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          )

                        ],
                      ),
                    ),

                    Divider()
                  ],
                ),
              )
            ],
          )
        ),
      ),

      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
    );
  }

  Widget _orderFullInfoModal(Order order) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
      ),

      child: Stack(
        children: <Widget>[
          ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: order.orderItems.length + 3,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return _receiptHeader(order.clientName);
                }

                if (i == order.orderItems.length + 1) {
                  return _receiptTotal(order.total());
                }
                
                if (i == order.orderItems.length + 2) {
                  return _receiptComment(order.comment);
                }

                return _receiptItem(order.orderItems[i-1]);
              }
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),]
              ),

              child: FlatButton(
                color: (order.orderStatus == OrderStatus.NEW) ? Colors.blue[400] : Colors.green[400],
                textColor: Colors.white,
                splashColor: (order.orderStatus == OrderStatus.NEW) ? Colors.blue[700] : Colors.green[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),

                child: Text(
                    (order.orderStatus == OrderStatus.NEW) ? 'Принять' : 'Готово',
                    style: GoogleFonts.openSans(
                        fontSize: 22,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold
                    )
                ),
                onPressed: () {
                  Navigator.pop(context);
                  (order.orderStatus == OrderStatus.NEW) ? _acceptOrder(order) : _completeOrder(order);
                },
              ),
            ),
          ),

        ],
      )
    );
  }

  Widget _receiptHeader(String clientName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(
              'Заказ',
              style: GoogleFonts.openSans(
                  fontSize: 22
              ),
            ),
          ),
        ),

        Row(
          children: <Widget>[
            Text(
              'Клиент: ',
              style: GoogleFonts.openSans(fontSize: 18),
            ),
            Text(
                clientName,
                style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                )
            )
          ],
        ),

        Divider()
      ],
    );
  }

  Widget _receiptItem(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          //order item
          Container(
            constraints: BoxConstraints(minWidth: 20, maxWidth: MediaQuery.of(context).size.width * 0.65),
            child: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                  fontSize: 15
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration (
                border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[300])),
              ),
            ),
          ),

          //item count
          Text(
            item.count.toString() + 'x ',
            style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),

          //item price
          Text(
            item.totalPrice().toString() + ' KZT',
            style: GoogleFonts.openSans(
                fontSize: 15
            ),
          )
        ],
      ),
    );
  }

  Widget _receiptTotal(int total) {
    return Column (
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            children: <Widget>[
              Text(
                'ИТОГО',
                style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration (
                    border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[300])),
                  ),
                ),
              ),

              Text(
                total.toString() + ' KZT',
                style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _receiptComment(comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),

        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'Комментарий',
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        Text(
          comment,
          style: GoogleFonts.openSans(
            fontSize: 16
          ),
        )
      ],
    );
  }

  void _acceptOrder(Order order) {
    FlutterRingtonePlayer.stop();

    setState(() {
      order.orderStatus = OrderStatus.COOKING;
    });

    _updateOrderStatus(order.id, OrderStatus.COOKING);
  }

  void _completeOrder(Order order) {
    setState(() {
      order.orderStatus = OrderStatus.DELIVERING;
    });

    _updateOrderStatus(order.id, OrderStatus.DELIVERING);

    var index = newOrders.indexOf(order);
    newOrdersListKey.currentState.removeItem(
        index,
            (context, animation) => _orderItem(context, order, animation),
        duration: Duration(milliseconds: 200)
    );
    newOrders.removeAt(index);

    completedOrders.insert(0, order);
  }

  void _updateOrderStatus(id, status) async {
    var response = await http.post(
      Network.api + "/update_order/",
      headers: Network.shared.headers(),
      body: json.encode({
        "id": id,
        "status": describeEnum(status)
      }),
    );

    print(response.body);
  }

//  void _sendMessage() {
//      var message = {
//        'type': 'NEW_ORDER',
//        'order': 'Hello'
//      };
//      var json = {'message': message};
//
//      String jsonString = jsonEncode(json);
//      channel.sink.add(jsonString);
//  }

  void _addNewOrder(Order order) async {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 10.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
//      FlutterRingtonePlayer.playNotification();
//      FlutterRingtonePlayer.play(
//        android: AndroidSounds.notification,
//        ios: const IosSound(1023),
//        looping: true,
//        volume: 1.0,
//      );

//      var json = jsonDecode(snapshot);
//      var messageJson = jsonDecode(json['message']);
//      print(messageJson);
//      Order order = Order.fromJson(messageJson);
//
//      print(order.orderItems[0].name);
//
      if (_selectedSegmentIndex == 0) {

        newOrdersListKey.currentState.insertItem(0, duration: Duration(milliseconds: 200));
      }

      newOrders.insert(0, order);
  }
}

