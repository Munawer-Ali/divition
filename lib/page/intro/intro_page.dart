
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../sign_in/sign_in_page.dart';
import 'intro_controller.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = PageController();
  final introController=Get.put(IntroController());
  int currentPage = 0;
  var imageList=[
    "assets/images/register.png",
    "assets/images/product.png",
    "assets/images/order.png",
    "assets/images/code.png",
  ];
  var titleList=[
    "Register",
    "Find the product",
    "Process Order",
    "Get the Code",
  ];
  var descriptionList=[
    "An officer authorized by law to keep a record called a register or registry",
    "The product is the answer to a multiplication problem. To find a product.",
    "A production order is generally used in discrete industries while a process order.",
    "Contact your mobile service provider to make sure you're sending a text message.",
  ];
  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: currentPage == index ? Color(0xFF15375A):Color(0xFFD9D9D9),
      ),
      margin: const EdgeInsets.only(right: 10),
      height: 8,

      curve: Curves.easeIn,
      width: 24,
    );
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
        body: Obx(() {
          if(introController.loading.value==true){
            return const Center(
              child: SpinKitCircle(
                size: 140,
                color: Color(0xFF8FC7FF),
              ),
            );
          }else{
            return Stack(
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

                Container(
                  margin: EdgeInsets.only(top: 123.h),

                  color: backgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 10,
                        child: PageView.builder(
                            controller: controller,
                            onPageChanged: (value) => setState(() => currentPage = value),
                            itemCount: introController.steps.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  Expanded(child: Image.asset(imageList[index]),flex: 3,),
                                  Expanded(flex: 2,child: Column(
                                    children: [
                                      Text(introController.steps[index].title!,style: TextStyle(fontSize: 18),),
                                      SizedBox(height: 22.h,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 44),
                                        child: Text(introController.steps[index].plainDescription!,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                                      ),
                                    ],
                                  ),),
                                  //
                                ],
                              );
                            }
                        ),
                      ),
                    context.locale.toString().contains("en") ? Expanded(flex: 2,child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(PageTransition(child: SignInPage(), type: PageTransitionType.fade));

                              },
                              child: CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Color(0xFF15375A),
                                child: Text("skip",style: TextStyle(color: Colors.white),).tr(),

                              ),
                            ),
                            Row(
                              children: List.generate(
                                imageList.length,
                                    (int index) => _buildDots(index: index),
                              ),
                            ),
                            InkWell(
                              onTap: ()async{
                                if(currentPage==3){
                                  await saveBoolean(ISINTROVISITED, true);
                                  Navigator.of(context).push(PageTransition(child: SignInPage(), type: PageTransitionType.fade));
                                }else{
                                  setState(() {
                                    currentPage++;
                                    controller.animateToPage(currentPage, duration: Duration(milliseconds: 200), curve: Curves.easeIn,);
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Color(0xFF15375A),
                                child: SvgPicture.asset("assets/images/arrow_right.svg"),

                              ),
                            )
                          ],
                        ),
                      ),):
                    Expanded(flex: 2,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: ()async{
                              if(currentPage==3){
                                await saveBoolean(ISINTROVISITED, true);
                                Navigator.of(context).push(PageTransition(child: SignInPage(), type: PageTransitionType.fade));
                              }else{
                                setState(() {
                                  currentPage++;
                                  controller.animateToPage(currentPage, duration: Duration(milliseconds: 200), curve: Curves.easeIn,);
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Color(0xFF15375A),
                              child: SvgPicture.asset("assets/images/arrow_back.svg",color: Colors.white,),

                            ),
                          ),

                          Row(
                            children: List.generate(

                              imageList.length,
                                  (int index) => _buildDots(index: index),
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(PageTransition(child: SignInPage(), type: PageTransitionType.fade));

                            },
                            child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Color(0xFF15375A),
                              child: Text("skip",style: TextStyle(color: Colors.white),).tr(),

                            ),
                          ),

                        ],
                      ),
                    ),)
                    ],
                  ),
                )

              ],
            );
          }
        })
      ),

    );
  }
}
