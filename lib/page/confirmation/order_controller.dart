
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/order/order_detail_data.dart';

class OrderDetailController extends GetxController{
  var loading=true.obs;
  var data=OrderDetailData().obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  void getOrderDetail(var load,String id){
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getOrderDetailData(id).then((resp) {
        data.value = resp;
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