import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'Pages/Home.dart';
import 'Pages/Profile/Settings.dart';
import 'Pages/Thread/Thread-Webview.dart';
import 'Pages/Startup/PreLogin.dart';
import 'Pages/Startup/Register.dart';
import 'Pages/Startup/Login.dart';
import 'Pages/Profile/ProfileDisplay.dart';
import 'Pages/Profile/Saved_Posts.dart';
import 'package:app/Pages/Profile/DisplayOtherProfile.dart';
import 'package:hive/hive.dart';
import 'package:app/Pages/Startup/ChangePassword.dart';

void main() async{
  String initialroute = '/prelogin';

  await Hive.initFlutter();
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white
    ),
    initialRoute: initialroute,
    routes: {
      '/home': (context) => home(),
      '/profile': (context) => profiles(),
      '/thread': (context) => thread(),
      '/saved': (context) => saved(),
      '/settings': (context) => settings(),
      '/prelogin': (context) => prelogin(),
      '/register': (context) => register(),
      '/login': (context) => login(),
      '/otherprofile': (context) => otherProfileDisplay(),
      '/changepassword': (context) => changePass(),
    },
    
  ));
}
