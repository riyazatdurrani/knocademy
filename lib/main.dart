import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


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

  final dbref = FirebaseDatabase.instance.reference();


var question="";
var option1="";
var option2="";
var score=0;
var count=0;


void getans(String ans){

  var a,b;
  dbref.once().then((value) {
    a = value.value["questions"];
   b  =  a[count-1]["ans"];

   if(ans == a[count-1][b] ){
     print(ans);
     setState(() {
       score =score +10;

     });
   }

   else{
     setState(() {
       score =score +0;
     });
   }
  } );



}





  String nextQuestion(){
  dbref.once().then((value) {
      if(count<value.value["questions"].length) {
        setState(() {
         var a = value.value["questions"];
          question = a[count]["question"];
          option1 = a[count]["option1"];
          option2 = a[count]["option2"];
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
    }
    );
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




Widget topNotchButton({Color color,String text}){
  return RaisedButton(
      color: color,
      child: Text(text,style: TextStyle(color: Colors.white),),
      onPressed: (){},
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
  );
}


Widget optionButton({String text}){
  return Container(
    width: MediaQuery.of(context).size.width -20,
    height: 60,
    child: Card(

      elevation: 20.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: (){
          getans(text);
          setState(() {
            nextQuestion();
            scrollController.animateTo(0, duration: Duration(milliseconds: 3000), curve: Curves.fastOutSlowIn);

          });
        },
        child: Center(
          child: Text(
            text,
          ),
        ),
      ),
    ),
  );
}


Widget bottomNotch({IconData icon}){
  return  Expanded(
    child: Icon(
      icon,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
  );
}
  ScrollController scrollController =  ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFF311a2e),
      body: SafeArea(
        child: Column(
          children: [

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(children: [


                  topNotchButton(color: Colors.yellow[800],text:"UPSC"),
                  SizedBox(width: 15,),
                  topNotchButton(color: Color(0xFF311a2e),text:"NEET"),
                  SizedBox(width: 15,),
                  topNotchButton(color: Color(0xFF311a2e),text:"SBI CLERK"),
                  SizedBox(width: 15,),
                  topNotchButton(color: Color(0xFF311a2e),text:"BANKING PO"),
                  SizedBox(width: 15,),
                  topNotchButton(color: Color(0xFF311a2e),text:"CDS"),

],),
              ),
            ),


            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.only(top: 50.0,bottom: 50) ,
                decoration: BoxDecoration(
                    color: Color(0xFFf2f2f2),
                    borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft:Radius.circular(40) ),

                ),
                child: SingleChildScrollView(
controller:  scrollController,
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: 800,
                    child: (
                    Column(

                        crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
                        child: Text(question.replaceAll("\\n", "\n"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      ),

                      SizedBox(height: 20),
                      optionButton(text: option1),
                      SizedBox(height: 30),
                      optionButton(text: option2),
                      SizedBox(height: 30),
                      optionButton(text: option1),
                      SizedBox(height: 30),
                      optionButton(text: option2),
                      SizedBox(height: 30),
                      Spacer(),




                    Column(
                      children: [
                      Text("TOTAL"),
                        Container(
                            width: MediaQuery. of(context). size. width,
                            color: Colors.blue,
                            child:
                            Center(child: Text(score.toString(),)),),
SizedBox(height: 20)
                    ],),
                    ],
                    )

                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [

                  bottomNotch(icon : Icons.system_update_alt),
                  bottomNotch(icon : Icons.favorite),
                  bottomNotch(icon : Icons.filter_none),
                  bottomNotch(icon : Icons.settings),
                ],
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),

    );
  }
}
