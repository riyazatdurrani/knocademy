import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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









  nextPage() async{

    bool visitedFlag = await getVIsitingFlag();
    setVIsitingFlag();
    if (visitedFlag == true) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewScreen()));
      var questionNumbers =0;
      Map<String,dynamic> Total ={"TotalQuestions":questionNumbers};
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('DisplayQnA');

      collectionReference.add(Total);
    }
  }


@override
  void initState() {

  Future.delayed(Duration(seconds: 5)).then((response) {
    nextPage();
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF311a2e),
      body: SafeArea(
        child:
     CircularProgressIndicator(),
    ),
    );
  }
}



 getVIsitingFlag() async{
SharedPreferences preferences = await SharedPreferences.getInstance();
bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false ;
return alreadyVisited;
}

 setVIsitingFlag()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
preferences.setBool('alreadyVisited', true);
}