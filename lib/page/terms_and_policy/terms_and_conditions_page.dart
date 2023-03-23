
import 'package:divisioniosfinal/page/terms_and_policy/terms_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../utils/constant.dart';
import '../widget/empty_failure_no_internet_view.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final controller=Get.put(TermsController());
  final internetController=Get.put(ConnectivityCheckerController());

  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    controller.getData(true);
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                else{
                  return SingleChildScrollView(
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
                              Text("termsAndCondition",style: productPageTitleTextStyle,).tr(),
                            SizedBox(height: 20,width: 50,)
                          ],
                        ),
                        SizedBox(height: 20,),
                        Html(data: controller.notificationData.value.data!.content!)

                      ],
                    ),
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
