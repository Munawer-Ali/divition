
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/city/city_data.dart';
import '../../model/registration/registration_form_data.dart';

class SignUpController extends GetxController{
  var formData=RegistrationFormData().obs;
  var loading=true.obs;
  var cityData=CityData().obs;
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
      getRegistrationFormData().then((resp) {
        formData.value=resp;
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
  void getCity(String countryId){
    loading(true);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getCityData(countryId).then((resp) {
        cityData.value = resp;
        loading(false);
      }, onError: (e) {
        loading(false);
        if (e.toString() == "Exception: internet") {
          internetError(true);
        }
        if (e.toString() == "Exception: something") {
          somethingWrong(true);
        }
        if (e.toString() == "Exception: server") {
          serverError(true);
        }
        if (e.toString() == "Exception: timeout") {
          timeoutError(true);
        } else {
          serverError(true);
        }
      });
    }catch(e){
      loading(false);
      somethingWrong(true);
    }
  }
}