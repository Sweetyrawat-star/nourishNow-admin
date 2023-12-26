import 'dart:convert';
import 'package:admin/models/order_model.dart';
import 'package:admin/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;


class OrdersController extends GetxController {
  @override
  void onInit() async{
    super.onInit();
    // TODO: implement onInit
    getToken();
    await getOrders();
    listenToChanges();
    listenToNotification();
  }

  bool loading = false;
  void listenToNotification(){
    FirebaseMessaging.onMessage.listen((event) {
      if(event.notification!=null) {
      }
    });
  }



  List<OrderModel> inProcessOrders = [];
  List<OrderModel> pendingOrders = [];
  List<OrderModel> declinedOrders = [];
  List<OrderModel> deliveredOrders = [];
  List<OrderModel> allOrders=[];


  Future<void> getOrders() async{

    loading=true;
    update();
    await  FirebaseFirestore.instance.collectionGroup('orders').orderBy("time",descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Map<String, dynamic> temp=element.data();
        switch(temp['state'].toLowerCase()){
          case 'pending':
            pendingOrders.add(OrderModel.fromJson(temp));
            break;
          case 'in process':
            inProcessOrders.add(OrderModel.fromJson(temp));
            break;
          case 'delivered':
            deliveredOrders.add(OrderModel.fromJson(temp));
            break;
          case 'declined':
            declinedOrders.add(OrderModel.fromJson(temp));
            break;
        }
        allOrders.add(OrderModel.fromJson(temp));
      }
    })
        .catchError((error) {
      debugPrint(error.toString());
    });
    loading=false;
    update();
  }

  void listenToChanges() {
    FirebaseFirestore.instance.collectionGroup('orders').snapshots()
        .listen((querySnapshot) {

      for (var change in querySnapshot.docChanges) {
        OrderModel order=OrderModel.fromJson(change.doc.data()!);
        if(change.type==DocumentChangeType.added&&allOrders.firstWhereOrNull((element) => element.id==order.id)==null) {
            pendingOrders.insert(0, order);
            update();
            Get.snackbar("Order", "a new order has been added",
                colorText: Colors.green);
            sendNotification(title: "Order", myBody: "a new order has been added");
          }
        else if(change.type==DocumentChangeType.modified&&order.state.toLowerCase()=="canceled"){
          pendingOrders.removeWhere((element) => element.id==order.id);
          update();
          Get.snackbar("Order", "an order has been canceled",
              colorText: Colors.green);
        }

      }
    }, onError: (error) {
      debugPrint(error.toString());
    });
  }


  Future<void> getToken()async{
    await FirebaseMessaging.instance.getToken()
        .then((token) {
      AppConstants.token=token??"";
    })
        .catchError((e)
    {
      debugPrint(e.toString());
    });
  }

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> sendNotification({required String title, required String myBody}) async {
    try {
      // Set the FCM endpoint URL
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      // Set the FCM server key
      final serverKey = AppConstants.serverKey;

      // Set the notification payload
      final notificationPayload = <String, dynamic>{
        'title': title,
        'body': myBody,
      };

      // Set the data payload
      final dataPayload = <String, dynamic>{
        'via': 'FlutterFire Cloud Messaging!!!',
      };

      // Set the request headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      // Set the request body
      final body = jsonEncode(<String, dynamic>{
        'notification': notificationPayload,
        'data': dataPayload,
        'to': AppConstants.token,
        'priority': 'high',
      });

      // Send the HTTP request
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully');
      } else {
        debugPrint('Error sending notification: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  Future<void> updateState(OrderModel orderModel ,{ String state=" ",bool delete=false})async{
    await FirebaseFirestore.instance.collectionGroup("orders").where("id",isEqualTo: orderModel.id).get().then((value)async {

      if(!delete) {
        for (var element in value.docs)  {
        await element.reference.update({"state":state});
      }
        if(state=="declined"){
          if(orderModel.state.toLowerCase()=="pending"){
            pendingOrders.removeWhere((element) => element.id==orderModel.id);
            orderModel.state=state;
            declinedOrders.insert(0, orderModel);
          }
          else if(orderModel.state.toLowerCase()=="in process"){
            inProcessOrders.removeWhere((element) => element.id==orderModel.id);
            orderModel.state=state;
            declinedOrders.insert(0, orderModel);
          }
        }
        else if(state=="in process"){
          pendingOrders.removeWhere((element) => element.id==orderModel.id);
          orderModel.state=state;
          inProcessOrders.insert(0, orderModel);
        }
        else{
          inProcessOrders.removeWhere((element) => element.id==orderModel.id);
          orderModel.state=state;
          deliveredOrders.insert(0, orderModel);
        }
      }else{
        for (var element in value.docs){

          await element.reference.delete();
        }
        if(orderModel.state.toLowerCase()=="declined"){
          declinedOrders.removeWhere((element) => element.id==orderModel.id);
        }
        else{
          deliveredOrders.removeWhere((element) => element.id==orderModel.id);
        }
        update();
      }


    }).catchError((error){
      debugPrint(error.toString());
    });
    update();
  }

}