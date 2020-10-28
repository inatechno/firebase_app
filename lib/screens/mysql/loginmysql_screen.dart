import 'package:firebase_app/helpers/general_helper.dart';
import 'package:firebase_app/network/network.dart';
import 'package:firebase_app/screens/halaman_chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginMysqlScreen extends StatefulWidget {
  static String id = "loginmysql";

  @override
  _LoginMysqlScreenState createState() => _LoginMysqlScreenState();
}

class _LoginMysqlScreenState extends State<LoginMysqlScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  bool _obscoreText = true;
  Network network = Network();

  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext c) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("gambar/background.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _key,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(
          children: [
            myTextField(
              _email,
              null,
              TextInputType.emailAddress,
              "input your email",
              "email",
              Icon(Icons.person),
              null,
              false,
              passwordNode,
            ),
            myTextField(
              _password,
              passwordNode,
              TextInputType.visiblePassword,
              "input your password",
              "password",
              Icon(Icons.lock),
              IconButton(
                  icon: Icon(
                      _obscoreText ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toogle),
              _obscoreText,
              null,
            ),
            Builder(
              builder: (contextNew) => Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (_email.text.isEmpty || _password.text.isEmpty) {
                        Toast.show("inputan tidak boleh kosong", context);
                      } else {
                        prosesLogin(contextNew);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue[400],
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toogle() {
    setState(() {
      _obscoreText = !_obscoreText;
    });
  }

  Widget myTextField(
      TextEditingController controller,
      FocusNode fromNode,
      TextInputType type,
      String hint,
      String label,
      Icon prefix,
      IconButton suffix,
      bool obs,
      FocusNode toNode) {
    return TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        focusNode: fromNode,
        keyboardType: type,
        obscureText: obs,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(toNode);
        },
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blue[400]),
            labelText: label,
            labelStyle: TextStyle(color: Colors.blue[400])));
  }

  Future<void> prosesLogin(BuildContext contextNew) async {
    String device = await getId();
    network
        .loginUser(_email.text, _password.text, device)
        .then((response) async {
      if (response.result == "true") {
        Toast.show(response.msg, context);
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, HalamanChat.id);

        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.setBool("sesi", true);
        preferences.setString("iduser", response.idUser);
        preferences.setString("token", response.token);
      } else {
        Scaffold.of(contextNew).showSnackBar(SnackBar(
          content: Text("gagal login :${response.msg}"),
        ));
      }
    });
  }
}
