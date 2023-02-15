import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../connectivity/connectivity_checker.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'faq_controller.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int toggle=0;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final controller=Get.put(FAQController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  String role="";
  @override
  void initState() {

    super.initState();
    internetController.startMonitoring();
    controller.getFAQ(true);
    getRole();
  }
  getRole()async{
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
                      Text("FAQ",style: productPageTitleTextStyle,),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),
                  SizedBox(height: 45,),
                  Expanded(
                    child: Obx((){
                      if(controller.loading.value==true){
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
                            title: 'Internet Error',
                            description: 'Internet not found',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getFAQ(true);
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
                              controller.getFAQ(true,);
                            },
                            status: 1,
                          ),
                        );
                      } else if (controller.serverError.value == true) {
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/failure_lottie.json',
                            title: 'Server error'.tr,
                            description: 'Please try again later',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getFAQ(true);
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
                              controller.getFAQ(true,);
                            },
                            status: 1,
                          ),
                        );
                      }else  if(controller.timeoutError.value==true){
                        return Center(
                          child: EmptyFailureNoInternetView(
                            image: 'assets/lottie/failure_lottie.json',
                            title: 'Timeout',
                            description: 'Please try again',
                            buttonText: "Retry",
                            onPressed: () {
                              controller.getFAQ(true);
                            },
                            status: 1,
                          ),
                        );
                      }
                      else{
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Text("FAQ Centre",style: cartPageHeadingTextStyle,),
                            ListView.separated(

                                itemBuilder: (context,index) {
                                  return ExpansionTile(
                                    title: Text("${controller.faqData.value.data![index].question}",style: detailPageHeadingTextStyle1,),
                                    tilePadding: EdgeInsets.zero,
                                    iconColor: Color(0xFFC4C4C4),
                                    children: [
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Html(data: controller.faqData.value.data![index].answer),
                                        ),
                                      )

                                    ],
                                  );
                                }
                            , separatorBuilder: (BuildContext context, int index) { 
                                  return SizedBox(height: 10,);
                            }, itemCount: controller.faqData.value.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),),
                            SizedBox(height: 40,),
                          ],
                        );
                      }
                    })
                  ),



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
