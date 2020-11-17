import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
void main() => runApp(MyApp());


class MyLogoutPage extends StatefulWidget {
  @override
  _MyLogoutPageState createState() => _MyLogoutPageState();
}

class _MyLogoutPageState extends State<MyLogoutPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Material(
          elevation: 5,
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(32.0),
          child: MaterialButton(
            onPressed: () async{
              SharedPreferences preferences = await SharedPreferences.getInstance();
             preferences.remove('uid');
              FirebaseAuth _auth = FirebaseAuth.instance;
             await _auth.signOut().then((value) =>
                 Navigator.push(context,
                   MaterialPageRoute(builder: (context) => MyLoginPage()),
                 )
             );
              },
            minWidth: 200.0,
            height: 45.0,
            child: Text(
              "Logout",
              style:
              TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}

