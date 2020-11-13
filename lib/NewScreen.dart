import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app223/HomeScreen.dart';
import 'package:flutter_app223/main.dart';
class NewScreen extends StatefulWidget {

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  double _currentSliderValue = 5;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child:   Column(
            children: [
              Container(
                child: Text("hello"),
              ),
              SizedBox(height: 40,),
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
                    });
                  },
                ),
              ),
              RaisedButton(
                  child: Text("SUBMIT"),
                  onPressed: (){print(_currentSliderValue.toInt());
                  Map<String,dynamic> Total ={"TotalQuestions":_currentSliderValue.toInt()};
                  CollectionReference collectionReference = FirebaseFirestore.instance
                      .collection('DisplayQnA');
                  collectionReference.snapshots().listen((event) {
                    event.docs[0].reference.update(Total);
                  });
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen() ));
                  }),
            ],
          ),
        ),
      ),

    );

  }
}
