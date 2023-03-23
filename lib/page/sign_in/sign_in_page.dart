import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:divisioniosfinal/page/sign_in/two_factor_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:loading_progress/loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../bottom_container/bottom_container_page.dart';
import '../forget_password/forget_password_page.dart';
import '../sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool showPassword=true;
  final controller =Get.put(AccountController());
  String? LanguagedropDownValue;
  List<String> Language = ["Arabic", "English"];
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
        body:Stack(
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

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    InkWell(onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      setState(() {
                        if(context.locale.toString().contains("en")){
                          preferences.setString("Language",'ar');
                          context.setLocale(Locale('ar'));

                        }else {
                          preferences.setString("Language",'en');
                          context.setLocale(Locale('en'));
                        }
                        Get.updateLocale(context.locale);

                      });

                    },child:  Container(decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 3 ),
                        shape: BoxShape.circle
                    ),height: 50,width: 40,child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                   Text(context.locale.toString().contains('en') ? "ع" : "E",style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
                        context.locale.toString().contains('en') ? SizedBox(height: 5,) :Center()   // LanguageSelect(),
                 ],
                    ),)),

                    // SizedBox(height: MediaQuery.of(context).padding.top,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 20,width: 20,),
                        Text("",style: productPageTitleTextStyle,),
                        SizedBox(height: 20,width: 50,)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Center(child: Text("login",style: confirmPageHeadingTextStyle,).tr()),
                    SizedBox(height: 50,),
                    Center(child: Image.asset("assets/images/logo.png")),
                    SizedBox(height: 80,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("email",style: formFieldTitleStyle,).tr(),
                    ),
                    SizedBox(height: 6,),
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 13,),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("password",style: formFieldTitleStyle,).tr(),
                    ),
                    SizedBox(height: 6,),
                    TextFormField(
                      obscureText: showPassword,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          filled: true,
                          hintText: "",
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            onPressed: (){
                              setState((){
                                showPassword=!showPassword;
                              });
                            },
                            icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),
                          ),
                          hintStyle: formFieldTitleStyle,
                          fillColor: Color(0xFFE1ECEF),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                    ),



                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(PageTransition(child: ForgetPassword(), type: PageTransitionType.fade));
                          },
                          child: Text("forgotYourPassword",style: introDescriptionTextStyle,).tr()),
                    ),
                    SizedBox(height: 82,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF15375A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async{

                          if(emailController.text.isEmpty){

                            showToast("pleaseEnterEmail").tr();
                            return;
                          }
                          if(passwordController.text.isEmpty){

                            showToast("pleaseEnterPassword").tr();
                            return;
                          }
                          LoadingProgress.start(context);
                          var response=await sendLoginData(emailController.text,passwordController.text);
                          LoadingProgress.stop(context);
                          if(response.statusCode==200){
                            var data=jsonDecode(response.body);
                            var token=data['data']['access_token'];
                            var role=data['data']['user']['role'];
                            var country=data['data']['user']['country']['name'];
                            await saveString(COUNTRY, country);
                            var symbol=data['data']['user']['country']['symbol'];
                            await saveString(SYMBOL, symbol);
                            var currency=data['data']['user']['country']['currency'];
                            await saveString(CURENCYNAME, currency);
                            var city=data['data']['user']['city']['name'];
                            await saveString(CITY, city);
                            var verified=data['data']['user']['email_verified_at'];
                            if(verified==null){
                              showCustomDialog(emailController.text);

                              return;
                            }
                            var approved=data['data']['user']['approved_at'];
                            if(approved==null&&role=='wholesaler'){
                              showToast("Please wait for admin approval");
                              return;
                            }
                            var twoFactor=data['data']['user']['two_factor_enabled'];
                            await saveString(ROLE, role);
                            if(twoFactor==null||twoFactor=="0"){
                              await saveString(TOKEN, token);
                              await saveBoolean(ISTWOFACTORENABLED, false);
                              controller.getData(false);
                              Navigator.of(context).pushAndRemoveUntil(PageTransition(child: BottomContainerPage(index: 0, predefinePage: 'page1',), type: PageTransitionType.fade), (route) => false);
                            }else{
                              await saveBoolean(ISTWOFACTORENABLED, true);
                              Navigator.of(context).push(PageTransition(child: TwoFactorPage(email: emailController.text, token: token,), type: PageTransitionType.fade));
                            }



                          }else{
                            var data=jsonDecode(response.body);
                            var token=data['message'];
                            showToast(token);
                          }

                        },
                        child: Text(
                          "signIn",
                          style: detailPageButtonTextStyle,
                        ).tr(),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                       Text("ifYouDoNotHaveAnAccountPlease",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF989898),height: 1.5)).tr(),
                       SizedBox(width: 5,),
                      InkWell(onTap: (){
                        Navigator.of(context).push(PageTransition(child: SignUpPage(), type: PageTransitionType.fade));},
                         child: Text("signUp",
                           style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xFF15375A),height: 1.5),).tr(),
                       )
                    ],),),
                    // Center(
                    //   child: Text.rich(
                    //
                    //     TextSpan(
                    //       children: [
                    //         TextSpan(text: 'ifYouDoNotHaveAnAccountPlease',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF989898),height: 1.5)
                    //         ),
                    //         TextSpan(
                    //           text: 'signUp',
                    //           recognizer: TapGestureRecognizer()..onTap=()=>Navigator.of(context).push(PageTransition(child: SignUpPage(), type: PageTransitionType.fade)),
                    //           style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xFF15375A),height: 1.5),
                    //         ),
                    //       ],
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ).tr(),
                    // ),
                    SizedBox(height: 30,),

                    Center(child: TextButton(onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(PageTransition(child: BottomContainerPage(index: 0, predefinePage: 'page1',), type: PageTransitionType.fade), (route) => false);

                    }, child: Text("skipForNow",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,color: Color(0xFF15375A)),).tr()))


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  showCustomDialog(String email) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "message",
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13)
                  ).tr(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "anEmailSentToEmailPleaseVerifyYourEmailAddress",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),textAlign: TextAlign.center,).tr( namedArgs: {
                    "email": email
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFF4FCC5D))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "ok",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)).tr(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }
  DropdownButton<String> LanguageSelect() {
    return DropdownButton<String>(
      icon: SizedBox(),
      underline: SizedBox(),
      items: Language.map((String items) {
        return DropdownMenuItem(value: items, child: Text(items,style: TextStyle(color: Colors.black,fontSize: 12),));
      }).toList(),
      onChanged: (String? newValue) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          LanguagedropDownValue = newValue!;
          if(newValue == "English"){
            preferences.setString("Language",'en');
            context.setLocale(Locale('en'));
     
          }else if(newValue == "Arabic"){
            preferences.setString("Language",'ar');
            context.setLocale(Locale('ar'));
          }
          Get.updateLocale(context.locale);

        });
      },
    );
  }

}
