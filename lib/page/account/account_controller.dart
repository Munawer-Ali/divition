

import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/api_call.dart';
import '../../model/city/city_data.dart';
import '../../model/registration/registration_form_data.dart';
import '../../utils/constant.dart';

class AccountController extends GetxController{
  var loading=false.obs;
  late TextEditingController fName;
  late TextEditingController lName;
  var profileImage="".obs;
  late TextEditingController mobile;
  late TextEditingController email;
  late TextEditingController store;
  var countryId;
  var cityId;
  var countryList=<Countries>[].obs;
  var cityList=<City>[].obs;
  var frontImageSignUp;
  File? frontImageSignUp1;
  final picker = ImagePicker();
  var twoFactor=1.obs;
  var messgae="Loading profile data...".obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var wallet="0.0".obs;
  var symbol="₪".obs;
  var token="".obs;
  @override
  void onInit(){
    super.onInit();
    fName=TextEditingController(text: "");
    lName=TextEditingController(text: "");
    mobile=TextEditingController(text: "");
    email=TextEditingController(text: "");
    store=TextEditingController(text: "");
    getToken();
    getData(true);

  }
  @override
  void onClose(){
    super.onClose();
    fName.dispose();
    lName.dispose();
    mobile.dispose();
    email.dispose();
    store.dispose();
  }
  getToken()async{
    token.value=await getStringPrefs(TOKEN);
  }
  void getData(var load){
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getProfileData().then((resp) async{
        try {
          profileImage.value = resp.data!.avatar!;
          fName.text = resp.data!.firstName!;
          lName.text = resp.data!.lastName!;
          mobile.text = resp.data!.phone!;
          email.text = resp.data!.email!;
          countryId = resp.data!.country!.id!;
          cityId = resp.data!.city!.id!;
          if (resp.data!.store == null) {
            store.text = "";
          } else {
            store.text = resp.data!.store!;
          }
          await saveString(COUNTRY, resp.data!.country!.name!);
          await saveString(CITY, resp.data!.city!.name!);
          await saveString(SYMBOL, resp.data!.country!.symbol ?? "₪");
          twoFactor.value = int.parse(resp.data!.twoFactorEnabled!);
          var wal = double.parse(resp.data!.walletAmount!);
          wallet.value = wal.toStringAsFixed(2);
          symbol.value = resp.data!.country!.symbol ?? "₪";
          getCountryList();
        }catch(e){
          print(e);
        }
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
  void getCountryList(){
    countryList.clear();
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getRegistrationFormData().then((resp) {
        countryList.addAll(resp.countries!);
        getCityList(countryId);
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

  void getCityList(countryId) {
    cityList.clear();
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getCityData(countryId.toString()).then((resp) {
        cityList.addAll(resp.data!);
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
  Future<void> getGalleryImageSignUp() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        frontImageSignUp1 = File(pickedFile.path);
        _cropFrontImage(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    }on PlatformException catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
    update();
  }
  _cropFrontImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1000,
      maxWidth: 1000,
      compressQuality: 80,
      uiSettings: [
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),

      ],
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    if (croppedImage != null) {
      frontImageSignUp = croppedImage;

      update();

    }else{
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }
}