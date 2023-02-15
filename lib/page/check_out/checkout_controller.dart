import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/cart_model/cart_data.dart';

class CheckoutController extends GetxController{
  var loading=false.obs;

  var countryList=<Countries>[];
  var cart=Cart().obs;
  var quantity=0.obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var subtotal="".obs;
  var discount="".obs;
  var deliveryCharge="0".obs;
  var total="".obs;

  void getData(var load){
    loading(load);
    countryList.clear();
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getCheckOutData().then((resp) {
        countryList.addAll(resp.countries!);

        cart.value = resp.cart!;
        subtotal.value=cart.value.subtotal.toString();
        discount.value=cart.value.discount.toString();
        total.value=cart.value.total.toString();
        quantity.value = int.parse(resp.cart!.qty!);
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