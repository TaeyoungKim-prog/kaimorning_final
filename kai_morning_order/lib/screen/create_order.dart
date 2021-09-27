
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../network/network_function.dart';
import '../useful/generate_key.dart';
import '../widgets/my_progress_indicator.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  DateTime _daySelect = DateTime.now();
  String _timeSelect = '';
  String _storeSelect = '';
  String _storeSelectKey;
  String _menuSelect = '';
  String _ordererSelect = '';
  String _ordererSelectKey;
  String _destSelect = '';
  int _prioritySelect;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 50.0,
                  ),
                  Text(
                    '신규 주문 등록',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('날짜'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(
                  '${DateFormat('yyyy-MM-dd').format(_daySelect)}'),
              SizedBox(
                height: 10.0,
              ),
              Text('시간'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(_timeSelect),
              SizedBox(
                height: 10.0,
              ),
              Text('가게'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(_storeSelect),
              SizedBox(
                height: 10.0,
              ),
              Text('메뉴'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(_menuSelect),
              SizedBox(
                height: 10.0,
              ),
              Text('주문자 선택'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(_ordererSelect),
              SizedBox(
                height: 10.0,
              ),
              Text('수령지 선택'),
              SizedBox(
                height: 5.0,
              ),
              _showContainer(_destSelect),
              SizedBox(
                height: 20.0,
              ),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _showContainer(String content) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1.0, color: Colors.grey[300]),
        color: Colors.grey[100],
      ),
      child: Center(
          child: Text(
        content,
        style: TextStyle(color: Colors.black87),
      )),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () async {

        if(_daySelect != '' && _timeSelect != '' && _storeSelect != '' && _menuSelect != '' && _destSelect != '' && _ordererSelect != ''){
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return MyProgressIndicator();
              },
              isDismissible: false,
              enableDrag: false);

          await firebaseNetwork.createNewOrder(
              orderKey: generateOrderKey(store: _storeSelect),
              store: _storeSelect,
              menu: _menuSelect,
              time: _timeSelect,
              dest: _destSelect,
              ordererKey: _ordererSelectKey,
              orderDay: _daySelect,
              priority: _prioritySelect);

          Navigator.pop(context);

          Navigator.pop(context);
        }
        else{
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Center(child: Text('적절하지 않은 order 양식입니다.'));
              },
              isDismissible: false,
              enableDrag: false);
          await Future.delayed(Duration(seconds: 2), (){});
          Navigator.pop(context);
        }


      },
      child: Text(
        '신규 주문 추가 (미작동으로 만듬)',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}
