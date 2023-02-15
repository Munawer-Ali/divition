import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../model/cart_model/cart_model_item.dart';
import '../../utils/constant.dart';

class CartController extends GetxController{
  var cart=List<CartModel>.empty(growable: true).obs;
  var loading=true.obs;
  var couponId=0.obs;
  var radioValue=2.obs;
  var tax=0.obs;
  var deliveryCharge=0.obs;
  late TextEditingController promoCodeController,addressController;
  var discountAmount=0.obs;
  var couponLoading=false.obs;
  var couponEnable=false.obs;
  var placeLoading=false.obs;
  var placeEnable=false.obs;
  @override
  void onInit() {
    promoCodeController=TextEditingController();
    addressController=TextEditingController();

    super.onInit();
  }
  @override
  void onClose() {
    promoCodeController.dispose();
    addressController.dispose();
    super.onClose();
  }
  sumCart(){
    return cart.isNotEmpty?cart.map((element) => element.price*element.quantity).reduce((value, element) => value+element):0;
  }
  shippingFee(){
    return 0;
  }
  getQuantity(){
    return cart.isNotEmpty?cart.map((element) => element.quantity).reduce((value, element) => value+element):0;
  }
}
bool isExistsInCart(RxList<CartModel> cart, CartModel cartItem) {
  return cart.isEmpty?false:cart.any((element) => element.id==cartItem.id)?true:false;
}

