import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/screens/halaman_chat.dart';
import 'package:firebase_app/screens/home_screen.dart';
import 'package:firebase_app/screens/firebase/loginemailpass_screen.dart';
import 'package:firebase_app/screens/firebase/loginphone_screen.dart';
import 'package:firebase_app/screens/firebase/register_screen.dart';
import 'package:firebase_app/screens/mysql/loginmysql_screen.dart';
import 'package:firebase_app/screens/mysql/registermysql_screen.dart';
import 'package:firebase_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashLoadingScreen.id,
      routes: {
        SplashLoadingScreen.id: (context) => SplashLoadingScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginEmailPassScreen.id: (context) => LoginEmailPassScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginPhoneScreen.id: (context) => LoginPhoneScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        HalamanChat.id: (context) => HalamanChat(),
        LoginMysqlScreen.id: (context) => LoginMysqlScreen(),
        RegisterMysqlScreen.id: (context) => RegisterMysqlScreen(),
      },
    );
  }
}
