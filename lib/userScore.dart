
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
var p=0;
var avgscore;
var ids=[];
var scoreavg=[];
var rank=0;


Future getdata() async{
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('score');
  var snapshot = await collectionReference.get();
  snapshot.docs.forEach((result) {
    CollectionReference collectionReferencee = FirebaseFirestore.instance
        .collection('DisplayQnA');
    collectionReferencee.doc(result.id).snapshots().listen((event) {
      ids.add(result.id);
    });
    collectionReference.doc(result.id).snapshots().listen((event) {
      scoreavg.add(event.data()['Average']);
      print("$ids oooooooooooooooooooo  $scoreavg");

    });

  });

}

var count=0;
void sort(){
  Future.delayed(Duration(seconds: 2)).then((response) {
var n = scoreavg.length;
var i, j;
for (i = 0; i < n - 1; i++)
for (j = 0; j < n - i - 1; j++)
if (scoreavg[j] < scoreavg[j + 1]) {
int temp = scoreavg[j];
scoreavg[j] = scoreavg[j + 1];
scoreavg[j + 1] = temp;

var temp1 = ids[j];
ids[j] = ids[j + 1];
ids[j + 1] = temp1;
}

print("$scoreavg+888888 $ids");

  for (int i = 0; i < ids.length; i++) {
    widget.uid.toString()==ids[i].toString()?rank=i+1:null;
  }

  });
}



























Future getRequest() async{
  CollectionReference collectionReference =  FirebaseFirestore.instance.collection('score');

  await collectionReference.doc(widget.uid).collection("indivisualscore").snapshots().listen((event) {

   lengthofscore= event.docs.length;
    setState(() {
      Future.delayed(Duration(seconds: 2)).then((response) {
        CollectionReference collectionReference = FirebaseFirestore.instance.collection('score');
        collectionReference.doc(widget.uid).snapshots().listen((event) {
          setState(() {
            avgscore = event.data()['Average'];
            p=1;
          });
        });

      });
      eventt=event.docs;

    });
   // eventt=event.docs;
      print(eventt[0].data()); // prints {score: 10}
      var b= eventt[0].data()['score'].toString();
      print(b); // prints 10
    });

}

  void initState() {
getdata();
sort();
getRequest();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Color(0xFF311a2e),
      body: SafeArea(

        child:p==0?Center(child: CircularProgressIndicator()): Column(
          children: [


            Padding(
              padding: const EdgeInsets.only(left: 30,right: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery. of(context). size.width/2.5,
                          child: Card(

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,right: 20),
                                      child: Text("Leaderboard",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 53,bottom: 15),
                                      child: Text("Ranking",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                    ),
                                    Text(rank.toString(),style: TextStyle(color: Color(0xFF311a2e),fontSize: 50),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Container(
                            height: MediaQuery. of(context). size.width/2.5,
                            child: Card(

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20,right: 50),
                                        child: Text("Average",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Text("Score Per",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 80,),
                                        child: Text("Text",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                      ),
                                      Text(avgscore.toString(),style: TextStyle(color: Color(0xFF311a2e),fontSize: 50),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        height: MediaQuery. of(context). size.width/2.5,
                        width: MediaQuery. of(context). size.width/2.5,
                        child: Card(

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20,top: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 50),
                                      child: Icon(
                                         Icons.emoji_objects,
                                        color: Color(0xFF311a2e),
                                        size: 30.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                    ),
                                    Column(
crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20,right: 60),
                                          child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                        ),
                                        Text("Tests",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF311a2e),fontSize: 17),),
                                        Text(lengthofscore.toString(),style: TextStyle(color: Color(0xFF311a2e),fontSize: 50),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),


//
                    ],
                  ),
                ],
              ),
            ),



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
            SizedBox(height: 30,),
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

