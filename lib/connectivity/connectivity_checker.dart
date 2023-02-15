
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityCheckerController extends GetxController{
  Connectivity connectivity=Connectivity();
  var isOnline=false.obs;

  @override
  void onInit() {
    startMonitoring();
    super.onInit();
  }

  startMonitoring()async{
    await initConnectivity();
    connectivity.onConnectivityChanged.listen((status) async{
      if(status==ConnectivityResult.none){
        isOnline.value=false;

      }else{
        await updateConnectionStatus().then((value){
          isOnline.value=value;
        });
      }
    });

  }
  Future<bool> updateConnectionStatus() async{
    bool isConnected=false;
    try{
      final List<InternetAddress> result=await InternetAddress.lookup("google.com");
      if(result.isNotEmpty&&result[0].rawAddress.isNotEmpty){
        isConnected=true;
        update();

      }
    }on SocketException catch(_){
      isConnected=false;
      update();
    }
    return isConnected;

  }
  Future<void> initConnectivity() async{
    try{
      var status=await connectivity.checkConnectivity();
      if(status==ConnectivityResult.none){
        isOnline.value=false;
      }else{
        isOnline.value=true;
      }
    }on PlatformException catch(e){
      print(e.toString());
    }
  }
}