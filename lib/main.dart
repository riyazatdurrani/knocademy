import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_app223/HomeScreen.dart';
import 'package:flutter_app223/NewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: MyApp(),
    );
  }
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {










Future<void> rememberMe() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var uidd = preferences.getString('uid');
  Future.delayed(Duration(seconds: 5)).then((response) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => uidd==null ? MyLoginPage() :HomeScreen(uidd)),
    );
  });
}


@override
  void initState() {
rememberMe();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF311a2e),
      body: SafeArea(
        child:
     Center(child: CircularProgressIndicator()),
    ),
    );
  }
}



