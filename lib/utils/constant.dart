import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order/order_data.dart';
import '../model/order/order_detail_data.dart';
import '../model/order/place_order_data.dart';
import '../package/page_transition/enum.dart';
import '../package/page_transition/page_transition.dart';
import '../page/sign_in/sign_in_page.dart';
const MY_CART_KEY="Cart";
const TOKEN="TOKEN";
const ROLE="ROLE";
const ISTWOFACTORENABLED="ISTWOFACTORENABLED";
const ISINTROVISITED="ISINTROVISITED";
const SYMBOL="SYMBOL";
const CURENCYNAME="CURENCYNAME";
const COUNTRY="COUNTRY";
const CITY="CITY";
const ISNOTICOME="ISNOTICOME";
const ORDERID="ORDERID";
const DEVICETOKEN="DEVICETOKEN";


const backgroundColor=Color(0xFFEDF4F6);
const titleTextColor=Color(0xFF262324);
const descriptionTextColor=Color(0xFF989898);


var introTitleTextStyle=TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: titleTextColor);
var introDescriptionTextStyle=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: descriptionTextColor);
var introDescriptionTextStyle8=TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: descriptionTextColor);
var introDescriptionTextStyle5=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: descriptionTextColor,height: 1.5);
var introDescriptionTextStyle1=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF4FCC5D));
var introDescriptionTextStyle2=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF5364FF));
var homeTitleTextStyle=TextStyle(fontWeight: FontWeight.w700,fontSize: 33,color: Colors.white);
var detailPageDescTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white);
var homeDescriptionTextStyle= TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black);

var detailPageMinusTextStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xFFC4C4C4));
var detailPageCountTextStyle=TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xFF15375A));
var productListTitleTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF262324));
var formFieldTitleStyle=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF262324));
var productListDescTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: Color(0xFF989898),height: 2);
var productListPriceTextStyle= TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Color(0xFF15375A));
var productListOutTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white);
var productPageTitleTextStyle=TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: Color(0xFF262324));
var detailPageTitleTextStyle=TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Color(0xFF262324));
var detailPageHeadingTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF262324),height: 1.6);
var detailPageHeadingTextStyle1=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF262324));
var detailPageHeading4TextStyle= TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF989898),height: 1.6);
var detailPagePriceTextStyle= TextStyle(fontWeight: FontWeight.w700,fontSize: 18,color: Color(0xFFBC985C));
var detailPageButtonTextStyle=TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.white);
var cartPageHeadingTextStyle= TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xFF262324));
var cartPageHeadingTextStyle1= TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Color(0xFF262324));
var cartPageCountTextStyle= TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color(0xFF989898));
var cartPagePriceTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Color(0xFF262324));
var cartPagePriceTextStyle1=TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xFF262324),height: 2,decoration: TextDecoration.underline);
var cartPageContactTextStyle= TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF989898));
var cartPageContactTextStyle1=TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Color(0xFF989898),height: 2);
var cartPageSpinnerTextStyle=TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF15375A));
var confirmPageHeadingTextStyle= TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: Color(0xFF262324),);
var contactPageInfoStyle= TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xFF262324),);
var formFieldHintStyle=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF9E9EA8),);
var formFieldHintStyle1=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF737373),height: 1.5);
var formFieldHintStyle4= TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xFF989898),);
var productListPageTitleStyle= TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Color(0xFF262324),);
var productListPriceStyle= TextStyle(fontWeight: FontWeight.w700,fontSize: 18,color: Color(0xFFBC985C),);
var productListPageHintStyle= TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF989898),);
var productListButtonTextStyle= TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color:Colors.white,);
var productListToolTiptStyle=TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color:Colors.white,);
Future<void> saveBoolean(String keyword, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(keyword, value);
}

Future<void> saveString(String keyword, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(keyword, value);
}

Future<void> saveInt(String keyword, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(keyword, value);
}
Future<void> saveDouble(String keyword, double value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(keyword, value);
}

getStringPrefs(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString(keyword) ?? "";
}

getIntPrefs(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt(keyword) ?? 0;
}

getBooleanPref(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(keyword) ?? false;
}
getDoublePref(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getDouble(keyword) ?? 0.0;
}

