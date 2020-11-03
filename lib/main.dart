import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


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



var question="";
var option1="";
var option2="";
var score=0;
var count=0;


void getans(String ans){
if(ans == "riyazat" || ans =="srk"|| ans =="anil"){
 setState(() {
   score =score +10;

 });

}
else{
  setState(() {
    score =score +0;

  });

}
}





  String nextQuestion(){
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('question');
    collectionReference.snapshots().listen((event) {
     if(count< event.docs.length) {
       setState(() {
         var a = (event.docs[count].data());
         question = a["question1"];
         option1 = a["option1"];
         option2 = a["option2"];
         count++;
       });
     }
     else{

             Map<String,dynamic> finalScore ={"score":score};
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('score');
      collectionReference.add(finalScore);
             setState(() {
               count=0;
               score=0;
             });
             nextQuestion();
    }

    });



  }

  @override
  void initState() {
   setState(() {
     count=0;
     score=0;
   });
   nextQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFF311a2e),
      body: Column(
        children: [

          Expanded(
            child: Container(
              margin:EdgeInsets.only(top: 150.0,bottom: 50) ,
              decoration: BoxDecoration(
                  color: Color(0xFFf2f2f2),
                  borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft:Radius.circular(40) ),

              ),
              child: (
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(question,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),

                SizedBox(height: 20),

              Card(
                  elevation: 20.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              child: InkWell(
              onTap: (){
                getans(option1);
                setState(() {
                  nextQuestion();
                });
              },
            child: Padding(
            padding: const EdgeInsets.only(left: 170,right: 170,top: 15,bottom: 15),
            child: Text(
              option1,
            ),
            ),
    ),
    ),




                SizedBox(height: 30),

                Card(
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: (){
                      getans(option2);
                      setState(() {
                        nextQuestion();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 170,right: 170,top: 15,bottom: 15),
                      child: Text(
                        option2,
                      ),
                    ),
                  ),
                ),
SizedBox(height: 30),




Spacer(),
//              Column(
//
//                children: [
//                Text("TOTAL"),
//                  Container(
//                      width: MediaQuery. of(context). size. width,
//                      color: Colors.blue,
//                      child:
//                      Center(child: Text(score.toString(),)),),
//SizedBox(height: 20)
//              ],),
              ],
              )

              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                Expanded(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                Expanded(
                  child: Icon(
                    Icons.filter_none,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                Expanded(
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),

    );
  }
}
