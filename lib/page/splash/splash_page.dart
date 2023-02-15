import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../bottom_container/bottom_container_page.dart';
import '../intro/intro_controller.dart';
import '../intro/intro_page.dart';
import '../sign_in/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller=Get.put(IntroController());
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), ()async{
      var token=await getStringPrefs(TOKEN);
      var isIntroVisited=await getBooleanPref(ISINTROVISITED);
      bool noti=await getBooleanPref(ISNOTICOME);
      print(token);
      if(token.isNotEmpty){
        if(noti){
          Navigator.of(context).pushReplacement(PageTransition(child: BottomContainerPage(predefinePage: 'page3', index: 2,), type: PageTransitionType.fade));
        }else{
          Navigator.of(context).pushReplacement(PageTransition(child: BottomContainerPage(predefinePage: 'page1', index: 0,), type: PageTransitionType.fade));
        }
        
        return;
      }if(isIntroVisited==false){
        Navigator.of(context).pushReplacement(PageTransition(child: IntroPage(), type: PageTransitionType.fade));
      }else{
        Navigator.of(context).pushReplacement(PageTransition(child: SignInPage(), type: PageTransitionType.fade));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark

      ),
      child: Scaffold(

        body: Container(
          color: backgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/images/splash_logo.gif",height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,),
        ),
      ),

    );
  }
}