clearPrefsData() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}
countJustTotal(PlaceData placeData){

  double total=0.0;
  total=double.parse(placeData.product!.customerPrice!)*int.parse(placeData.qty!);
  return total;
}
countJustDiscount(PlaceData placeData){
  var cal=0.0;
  if(placeData.coupon!.discount==null){
    return cal;
  }else{
    var discount=(double.parse(placeData.coupon!.discount!)/100);
    cal=countJustTotal(placeData)*discount;
    return cal;
  }

}
countJustFinalTotal(PlaceData placeData){
   return countJustTotal(placeData)-countJustDiscount(placeData)+double.parse(placeData.deliveryCharge!);
}

countJustTotal1(OrderDetail data,String role){

  double total=0.0;
  total=double.parse(role=="general"?data.product!.customerPrice!:data.product!.wholesalerPrice!)*int.parse(data.qty!);
  return total;
}

countJustDiscount1(OrderDetail data,String role){
  var cal=0.0;
  if(data.coupon!.discount==null){
    return cal;
  }else{
    var discount=(double.parse(data.coupon!.discount!)/100);
    cal=countJustTotal1(data,role)*discount;
    return cal;
  }

}
countJustFinalTotal1(OrderDetail data,String role){
  return countJustTotal1(data,role)-countJustDiscount1(data,role)+double.parse(data.deliveryCharge!);
}

countJustDiscountExport(String discount,String customerPrice,String wholesalePrice,String quantity,String role,){
  //discount
  double cal=0.00;
  if(discount=="0.00"){
    return cal;
  }else{
    var discount1=(double.parse(discount)/100);
    cal=countJustTotalExport(customerPrice,wholesalePrice,quantity,role)*discount1;
    return cal;
  }

}
countJustTotalExport(String customerPrice,String wholesalePrice,String quantity,String role){

  double total=0.00;
  total=double.parse(role=="general"?customerPrice:wholesalePrice)*int.parse(quantity);
  return total;
}
countJustFinalExport(String discount,String customerPrice,String wholesalePrice,String quantity,String role,String delivery){
  var total=countJustTotalExport(customerPrice,wholesalePrice,quantity,role)-countJustDiscountExport(discount,customerPrice,wholesalePrice,quantity,role)+double.parse(delivery);
  return total;
}

String orderTime(String time){
  var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(time);
  var localDateTime=dateTime.toLocal();
  var time1="${localDateTime.year}-${localDateTime.month}-${localDateTime.day} ${localDateTime.hour}:${localDateTime.minute}:${localDateTime.second}";
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var inputDate = inputFormat.parse(time1);
  var outputFormat = DateFormat('yyyy-MM-dd HH:mm aa');
  var outputDate = DateFormat.yMd().add_jm().format(inputDate);
  DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(time).toLocal();
  String formatedDateTime = DateFormat.yMd().add_jm().format(parsedDateFormat).toString();
  return formatedDateTime;
}
showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message.tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
showLoaderDialog(BuildContext context, String title) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: 10,
        ),
        Container(margin: EdgeInsets.only(left: 7), child: Text(title)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
countJustTotal9(Order data,String role){

  double total=0.0;
  total=double.parse(role=="general"?data.product!.customerPrice!:data.product!.customerPrice!)*int.parse(data.qty!);
  return total;
}
countJustDiscount9(Order data,String role){
  var cal=0.0;
  if(data.coupon!.discount==null){
    return cal;
  }else{
    var discount=(double.parse(data.coupon!.discount!)/100);
    cal=countJustTotal9(data,role)*discount;
    return cal;
  }

}
countJustFinalTotal9(Order data,String role,String deliveryCharge){
  return countJustTotal9(data,role)-countJustDiscount9(data,role)+double.parse(deliveryCharge);
}
Future<String> getApplicationPath() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return "${appDocDir.path}/division/";
}

