import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divisioniosfinal/page/wallet/wallet_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final controller = Get.put(WalletController());
  final accountcontroller = Get.put(AccountController());
  final internetController = Get.put(ConnectivityCheckerController());
  int toggle = 0;
  var tap;
  bool isTap = false;
  bool toolTip = false;
  final amountController = TextEditingController();
  String symbol = "";
  var loading=false;
  String role="";

  @override
  void initState() {

    super.initState();
    getSymbol();
    internetController.startMonitoring();
    controller.getData(true);
  }

  getSymbol() async {
    symbol = await getStringPrefs(SYMBOL);
    role=await getStringPrefs(ROLE);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
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
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            "assets/images/arrow_back.svg"),
                        splashRadius: 20,
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "wallet",
                        style: productPageTitleTextStyle,
                      ).tr(),
                      SizedBox(
                        height: 20,
                        width: 50,
                      )
                    ],
                  ),
                  Expanded(child: RefreshIndicator(
                    onRefresh: ()async{
                       controller.getData(false);
                       accountcontroller.getData(false);
                    },
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
                              controller.getData(
                                true,
                              );
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
                              controller.getData(
                                true,
                              );
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.timeoutError.value == true) {
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
                      else if (controller.loading.value == false && controller.wallet.isEmpty) {
                        return role!="general"?ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Text("personalBalance",style: confirmPageHeadingTextStyle,).tr(),
                            SizedBox(height: 8,),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFE1ECEF),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 40,
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          fit: BoxFit.fill,
                                          height: 90,
                                          width: 90,
                                            imageErrorBuilder: (a,b,c){
                                              return CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: AssetImage("assets/images/img6.png"));
                                            },
                                          image: "${accountcontroller.profileImage.value}",
                                            placeholder: "assets/images/img6.png"
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 50),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${accountcontroller.fName.text} ${accountcontroller.lName.text}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16),),
                                        SizedBox(height: 2,),
                                        Text("${accountcontroller.store.text}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14)),
                                        SizedBox(height: 5,),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xFF15375A)
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(

                                                child: Text(accountcontroller.symbol.value,style: TextStyle(fontSize: 30,color: Colors.black),

                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                              SizedBox(width: 20,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("totalBalance",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10)).tr(),
                                                  SizedBox(height: 5,),
                                                  Text("${accountcontroller.wallet.value} $symbol",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),)
                                ],
                              ),
                            ),
                            SizedBox(height: 8,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "uploadFunds",
                                style: confirmPageHeadingTextStyle,
                              ).tr(),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: cartPageSpinnerTextStyle,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: context.locale.toString().contains("en") ?"Enter Fund" :"أدخل قيمة الرصيد المطلوب",
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Color(0xFF15375A), width: 0.5))),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF15375A),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10))),
                                onPressed: () async {
                                  if (amountController.text.isEmpty) {
                                    showToast("pleaseEnterYourFundAmount").tr();
                                    return;
                                  }
                                  LoadingProgress.start(context);
                                  var response =
                                  await addMoney(amountController.text);
                                  LoadingProgress.stop(context);
                                  if (response.statusCode == 201) {
                                    var data = jsonDecode(response.body);
                                    var message = data['message'];
                                    showToast(message);
                                    amountController.text="";
                                    accountcontroller.getData(false);
                                    controller.getData(true);

                                  } else {
                                    showToast("somethingWrong").tr();
                                  }
                                },
                                child: Text(
                                  "uploadFunds",
                                  style: detailPageButtonTextStyle,
                                ).tr(),
                              ),
                            ),
                            Center(
                              child: EmptyFailureNoInternetView(
                                image: 'assets/lottie/empty_lottie.json',
                                title: 'empty',
                                description: 'transactionHistoryEmpty',
                                buttonText: "retry",
                                onPressed: () {
                                  controller.getData(true);
                                },
                                status: 0,
                              ),
                            ),
                          ],
                        ):Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("noHistoryData",style: TextStyle(fontSize: 16),).tr()
                          ],
                        );
                      }
                      else{
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            role!="general"?Column(
                              children: [
                                SizedBox(
                                  height: 13,
                                ),
                                Text("personalBalance",style: confirmPageHeadingTextStyle,).tr(),
                                SizedBox(height: 8,),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFE1ECEF),
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 40,
                                          child: ClipOval(
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.fill,
                                              height: 90,
                                              width: 90,
                                              imageErrorBuilder: (a,b,c){
                                                return CircleAvatar(
                                                    radius: 40,
                                                    backgroundImage: AssetImage("assets/images/img6.png"));
                                              },
                                              placeholder: "assets/images/img6.png",
                                              image: "${accountcontroller.profileImage.value}",
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 50),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Text("${accountcontroller.fName.text} ${accountcontroller.lName.text}",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16)),
                                            SizedBox(height: 2,),
                                            Text("${accountcontroller.store.text}",style:
                      TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14)),
                                            SizedBox(height: 5,),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Color(0xFF15375A)
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(

                                                    child: Text(accountcontroller.symbol.value,style: TextStyle(fontSize: 30,color: Colors.black),

                                                    ),
                                                    backgroundColor: Colors.white,
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("totalBalance",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10)).tr(),
                                                      SizedBox(height: 5,),
                                                      Text("${accountcontroller.wallet.value} $symbol",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "uploadFunds",
                                    style: productListTitleTextStyle,
                                  ).tr(),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: amountController,
                                    textAlign: TextAlign.center,
                                    style: cartPageSpinnerTextStyle,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        hintText: context.locale.toString().contains("en") ? "Enter Fund":"أدخل قيمة الرصيد المطلوب",
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Color(0xFF15375A), width: 0.5))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF15375A),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    onPressed: () async {
                                      if (amountController.text.isEmpty) {
                                        showToast("pleaseEnterYourFundAmount").tr();
                                        return;
                                      }
                                      LoadingProgress.start(context);
                                      var response =
                                      await addMoney(amountController.text);
                                      LoadingProgress.stop(context);
                                      if (response.statusCode == 201) {
                                        var data = jsonDecode(response.body);
                                        var message = data['message'];
                                        showToast(message);
                                        amountController.text="";
                                        accountcontroller.getData(false);
                                        controller.getData(true);
                                      } else {
                                        showToast("somethingWrong").tr();
                                      }
                                    },
                                    child: Text(
                                      "uploadFunds",
                                      style: detailPageButtonTextStyle,
                                    ).tr(),
                                  ),
                                ),
                                SizedBox(
                                  height: 22,
                                ),
                              ],
                            ):SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "transactionHistory",
                                style: productListTitleTextStyle,
                              ).tr(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.wallet.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFE1ECEF)),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: controller
                                                  .wallet[index]
                                                  .transactionType ==
                                                  "Debit"
                                                  ? Color(0xFFDA0200)
                                                  : Color(0xFF78DC94),
                                              child: controller.wallet[index]
                                                  .transactionType ==
                                                  "Debit"
                                                  ? Icon(
                                                Icons.arrow_downward,
                                                color: Colors.white,
                                              )
                                                  : Icon(
                                                Icons.arrow_upward,
                                                color: Colors.white,
                                              ),
                                              radius: 15,
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  controller.wallet[index]
                                                      .transactionTypeCase!.toLowerCase(),
                                                  style:
                                                  detailPageHeadingTextStyle1,
                                                ).tr(),
                                                Text(
                                                  controller
                                                      .wallet[index].createdAt!
                                                      .substring(0, 10),
                                                  style: formFieldHintStyle4,
                                                )
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                            )
                                          ],
                                        ),
                                        Expanded(
                                            child: Text(
                                              controller.wallet[index].status == null
                                                  ? "${controller.wallet[index].orderNo}"
                                                  : "${controller.wallet[index].status!.toLowerCase()}",
                                              style: detailPageHeadingTextStyle1,
                                              textAlign: TextAlign.center,
                                            ).tr()),
                                        Text(
                                          "${controller.wallet[index].amount!} $symbol",
                                          style: detailPageHeadingTextStyle1,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        );
                      }
                    })
                  ))
                ],
              ),
            ),
            Positioned(
                right: 20,
                top: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width * 0.45,
                child: role!='general'?BalanceWidget(
                  controller: accountcontroller,
                ):SizedBox()),
          ],
        ),
      ),
    );
  }
}
