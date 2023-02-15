
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/wallet/wallet_data.dart';

class WalletController extends GetxController{
  var wallet=<Wallet>[].obs;
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
    var data=<Wallet>[].obs;
    try {
      getWalletData().then((resp) {
        data.addAll(resp.data!);
        wallet.value = data;
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
