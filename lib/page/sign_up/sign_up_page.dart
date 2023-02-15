import 'dart:convert';



import 'package:divisioniosfinal/page/sign_up/sign_up_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../sign_in/sign_in_page.dart';
import '../widget/empty_failure_no_internet_view.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var userType=[
    "Customer",
    "Wholesaler"
  ];
  var type;
  var country;
  var city;
  final controller=Get.put(SignUpController());
  final internetController=Get.put(ConnectivityCheckerController());
  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  final phoneNumberController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();
  final storeController=TextEditingController();
  bool errorType=false;
  bool errorFirstName=false;
  bool errorLastName=false;
  bool errorCountryName=false;
  bool errorCityName=false;
  bool errorPhone=false;
  bool errorEmail=false;
  bool errorPassword=false;
  bool errorConfirmPassword=false;
  var fName="The fist name field is required";
  var lName="The last name field is required";
  var phoneNumber="The phone number field is required";
  var email="The email field is required";
  var password="The password field is required";
  var loading_msg="Preparing form data...";
  bool showconPassword=true;
  bool showPassword=true;
  bool checkbox=false;
  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

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
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
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
            ),
            Positioned(

              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,

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
                        title: 'Internet Error',
                        description: 'Internet not found',
                        buttonText: "Retry",
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
                        title: 'Internet Error',
                        description: 'Internet not found',
                        buttonText: "Retry",
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
                        title: 'Server error',
                        description: 'Please try again later',
                        buttonText: "Retry",
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
                        title: 'Something went wrong',
                        description: 'Please try again later',
                        buttonText: "Retry",
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
                        title: 'Timeout',
                        description: 'Please try again',
                        buttonText: "Retry",
                        onPressed: () {
                          controller.getData(true);
                        },
                        status: 1,
                      ),
                    );
                  }
                  else{
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).padding.top,),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  SizedBox(height: 12,),
                                  Center(child: Text("Sign Up",style: confirmPageHeadingTextStyle,)),
                                  SizedBox(height: 32,),
                                  Text("New Customer",style: cartPageHeadingTextStyle,),
                                  SizedBox(height: 20,),
                                  Text("Personal Informations",style: detailPageTitleTextStyle,),
                                  SizedBox(height: 23,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("User type",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,
                                    child: DropdownButtonFormField(
                                      icon: SvgPicture.asset("assets/images/arrow_down.svg"),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFE1ECEF),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          isDense: true,
                                          hintText: "Select",
                                          hintStyle: formFieldHintStyle,
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                      value: type,
                                      items: userType.map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      )
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          type=value as String;
                                          errorType=false;
                                          if(type=="Customer"){
                                            storeController.text="Division Store";
                                          }else{
                                            storeController.text="";
                                          }

                                        });
                                      },

                                    ),),
                                  SizedBox(height: 5,),
                                  errorType?Text("The user type field is required.",style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("First name",style: formFieldTitleStyle,),
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
                                      keyboardType: TextInputType.text,
                                      controller: firstNameController,
                                      onChanged: (val){
                                        setState((){
                                          errorFirstName=false;
                                        });
                                      },
                                      onTap: () {
                                        if (type == null) {
                                          setState(() {
                                            errorType = true;
                                          });
                                        }
                                        if (type != null) {
                                          setState(() {
                                            errorType = false;
                                          });
                                        }




                                      },
                                      decoration: InputDecoration(
                                         
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none
                                          ),

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  errorFirstName?Text(fName,style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Last name",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(

                                    keyboardType: TextInputType.text,
                                   controller: lastNameController,
                                    onChanged: (val){
                                     setState((){
                                       errorLastName=false;
                                     });
                                    },
                                    onTap: () {
                                      if (type == null) {
                                        setState(() {
                                          errorType = true;
                                        });
                                      }
                                      if (type != null) {
                                        setState(() {
                                          errorType = false;
                                        });
                                      }
                                      if (firstNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="The first name field is required";
                                        });
                                      }
                                      if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="First name is invalid";
                                        });
                                      }
                                      if (firstNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }




                                    },
                                    decoration: InputDecoration(
                                        isDense: true,
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
                                  SizedBox(height: 5,),
                                  errorLastName?Text(lName,style: TextStyle(color: Colors.red),):SizedBox(),
                                  //drop down button
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Country",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,
                                    child: DropdownButtonFormField(
                                      icon: SvgPicture.asset("assets/images/arrow_down.svg"),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFE1ECEF),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          isDense: true,
                                          hintText: "Select",
                                          hintStyle: formFieldHintStyle,
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                      value: country,
                                      items: controller.formData.value.countries!.map((e) => DropdownMenuItem(
                                        child: Text(e.name!),
                                        value: e.id,
                                      )
                                      ).toList(),
                                      onChanged: (value) async{
                                        var hmm=controller.formData.value.countries!.firstWhere((element) => element.id==value);
                                        await saveString(COUNTRY, hmm.name!);
                                        setState(() {
                                          country=value as int;
                                          errorCountryName=false;

                                          loading_msg="Please wait city data loading...";

                                        });
                                        controller.getCity(country.toString());
                                      },
                                      onTap: () {
                                        if (type == null) {
                                          setState(() {
                                            errorType = true;
                                          });
                                        }
                                        if (type != null) {
                                          setState(() {
                                            errorType = false;
                                          });
                                        }
                                        if (firstNameController.text
                                            .isEmpty) {
                                          setState(() {
                                            errorFirstName = true;
                                            fName="The first name field is required";
                                          });
                                        }
                                        if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                            firstNameController.text)) {
                                          setState(() {
                                            errorFirstName = true;
                                            fName="First name is invalid";
                                          });
                                        }
                                        if (firstNameController.text
                                            .isNotEmpty) {
                                          setState(() {
                                            errorFirstName = false;
                                          });
                                        }
                                        if (GetUtils.isUsername(
                                            firstNameController.text)) {
                                          setState(() {
                                            errorFirstName = false;
                                          });
                                        }
                                        if (lastNameController.text
                                            .isEmpty) {
                                          setState(() {
                                            errorLastName = true;
                                            lName="The last name field is required";
                                          });
                                        }
                                        if (lastNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                            lastNameController.text)) {
                                          setState(() {
                                            errorLastName = true;
                                            lName="Last name is invalid";
                                          });
                                        }


                                        if (lastNameController.text
                                            .isNotEmpty) {
                                          setState(() {
                                            errorLastName = false;
                                          });
                                        }
                                        if (GetUtils.isUsername(
                                            lastNameController.text)) {
                                          setState(() {
                                            errorLastName = false;
                                          });
                                        }



                                      },

                                    ),),
                                  SizedBox(height: 5,),
                                  errorCountryName?Text("The country field is required.",style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  controller.cityData.value.data!=null?Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("City",style: formFieldTitleStyle,),
                                  ):SizedBox(),
                                  controller.cityData.value.data!=null?SizedBox(height: 4,):SizedBox(),
                                  controller.cityData.value.data!=null?SizedBox(height: 40,
                                    child: DropdownButtonFormField(
                                      icon: SvgPicture.asset("assets/images/arrow_down.svg"),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFE1ECEF),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          isDense: true,
                                          hintText: "Select",
                                          hintStyle: formFieldHintStyle,
                                          contentPadding: EdgeInsets.all(10)
                                      ),
                                      value: city,
                                      items: controller.cityData.value.data!.map((e) => DropdownMenuItem(
                                        child: Text(e.name!),
                                        value: e.id,
                                      )
                                      ).toList(),
                                      onChanged: (value) async{
                                        var hmm=controller.cityData.value.data!.firstWhere((element) => element.id==value);
                                        await saveString(CITY, hmm.name!);
                                        setState(() {
                                          city=value as int;
                                          errorCityName=false;
                                        });
                                      },

                                    ),):SizedBox(),
                                  errorCityName&&controller.cityData.value.data!=null?SizedBox(height: 5,):SizedBox(),
                                  errorCityName&&controller.cityData.value.data!=null?Text("The city field is required.",style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Phone number",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val){
                                      setState(() {
                                        errorPhone=false;
                                      });
                                    },
                                    onTap: () {
                                      if (type == null) {
                                        setState(() {
                                          errorType = true;
                                        });
                                      }
                                      if (type != null) {
                                        setState(() {
                                          errorType = false;
                                        });
                                      }
                                      if (firstNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="The first name field is required";
                                        });
                                      }
                                      if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="First name is invalid";
                                        });
                                      }
                                      if (firstNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (lastNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="The last name field is required";
                                        });
                                      }
                                      if (lastNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="Last name is invalid";
                                        });
                                      }


                                      if (lastNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if(country==null){
                                        setState(() {
                                          errorCountryName = true;
                                        });
                                      }
                                      if(country!=null){
                                        setState(() {
                                          errorCountryName = false;
                                        });
                                      }
                                      if(city==null){
                                        setState(() {
                                          errorCityName = true;
                                        });
                                      }
                                      if(city!=null){
                                        setState(() {
                                          errorCityName = false;
                                        });
                                      }



                                    },
                                    controller: phoneNumberController,
                                    decoration: InputDecoration(
                                        isDense: true,
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
                                  SizedBox(height: 5,),
                                  errorPhone?Text(phoneNumber,style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Email",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (val){
                                      setState((){
                                        errorEmail=false;
                                      });
                                    },
                                    onTap: () {
                                      if (type == null) {
                                        setState(() {
                                          errorType = true;
                                        });
                                      }
                                      if (type != null) {
                                        setState(() {
                                          errorType = false;
                                        });
                                      }
                                      if (firstNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="The first name field is required";
                                        });
                                      }
                                      if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="First name is invalid";
                                        });
                                      }
                                      if (firstNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (lastNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="The last name field is required";
                                        });
                                      }
                                      if (lastNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="Last name is invalid";
                                        });
                                      }


                                      if (lastNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if(country==null){
                                        setState(() {
                                          errorCountryName = true;
                                        });
                                      }
                                      if(country!=null){
                                        setState(() {
                                          errorCountryName = false;
                                        });
                                      }
                                      if(phoneNumberController.text.isEmpty){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="The phone number field is required";
                                        });
                                      }
                                      if(phoneNumberController.text.isNotEmpty){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }

                                      if(phoneNumberController.text.isNotEmpty&&!GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="Phone number is invalid";
                                        });
                                      }
                                      if(GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }
                                      if(city==null){
                                        setState(() {
                                          errorCityName = true;
                                        });
                                      }
                                      if(city!=null){
                                        setState(() {
                                          errorCityName = false;
                                        });
                                      }


                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        isDense: true,
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
                                  SizedBox(height: 5,),
                                  errorEmail?Text(email,style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Password",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (val){
                                      setState(() {
                                        errorPassword = false;
                                      });
                                    },
                                    onTap: () {
                                      if (type == null) {
                                        setState(() {
                                          errorType = true;
                                        });
                                      }
                                      if (type != null) {
                                        setState(() {
                                          errorType = false;
                                        });
                                      }
                                      if (firstNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="The first name field is required";
                                        });
                                      }
                                      if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="First name is invalid";
                                        });
                                      }
                                      if (firstNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (lastNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="The last name field is required";
                                        });
                                      }
                                      if (lastNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="Last name is invalid";
                                        });
                                      }


                                      if (lastNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if(country==null){
                                        setState(() {
                                          errorCountryName = true;
                                        });
                                      }
                                      if(country!=null){
                                        setState(() {
                                          errorCountryName = false;
                                        });
                                      }
                                      if(phoneNumberController.text.isEmpty){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="The phone number field is required";
                                        });
                                      }
                                      if(phoneNumberController.text.isNotEmpty){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }

                                      if(phoneNumberController.text.isNotEmpty&&!GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="Phone number is invalid";
                                        });
                                      }
                                      if(GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }
                                      if(emailController.text.isEmpty){
                                        setState(() {
                                          errorEmail = true;
                                          email="The email field is required";
                                        });
                                      }
                                      if(emailController.text.isNotEmpty){
                                        setState(() {
                                          errorEmail = false;
                                        });
                                      }

                                      if(emailController.text.isNotEmpty&&!GetUtils.isEmail(emailController.text)){
                                        setState(() {
                                          errorEmail = true;
                                          email="Email is invalid";
                                        });
                                      }
                                      if(GetUtils.isPhoneNumber(emailController.text)){
                                        setState(() {
                                          errorEmail = false;
                                        });
                                      }
                                      if(city==null){
                                        setState(() {
                                          errorCityName = true;
                                        });
                                      }
                                      if(city!=null){
                                        setState(() {
                                          errorCityName = false;
                                        });
                                      }

                                    },
                                    controller: passwordController,
                                    obscureText: showPassword,
                                    decoration: InputDecoration(
                                        isDense: showPassword,
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
                                  ),),
                                  SizedBox(height: 5,),
                                  errorPassword?Text(password,style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Confirm Password",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (val){
                                      if(val!=passwordController.text){
                                        setState((){
                                          errorConfirmPassword=true;
                                        });
                                      }else{
                                        setState((){
                                          errorConfirmPassword=false;
                                        });
                                      }
                                    },
                                    onTap: () {
                                      if (type == null) {
                                        setState(() {
                                          errorType = true;
                                        });
                                      }
                                      if (type != null) {
                                        setState(() {
                                          errorType = false;
                                        });
                                      }
                                      if (firstNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="The first name field is required";
                                        });
                                      }
                                      if (firstNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = true;
                                          fName="First name is invalid";
                                        });
                                      }
                                      if (firstNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          firstNameController.text)) {
                                        setState(() {
                                          errorFirstName = false;
                                        });
                                      }
                                      if (lastNameController.text
                                          .isEmpty) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="The last name field is required";
                                        });
                                      }
                                      if (lastNameController.text.isNotEmpty&&!GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = true;
                                          lName="Last name is invalid";
                                        });
                                      }


                                      if (lastNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if (GetUtils.isUsername(
                                          lastNameController.text)) {
                                        setState(() {
                                          errorLastName = false;
                                        });
                                      }
                                      if(country==null){
                                        setState(() {
                                          errorCountryName = true;
                                        });
                                      }
                                      if(country!=null){
                                        setState(() {
                                          errorCountryName = false;
                                        });
                                      }
                                      if(phoneNumberController.text.isEmpty){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="The phone number field is required";
                                        });
                                      }
                                      if(phoneNumberController.text.isNotEmpty){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }

                                      if(phoneNumberController.text.isNotEmpty&&!GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = true;
                                          phoneNumber="Phone number is invalid";
                                        });
                                      }
                                      if(GetUtils.isPhoneNumber(phoneNumberController.text)){
                                        setState(() {
                                          errorPhone = false;
                                        });
                                      }
                                      if(emailController.text.isEmpty){
                                        setState(() {
                                          errorEmail = true;
                                          email="The email field is required";
                                        });
                                      }
                                      if(emailController.text.isNotEmpty){
                                        setState(() {
                                          errorEmail = false;
                                        });
                                      }

                                      if(emailController.text.isNotEmpty&&!GetUtils.isEmail(emailController.text)){
                                        setState(() {
                                          errorEmail = true;
                                          email="Email is invalid";
                                        });
                                      }
                                      if(GetUtils.isPhoneNumber(emailController.text)){
                                        setState(() {
                                          errorEmail = false;
                                        });
                                      }
                                      if(passwordController.text.isEmpty){
                                        setState(() {
                                          errorPassword = true;
                                          password="The password field is required";
                                        });
                                      }
                                      if(passwordController.text.isNotEmpty){
                                        setState(() {
                                          errorPassword = false;
                                        });
                                      }
                                      if(passwordController.text.isNotEmpty&&passwordController.text.length<6){
                                        setState(() {
                                          errorPassword = true;
                                          password="Password cannot be smaller than 6 characters";
                                        });
                                      }
                                      if(passwordController.text.length>6){
                                        setState(() {
                                          errorPassword = false;
                                        });
                                      }
                                      if(city==null){
                                        setState(() {
                                          errorCityName = true;
                                        });
                                      }
                                      if(city!=null){
                                        setState(() {
                                          errorCityName = false;
                                        });
                                      }

                                    },
                                    controller: confirmPasswordController,
                                    obscureText: showconPassword,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      hintText: "",
                                      suffixIcon: IconButton(
                                        splashRadius: 20,
                                        onPressed: (){
                                          setState((){
                                            showconPassword=!showconPassword;
                                          });
                                        },
                                        icon: Icon(showconPassword?Icons.visibility:Icons.visibility_off),
                                      ),
                                      hintStyle: formFieldTitleStyle,
                                      fillColor: Color(0xFFE1ECEF),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(5)
                                      ),

                                    ),
                                  ),),
                                  SizedBox(height: 5,),
                                  errorConfirmPassword?Text("Confirm password not matched!",style: TextStyle(color: Colors.red),):SizedBox(),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text("Store",style: formFieldTitleStyle,),
                                  ),
                                  SizedBox(height: 4,),
                                  SizedBox(height: 40,child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: storeController,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      hintText: "",
                                      hintStyle: formFieldTitleStyle,
                                      fillColor: Color(0xFFE1ECEF),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(5)
                                      ),

                                    ),
                                  ),),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(

                                    children:   [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Checkbox(

                                          value: checkbox,
                                          activeColor: Color(0xFF15375A),
                                          onChanged: (val) {
                                            setState(() {
                                              checkbox = val as bool;
                                            });
                                          },

                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Expanded(
                                        child: Text.rich(
                                            TextSpan(text: "I accept terms and conditions", children: [
                                            //   TextSpan(
                                            //       text: "Terms and Conditions",
                                            //       style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                                            //       recognizer: TapGestureRecognizer()
                                            //         ..onTap = () => _launchInBrowser("https://divisionco.com/development/page/terms-and-conditions")),
                                            //   TextSpan(text: " and ",),
                                            //   TextSpan(
                                            //       text: "Privacy Policy.",
                                            //       style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                                            //       recognizer: TapGestureRecognizer()
                                            //         ..onTap = () => _launchInBrowser("https://divisionco.com/development/page/privacy-policy"))
                                            // ])),
                                              ]
                                      )
                                        ))],
                                  ),
                                  SizedBox(height: 53,),
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF15375A),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
                                      onPressed: () async{

                                        setState((){
                                          loading_msg="Signing up...";
                                        });
                                        if (type == null) {

                                          setState(() {
                                            errorType = true;
                                          });
                                          showToast("Please select user type");
                                          return;

                                        }

                                        if (firstNameController.text.isEmpty) {

                                          setState(() {
                                            errorFirstName = true;
                                            fName="The first name field is required";
                                          });
                                          showToast("Please enter full name");
                                          return;
                                        }


                                        if (lastNameController.text.isEmpty) {

                                          setState(() {
                                            errorLastName = true;
                                            lName="The last name field is required";
                                          });
                                          showToast("Please enter the last name");
                                          return;
                                        }

                                        if(country==null){

                                          setState(() {
                                            errorCountryName = true;
                                          });
                                          showToast("Please select country");
                                          return;
                                        }
                                        if(city==null){

                                          setState(() {
                                            errorCityName = true;
                                          });
                                          showToast("Please select city");
                                          return;
                                        }


                                        if(phoneNumberController.text.isEmpty){

                                          setState(() {
                                            errorPhone = true;
                                            phoneNumber="The phone number field is required";
                                          });
                                          showToast("Please enter phone number");
                                          return;
                                        }

                                        if(phoneNumberController.text.isNotEmpty&&!GetUtils.isPhoneNumber(phoneNumberController.text)){

                                          setState(() {
                                            errorPhone = true;
                                            phoneNumber="Phone number is invalid";
                                          });
                                          showToast("Invalid phone number");
                                          return;
                                        }

                                        if(emailController.text.isEmpty){

                                          setState(() {
                                            errorEmail = true;
                                            email="The email field is required";
                                          });
                                          showToast("Please enter email");
                                          return;
                                        }


                                        if(emailController.text.isNotEmpty&&!GetUtils.isEmail(emailController.text)){

                                          setState(() {
                                            errorEmail = true;
                                            email="Email is invalid";
                                          });
                                          showToast("Please provide valid email");
                                          return;
                                        }

                                        if(passwordController.text.isEmpty){

                                          setState(() {
                                            errorPassword = true;
                                            password="The password field is required";
                                          });
                                          showToast("Please enter password");
                                          return;
                                        }

                                        if(passwordController.text.isNotEmpty&&passwordController.text.length<6){

                                          setState(() {
                                            errorPassword = true;
                                            password="Password cannot be smaller than 6 characters";
                                          });
                                          showToast("Password not strong");
                                          return;
                                        }
                                        if(passwordController.text!=confirmPasswordController.text){

                                          setState(() {
                                            errorPassword = true;
                                            password="Confirm password not matched";
                                          });
                                          showToast("Confirm password not matched");
                                          return;
                                        }
                                        if(checkbox==false){
                                          showToast("Please check Privacy Policy and Terms and Conditions");
                                          return;
                                        }
                                        LoadingProgress.start(context);
                                        var response=await sendRegisterData(
                                            emailController.text,
                                            passwordController.text,
                                            confirmPasswordController.text,
                                            firstNameController.text,
                                            lastNameController.text,
                                            type=="Customer"?"general":"wholesaler",
                                            country.toString(),
                                            phoneNumberController.text,
                                          city.toString(),
                                          storeController.text,
                                          checkbox?"1":"0"
                                        );
                                        LoadingProgress.stop(context);
                                        if(response.statusCode==201){
                                           var data=jsonDecode(response.body);
                                           var message=data['message'];
                                           var token=data['data']['access_token'];
                                           showToast(message);
                                           var role=data['data']['user']['role'];
                                           await saveString(ROLE, role);
                                           var country=data['data']['user']['country']['name'];
                                           await saveString(COUNTRY, country);
                                           var symbol=data['data']['user']['country']['symbol'];
                                           await saveString(SYMBOL, symbol);
                                           var currency=data['data']['user']['country']['currency'];
                                           await saveString(CURENCYNAME, currency);
                                           var city=data['data']['user']['city']['name'];
                                           await saveString(CITY, city);

                                           var varify=data['data']['user']['email_verified_at'];
                                           if(varify==null){
                                             showCustomDialog(emailController.text);
                                           }


                                        }else{
                                          var data=jsonDecode(response.body);
                                          var message=data['message'];
                                          showToast(message);
                                        }
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: detailPageButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: Text.rich(

                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'If you already have an account with us,\nplease login at the ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF989898),height: 1.5)
                                          ),
                                          TextSpan(
                                            text: 'Login',
                                            recognizer: TapGestureRecognizer()..onTap=()=>Navigator.of(context).push(PageTransition(child: SignInPage(), type: PageTransitionType.fade)),
                                            style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xFF15375A),height: 1.5),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 30,),

                                ],
                              ),
                            ),
                            SizedBox(height: 17,),
                          ],
                        ),
                      ),
                    );
                  }
                })
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


