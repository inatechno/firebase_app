import 'dart:async';
import 'dart:convert';
  
import 'package:firebase_app/model/model_history.dart';
import 'package:firebase_app/model/model_item.dart';
import 'package:flutter/material.dart';


  final Map<String, Item> _items = <String, Item>{};
  Item itemForMessage(Map<String, dynamic> message) {
    final dynamic data = message['data'] ?? message;
    var datax = data['datax'];
    var itemData = jsonDecode(datax)['datax']['data'];
    DataHistory dataHistory = DataHistory.fromJson(itemData);
    String idbooking = dataHistory.idBooking;
    print("idbooking:" + idbooking);

    final Item item = _items.putIfAbsent(
        idbooking,
        () => Item(
              itemId: idbooking,
              origin: dataHistory.bookingFrom,
              destination: dataHistory.bookingTujuan,
              harga: dataHistory.bookingBiayaDriver,
            ))
      ..status = jsonDecode(datax)['datax']['msg'];

    return item;
  
}

class DetailPage extends StatefulWidget {
  DetailPage(this.itemId);
  final String itemId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
   
  StreamSubscription<Item> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item ${_item.itemId}"),
      ),
      body: Material(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("origin: ${_item.origin}"),
            Text("destination: ${_item.destination}"),
            Text("harga: ${_item.harga}")
          ],
        )),
      ),
    );
  }
}
