import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String from;
  final String text;
  final bool fromMe;
  MessageBubble({this.from, this.text, this.fromMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          from,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        Material(
          color: fromMe ? Colors.blueAccent : Colors.green.shade400,
          borderRadius: fromMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(0))
              : BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15)),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
