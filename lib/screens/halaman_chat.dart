import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helpers/constant.dart';
import 'package:firebase_app/helpers/general_helper.dart';
import 'package:firebase_app/helpers/messagebubble.dart';
import 'package:firebase_app/model/model_item.dart';
import 'package:firebase_app/network/network.dart';
import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/screens/detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HalamanChat extends StatefulWidget {
  static const String id = "CHAT";

  @override
  _HalamanChatState createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String msgText;
  TextEditingController msgTextcontroller = TextEditingController();

  String iduser;

  String _homeScreenText = "Waiting for token...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Network network;
  String fcm;
  String tokenUpdate;
  String token;
  String device;

  void getCurrentUser() async {
    _currentUser = await _auth.currentUser;
    print(_currentUser);
  }

  void getMsg() {
    Stream<QuerySnapshot> snapshot =
        _firestore.collection("messages").snapshots();

    snapshot.listen((onData) {
      List<DocumentSnapshot> docs = onData.docs;
      for (DocumentSnapshot doc in docs) {
        print(doc.data()['text']);
      }
    });
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("Item ${item.itemId} has been updated"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    network = Network();
    getCurrentUser();
    getPref();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _showItemDialog(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        tokenUpdate = token;
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
      if (fcm == '') {
        setTokenToPref(tokenUpdate);
        insertTokenToDB(tokenUpdate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                // cara1
                var user = await _auth?.currentUser ?? iduser;
                //cara 2
                // var user = await _auth.currentUser != null
                //     ? _auth.currentUser
                //     : iduser;
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();
                final String uid = "id";
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(' has successfully signed out.'),
                ));
                Navigator.popAndPushNamed(context, AuthScreen.id);
              },
            );
          })
        ],
        title: Text("Chat"),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    List<MessageBubble> textItems = List<MessageBubble>();
                    for (DocumentSnapshot doc in docs) {
                      textItems.add(MessageBubble(
                        from: doc.data()['sender'],
                        text: doc.data()['text'],
                        fromMe: _currentUser?.email == doc.data()['sender'],
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textItems == null
                          ? Center(
                              child: Text(
                                "belum ada chating",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            )
                          : ListView(
                              children: textItems,
                            ),
                    );
                  }
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      controller: msgTextcontroller,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      print(msgTextcontroller?.text ?? "");
                      if (msgTextcontroller.text.length > 0) {
                        await _firestore.collection("messages").add({
                          'text': msgTextcontroller?.text ?? "tidak ada data",
                          'sender': _currentUser?.email ?? ""
                        });
                        insertBooking();
                        msgTextcontroller.clear();
                      }
                    },
                    child: Text(
                      "send",
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  insertBooking() async {
    var device = await getId();
    network
        .insertBooking(
      iduser,
      "-6.2926353",
      "Haleyora Powerindo Pusat",
      "-6.1953815",
      "106.7948458",
      "inatechno",
      "baju flutter",
      "20",
      "106.700744",
      token,
      device,
    )
        .then((response) {
      if (response.result == "true") {
        Toast.show(response.msg, context);
        // Navigator.pushNamed(context, WaitingDriverScreen.id,
        //     arguments: response.idBooking.toString());
      } else {
        Toast.show(response.msg, context);
      }
    });
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    iduser = preferences.getString("iduser");
    fcm = preferences.getString("fcm") ?? "";
    token = preferences.getString("token");
  }

  Future<void> setTokenToPref(String tokenUpdate) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("fcm", tokenUpdate);
  }

  insertTokenToDB(String tokenUpdate) {
    print("iduser$iduser + token $tokenUpdate");
    return network.insertFcm(iduser, token).then((response) {
      Toast.show(response.msg, context);
      if (response.result == "true") {
        Toast.show(response.msg, context);
      } else {
        Toast.show(response.msg, context);
      }
    });
  }
}
