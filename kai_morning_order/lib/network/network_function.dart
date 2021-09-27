import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../useful/search_engine.dart';

import '../constant/firestore_keys.dart';

import '../model/order_model.dart';
import 'helper/transformer.dart';

class FirebaseNetwork with Transformers{
  Future<void> createNewOrder({
    @required String orderKey,
    @required String store,
    @required String menu,
    @required String time,
    @required String dest,
    @required String ordererKey,
    @required DateTime orderDay,
    @required int priority,
  }) async {
    final DocumentReference orderRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS).doc(orderKey);

    DocumentSnapshot snapshot = await orderRef.get();

    if(!snapshot.exists){
      return await orderRef.set(OrderModel.getMapForCreateOrder(
          orderKey: orderKey,
          store: store,
          menu: menu,
          time: time,
          dest: dest,
          ordererKey: ordererKey,
          orderDay: orderDay,
          priority: priority
      ));
    }
  }


  Stream<List<OrderModel>> getOrdersReady(DateTime daySelect) {

    final toSelDay = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {
      List<OrderModel> temp = [];

      orders.forEach((element) {
        if(SearchEngine.isSameDay(element.orderDay, daySelect))
          temp.add(element);
      });

      sink.add(temp);
    });

    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toReadyOrder).transform(toSelDay);
        //.transform(toReadyOrder).transform(toPriorityStore);
  }

  Stream<List<OrderModel>> getOrdersDoing(DateTime daySelect) {
    final toSelDay = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {
      List<OrderModel> temp = [];

      orders.forEach((element) {
        if(SearchEngine.isSameDay(element.orderDay, daySelect))
          temp.add(element);
      });

      sink.add(temp);
    });

    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toDoingOrder).transform(toSelDay);
    //.transform(toDoingOrder).transform(toPriorityDest);
  }

  Stream<List<OrderModel>> getOrdersDone(DateTime daySelect) {
    final toSelDay = StreamTransformer<List<OrderModel>, List<OrderModel>>.fromHandlers(handleData: (orders, sink) async {
      List<OrderModel> temp = [];

      orders.forEach((element) {
        if(SearchEngine.isSameDay(element.orderDay, daySelect))
          temp.add(element);
      });

      sink.add(temp);
    });

    return FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS)
        .snapshots()
        .transform(toDoneOrder).transform(toSelDay);
  }

  Future<void> changeOrderProcess({@required String orderKey, @required String process}) async {

    final DocumentReference orderRef = FirebaseFirestore.instance.collection(COLLECTION_HOME).doc(DOCUMENT_ADMIN).collection(COLLECTION_ORDERS).doc(orderKey);
    final DocumentSnapshot orderSnapshot = await orderRef.get();

    if(orderSnapshot.exists){
      switch(process){
        case KEY_READY:
          await orderRef.update({KEY_PROCESS: KEY_READY});
          break;

        case KEY_DOING:
          await orderRef.update({KEY_PROCESS: KEY_DOING});
          break;

        case KEY_DONE:
          await orderRef.update({KEY_PROCESS: KEY_DONE});
          break;

        default:
          break;
      }
    }
  }

}

FirebaseNetwork firebaseNetwork = FirebaseNetwork();