
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/terms/terms_data.dart';

class TermsController extends GetxController{
  var notificationData=TermsData().obs;
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
    try{
      getTermsData().then((resp) {
        notificationData.value=resp;
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