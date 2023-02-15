
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/search/search_data.dart';

class SearchController extends GetxController{
  var order=<SearchL>[].obs;
  var loading=false.obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  void getData(var load,var query){
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    var order1=<SearchL>[];
    try{
      getSearchData(query).then((resp) {
        if(resp.isEmpty){
          loading(false);
          return;
        }
        order1.addAll(resp);
        order.value=order1;
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
      }
      );
    }catch(e){
      loading(false);
      somethingWrong(true);
    }
  }
}