import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_app/helpers/rounded_button.dart';
import 'package:firebase_app/screens/halaman_chat.dart';
import 'package:firebase_app/screens/home_screen.dart';
import 'package:firebase_app/screens/firebase/loginemailpass_screen.dart';
import 'package:firebase_app/screens/firebase/loginphone_screen.dart';
import 'package:firebase_app/screens/firebase/register_screen.dart';
import 'package:firebase_app/screens/mysql/loginmysql_screen.dart';
import 'package:firebase_app/screens/mysql/registermysql_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  static String id = "auth";
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                  tag: "logo",
                  child: Image.asset(
                    "gambar/flut.png",
                    height: 60,
                  )),
              Flexible(
                  child: TypewriterAnimatedTextKit(
                      speed: Duration(milliseconds: 1000),
                      totalRepeatCount: 4,
                      repeatForever: true, //this will ignore [totalRepeatCount]
                      pause: Duration(milliseconds: 1000),
                      text: [
                        "Firebase App!",
                        "do it RIGHT!!",
                        "do it RIGHT NOW!!!"
                      ],
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontFamily: "Horizon",
                          fontWeight: FontWeight.bold),
                      // pause: Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true))
            ],
          ),
          SizedBox(
            height: 40,
          ),
          RoundedButton(
            color: Colors.orange,
            text: "Login email/pass",
            callback: () {
              Navigator.pushNamed(context, LoginEmailPassScreen.id);
            },
          ),
          RoundedButton(
            color: Colors.orange,
            text: "Login by google",
            callback: () {
              loginbyGoogle();
            },
          ),
          RoundedButton(
            color: Colors.orange,
            text: "Login by Phone",
            callback: () {
              Navigator.pushNamed(context, LoginPhoneScreen.id);
            },
          ),
          RoundedButton(
            color: Colors.orange,
            text: "Login Mysql",
            callback: () {
              Navigator.pushNamed(context, LoginMysqlScreen.id);
            
            },
          ),
          Center(child: Text("OR")),
          RoundedButton(
            color: Colors.orange,
            text: "Register",
            callback: () {
              Navigator.pushNamed(context, RegisterScreen.id);
            },
          ),
          RoundedButton(
            color: Colors.orange,
            text: "Register Mysql",
            callback: () {
              Navigator.pushNamed(context, RegisterMysqlScreen.id);
            },
          ),
        ],
      ),
    );
  }

  loginbyGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      Navigator.pushNamed(context, HalamanChat.id);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sign In ${user.uid} with Google"),
      ));
    } catch (e) {
      print(e);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e}"),
      ));
    }
  }
}
