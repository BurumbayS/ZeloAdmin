import 'package:ZeloBusiness/models/Order.dart';
import 'package:ZeloBusiness/models/OrderItem.dart';
import 'package:ZeloBusiness/models/Place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SectionType {
  placeInfo,
  deliveryInfo,
  contactInfo,
  total
}

class OrderDetailsPage extends StatefulWidget {

  final Order order;

  const OrderDetailsPage({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();

}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Детали заказа'),
        ),
        body: ListView.builder(
            itemCount: widget.order.orderItems.length + 4,
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _placeInfo(widget.order.place);
              }
              if (i == 1) {
                return _deliveryInfo();
              }
              if (i == 2) {
                return _contactsInfo();
              }

              if (i == widget.order.orderItems.length + 3) {
                return _total();
              }

              return _orderItem(widget.order.orderItems[i - 3]);
            }
        )
    );
  }

  Widget _placeInfo(Place place) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Откуда',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.grey
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            place.name,
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            place.address,
            style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey
            ),
          ),
        ),

        Divider(
          color: Colors.grey,
        )

      ],
    );
  }

  Widget _deliveryInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Куда',
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),

          SelectableText(
            widget.order.deliveryAddress.firstAddress,
            style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
          ),

          Text(
            widget.order.deliveryAddress.secondAddress,
            style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Доставка: ',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey
                ),
              ),

              Text(
                widget.order.deliveryPrice.toString() + 'KZT',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),

          Divider(
            color: Colors.grey,
          ),

        ],
      ),
    );
  }

  Widget _contactsInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Контакты',
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              widget.order.client.name,
              style: GoogleFonts.openSans(
                fontSize: 18,
              ),
            ),
          ),

          SelectableText(
            widget.order.contactPhone,
            style: GoogleFonts.openSans(
              fontSize: 18,
            ),
          ),

          Divider(
            color: Colors.grey,
          ),

          Padding (
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Заказ',
              style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _orderItem(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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

  Widget _total() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column (
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
                  widget.order.total().toString() + ' KZT',
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
