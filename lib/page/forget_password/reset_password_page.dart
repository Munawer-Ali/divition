import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../sign_in/sign_in_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordPage({Key? key,required this.otp,required this.email}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<ResetPasswordPage> {
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  final GlobalKey<FormState> resetKey = GlobalKey<FormState>();
  var loading=false;
  @override
  void dispose(){
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }
  String? validateConfirmPassword(String newpassword,String confirmpassword) {
    if (newpassword!=confirmpassword) {
      return "Confirm password not matched";
    }
    return null;
  }
  bool checkIsValidated() {
    final isValid = resetKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    resetKey.currentState!.save();
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
                  key: resetKey,
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
                      Center(child: Text("Reset\nPassword",style: confirmPageHeadingTextStyle,textAlign: TextAlign.center,)),
                      SizedBox(height: 163,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("New Password",style: formFieldTitleStyle,),
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
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              )
                          ),
                          validator: (val){
                            return validatePassword(val!);
                          },
                        ),
                      ),
                      SizedBox(height: 13,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("Confirm Password",style: formFieldTitleStyle,),
                      ),
                      SizedBox(height: 4,),
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            filled: true,
                            hintText: "",
                            hintStyle: formFieldTitleStyle,
                            fillColor: Color(0xFFE1ECEF),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                        validator: (val){
                          return validateConfirmPassword(passwordController.text, val!);
                        },
                      ),


                      SizedBox(height: 222,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF15375A),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async{
                            if(!checkIsValidated()){
                              return;
                            }
                            LoadingProgress.start(context);
                            var response=await resetForgetPassword(widget.email,widget.otp,passwordController.text,confirmPasswordController.text);
                            LoadingProgress.stop(context);
                            if(response.statusCode==200){
                              var data=jsonDecode(response.body);
                              var message=data['message'];
                              showToast(message);
                              Navigator.of(context).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                            }else{
                              var data=jsonDecode(response.body);
                              var message=data['message'];
                              showToast(message);
                            }


                          },
                          child: Text(
                            "Reset Password",
                            style: detailPageButtonTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),

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
