import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screen/create_order.dart';
import '../network/network_function.dart';
import '../useful/search_engine.dart';
import '../widgets/my_progress_indicator.dart';
import '../widgets/order_item.dart';
import '../model/order_model.dart';
import '../widgets/day_dialog.dart';
import '../constant/size.dart';
import 'package:provider/provider.dart';

class SetScreen extends StatefulWidget {
  @override
  _SetScreenState createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {

  DateTime _daySelect;

  @override
  void initState() {
    _daySelect = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.2),
            child: InkWell(
              onTap: dialogDay,
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 1.0, color: Colors.grey[300]),
                  color: Colors.grey[50],
                ),
                child: Center(
                    child: Text(
                      '${DateFormat('yyyy-MM-dd').format(_daySelect)}',
                      style: TextStyle(color: Colors.black87, fontSize: 20.0),
                    )),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateOrderScreen()));
            },
            child: Container(
              height: 60.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 1.0, color: Colors.grey[300]),
                color: Colors.grey[50],
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.grey)]
              ),
            child: Center(child: Text('주문 추가 [1개씩]', style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),)),),
          ),
          SizedBox(height: 15.0,),
          InkWell(
            onTap: setOrder,
            child: Container(
              height: 30.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 1.0, color: Colors.grey[300]),
                  color: Colors.grey[50],
                  boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.grey)]
              ),
              child: Center(child: Text('엑셀 양식으로 주문 추가', style: TextStyle(color: Colors.green, fontSize: 15.0, fontWeight: FontWeight.bold),)),),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
              SizedBox(
                  width: size.width*0.25,
                  height: size.height*0.5 + 100.0,
                  child: ReadyOrder()),
              SizedBox(
                  width: size.width*0.25,
                  height: size.height*0.5 + 100.0,
                  child: DoingOrder()),
              SizedBox(
                  width: size.width*0.25,
                  height: size.height*0.5 + 100.0,
                  child: DoneOrder()),
            ],
          )

        ],
      )
    ));
  }

  Widget ReadyOrder(){
    return StreamProvider<List<OrderModel>>.value(
      value: firebaseNetwork.getOrdersReady(_daySelect),
      child: Consumer<List<OrderModel>>(
        builder: (context, orders, _){
          if(orders == null){
            return MyProgressIndicator();
          }
          else {
            return Column(
              children: [
                Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(width: 1.0, color: Colors.grey[300]),
                    color: Colors.white,
                  ),
                  child: Center(child: Text('준비중 (${orders.length})', style: TextStyle(color: Colors.lightGreen, fontSize: 15.0, fontWeight: FontWeight.bold),)),),
                SizedBox(height: 20.0,),
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){

                      if(/*&& widget.selTime == '종일' || widget.selTime == orders[index].time*/true){
                        return OrderItem(
                          orderModel: orders[index],
                        );}


                  }, itemCount: orders.length,),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget DoingOrder(){
    return StreamProvider<List<OrderModel>>.value(
      value: firebaseNetwork.getOrdersDoing(_daySelect),
      child: Consumer<List<OrderModel>>(
        builder: (context, orders, _){
          if(orders == null){
            return MyProgressIndicator();
          }
          else {
            return Column(
              children: [
                Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(width: 1.0, color: Colors.grey[300]),
                    color: Colors.white,
                  ),
                  child: Center(child: Text('진행중 (${orders.length})', style: TextStyle(color: Colors.lightBlue, fontSize: 15.0, fontWeight: FontWeight.bold),)),),
                SizedBox(height: 20.0,),
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){

                    if(/*&& widget.selTime == '종일' || widget.selTime == orders[index].time*/true){
                      return OrderItem(
                        orderModel: orders[index],
                      );}


                  }, itemCount: orders.length,),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget DoneOrder(){
    return StreamProvider<List<OrderModel>>.value(
      value: firebaseNetwork.getOrdersDone(_daySelect),
      child: Consumer<List<OrderModel>>(
        builder: (context, orders, _){
          if(orders == null){
            return MyProgressIndicator();
          }
          else {
            return Column(
              children: [
                Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(width: 1.0, color: Colors.grey[300]),
                    color: Colors.white,
                  ),
                  child: Center(child: Text('완료 (${orders.length})', style: TextStyle(color: Colors.red, fontSize: 15.0, fontWeight: FontWeight.bold),)),),
                SizedBox(height: 20.0,),
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){

                    if(/*&& widget.selTime == '종일' || widget.selTime == orders[index].time*/true){
                      return OrderItem(
                        orderModel: orders[index],
                      );}


                  }, itemCount: orders.length,),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void transferOrder(String data) async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _orderController = TextEditingController();
        return AlertDialog(
          content: SafeArea(
              child: Text(data)
          ),
          actions: [
            TextButton(
              child: Text("등록하기(미구현)", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.pop(context); // 변환 후 화면
                Navigator.pop(context); // 글 등록 화면
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: (){
                Navigator.pop(context); // 변환 후 화면
                Navigator.pop(context); // 글 등록 화면
              },
            )
          ],);
      },
    );

  }


  void setOrder() async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _orderController = TextEditingController();
        return AlertDialog(
            content: SafeArea(
            child: TextField(
              controller: _orderController,

            )
        ),
        actions: [
          TextButton(
            child: Text("변환하기(미구현)", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            onPressed: (){
              transferOrder(_orderController.text);
            },
          ),
          TextButton(
            child: Text('취소'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],);
      },
    );
  }

  void dialogDay() async {
    await showDialog(
      context: context,
      builder: (context) {
        return DaySelectDialog(selDay: (DateTime dateTime) {
          setState(() {
            _daySelect = dateTime;
          });
        });
      },
    );
  }
}
