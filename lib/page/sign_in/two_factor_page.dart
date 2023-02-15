import 'dart:async';
import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../package/pin_code/models/animation_type.dart';
import '../../package/pin_code/models/pin_theme.dart';
import '../../package/pin_code/pin_code_fields.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../bottom_container/bottom_container_page.dart';

class TwoFactorPage extends StatefulWidget {
  final String email;
  final String token;
  const TwoFactorPage({Key? key,required this.email,required this.token}) : super(key: key);

  @override
  State<TwoFactorPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<TwoFactorPage> {
  final controller=TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool loading=false;
  String device_token="";
  final accountController=Get.put(AccountController());

  @override
  void initState() {

    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    sendCode(widget.token);
  }

  sendCode(String token)async{
   await sendOtpTwoFactor(token);
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
                    SizedBox(height: 30,),
                    Center(child: Text("Two Factor\nVerification Code",style: confirmPageHeadingTextStyle,textAlign: TextAlign.center,)),
                    SizedBox(height: 64,),
                    Text("Enter your varification code",style: cartPageHeadingTextStyle1,),
                    SizedBox(height: 10,),
                    Text("A 6 digit code has been sent\nto your email: ${widget.email}",style: introDescriptionTextStyle5,),
                    SizedBox(height: 39,),
                    Container(
                      padding: EdgeInsets.only(top: 50,bottom:50,left:  29,right: 29),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE1ECEF),

                      ),
                      child: Center(
                        child: PinCodeTextField(
                          backgroundColor: Colors.transparent,
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length == 6) {

                              return "";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 45,
                            fieldWidth: 45,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: controller,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                          beforeTextPaste: (text) {

                            return true;
                          },
                        ),
                      ),

                    ),
                    SizedBox(height: 7,),
                    Center(child: Text("Don’t receive an Code?",style: cartPageContactTextStyle1,)),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: ()async{
                        setState((){loading=true;});
                        var response=await sendOtpTwoFactor(widget.token);
                        setState((){loading=false;});
                        if(response.statusCode==200){
                          var data=jsonDecode(response.body);
                          var message=data['success'];
                          showToast(message);
                        }else{
                          showToast("Failed to send OTP");
                        }
                      },
                        child: Center(child: Text("Resend Code",style: cartPagePriceTextStyle1,))),
                    SizedBox(height: 38,),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF15375A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async{
                          if(controller.text.isEmpty){
                            showToast("Please enter OTP code");
                            return;
                          }
                          LoadingProgress.start(context);
                          var response=await verifyOtpTwoFactor(controller.text,widget.token);
                          LoadingProgress.stop(context);
                          if(response.statusCode==200){
                            await saveString(TOKEN, widget.token);
                            var data=jsonDecode(response.body);
                            var message=data['success'];
                            showToast(message);
                            accountController.getData(false);
                            Navigator.of(context).pushAndRemoveUntil(PageTransition(child: BottomContainerPage(predefinePage: 'page1', index: 0,), type: PageTransitionType.fade), (route) => false);
                          }else{
                            print(widget.token);
                            var data=jsonDecode(response.body);
                            var message=data['error'];
                            showToast(message);
                          }

                        },
                        child: Text(
                          "Submit",
                          style: detailPageButtonTextStyle,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
