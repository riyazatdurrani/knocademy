import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app223/HomeScreen.dart';
import 'package:flutter_app223/main.dart';
class NewScreen extends StatefulWidget {
  String uid;
 NewScreen(String uid){
    this.uid = uid;
  }
  @override
  _NewScreenState createState() => _NewScreenState();
}
var name;

class _NewScreenState extends State<NewScreen> {
  double _currentSliderValue = 5;
  var p=0;
  int sliderIntVal=5;

  @override

  Widget topNotchButton({String text}){

    return RaisedButton(

        color:  text == buttonName.toString() ? Colors.yellow[800] :   Color(0xFF311a2e),
        child: Text(text,style: TextStyle(color: Colors.white),),
        onPressed: (){
          setState(() {
            buttonName=text;
          });
        },
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),side: BorderSide(color: Colors.white))
    );
  }

  void initState() {
    print(buttonName+"uuuuuu");
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('DisplayQnA');
    collectionReference.doc(widget.uid).snapshots().listen((event) {
      name=event.data()['DisplayName'];
      print(name);
    });

    Future.delayed(Duration(seconds: 2)).then((response) {
      setState(() {
        p=1;
      });
    });
    super.initState();
  }
 int screen;
  String buttonName ="UPSC";
  ScrollController scrollController =  ScrollController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF311a2e),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(

          child: Center(
            child: p==0?CircularProgressIndicator():
            Padding(
              padding: const EdgeInsets.all(35),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(

                  children: [
                    Text("Hello $name",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    SizedBox(height: 40,),

                    Center(child: Text("What are you preparing for",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),)),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [


                        topNotchButton(text:"UPSC"),
                        SizedBox(width: 20,),
                        topNotchButton(text:"NEET",),
                        SizedBox(width: 20,),
                        topNotchButton(text:"SBI CLERK"),
                        SizedBox(width: 20,),
                        topNotchButton(text:"BANKING PO"),
                        SizedBox(width: 20,),
                        topNotchButton(text:"CDS"),
SizedBox(height: 30,),

                        Center(child: Text("How many questions do you want per test?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),)),
                        SizedBox(height: 30,),
                        Container(
                          child: Slider(
                            value: _currentSliderValue,
                            min: 0,
                            max: 20,
                            divisions: 4,
                            label: _currentSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                                sliderIntVal=value.toInt();
                              });
                            },
                          ),
                        ),
                      ],),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("$sliderIntVal"),
                    ),

                    SizedBox(height: 30,),
                    RaisedButton(
                        child: Text("SUBMIT"),
                        onPressed: (){print(_currentSliderValue.toInt());
                        _currentSliderValue.toInt()==0?_currentSliderValue=1:_currentSliderValue=_currentSliderValue;
                        print(_currentSliderValue.toInt());
                        Map<String,dynamic> Total ={"TotalQuestions":_currentSliderValue.toInt()};
                        CollectionReference collectionReference = FirebaseFirestore.instance
                            .collection('DisplayQnA');
//                  collectionReference.doc(widget.uid).snapshots().listen((event) {
//                    event.reference.update(Total);
 collectionReference.doc(widget.uid).update(Total);
//                });

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(widget.uid,buttonName) ));
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );

  }
}
