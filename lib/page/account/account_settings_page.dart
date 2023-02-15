import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../sign_in/sign_in_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'account_controller.dart';
import 'account_controller1.dart';
import 'change_password_page.dart';

class AccountSettingsPage extends StatefulWidget {
  final bool home;
  const AccountSettingsPage({Key? key,required this.home}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  int toggle=0;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final controller=Get.put(AccountController());
  final controller1=Get.put(AccountController1());
  final internetController=Get.put(ConnectivityCheckerController());
  String symbol="";
  String role="";
  String token="";
  @override
  void initState() {
    super.initState();
    internetController.startMonitoring();
    getSymbol();
  }
  getSymbol()async{
    symbol=await getStringPrefs(SYMBOL);
    role=await getStringPrefs(ROLE);
    token=await getStringPrefs(TOKEN);
    setState((){});
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
              child: Obx((){
                if(controller.loading.value==true){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Center(
                  child: SpinKitCircle(
                  size: 140,
                    color: Color(0xFF8FC7FF),
                  ),
                ),
                      Center(child: Text(controller.messgae.value),)
                    ],
                  );
                }else if(controller.token.value.isEmpty){
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/login.json',
                      title: 'Alert',
                      description: 'Please login first',
                      buttonText: "Login",
                      onPressed: () {
                        Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                      },
                      status: 1,
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
                      title: 'Server error'.tr,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.home?IconButton(

                              icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                              splashRadius: 20,
                              iconSize: 30,
                              onPressed: (){
                                Navigator.of(context).pop();
                              },):SizedBox(height: 20,width: 20,),
                            Text("Account settings",style: productPageTitleTextStyle,),
                            SizedBox(height: 20,width: 50,)
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text("Personal Info",style: confirmPageHeadingTextStyle,),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFE1ECEF),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 90,
                                  child: Stack(
                                    children: [
                                      GetBuilder<AccountController>(
                                        builder: (_) {
                                          return controller.frontImageSignUp != null
                                              ? CircleAvatar(
                                              radius: 40,
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(controller.frontImageSignUp!.path),
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              ))
                                              :controller.profileImage.isNotEmpty? CircleAvatar(
                                              radius: 40,
                                              child: ClipOval(
                                                child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.fill,
                                                  height: 90,
                                                  width: 90,
                                                  image: "${controller.profileImage.value}",
                                                  imageErrorBuilder: (a,b,c){
                                                    return CircleAvatar(
                                                        radius: 40,
                                                        backgroundImage: AssetImage("assets/images/img6.png"));
                                                  },
                                                  placeholder: "assets/images/img6.png")))
                                                :CircleAvatar(
                                            radius: 40,
                                            backgroundImage: AssetImage("assets/images/img6.png"),


                                          );
                                        },
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: (){
                                              controller.getGalleryImageSignUp();
                                            },
                                              child: CircleAvatar(backgroundColor:Colors.white,radius:12,child: SvgPicture.asset("assets/images/camera.svg"))))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(PageTransition(child: ChangePasswordPage(), type: PageTransitionType.rightToLeft));

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)
                                    ),
                                      child: Text("Change Password",style: productListPriceTextStyle,)),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("First name",style: formFieldTitleStyle,),
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
                            controller: controller.fName,
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
                          child: Text("Last name",style: formFieldTitleStyle,),
                        ),
                        SizedBox(height: 4,),
                        SizedBox(height: 40,child: TextFormField(
                          controller: controller.lName,
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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Mobile number",style: formFieldTitleStyle,),
                        ),
                        SizedBox(height: 4,),
                        SizedBox(height: 40,child: TextFormField(
                          controller: controller.mobile,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Email address",style: formFieldTitleStyle,),
                        ),
                        SizedBox(height: 4,),
                        SizedBox(height: 40,child: TextFormField(
                          controller: controller.email,
                          enabled: false,
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
                            value: controller.countryId,
                            items: controller.countryList.map((e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e.id,
                            )
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                controller.countryId=value as String;
                              });
                            },

                          ),),
                        SizedBox(height: 13,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("City",style: formFieldTitleStyle,),
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
                            value: controller.cityId,
                            items: controller.cityList.map((e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e.id,
                            )
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                controller.cityId=value as int;
                              });
                            },

                          ),),
                        SizedBox(height: 13,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Store",style: formFieldTitleStyle,),
                        ),
                        SizedBox(height: 4,),
                        SizedBox(height: 40,child: TextFormField(
                          controller: controller.store,
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
                        SizedBox(height: 13,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Two Factor",style: formFieldTitleStyle,),
                        ),
                        SizedBox(height: 4,),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                activeColor: Color(0xFF15375A),
                                value: 1, groupValue: controller.twoFactor.value, onChanged: (val){

                                  setState((){
                                    controller.twoFactor.value=val as int;
                                  });
                              },title: Text("Enabled",style: productListPriceTextStyle,),),
                            ),
                            Expanded(
                              child: RadioListTile(
                                activeColor: Color(0xFF15375A),
                                value: 0, groupValue: controller.twoFactor.value, onChanged: (val){
                                setState((){
                                  controller.twoFactor.value=val as int;
                                });
                              },title: Text("Disabled",style: productListPriceTextStyle,),),
                            )
                          ],
                        ),
                        SizedBox(height: 30,),

                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF15375A),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async{
                              controller.loading.value=true;
                              controller.messgae.value="Updating profile data...";
                              var response=await sendUpdateProfile(controller.fName.text, controller.lName.text,
                                controller.countryId.toString(),controller.cityId.toString(),
                                  controller.mobile.text,controller.twoFactor.value.toString(),controller.frontImageSignUp1,controller.store.text
                              );
                              controller.loading.value=false;
                              if(response.statusCode==200){
                                var message=response.data['message'];
                                showToast(message);
                                controller.getData(false);
                                controller1.getData(false);
                              }else{
                                var message=response.data['message'];
                                showToast(message);
                              }
                            },
                            child: Text(
                              "Update",
                              style: detailPageButtonTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),

                      ],
                    ),
                  );
                }
              }),
            ),
            Positioned(
              right: 20,
              top: MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width*0.45,
              child:  role!='general'?BalanceWidget(controller: controller,):SizedBox()
            ),
          ],
        ),
      ),
    );
  }
}