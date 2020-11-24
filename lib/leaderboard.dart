import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app223/HomeScreen.dart';
import 'package:flutter_app223/main.dart';


class Leaderboard extends StatefulWidget {

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

var ids=[];
var avgscore=[];
var p=0;
var updatedid;
var updatedavgscore;

class _LeaderboardState extends State<Leaderboard> {


Future getdata() async{
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('score');
  var snapshot = await collectionReference.get();
  snapshot.docs.forEach((result) {
    CollectionReference collectionReferencee = FirebaseFirestore.instance
        .collection('DisplayQnA');
    collectionReferencee.doc(result.id).snapshots().listen((event) {
      ids.add(event.data()['DisplayName']);
    });
    collectionReference.doc(result.id).snapshots().listen((event) {
      avgscore.add(event.data()['Average']);
 print("$ids oooooooooooooooooooo  $avgscore");

//      var ascending = avgscore..sort();
//      var descending = ascending.reversed;
//      print(ascending);
//      print(descending);
    });

  });

  setState(() {
    ids=[];
    avgscore=[];

  });

}

 void sort() {
   Future.delayed(Duration(seconds: 2)).then((response) {
     updatedavgscore = avgscore;
     updatedid = ids;
     var n = avgscore.length;
     int i, j;
     for (i = 0; i < n - 1; i++)
       for (j = 0; j < n - i - 1; j++)
         if (updatedavgscore[j] < updatedavgscore[j + 1]) {
           int temp = updatedavgscore[j];
           updatedavgscore[j] = updatedavgscore[j + 1];
           updatedavgscore[j + 1] = temp;

           var temp1 = updatedid[j];
           updatedid[j] = updatedid[j + 1];
           updatedid[j + 1] = temp1;
         }

     print("$updatedavgscore+888888 $updatedid");
     setState(() {
       p = 1;
     });
   });

}

  @override
  void initState() {

  getdata();
  sort();

setState(() {
  p=0;
});
 super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF311a2e),
      body:
        SafeArea(
        child: p==0?Center(child: CircularProgressIndicator()):

        Column(
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
                child: Text("LEADERBOARD",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
                  ,),
              ),

              ),
            SizedBox(height: 40,),

            Expanded(
              child: ListView.builder
                (
                  itemCount: avgscore.length,
                  itemBuilder: (BuildContext context, int index) {
                    return   InkWell(


                      child: ListTile(                //return new ListTile(
                        onTap: null,
                        leading: Container(
                         //height: 100,
                          width: MediaQuery.of(context).size.width-50,
                          child: Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Row(

                              children: [
                                Expanded(child: Text((index+1).toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)),
                                SizedBox(width: 80,),
                                Text(updatedid[index].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                                  SizedBox(width: 80,),
                                  Text(updatedavgscore[index].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                                SizedBox(height: 40,)
                              ],
                            ),
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
