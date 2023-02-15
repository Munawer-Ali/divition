import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/intro/intro_data.dart';
import '../../utils/constant.dart';
class IntroController extends GetxController{
  var steps=<Steps>[].obs;
  var loading=false.obs;
  @override
  void onInit(){
    super.onInit();
    getData();
  }
  void getData()async{
    steps.clear();
    loading(true);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

      final response =
          await http.get(Uri.parse("$urlStep"), headers: headers);
      if (response.statusCode == 200) {
        var map = json.decode(response.body);
        StepsData modelObject = StepsData.fromJson(map);
        steps.addAll(modelObject.content!.steps!);
        loading(false);
      } else if (response.statusCode == 500) {
        throw Exception("server");
      } else {
        throw Exception("something");
      }
    }

}