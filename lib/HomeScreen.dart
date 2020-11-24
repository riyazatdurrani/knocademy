import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app223/NewScreen.dart';
import 'package:flutter_app223/leaderboard.dart';
import 'package:flutter_app223/logout.dart';
import 'package:flutter_app223/userScore.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class HomeScreen extends StatefulWidget {
String uid;
String buttonName;
HomeScreen(String uid,String buttonName){
  this.uid = uid;
  this.buttonName=buttonName;

}
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final dbref = FirebaseDatabase.instance.reference();
  var question="";
  var option1="";
  var option2="";
  var score=0;
  var count=0;
  String buttonName ="UPSC";
  var arr=[];
  var total=0;
  var avg=0;
  var lengthofquestion=2;
  var p=0;
  var m=0;
  var w;



  void getans(String ans){
 var a,b;
    dbref.once().then((value) {
      a = value.value[buttonName];
      b  =  a[arr[count-1]]["ans"];

if(ans == a[arr[count-1]][b] ){

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


  Future addAvg() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('score');
    var snapshot = await collectionReference.get();


      collectionReference.doc(widget.uid).collection("indivisualscore").snapshots().forEach((element) {


        for(int i=0;i<element.docs.length;i++){

          total= total+(element.docs[i].data()['score']);

          avg = ((total) / (element.docs.length)).round().toInt();
        }

        Map<String,dynamic> Average ={"Average":avg};
        collectionReference.doc(widget.uid).set(Average);
        setState(() {
          total=0;
          avg=0;
        });
      });

  }


  String nextQuestion(){
    dbref.once().then((value) {
      if(count<arr.length) {

        setState(() {
          m=1;
 var a = value.value[buttonName];
          question = a[arr[count]]["question"];
          option1 = a[arr[count]]["option1"];
          option2 = a[arr[count]]["option2"];
          count++;
        });
      }
      else{
        var finalscoree=score;
        Map<String,dynamic> finalScore ={"score":score};
        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection('score');
        collectionReference.doc(widget.uid).collection("indivisualscore").add(finalScore);


addAvg();

        setState(() {
          count=0;
          score=0;
        });
        Alert(
          context: context,
          type: AlertType.warning,
          title: "ALERT",
          desc: "you scored $finalscoree",
          buttons: [
            DialogButton(
              child: Text(
                "CHECK SCORE",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserScore(widget.uid)  )),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "RETRY",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  arr =[];
                  initState();
                });
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();
        nextQuestion();
      }
    }
    );
  }

  @override
setdb(){
    dbref.once().then((value) {
      setState(() {
        m=0;
     p==0? lengthofquestion=(value.value[widget.buttonName]).length-1 :  lengthofquestion = (value.value[buttonName]).length-1;

      });

      print(lengthofquestion);
    });
  }


  void initState() {
  setdb();
    Future.delayed(Duration(seconds: 2)).then((response) {
 setState(() {
  p==0? buttonName=widget.buttonName : buttonName=buttonName;

      count=0;
      score=0;

CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('DisplayQnA');
      collectionReference.doc(widget.uid).snapshots().listen((event) {
        var q=event.data();
        w = q["TotalQuestions"];

        for(int i=0;i<w;i++) {
          Random random = new Random();
          int randomNumber = random.nextInt(lengthofquestion)+1;
          arr.add(randomNumber);
 }
        p=1;
        m=1;
        print(arr);
      });
 });
    nextQuestion();
});
super.initState();
  }





  Widget topNotchButton({String text}){

    return RaisedButton(

        color:  text ==buttonName.toString() ? Colors.yellow[800] :   Color(0xFF311a2e),
        child: Text(text,style: TextStyle(color: Colors.white),),
        onPressed: (){
          setState(() {
m=0;
p=1;
            buttonName=text;
            count=0;
            arr=[];
initState();
           // nextQuestion();
            scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);

          });
        },
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),side: BorderSide(color: Colors.white))
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
              scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);

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


  Widget bottomNotch({IconData icon, int  screen}){
 return  Expanded(
 child: GestureDetector(
 onTap: (){
 Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen == 1? NewScreen(widget.uid): screen == 2 ? MyLogoutPage() : screen ==3? UserScore(widget.uid) : screen ==4? Leaderboard() : null  ));
        },
        child: Icon(
          icon,
 color: Colors.white,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
),
      ),
    );
}

  ScrollController scrollController =  ScrollController();
String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF311a2e),
      body: m==0?Center(child: CircularProgressIndicator()): SafeArea(
        child: Column(
          children: [

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:

              Padding(
                padding: const EdgeInsets.only(top:20.0,bottom: 5,left: 20,right: 20),
                child: Row(children: [


                  topNotchButton(text:"UPSC"),
                  SizedBox(width: 15,),
                  topNotchButton(text:"NEET",),
                  SizedBox(width: 15,),
                  topNotchButton(text:"SBI CLERK"),
                  SizedBox(width: 15,),
                  topNotchButton(text:"BANKING PO"),
                  SizedBox(width: 15,),
                  topNotchButton(text:"CDS"),

                ],),
              ),
            ),
Padding(
  padding: const EdgeInsets.only(right: 10),
  child:   Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
 Container(
   decoration: BoxDecoration(
     color: Colors.blue,
     borderRadius: BorderRadius.all (Radius.circular(40) ),

   ),

   child:    Padding(
     padding: const EdgeInsets.all(8.0),
     child: Row(

     children: [

        Text(count.toString(),style: TextStyle(color: Colors.white),),

     Text("/",style: TextStyle(color: Colors.white),),

     Text(w.toString(),style: TextStyle(color: Colors.white),),

     ],),
   ),
 ),
],
),
),

            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.only(top: 30.0,bottom: 50) ,
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




//                            Column(
//                              children: [
//                                Text("TOTAL"),
//                                Container(
//                                  width: MediaQuery. of(context). size.width,
//                                  color: Colors.blue,
//                                  child:
//                                  Center(child: Text(score.toString(),)),),
//                                SizedBox(height: 20)
//                              ],),
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

                  bottomNotch(icon : Icons.system_update_alt, screen :2),
                  bottomNotch(icon : Icons.pending_actions,screen: 3),
                  bottomNotch(icon : Icons.verified_user,screen: 4),
                  bottomNotch(icon : Icons.perm_identity, screen :1),
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



getVIsitingFlag() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false ;
  return alreadyVisited;
}

setVIsitingFlag()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('alreadyVisited', true);
}