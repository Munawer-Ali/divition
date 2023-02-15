import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../utils/constant.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<ChangePasswordPage> {

  final passwordController=TextEditingController();
  final newPasswordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  var loading=false;
  bool showPassword=true;
  bool newPassword=true;
  bool conPassword=true;

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
                    SizedBox(height: 60,),
                    Center(child: Text("Change\nPassword",style: confirmPageHeadingTextStyle,textAlign: TextAlign.center,)),
                    SizedBox(height: 163,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Password",style: formFieldTitleStyle,),
                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 40,
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
                        obscureText: showPassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                            isDense: true,
                            suffixIcon: IconButton(
                              splashRadius: 20,
                              onPressed: (){
                                setState((){
                                  showPassword=!showPassword;
                                });
                              },
                              icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),
                            ),
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
                      child: Text("New Password",style: formFieldTitleStyle,),
                    ),
                    SizedBox(height: 4,),
                    SizedBox(height: 40,child: TextFormField(
                      obscureText: newPassword,
                      controller: newPasswordController,
                      decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            onPressed: (){
                              setState((){
                                newPassword=!newPassword;
                              });
                            },
                            icon: Icon(newPassword?Icons.visibility:Icons.visibility_off),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          filled: true,
                          hintText: "",
                          hintStyle: formFieldTitleStyle,
                          fillColor: Color(0xFFE1ECEF),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                    ),),
                    SizedBox(height: 13,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Confirm Password",style: formFieldTitleStyle,),
                    ),
                    SizedBox(height: 4,),
                    SizedBox(height: 40,child: TextFormField(
                      obscureText: conPassword,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          filled: true,
                          hintText: "",
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            onPressed: (){
                              setState((){
                                conPassword=!conPassword;
                              });
                            },
                            icon: Icon(conPassword?Icons.visibility:Icons.visibility_off),
                          ),
                          hintStyle: formFieldTitleStyle,
                          fillColor: Color(0xFFE1ECEF),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                    ),),
                    SizedBox(height: 200,),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF15375A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async{
                           if(passwordController.text.isEmpty){
                             showToast("Please enter password.");
                             return;
                           }
                           if(newPasswordController.text.isEmpty){
                             showToast("Please enter new password.");
                             return;
                           }
                           if(confirmPasswordController.text.isEmpty){
                             showToast("Please enter confirm password.");
                             return;
                           }
                           if(newPasswordController.text!=confirmPasswordController.text){
                             showToast("Confirm password not matched.");
                             return;
                           }
                           LoadingProgress.start(context);
                           var response=await sendUpdatePassword(passwordController.text,newPasswordController.text,confirmPasswordController.text);
                           LoadingProgress.stop(context);

                           if(response.statusCode==200){
                             var data=jsonDecode(response.body);
                             var message=data['message'];
                             showToast(message);
                             Navigator.of(context).pop();
                           }else{
                             var data=jsonDecode(response.body);
                             var message=data['message'];
                             showToast(message);
                           }


                        },
                        child: Text(
                          "Update Password",
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
          ],
        ),
      ),
    );
  }
}
