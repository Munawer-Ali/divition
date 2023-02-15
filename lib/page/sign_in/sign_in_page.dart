import 'dart:convert';


import 'package:divisioniosfinal/page/sign_in/two_factor_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:loading_progress/loading_progress.dart';

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
                    SizedBox(height: MediaQuery.of(context).padding.top,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 20,width: 20,),
                        Text("",style: productPageTitleTextStyle,),
                        SizedBox(height: 20,width: 50,)
                      ],
                    ),
                    SizedBox(height: 60,),
                    Center(child: Text("Login",style: confirmPageHeadingTextStyle,)),
                    SizedBox(height: 50,),
                    Center(child: Image.asset("assets/images/logo.png")),
                    SizedBox(height: 80,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Email",style: formFieldTitleStyle,),
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
                      child: Text("Password",style: formFieldTitleStyle,),
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
                          child: Text("Forgot your password?",style: introDescriptionTextStyle,)),
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

                            showToast("Please enter email");
                            return;
                          }
                          if(passwordController.text.isEmpty){

                            showToast("Please enter password");
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
                          "Sign In",
                          style: detailPageButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child: Text.rich(

                        TextSpan(
                          children: [
                            TextSpan(text: 'If you do not have an account please ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF989898),height: 1.5)
                            ),
                            TextSpan(
                              text: 'Sign Up',
                              recognizer: TapGestureRecognizer()..onTap=()=>Navigator.of(context).push(PageTransition(child: SignUpPage(), type: PageTransitionType.fade)),
                              style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xFF15375A),height: 1.5),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 50,),

                    Center(child: TextButton(onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(PageTransition(child: BottomContainerPage(index: 0, predefinePage: 'page1',), type: PageTransitionType.fade), (route) => false);

                    }, child: Text("Skip for Now",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,color: Color(0xFF15375A)),)))


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
                    "Message",
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "An email sent to $email. Please verify your email address.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),textAlign: TextAlign.center,),
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
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
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
}
