import 'dart:async';
import 'dart:convert';

import 'package:divisioniosfinal/page/forget_password/reset_password_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../package/pin_code/models/animation_type.dart';
import '../../package/pin_code/models/pin_theme.dart';
import '../../package/pin_code/pin_code_fields.dart';
import '../../utils/constant.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  const VerificationPage({Key? key,required this.email}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final controller=TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool loading=false;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
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
                    Center(child: Text("varificationncode",style: confirmPageHeadingTextStyle,textAlign: TextAlign.center,).tr()),
                    SizedBox(height: 64,),
                    Text("enterYourVarificationCode",style: cartPageHeadingTextStyle1,).tr(),
                    SizedBox(height: 10,),
                    Text("a6DigitCodeHasBeenSentntoYourEmailWidgetemail",style: introDescriptionTextStyle5,).tr( namedArgs: {
                      "widget.email":widget.email
                    }),
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
                    Center(child: Text("dontReceiveAnCode",style: cartPageContactTextStyle1,).tr()),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: ()async{
                        LoadingProgress.start(context);
                        var response=await sendOtpForForget(widget.email);
                        LoadingProgress.stop(context);
                        if(response.statusCode==200){
                          var data=jsonDecode(response.body);
                          var message=data['message'];
                          showToast(message);
                        }else{
                          var data=jsonDecode(response.body);
                          var message=data['message'];
                          showToast(message);
                        }
                      },
                        child: Center(child: Text("resendCode",style: cartPagePriceTextStyle1,).tr())),
                    SizedBox(height: 38,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF15375A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async{
                          if(controller.text.isEmpty){
                            showToast("pleaseEnterOtpCode").tr();
                            return;
                          }
                          LoadingProgress.start(context);
                          var response=await verifyOtpForForget(widget.email,controller.text);
                          LoadingProgress.stop(context);
                          if(response.statusCode==200){
                            var data=jsonDecode(response.body);
                            var message=data['message'];
                            showToast(message);
                            Navigator.of(context).push(PageTransition(child: ResetPasswordPage(otp: controller.text, email: widget.email,), type: PageTransitionType.fade));
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

                  ],
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
