

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/notification/notification_data.dart';

class NotificationController extends GetxController{
  var notificationData=<NotificationList>[].obs;
  var loading=false.obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  void getData(var load){
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    var notificationData1=<NotificationList>[];
    try{
      getNotificationData().then((resp) {
        notificationData1.addAll(resp.data);
        notificationData.value=notificationData1;
        loading(false);
      },onError: (e){
        loading(false);
        if(e.toString()=="Exception: internet"){
          internetError(true);
        }
        if(e.toString()=="Exception: something"){
          somethingWrong(true);
        }
        if(e.toString()=="Exception: server"){
          serverError(true);
        }
        if(e.toString()=="Exception: timeout"){
          timeoutError(true);
        }else {
          serverError(true);
        }

      });
    }catch(e){
      loading(false);
      somethingWrong(true);
    }
  }

}