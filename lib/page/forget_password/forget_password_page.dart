import 'dart:convert';

import 'package:divisioniosfinal/page/forget_password/verification_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<ForgetPassword> {
  final emailController=TextEditingController();
  final GlobalKey<FormState> forgetKey = GlobalKey<FormState>();
  var loading=false;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
  }
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "provideValidEmail".tr();
    }
    return null;
  }
  bool checkLogin() {
    final isValid = forgetKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    forgetKey.currentState!.save();
    return true;
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
              height: 123,
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
              child: SingleChildScrollView(
                child: Form(
                  key: forgetKey,
                  autovalidateMode: AutovalidateMode.always,
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
                          Text("",style: productPageTitleTextStyle,),
                          SizedBox(height: 20,width: 50,)
                        ],
                      ),
                      SizedBox(height: 60,),
                      Center(child: Text("forgotnpassword",style: confirmPageHeadingTextStyle,textAlign: TextAlign.center,).tr()),
                      SizedBox(height: 43,),
                      Center(child: Image.asset("assets/images/forget_logo.png")),
                      SizedBox(height: 51,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("email",style: formFieldTitleStyle,).tr(),
                      ),
                      SizedBox(height: 4,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color(0xFFB2BAFF),width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF77CEDA).withOpacity(0.2),
                                  offset: Offset(0,10),
                                  blurRadius: 20
                              )
                            ]
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              )
                          ),
                          validator: (val){
                            return validateEmail(val!);
                          },
                        ),
                      ),

                      SizedBox(height: 117,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF15375A),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async{

                            if(!checkLogin()){
                              return;
                            }
                            LoadingProgress.start(context);
                            var response=await sendOtpForForget(emailController.text);
                            LoadingProgress.stop(context);
                            if(response.statusCode==200){
                              var data=jsonDecode(response.body);
                              var message=data['message'];
                              showToast(message);
                              Navigator.of(context).push(PageTransition(child: VerificationPage(email: emailController.text,), type: PageTransitionType.fade));
                            }else{
                              var data=jsonDecode(response.body);
                              var message=data['message'];
                              showToast(message);
                            }



                          },
                          child: Text(
                            "submit",
                            style: detailPageButtonTextStyle,
                          ).tr(),
                        ),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ),
            ),
            loading?Center(
              child: Image.asset("assets/images/loader.gif"),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
