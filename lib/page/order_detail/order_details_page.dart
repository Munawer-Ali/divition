import 'dart:convert';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/api_call.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../model/codes/code.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../confirmation/order_controller.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';

class OrderDetailPage extends StatefulWidget {
  String id;
   OrderDetailPage({Key? key,required this.id}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int toggle=0;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final controller=Get.put(OrderDetailController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  String symbol="";
  String role="";
  var codeList=<Codes>[];
  @override
  void initState() {

    super.initState();
    getSymbol();
    internetController.startMonitoring();
    controller.getOrderDetail(true,widget.id);
  }
  getSymbol()async{
   symbol=await getStringPrefs(SYMBOL);
   role=await getStringPrefs(ROLE);
   await saveString(ORDERID, widget.id);
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
                      Text("Details",style: productPageTitleTextStyle,),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),
                  SizedBox(height: 17,),

                  Expanded(
                    child: Obx((){
                      if (controller.loading.value == true) {
                        return Center(
                          child: SpinKitCircle(
                            size: 140,
                            color: Color(0xFF8FC7FF),
                          ),
                        );
                      } else if (internetController.isOnline.value == false) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/no_internet_lottie.json',
                            title: 'Internet Error',
                            description: 'Internet not found',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getOrderDetail(true,widget.id);
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.internetError.value == true) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/no_internet_lottie.json',
                            title: 'Internet Error',
                            description: 'Internet not found',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getOrderDetail(true,widget.id);
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.serverError.value == true) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/failure_lottie.json',
                            title: 'Server error',
                            description: 'Please try again later',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getOrderDetail(true,widget.id);
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.somethingWrong.value == true) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/failure_lottie.json',
                            title: 'Something went wrong',
                            description: 'Please try again later',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getOrderDetail(true,widget.id);
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.timeoutError.value == true) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/failure_lottie.json',
                            title: 'Timeout',
                            description: 'Please try again',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getOrderDetail(true,widget.id);
                            },
                            status: 1,
                          ),
                        );
                      }else{
                        return ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            Row(
                              children: [
                                Text("Order number ",style: introDescriptionTextStyle8,),
                                Text("${controller.data.value.data!.no}",style: TextStyle(color: Color(0xFF15375A)),),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Container(
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
                                    Image.network("$imageBaseUrl/${controller.data.value.data!.product!.image}",height: 60.h,width: 60.w,fit: BoxFit.fill,errorBuilder: (a,b,c){
                                      return Icon(Icons.image,size: 100,);
                                    },),
                                    SizedBox(width: 15.5,),
                                    Expanded(child: Column(

                                      children: [//'''
                                        Text("${controller.data.value.data!.product!.title}"),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text("x ${controller.data.value.data!.qty}",style: introDescriptionTextStyle8,),
                                            Spacer(),
                                            Text("${countJustTotal1(controller.data.value.data!,role)} $symbol",style: cartPagePriceTextStyle,)
                                          ],
                                        )

                                      ],
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    )),
                                    IconButton(
                                        onPressed: (){

                                        },
                                        icon: SvgPicture.asset("assets/images/close.svg",color: Colors.white,)
                                    )

                                  ],
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Store:",style: detailPageHeadingTextStyle,),
                                Text(controller.data.value.data!.user!.store==null?"Division Store":controller.data.value.data!.user!.store!,style: cartPageContactTextStyle,)
                              ],
                            ),

                           SizedBox(height: 7,),
                            controller.data.value.data!.product!.category!.type=="physical"?SizedBox():controller.data.value.data!.playerId!=null?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Player ID",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.playerId}",style: cartPageContactTextStyle,)
                              ],
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Player ID",style: detailPageHeadingTextStyle,),
                                Text("No Player ID available",style: cartPageContactTextStyle,)
                              ],
                            ),
                            controller.data.value.data!.playerName!=null?SizedBox(height: 7,):SizedBox(),
                            controller.data.value.data!.playerName!=null?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Player Name",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.playerName}",style: cartPageContactTextStyle,)
                              ],
                            ):SizedBox(),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Number:",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.no}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Date:",style: detailPageHeadingTextStyle,),
                                Text("${orderTime(controller.data.value.data!.createdAt!)}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Payment Type:",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.paymentType}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Phone Number:",style: detailPageHeadingTextStyle,),
                                Text(controller.data.value.data!.phone==null||controller.data.value.data!.phone==""?"Phone not available":"0${controller.data.value.data!.phone}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?SizedBox(height: 28,):SizedBox(),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?Divider(
                              thickness: 1,
                              color: Color(0xFFB2BAFF),
                            ):SizedBox(),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?SizedBox(height: 21,):SizedBox(),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?Text("Your Codes:",style: detailPageHeadingTextStyle,):SizedBox(),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?SizedBox(height: 7,):SizedBox(),
                            controller.data.value.data!.codes!=null&&controller.data.value.data!.codes!.isNotEmpty?
                            Column(
                                children: controller.data.value.data!.codes!.map((e) => ListTile(
                                  title: Text(e.no!,style: cartPageContactTextStyle,),
                                  contentPadding: EdgeInsets.zero,
                                  trailing: Icon(Icons.copy),
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text: e.no));
                                  },
                                )).toList()
                            ):const SizedBox(),
                            SizedBox(height: 22,),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFB2BAFF),
                            ),
                            SizedBox(height: 18,),
                            Text("Order Summery",style: cartPageHeadingTextStyle,),
                            SizedBox(height: 11,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Title:",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.product!.title}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Qty:",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.qty}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Price:",style: detailPageHeadingTextStyle,),
                                Text(role=="general"?"${controller.data.value.data!.product!.customerPrice} $symbol":"${controller.data.value.data!.product!.wholesalerPrice} $symbol",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 15,),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFB2BAFF),
                            ),
                            SizedBox(height: 14,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Subtotal",style: detailPageHeadingTextStyle,),
                                Text("${countJustTotal1(controller.data.value.data!,role)} $symbol",style: cartPageContactTextStyle,)
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discount",style: detailPageHeadingTextStyle,),
                                Text(controller.data.value.data!.coupon!=null?"${countJustDiscount1(controller.data.value.data!,role)} $symbol":"0.0 $symbol",style: cartPageContactTextStyle,)
                              ],
                            ),
                            Visibility(

                                visible: controller.data.value.data!.categorizedDiscountInAmount!=0,

                                child: Column(
                              children: [
                                SizedBox(height: 3,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Special Discount",style: detailPageHeadingTextStyle,),
                                    Text("${controller.data.value.data!.categorizedDiscountInAmount} $symbol",style: cartPageContactTextStyle,)
                                  ],
                                ),
                              ],
                            ),),
                            role=="general"?SizedBox(height: 3,):SizedBox(),
                            role=="general"?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Charge",style: detailPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.deliveryCharge}.0 $symbol",style: cartPageContactTextStyle,)
                              ],
                            ):SizedBox(),
                            SizedBox(height: 14,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total",style: cartPageHeadingTextStyle,),
                                Text("${controller.data.value.data!.price} $symbol",style: cartPageHeadingTextStyle,)
                              ],
                            ),
                            SizedBox(height: 20,),
                            controller.data.value.data!.product!.category!.type=="code"?SizedBox(height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF15375A),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: ()async{
                                LoadingProgress.start(context);
                               var response=await resendCode(controller.data.value.data!.id.toString());
                               LoadingProgress.stop(context);
                               if(response.statusCode==200){
                                 var data=jsonDecode(response.body);
                                 showToast(data['0']);
                               }else{
                                 var data=jsonDecode(response.body);
                                 showToast(data['message']);
                               }
                               
                              },
                              child: Text("Resend",style: detailPageButtonTextStyle,),
                            ),):SizedBox(),
                            SizedBox(height:48 ,),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF15375A),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10))),
                                onPressed: () async{
                                  var status = await Permission.storage.status;
                                  if (!status.isGranted) {
                                    await Permission.storage.request();
                                  }
                                  LoadingProgress.start(context);
                                  try {
                                    getProfileData().then((value) async {
                                      await saveString(COUNTRY,
                                          value.data!.country!.name ??
                                              "country");
                                      await saveString(CITY,
                                          value.data!.city!.name ?? "city");
                                    });
                                    final pdfFile = await PdfInvoiceApi
                                        .generate(
                                        controller.data.value.data!.createdAt!,
                                        controller.data.value.data!.product!
                                            .title!,
                                        role == "general"
                                            ? controller.data.value.data!
                                            .product!.customerPrice!
                                            : controller.data.value.data!
                                            .product!.customerPrice!,
                                        controller.data.value.data!.phone??"",
                                        countJustTotal111(
                                            controller.data.value.data!, role)
                                            .toString(),
                                        controller.data.value.data!.codes ??
                                            codeList,
                                        controller.data.value.data!.coupon !=
                                            null
                                            ? "${countJustDiscount111(
                                            controller.data.value.data!, role)}"
                                            : "0.0",
                                        "${countJustFinalTotal111(
                                            controller.data.value.data!,
                                            role,controller.data.value.data!.deliveryCharge!)}",
                                        controller.data.value.data!.qty!,
                                        controller.data.value.data!.user!
                                            .store ?? "Division Store",
                                      controller.data.value.data!.deliveryCharge!
                                    );
                                    LoadingProgress.stop(context);
                                    PdfApi.openFile(pdfFile,context);
                                  }catch(e){
                                    showToast(e.toString());
                                    LoadingProgress.stop(context);
                                  }
                                },
                                child: Text(
                                  "Print",
                                  style: detailPageButtonTextStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: 40,)
                          ],
                        );
                      }
                    })
                  )
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
