import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constant/firestore_keys.dart';
import '../../model/order_model.dart';


class Transformers {


  final toOrder = StreamTransformer<DocumentSnapshot, OrderModel>.fromHandlers(
      handleData: (snapshot, sink) async {
        sink.add(OrderModel.fromSnapshot(snapshot));
      }
  );

  final toReadyOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_READY)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });

  final toPriorityStore = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {

    //dreamStones.sort((a,b)=>b.recentUpdateTime.compareTo(a.recentUpdateTime));
    orders.sort((a,b) => a.priority.compareTo(b.priority));

    sink.add(orders);

  });

  final toPriorityDest = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {

    // n e w
    orders.sort((a,b) {
      String _a = a.dest[0];
      String _b = b.dest[0];

      if(_a != _b ){
        if(_a  == 'n')
          return 1;
        else if(_a  == 'e'){
          if(_b == 'n')
            return -1;
          else
            return 1;
        }
        else
          return -1;
      }
      else
        return 0;
    });

    sink.add(orders);

  });


  final toDoingOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_DOING)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });

  final toDoneOrder = StreamTransformer<QuerySnapshot, List<OrderModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<OrderModel> orders = [];

    snapshot.docs.forEach((documentSnapshot) {
      if(documentSnapshot.data()[KEY_PROCESS] == KEY_DONE)
        orders.add(OrderModel.fromSnapshot(documentSnapshot));
    });

    sink.add(orders);
  });


  final toKeys = StreamTransformer<DocumentSnapshot, List<dynamic>>.fromHandlers(handleData: (snapshot, sink) async {
    sink.add(snapshot.data()[KEY_PRIORITY]);
  });

}