Future<String> getFilePath(String fileName) async {
  final path = Directory("${await getApplicationPath()}$fileName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  return path.path;
}
// const imageBaseUrl="https://divisionco.com";
// const urlGetName="https://playerid.herokuapp.com/";
// const urlGetRegistrationFormData="https://divisionco.com/api/register";
// const urlLogin="https://divisionco.com/api/login";
// const urlHome="https://divisionco.com/api";
// const urlCategoryList="https://divisionco.com/api/category";
// const urlAddCart="https://divisionco.com/api/carts";
// const urlCheckOutData="https://divisionco.com/api/checkouts/create";
// const urlGetCity="https://divisionco.com/api/countries";
// const urlOrderConfirmation= "https://divisionco.com/api/orders/17/confirm";
// const urlGetProfile="https://divisionco.com/api/account/profile";
// const urlUpdatePassword="https://divisionco.com/api/account/password";
// const urlGetNotification="https://divisionco.com/api/notifications";
// const urlCouponsVerification="https://divisionco.com/api/coupons/verification";
// const urlDeleteCoupon="https://divisionco.com/api/coupons";
// const urlAddMoney="https://divisionco.com/api/wallets";
// const urlGetOrders="https://divisionco.com/api/orders";
// const urlGetFAQ="https://divisionco.com/api/faqs";
// const urlGetContactUs="https://divisionco.com/api/default-settings";
// const urlPostContact="https://divisionco.com/api/contacts";
// const urlGetTerms="https://divisionco.com/api/page/terms-and-conditions";
// const urlSendOtp="https://divisionco.com/api/forgot-password";
// const urlVerifyOtp="https://divisionco.com/api/verify-otp";
// const urlResetForgetPassword="https://divisionco.com/api/reset-password";
// const urlSentTwoFactorOtp="https://divisionco.com/api/two-factor-challenge";

countJustTotal111(OrderDetail data,String role){

  double total=0.0;
  total=double.parse(role=="general"?data.product!.customerPrice!:data.product!.customerPrice!)*int.parse(data.qty!);
  return total;
}

countJustDiscount111(OrderDetail data,String role){
  var cal=0.0;
  if(data.coupon!.discount==null){
    return cal;
  }else{
    var discount=(double.parse(data.coupon!.discount!)/100);
    cal=countJustTotal111(data,role)*discount;
    return cal;
  }

}
countJustFinalTotal111(OrderDetail data,String role,String deliveryCharge){
  return countJustTotal111(data,role)-countJustDiscount111(data,role)+double.parse(deliveryCharge);
}


const imageBaseUrl="https://divisionco.com";
const apiBaseUrl="https://divisionco.com/api";
const urlGetName="https://playerid.herokuapp.com/";
const urlGetRegistrationFormData="$apiBaseUrl/register";
const urlLogin="$apiBaseUrl/login";
const urlHome="$apiBaseUrl";
const urlStep="$apiBaseUrl";
const urlCategoryList="$apiBaseUrl/category";
const urlAddCart="$apiBaseUrl/carts";
const urlCheckOutData="$apiBaseUrl/checkouts/create";
const urlGetCity="$apiBaseUrl/countries";
const urlGetProfile="$apiBaseUrl/account/profile";
const urlUpdatePassword="$apiBaseUrl/account/password";
const urlGetNotification="$apiBaseUrl/notifications";
const urlCouponsVerification="$apiBaseUrl/coupons/verification";
const urlDeleteCoupon="$apiBaseUrl/coupons";
const urlAddMoney="$apiBaseUrl/wallets";
const urlGetOrders="$apiBaseUrl/orders";
const urlGetFAQ="$apiBaseUrl/faqs";
const urlGetContactUs="$apiBaseUrl/default-settings";
const urlPostContact="$apiBaseUrl/contacts";
const urlGetTerms="$apiBaseUrl/page/terms-and-conditions";
const urlSendOtp="$apiBaseUrl/forgot-password";
const urlVerifyOtp="$apiBaseUrl/verify-otp";
const urlResetForgetPassword="$apiBaseUrl/reset-password";
const urlSentTwoFactorOtp="$apiBaseUrl/two-factor-challenge";
const urlSearch="$apiBaseUrl/search";
const urlUpdateDeviceToken="$apiBaseUrl/account/fcm-device-token";
const urlPayment="$apiBaseUrl/temp-orders";
const urlDeviceWiseCategoryAndroid="$apiBaseUrl/categories?platform=android";
const urlDeviceWiseCategoryiOS="$apiBaseUrl/categories?platform=ios";
const urlCheckOutPaymentType="$apiBaseUrl/checkouts/cod-charge";
const urlDelete="$apiBaseUrl/account";
guestDialog(BuildContext context,String body) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "alert",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ).tr(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(

                      onPressed: (){
                        Navigator.of(context,rootNavigator: true).pop();
                      },
                      child: Text("cancel",style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF262324)
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF77CEDA)
                        ),
                        onPressed: ()async{

                          Navigator.of(context,rootNavigator: true).pop();
                          Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                        },
                        child: Text("login",style: TextStyle(color: Colors.white,fontSize: 14),).tr()),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      });
}
