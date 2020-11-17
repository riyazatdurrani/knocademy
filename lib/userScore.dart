
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'login.dart';
void main() => runApp(MyApp());


class UserScore extends StatefulWidget {
  String uid;
  UserScore(String uid){
    this.uid = uid;
  }
  @override
  _UserScoreState createState() => _UserScoreState();
}

class _UserScoreState extends State<UserScore> {
@override
var lengthofscore;
var eventt;


Future getRequest() async{
  CollectionReference collectionReference =  FirebaseFirestore.instance.collection('score');

  await collectionReference.doc(widget.uid).collection("indivisualscore").snapshots().listen((event) {

    lengthofscore= event.docs.length;
    setState(() {
      eventt=event.docs;
    });
   // eventt=event.docs;
      print(eventt[0].data()); // prints {score: 10}
      var b= eventt[0].data()['score'].toString();
      print(b); // prints 10
    });

}

  void initState() {

  getRequest();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 65,
            width:  MediaQuery. of(context). size.width-30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:  Colors.yellow[800],
            ),
            child:

          Center(
            child: Text("YOUR SCORE HISTORY",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
              ,),
          )

            ,),
            Expanded(
              child: ListView.builder
                (
                  itemCount: lengthofscore,
                  itemBuilder: (BuildContext context, int index) {
                    return   InkWell(


                      child: ListTile(                //return new ListTile(
                          onTap: null,
                          leading: Container(
                          margin: EdgeInsets.only(left: MediaQuery. of(context). size.width/2.4),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(eventt[index].data()['score'].toString()),
                            ),
                          ),

                      ),

                    );


                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

