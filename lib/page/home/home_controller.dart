
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/device_wise_data.dart';
import '../../model/home/home_data.dart';

class HomeController extends GetxController{
  var loading=true.obs;
  var homeData=HomeData().obs;
  var list=<DeviceWiseData>[].obs;
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
    var list1=<DeviceWiseData>[];
    try {
      getHomeData().then((resp) {
        homeData.value = resp;
        getHomeDeviceWiseData().then((resp1) {
          list1.addAll(resp1.data!);
          list.value=list1;
          loading(false);
        });

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