import 'package:flutter/material.dart';
import '../screen/set_screen.dart';
import '../constant/size.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    if(size == null){
      size = MediaQuery.of(context).size;
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('카이모닝(관리자용)', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                          ),
                          Icon(Icons.directions_car, size: 30.0, color: Colors.red,)
                        ],
                      ),
                      Column(
                        children: [
                          TextField(
                            controller: _textController,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height:20.0),
                          IconButton(icon: Icon(Icons.exit_to_app, size: 30.0,),onPressed: (){
                            if(_textController.text == 'asdf')
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SetScreen()));
                          },),
                          SizedBox(height:20.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
