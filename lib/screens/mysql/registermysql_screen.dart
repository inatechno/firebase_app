import 'package:firebase_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RegisterMysqlScreen extends StatefulWidget {
  static String id = "registermysql";

  @override
  _RegisterMysqlScreenState createState() => _RegisterMysqlScreenState();
}

class _RegisterMysqlScreenState extends State<RegisterMysqlScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nohp = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode noHpNode = FocusNode();
  bool _obscoreText = true;
  Network network = Network();

  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("gambar/background.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _key,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              myTextField(
                _email,
                null,
                TextInputType.emailAddress,
                "input your email",
                "email",
                Icon(Icons.person, color: Colors.blue),
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
                Icon(Icons.lock, color: Colors.blue),
                IconButton(
                    icon: Icon(
                        _obscoreText ? Icons.visibility : Icons.visibility_off),
                    onPressed: _toogle,
                    color: Colors.blue),
                _obscoreText,
                nameNode,
              ),
              myTextField(
                _name,
                nameNode,
                TextInputType.text,
                "input your name",
                "name",
                Icon(Icons.person, color: Colors.blue),
                null,
                false,
                noHpNode,
              ),
              myTextField(
                _nohp,
                noHpNode,
                TextInputType.phone,
                "input your phone",
                "phone",
                Icon(
                  Icons.call,
                  color: Colors.blue,
                ),
                null,
                false,
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
                        if (_email.text.isEmpty ||
                            _password.text.isEmpty ||
                            _name.text.isEmpty ||
                            _nohp.text.isEmpty) {
                          Toast.show("inputan tidak boleh kosong", context);
                        } else {
                          prosesRegister(contextNew);
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.blue[400],
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
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

  void prosesRegister(BuildContext contextNew) {
    network
        .registerUser(_email.text, _password.text, _name.text, _nohp.text)
        .then((response) {
      if (response.result == "true") {
        Toast.show(response.msg, context);
        Navigator.pop(context);
      } else {
        Scaffold.of(contextNew).showSnackBar(SnackBar(
          content: Text("gagal register :${response.msg}"),
        ));
      }
    });
  }
}
