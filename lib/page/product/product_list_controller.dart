
import 'package:get/get.dart';

import '../../api/api_call.dart';
import '../../model/search/search_data.dart';

class ProductListController extends GetxController{
 var categoryList=<SearchL>[].obs;
 var loading=false.obs;
 var internetError=false.obs;
 var somethingWrong=false.obs;
 var serverError=false.obs;
 var timeoutError=false.obs;
 void getData(var load,var slag){
   loading(load);
   internetError(false);
   serverError(false);
   somethingWrong(false);
   timeoutError(false);
   var list=<SearchL>[];
   try {
     getCategoryListData(slag).then((resp) {
       list.addAll(resp);
       categoryList.value = list;
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



