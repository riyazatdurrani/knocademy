import 'package:flutter/material.dart';
import 'package:flutter_app223/main.dart';
class NewScreen extends StatefulWidget {
  int count;
  NewScreen(this.count);
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.count.toString()),
      ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: Text("RESET"),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            }
        )
    );

  }
}
