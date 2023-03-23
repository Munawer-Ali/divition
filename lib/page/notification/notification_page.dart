
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../connectivity/connectivity_checker.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../sign_in/sign_in_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'notification_controller.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final controller=Get.put(NotificationController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  String role="";
  @override
  void initState(){
    super.initState();
    getRole();
    internetController.startMonitoring();
    controller.notificationData.clear();
    controller.getData(true);
  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    await saveBoolean(ISNOTICOME, false);
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light
      ),
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
            RefreshIndicator(
              onRefresh: ()async{
                controller.getData(false);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 20,width: 50,),
                      Text("Notifications",style: productPageTitleTextStyle,),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),

                  Obx((){
                    if(controller.loading.value==true){
                      return const Center(
                        child: SpinKitCircle(
                          size: 140,
                          color: Color(0xFF8FC7FF),
                        ),
                      );
                    }else if(accountcontroller.token.value.isEmpty){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/login.json',
                          title: 'Alert',
                          description: 'Please login first',
                          buttonText: "Login",
                          onPressed: () {
                            Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                          },
                          status: 1,
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
                            controller.getData(true);
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
                            controller.getData(true,);
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
                            controller.getData(true);
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
                            controller.getData(true,);
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
                            controller.getData(true);
                          },
                          status: 1,
                        ),
                      );
                    }
                    else if(controller.loading.value==false&&controller.notificationData.isEmpty){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/empty_lottie.json',
                          title: 'Empty',
                          description: 'Notification is empty!',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true);
                          },
                          status: 0,
                        ),
                      );
                    }
                    else{
                      return RefreshIndicator(
                        onRefresh: ()async{
                          controller.getData(false);
                        },
                        child: ListView.builder(

                          itemBuilder: (context,index){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFE1ECEF)
                                  ),
                                  child: Html(data: controller.notificationData[index].message),
                                ),
                                SizedBox(height: 4,),
                                Text("${controller.notificationData[index].createdAt?.substring(0,10)}",style: formFieldHintStyle4,textAlign: TextAlign.end,),
                                const SizedBox(height: 4,),
                              ],
                            );
                          },shrinkWrap: true,
                          primary: false,
                          itemCount: controller.notificationData.length,)
                      );
                    }
                  }),
                  SizedBox(height: 30,)
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
