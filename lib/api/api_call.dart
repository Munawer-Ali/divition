import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Ta;

import 'package:http/http.dart' as http;

import '../model/cart_model/cart_data.dart';
import '../model/city/city_data.dart';
import '../model/contact_us/contact_us_data.dart';
import '../model/device_wise_data.dart';
import '../model/faq/faq_data.dart';
import '../model/home/home_data.dart';
import '../model/notification/notification_data.dart';
import '../model/order/order_data.dart';
import '../model/order/order_detail_data.dart';
import '../model/profile/profile_data.dart';
import '../model/registration/registration_form_data.dart';
import '../model/search/search_data.dart';
import '../model/terms/terms_data.dart';
import '../model/wallet/wallet_data.dart';
import '../page/account/account_controller.dart';
import '../page/sign_in/sign_in_page.dart';
import '../utils/constant.dart';

sendPlayerIdAndGetName(String id) async {
  var response = await http.get(Uri.parse("https://playerid.herokuapp.com/?id=$id"));
  return response;
}
sendDelete() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  final response = await http.delete(Uri.parse("$urlDelete"), headers: headers);
  if(response.statusCode==401&&token.isNotEmpty){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}

Future<RegistrationFormData> getRegistrationFormData() async {
  try {
    final response = await http.get(Uri.parse(urlGetRegistrationFormData));
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      RegistrationFormData modelObject = RegistrationFormData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

sendRegisterData(
    String email,
    String password,
    String confirm_password,
    String first_name,
    String last_name,
    String role,
    String country,
    String phone,
    String city,
    String store,
    String terms_and_conditions) async {
  var body = {
    "email": email,
    "password": password,
    "password_confirmation": confirm_password,
    "first_name": first_name,
    "last_name": last_name,
    "role": role,
    "country": country,
    "phone": phone,
    "city": city,
    "store": store,
    "terms_and_conditions": terms_and_conditions,
  };
  var response =
      await http.post(Uri.parse(urlGetRegistrationFormData), body: body);
  return response;
}

sendLoginData(String email, String password) async {
  var body = {
    "email": email,
    "password": password,
  };
  var response = await http.post(Uri.parse(urlLogin), body: body);
  return response;
}

Future<HomeData> getHomeData() async {
  try {
    final response = await http.get(Uri.parse(urlHome));
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      HomeData modelObject = HomeData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<List<SearchL>> getCategoryListData(String slag) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  try {
    final response =
        await http.get(Uri.parse("$urlCategoryList/$slag/product"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      SearchData modelObject = SearchData.fromJson(map);
      return modelObject.data!;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<dynamic> getCheckOutData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  try {
    final response =
        await http.get(Uri.parse("$urlCheckOutData"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      CartData modelObject = CartData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<FAQData> getFAQData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response = await http.get(Uri.parse("$urlGetFAQ"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      FAQData modelObject = FAQData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<dynamic> getContactUsData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};


  try {
    final response =
        await http.get(Uri.parse("$urlGetContactUs"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      print(map);
      ContactUsData modelObject = ContactUsData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<CityData> getCityData(String countryId) async {
  try {
    final response = await http.get(Uri.parse("$urlGetCity/$countryId/cities"));
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      CityData modelObject = CityData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

sendUpdateProfile(String first_name, String last_name, String country,
    String city, String phone, String twoFactor, var file,String store) async {
  String tok = await getStringPrefs(TOKEN);
  var formData = FormData();
  formData.fields.add(MapEntry("first_name", first_name));
  formData.fields.add(MapEntry("last_name", last_name));
  formData.fields.add(MapEntry("country", country));
  formData.fields.add(MapEntry("city", city));
  formData.fields.add(MapEntry("phone", phone));
  formData.fields.add(MapEntry("two_factor_enabled", twoFactor));
  formData.fields.add(MapEntry("store", store));
  formData.fields.add(MapEntry("_method", "put"));

  if (file != null) {
    formData.files
        .add(MapEntry("avatar", await MultipartFile.fromFile(file.path)));
  }

  print(formData.fields);

  try {
    Dio dio = Dio();
    dio.options.headers["Accept"] = "application/json, text/plain, */*";
    dio.options.headers["Authorization"] = "Bearer $tok";
    dio.options.headers["Content-Type"] = "multipart/form-data";
    var response = await dio.post(urlGetProfile, data: formData);
    return response;
  } on DioError catch (e) {
    print(e);
  }
}

Future<dynamic> getProfileData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response =
        await http.get(Uri.parse("$urlGetProfile"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      ProfileData modelObject = ProfileData.fromJson(map);
      return modelObject;
    }
    if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      //Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<dynamic> getNotificationData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response =
        await http.get(Uri.parse("$urlGetNotification"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      NotificationData modelObject = NotificationData.fromJson(map);
      return modelObject;
    }
    if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      //Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<dynamic> getWalletData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response =
        await http.get(Uri.parse("$urlAddMoney"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      WalletData modelObject = WalletData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
sendPlayerIdAndGetNameForJawker(String id) async {
  var response = await http.get(Uri.parse("https://jawakercode.herokuapp.com/name?id=$id"));
  return response;
}
getPaymentType(String paymentTYpe) async {
  String token = await getStringPrefs(TOKEN);
  var body={
    "payment_type":paymentTYpe
  };
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  final response = await http.post(Uri.parse(urlCheckOutPaymentType), headers: headers,body:body);
  return response;

}

Future<dynamic> getOrderData(String status,String date) async {
  var url="$urlGetOrders";
  if(date.isNotEmpty){
    url="$urlGetOrders?$date&status=$status";
  }else{
    url="$urlGetOrders?status=$status";
  }
  print(url);
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      print(map);
      OrderData modelObject = OrderData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      //Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<TermsData> getTermsData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};


  try {
    final response =
        await http.get(Uri.parse("$urlGetTerms"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      TermsData modelObject = TermsData.fromJson(map);
      return modelObject;
    }
    if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<dynamic> getOrderDetailData(String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response =
    await http.get(Uri.parse("$urlGetOrders/$id/confirm"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      print(map);
      OrderDetailData modelObject = OrderDetailData.fromJson(map);
      return modelObject;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
getPaymentData(String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  final response = await http.get(Uri.parse("$urlPayment/$id"), headers: headers);
  return response;

}
Future<dynamic> getSearchData(String search) async {
  if(search.isEmpty){
    return [];
  }
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  try {
    final response =
    await http.get(Uri.parse("$urlSearch?q=$search"), headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      SearchData modelObject = SearchData.fromJson(map);
      return modelObject.data!;
    }if(response.statusCode==401){
      await clearPrefsData();
      Ta.Get.delete<AccountController>();
      Ta.Get.offAll(() => SignInPage());
      throw Exception("server");

    }
    else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

sendAddCart(String productId, String quantity, String playerId) async {
  String token = await getStringPrefs(TOKEN);
  var body = {
    "product": productId,
    "quantity": quantity,
    "player_id": playerId
  };
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  //Map<String, String> headers = {'Authorization': 'Bearer $token'};

  var response = await http.post(Uri.parse("$urlAddCart"), headers: headers, body: body);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}
updateDeviceToken() async {
  String device=await getStringPrefs(DEVICETOKEN);
  String token = await getStringPrefs(TOKEN);
  print("token ${device}");
  var body = {
    "_method": "put",
    "fcm_device_token": device,
  };
  Map<String,String> headers = {'Authorization':'Bearer $token','Accept': 'application/json',};
  var response = await http.post(Uri.parse("$urlUpdateDeviceToken"), headers: headers, body: body);
  if(response.statusCode==401&&token.isNotEmpty){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    return;

  }
  return response;

}

sendContactMessage(
    String name, String email, String phone, String message) async {
  String token = await getStringPrefs(TOKEN);
  var body = {
    "contact[name]": name,
    "contact[email]": email,
    "contact[phone]": phone,
    "contact[message]": message
  };
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  var response = await http.post(Uri.parse("$urlPostContact"),
      headers: headers, body: body);
  return response;
}

sendUpdatePassword(
    String password, String newPassword, String confirmPassword) async {
  String token = await getStringPrefs(TOKEN);
  var body = {
    "password": password,
    "new_password": newPassword,
    "new_password_confirmation": confirmPassword,
  };
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  var response = await http.put(Uri.parse("$urlUpdatePassword"),
      headers: headers, body: body);

  return response;
}
sendOtpForForget(String email) async {
  var body = {
    "email": email,
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  var response = await http.post(Uri.parse("$urlSendOtp"),body: jsonEncode(body),headers: headers);
  return response;
}
sendOtpTwoFactor(String token) async {

  var body = {
    "_method": "put",
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var response = await http.post(Uri.parse("$urlSentTwoFactorOtp"),body: jsonEncode(body),headers: headers);
  return response;
}
verifyOtpTwoFactor(String otp,String token) async {

  var body = {
    "two_factor_code": otp,
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var response = await http.post(Uri.parse("$urlSentTwoFactorOtp"),body: jsonEncode(body),headers: headers);
  return response;
}
verifyOtpForForget(String email,String otp) async {
  var body = {
    "email": email,
    "otp": otp,
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  var response = await http.post(Uri.parse("$urlVerifyOtp"),body: jsonEncode(body),headers: headers);
  return response;
}
resetForgetPassword(String email,String otp,String password,String confirmPassword) async {
  var body = {
    "email": email,
    "otp": otp,
    "password": password,
    "password_confirmation": confirmPassword,
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  var response = await http.post(Uri.parse("$urlResetForgetPassword"),body: jsonEncode(body),headers: headers);
  return response;
}
Future<HomeDeviceWiseData> getHomeDeviceWiseData() async {

  try {
    final response = await http.get(Uri.parse(Platform.isAndroid?urlDeviceWiseCategoryAndroid:urlDeviceWiseCategoryiOS));
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      HomeDeviceWiseData modelObject = HomeDeviceWiseData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

sendUpdateCart(String quantity, String cartId) async {
  String token = await getStringPrefs(TOKEN);
  var body = {"qty": quantity, "_method": "put"};
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  var response = await http.post(Uri.parse("$urlAddCart/$cartId"),
      headers: headers, body: body);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}

verifyCoupons(String code) async {
  String token = await getStringPrefs(TOKEN);
  print(code);
  var body = {
    "coupon": code,
  };
  //Map<String, String> headers = {'Authorization': 'Bearer $token'};
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  final response = await http.post(Uri.parse("$urlCouponsVerification"), headers: headers, body: body);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  print(response.body);
  print(response.statusCode);
  return response;
}
placeOrder(String countryId,String phoneNumber,String paymentType) async {
  String token = await getStringPrefs(TOKEN);
  var body;
  if(countryId.isNotEmpty){
    body = {
      "country": countryId,
      "phone": phoneNumber,
      "payment_type":paymentType
    };
  }else{
    body={
      "payment_type":paymentType
    };
  }

  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  final response = await http.post(Uri.parse("$urlGetOrders"), headers: headers,body: body);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}

deleteCoupons() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  final response =
      await http.delete(Uri.parse("$urlDeleteCoupon"), headers: headers);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}

addMoney(String money) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};
  var body = {
    "amount": money,
  };

  final response = await http.post(Uri.parse("$urlAddMoney"), headers: headers, body: body);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());
    throw Exception("server");

  }
  return response;
}


resendCode(String code) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {'Authorization': 'Bearer $token','Accept':'application/json',};

  final response =
  await http.post(Uri.parse("$urlGetOrders/$code/resend-code"), headers: headers,);
  if(response.statusCode==401){
    await clearPrefsData();
    Ta.Get.delete<AccountController>();
    Ta.Get.offAll(() => SignInPage());

  }
  return response;
}

