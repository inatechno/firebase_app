import 'package:firebase_app/screens/halaman_chat.dart';
import 'package:firebase_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';

class LoginPhoneScreen extends StatefulWidget {
  static String id = "loginphone";

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login by Phone"),
      ),
      body: Builder(builder: (c) {
        return SingleChildScrollView(
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: const Text('Test sign in with phone number',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      alignment: Alignment.center,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                          labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Phone number (+x xxx-xxx-xxxx)';
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                        icon: Icons.contact_phone,
                        backgroundColor: Colors.deepOrangeAccent[700],
                        text: "Verify Number",
                        onPressed: () async {
                          _verifyPhoneNumber(c);
                        },
                      ),
                    ),
                    TextField(
                      controller: _smsController,
                      decoration:
                          const InputDecoration(labelText: 'Verification code'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                          icon: Icons.phone,
                          backgroundColor: Colors.deepOrangeAccent[400],
                          onPressed: () async {
                            _signInWithPhoneNumber(c);
                          },
                          text: 'Sign In'),
                    ),
                    Visibility(
                      visible: _message == null ? false : true,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        );
      }),
    );
  }

  void _verifyPhoneNumber(BuildContext c) async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      Scaffold.of(c).showSnackBar(SnackBar(
        content: Text(
            "Phone number automatically verified and user signed in: ${phoneAuthCredential}"),
      ));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Scaffold.of(c).showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Scaffold.of(c).showSnackBar(SnackBar(
        content: Text("Failed to Verify Phone Number: ${e}"),
      ));
    }
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber(BuildContext c) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      Scaffold.of(c).showSnackBar(SnackBar(
        content: Text("Successfully signed in UID: ${user.uid}"),
      ));
      Navigator.pushNamed(context, HalamanChat.id);
    } catch (e) {
      print(e);
      Scaffold.of(c).showSnackBar(SnackBar(
        content: Text("Failed to sign in"),
      ));
    }
  }
}
