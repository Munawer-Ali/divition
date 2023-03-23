import 'dart:convert';


import 'package:easy_localization/easy_localization.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../model/cart_model/cart_data.dart';
import '../../model/order/place_order_data.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../confirmation/order_confirmation_page.dart';
import '../orders/order_controller.dart';
import '../orders/order_controller1.dart';
import '../wallet/wallet_controller.dart';
import '../web/web_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'checkout_controller.dart';

class CheekOutPage extends StatefulWidget {
  final String playerId;
  final String playerName;
  const CheekOutPage({Key? key,required this.playerId,required this.playerName}) : super(key: key);

  @override
  State<CheekOutPage> createState() => _CheekOutPageState();
}

class _CheekOutPageState extends State<CheekOutPage> {
  final controller=Get.put(CheckoutController());
  final accountcontroller=Get.put(AccountController());
  final walletcontroller = Get.put(WalletController());
  final orderController = Get.put(OrderController1());
  final orderController1 = Get.put(OrderController());
  var phoneNumber="";
  String symbol="";
  String role="";
  int toggle=0;
  AnimationController? _con;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final couponController=TextEditingController();
  final phonenumberController=TextEditingController();
  final internetController=Get.put(ConnectivityCheckerController());
  var loading=false;
  var countryId=172;
  var list=["Card Payment","Cash on Delivery"];
  var paymentType;
  @override
  void initState() {

    super.initState();
    getCurrency();
    internetController.startMonitoring();
    controller.getData(true);

  }
  @override
  void dispose() {
    Get.delete<CheckoutController>();
    super.dispose();
  }
  getCurrency()async{
    symbol=await getStringPrefs(SYMBOL);
    role=await getStringPrefs(ROLE);
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Container(
              height: 123.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF15375A).withOpacity(1),
                    Color(0xFF77CEDA).withOpacity(0)
                  ],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,

                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(

                        icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                        splashRadius: 20,
                        iconSize: 30,
                        onPressed: (){
                          Navigator.of(context).pop();
                        },),
                      Text("checkOut",style: productPageTitleTextStyle,).tr(),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),

                  Expanded(child: Obx(() {
                    if (controller.loading.value == true) {
                      return Center(
                        child: SpinKitCircle(
                          size: 140,
                          color: Color(0xFF8FC7FF),
                        ),
                      );
                    }
                    else if (internetController.isOnline.value == false) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/no_internet_lottie.json',
                          title: 'internetError',
                          description: 'internetNotFound',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.internetError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/no_internet_lottie.json',
                          title: 'internetError',
                          description: 'internetNotFound',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.serverError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'serverError',
                          description: 'pleaseTryAgainLater',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.somethingWrong.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'somethingWentWrong',
                          description: 'pleaseTryAgainLater',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,);
                          },
                          status: 1,
                        ),
                      );
                    }else  if(controller.timeoutError.value==true){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'timeout',
                          description: 'pleaseTryAgain',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true);
                          },
                          status: 1,
                        ),
                      );
                    }
                    else {
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          SizedBox(height: 13,),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text("orderSummery",style: cartPageHeadingTextStyle,).tr(),
                          ),
                          SizedBox(height: 37,),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              primary: false,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.only(left: 9.5,right: 9.5,top: 14,bottom: 14),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFAFAFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF77CEDA).withOpacity(0.2),
                                            offset: Offset(0,4),
                                            blurRadius: 20
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(20.0)),
                                    child: Row(
                                      children: [
                                        ClipRRect(



                                            child: Image.network("$imageBaseUrl/${controller.cart.value.product!.image!}",height: 70.h,width: 60.w,fit: BoxFit.fill,
                                            errorBuilder: (a,b,c){
                                              return Icon(Icons.image,size: 100,);
                                            },),),
                                        SizedBox(width: 15.5,),
                                        Expanded(child: Column(

                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Text(controller.cart.value.product!.title!),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                SizedBox(width: 7,),
                                                Container(
                                                  height:30.h,
                                                  width:30.w,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                    child: Center(
                                                      child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: ()async{
                                                          if(controller.quantity.value>1){

                                                            LoadingProgress.start(context);
                                                            var response=await sendUpdateCart((controller.quantity.value-1).toString(), controller.cart.value.id.toString());
                                                            LoadingProgress.stop(context);
                                                            if(response.statusCode==200){
                                                              controller.quantity.value--;
                                                              var data=jsonDecode(response.body);
                                                              controller.subtotal.value=data['data']['subtotal'].toString();
                                                              controller.total.value=data['data']['total'].toString();
                                                              controller.discount.value=data['data']['discount'].toString();
                                                              controller.deliveryCharge.value=data['data']['cod_delivery_charge'].toString();
                                                            }else{
                                                              showToast("somethingWrong").tr();
                                                            }
                                                            // controller.cart[index].quantity--;
                                                            // controller.cart[index].subtotal=controller.cart[index].quantity*controller.cart[index].price;
                                                            // saveQuantityToDatabase(controller.cart);
                                                            // controller.cart.refresh();
                                                          }
                                                        },
                                                        icon: Icon(Icons.remove),
                                                      ),
                                                    )
                                                ),
                                                SizedBox(width: 7,),
                                                Obx(() => Text(controller.quantity.value.toString(),style: cartPageCountTextStyle,),),
                                                SizedBox(width: 7,),
                                                Container(
                                                    height:30.h,
                                                    width:30.w,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF2F2F2),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Center(
                                                      child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: ()async{

                                                          LoadingProgress.start(context);
                                                          var response=await sendUpdateCart((controller.quantity.value+1).toString(), controller.cart.value.id.toString());
                                                          LoadingProgress.stop(context);
                                                          if(response.statusCode==200){
                                                            controller.quantity.value++;
                                                            var data=jsonDecode(response.body);
                                                            controller.subtotal.value=data['data']['subtotal'].toString();
                                                            controller.total.value=data['data']['total'].toString();
                                                            controller.discount.value=data['data']['discount'].toString();
                                                            controller.deliveryCharge.value=data['data']['cod_delivery_charge'].toString();
                                                          }else{
                                                            showToast("somethingWrong").tr();
                                                          }
                                                        },
                                                        icon: Icon(Icons.add),
                                                      ),
                                                    )
                                                ),
                                                Spacer(),
                                                Obx(() => Text("${controller.subtotal.value} $symbol",style: cartPageContactTextStyle,)),
                                                SizedBox(width: 10,),
                                              ],
                                            )


                                          ],
                                        )),
                                        // IconButton(
                                        //     onPressed: (){
                                        //       controller.cart.removeAt(index);
                                        //       saveQuantityToDatabase(controller.cart);
                                        //       controller.cart.refresh();
                                        //     },
                                        //     icon: SvgPicture.asset("assets/images/close.svg")
                                        // )

                                      ],
                                    ));
                              }),
                          SizedBox(height: 21,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text("customerNumber",style: cartPageContactTextStyle,).tr(),
                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Expanded(flex: 2,child: Container(

                                      decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFFAFAFF)
                                       ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: 10,right: 10),
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: context.locale.toString().contains("en") ? "Select":  "اختار",
                                          ),
                                          value: countryId,
                                          isExpanded: true,
                                          // Down Arrow Icon
                                          icon: const Icon(Icons.keyboard_arrow_down,color: Color(0xFF989898),),

                                          // Array list of items
                                          items: controller.countryList.map((Countries items) {
                                            return DropdownMenuItem(
                                              value: items.id,
                                              child: Text(items.name!,style: cartPageSpinnerTextStyle,),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (Object? newValue) {
                                            setState(() {
                                              countryId=newValue as int;
                                              var object=controller.countryList.firstWhere((element) => element.id==countryId);
                                              phoneNumber=object.phone!;

                                             // phonenumberController.text=phoneNumber;
                                            });
                                          },
                                        ),
                                      ),
                                    ),),
                                    SizedBox(width: 9,),
                                    SizedBox(

                                        width: MediaQuery.of(context).size.width*0.4,

                                        child: TextFormField(

                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none
                                          ),
                                          contentPadding: EdgeInsets.all(10),
                                          fillColor: Color(0xFFFAFAFF),
                                          filled: true
                                      ),
                                      controller: phonenumberController,
                                      keyboardType: TextInputType.phone,
                                    ),

                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          role=="general"?SizedBox(height: 21,):SizedBox(),
                          role=="general"?Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text("paymentType",style: cartPageContactTextStyle,).tr(),
                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Expanded(flex: 1,child: Container(

                                      decoration:BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFFFAFAFF)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: DropdownButtonFormField(
                                          decoration:  InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(10),
                                              hintText: context.locale.toString().contains("en") ? "Select":  "اختار",
                                          ),
                                          value: paymentType,
                                          isExpanded: true,
                                          // Down Arrow Icon
                                          icon: const Icon(Icons.keyboard_arrow_down,color: Color(0xFF989898),),

                                          // Array list of items
                                          items: list.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items,style: cartPageSpinnerTextStyle,).tr(),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (Object? newValue) async{
                                            setState(() {
                                              paymentType=newValue as String;


                                              // phonenumberController.text=phoneNumber;
                                            });
                                            var typedata=paymentType=="Card Payment"?"card":"cod";
                                            LoadingProgress.start(context);
                                            var response= await getPaymentType(typedata);
                                            LoadingProgress.stop(context);
                                            if(response.statusCode==200){
                                              var data=jsonDecode(response.body);
                                              controller.subtotal.value=data['data']['subtotal'].toString();
                                              controller.total.value=data['data']['total'].toString();
                                              controller.discount.value=data['data']['discount'].toString();
                                              controller.deliveryCharge.value=data['data']['cod_delivery_charge'].toString();
                                            }else{
                                              showToast("somethingWentWrong").tr();
                                            }

                                          },
                                        ),
                                      ),
                                    ),),

                                  ],
                                )
                              ],
                            ),
                          ):SizedBox(),
                          SizedBox(height: 24,),
                          Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFAFAFF),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF77CEDA).withOpacity(0.2),
                                  offset: Offset(0,4),
                                  blurRadius: 20
                                )
                              ]
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: SizedBox(
                                      height:40,
                                      child: TextFormField(

                                        decoration: InputDecoration(
                                            border:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none
                                            ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none
                                          ),
                                          fillColor: Color(0xFFE1ECEF),
                                          filled: true,
                                          hintText: context.locale.toString().contains("en") ? "Gift card/Discount code":"كود خصم",
                                          hintStyle: cartPageContactTextStyle,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(10)
                                        ),
                                        controller: couponController,
                                      ),
                                    )),
                                    SizedBox(width: 13,),
                                    SizedBox(
                                      height: 40,
                                      width: 88,
                                      child: ElevatedButton(
                                        
                                        onPressed: ()async{
                                          if(couponController.text.isEmpty){
                                            showToast("pleaseEnterGiftCarddiscountCode").tr();
                                            return;
                                          }
                                          print(couponController.text.toString());
                                          LoadingProgress.start(context);
                                          var response=await verifyCoupons(couponController.text);
                                          LoadingProgress.stop(context);
                                          if(response.statusCode==200){
                                            var data=jsonDecode(response.body);
                                            controller.subtotal.value=data['data']['subtotal'].toString();
                                            controller.total.value=data['data']['total'].toString();
                                            controller.discount.value=data['data']['discount'].toString();
                                            controller.deliveryCharge.value=data['data']['cod_delivery_charge'].toString();
                                          }else{
                                            var data=jsonDecode(response.body);

                                            showToast(data['message']);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF15375A),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          )
                                        ),

                                        child: Text("use",style: detailPageDescTextStyle,).tr(),
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(height: 7,),
                                Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("subtotal",style: cartPageContactTextStyle,).tr(),
                                    Obx(() => Text("${controller.subtotal.value} $symbol",style: cartPageContactTextStyle,))
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("discount",style: cartPageContactTextStyle,).tr(),
                                    Obx(() => Text("${controller.discount.value} $symbol",style: cartPageContactTextStyle,))
                                  ],
                                ),
                                role=="general"?SizedBox(height: 7,):SizedBox(),
                                role=="general"?Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("deliveryCharge",style: cartPageContactTextStyle,).tr(),
                                    Obx(() => Text("${controller.deliveryCharge.value} $symbol",style: cartPageContactTextStyle,))
                                  ],
                                ):SizedBox(),
                                controller.discount.value!="0"?Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("notSatisfied",style: cartPageContactTextStyle,).tr(),
                                    TextButton(onPressed: ()async{
                                      LoadingProgress.start(context);
                                      var response=await deleteCoupons();
                                      LoadingProgress.stop(context);
                                      if(response.statusCode==200){
                                        showToast("appliedCouponRemoved").tr();
                                        couponController.text="";
                                        controller.discount.value="";
                                        controller.getData(false);
                                        setState((){});

                                      }else{
                                        showToast("somethingWrong").tr();
                                      }
                                      },child: Text("remove").tr(),)
                                  ],
                                ):SizedBox(),
                                SizedBox(height: 23,),
                                Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("total",style: cartPagePriceTextStyle,).tr(),
                                    Obx(() => Text("${controller.total.value} $symbol",style: cartPagePriceTextStyle,))
                                  ],
                                )

                              ],
                            ),
                          ),
                          SizedBox(height:30 ,),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF15375A),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async{
                                var typedata="";
                                if(paymentType==null&&role=="general"){
                                  showToast("pleaseSelectPaymentType").tr();
                                  return ;
                                }
                                if(paymentType!=null){
                                  typedata=paymentType=="Card Payment"?"card":"cod";
                                }
                                if(role!="general"){
                                  typedata="cod";
                                }
                                LoadingProgress.start(context);
                                var response=await placeOrder(countryId.toString(),phonenumberController.text,typedata);
                                LoadingProgress.stop(context);
                                if(response.statusCode==201){
                                  var data=jsonDecode(response.body);
                                  PlaceOrderData placeData=PlaceOrderData.fromJson(data);
                                  orderController.getData(false, "", "");
                                  orderController1.getData(false, "", "");
                                  accountcontroller.getData(false);
                                  walletcontroller.getData(false);

                                  if(placeData.data!.object=="temp-order"){
                                    Navigator.of(context).push(PageTransition(child: WebPage(placeData: placeData.data!, playerName: widget.playerName, playerId: widget.playerId,), type: PageTransitionType.fade));

                                  }else{
                                    Navigator.of(context).push(PageTransition(child: ConfirmationPage(placeData: placeData.data!, playerName: widget.playerName, playerId: widget.playerId, from: 'cart',), type: PageTransitionType.fade));

                                  }
                                }else if(response.statusCode==422){
                                  var res = jsonDecode(response.body) as Map;

                                  if(res.containsKey("error")){
                                    showToast(res['error']);
                                  }
                                  if(res.containsKey("message")){
                                    showToast(res['message']);
                                  }


                                }

                                else{
                                  var data=jsonDecode(response.body);
                                  var message=data['message'];
                                  showToast(message);
                                }

                              },
                              child: Text(
                                "complete",
                                style: detailPageButtonTextStyle,
                              ).tr(),
                            ),
                          ),
                          SizedBox(height: 40,)
                        ],
                      );
                    }

                  }),),
                ],
              ),
            ),
            Positioned(
                right: 20,
                top: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width*0.45,
                child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
            ),


          ],
        ),
      ),

    );
  }
}
