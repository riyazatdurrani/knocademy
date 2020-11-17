import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'NewScreen.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showProgress = false;
 String  name;
 String password;
 String email;
  FirebaseAuth _auth = FirebaseAuth.instance;

  nextPage(String uid) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool visitedFlag = await getVIsitingFlag();
    setVIsitingFlag();
    preferences.setString('uid', uid);
    if (visitedFlag == true) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(uid)));
    }
    else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewScreen(uid)));
      var questionNumbers =0;
      Map<String,dynamic> Total ={"TotalQuestions":questionNumbers};
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('DisplayQnA');

      collectionReference.doc(uid).set(Total);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ModalProgressHUD(
                inAsyncCall:showProgress ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Registration Page",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        name=value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email= value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password=value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 5,
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(32.0),
                      child: MaterialButton(
                        onPressed: () async{
                          setState(() {
                            showProgress=true;
                          });
                          try {
                            final newUser = await _auth
                                .createUserWithEmailAndPassword(
                                email: email, password: password);
                            if(newUser != null){
                              nextPage(newUser.user.uid);
                              setState(() {
                                showProgress=false;
                              });
                            }
                          }
                          catch(e){
                          print(e);
                          }
                        },
                        minWidth: 200.0,
                        height: 45.0,
                        child: Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                        ),
                      ),

                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already Have an account? "),
                        GestureDetector(onTap:(){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyLoginPage()),
                          );
                        }, child:
                        Text("CLICK HERE"),),
                      ],
                    ),

                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }getVIsitingFlag() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false ;
    return alreadyVisited;
  }

  setVIsitingFlag()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('alreadyVisited', true);
  }
}