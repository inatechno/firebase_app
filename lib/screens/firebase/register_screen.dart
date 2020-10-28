import 'package:firebase_app/helpers/constant.dart';
import 'package:firebase_app/helpers/rounded_button.dart';
import 'package:firebase_app/screens/firebase/loginemailpass_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email, password;
  bool loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: "logo",
                child: Image.asset(
                  "gambar/flut.png",
                  height: 60,
                )),
            SizedBox(
              height: 50,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: "enter your email"),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: "enter your password"),
            ),
            SizedBox(
              height: 8,
            ),
            RoundedButton(
              text: "Register",
              color: Colors.orange,
              callback: () {
                prosesRegister();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> prosesRegister() async {
    loading = true;
    User user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      setState(() {
        loading = false;
      });
      //kirim verifikasi ke email yg didaftarkan
      user.sendEmailVerification();
      Navigator.popAndPushNamed(context, LoginEmailPassScreen.id);
      Toast.show("Berhasil Register", context);
    } else {
      setState(() {
        loading = false;
      });
      Toast.show("Gagal Register", context);
    }
  }
}
