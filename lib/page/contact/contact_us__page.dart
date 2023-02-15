import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'contact_controller.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<ContactUsPage>{
  int toggle=0;
  String role="";
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final controller=Get.put(ContactController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final messageController=TextEditingController();
  @override
  void initState() {

    super.initState();
    internetController.startMonitoring();
    controller.getContactInfo(true);
    getRole();

  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    setState((){});
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  Future<void> _makeEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }
  Future<void> _makeMessenger(String id) async {
    await canLaunch("https://m.me/$id")
        ? await launch("https://m.me/$id", forceWebView: false)
        : throw 'Could not launch ${"https://m.me/$id"}';
  }
  Future<void> _makeBrowser(String url) async {
    await canLaunch(url)
        ? await launch(url, forceWebView: false)
        : throw 'Could not launch ${url}';
  }
  _launchWhatsapp(var number) async {
    var whatsapp =Uri.parse("whatsapp://send?phone=$number&text=hello");
    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(whatsapp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
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
                      Text("Contact",style: productPageTitleTextStyle,),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),

                  Expanded(child: Obx((){
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
                            controller.getContactInfo(true);
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
                            controller.getContactInfo(true,);
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
                            controller.getContactInfo(true);
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
                            controller.getContactInfo(true,);
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
                            controller.getContactInfo(true);
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
                            SizedBox(height: 26,),
                            Text("Contact info",style: cartPageHeadingTextStyle,),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(top: 14,bottom: 16,left: 12,right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF77CEDA).withOpacity(0.2),
                                      offset: Offset(0,0),
                                      blurRadius: 20
                                  )
                                ],
                                color: Color(0xFFFAFAFF),


                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text("${controller.contactData.value.country!.name}",style: contactPageInfoStyle,)),
                                      Expanded(child: Text("Follow Us",style: contactPageInfoStyle,))
                                    ],
                                  ),
                                  SizedBox(height: 9,),
                                  Row(
                                    children: [
                                      Expanded(child: GestureDetector(
                                        onTap:(){
                                          _makePhoneCall(controller.contactData.value.contact!.phone!);
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset("assets/images/phone.svg",height: 20,width: 20,fit: BoxFit.fill,),
                                            SizedBox(width: 5,),
                                            Text("${controller.contactData.value.contact!.phone}",style: introDescriptionTextStyle,)
                                          ],
                                        ),
                                      )),
                                      Expanded(child: Row(

                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              _makeBrowser("${controller.contactData.value.contact!.twitter}");

                    },
                                              child: SvgPicture.asset("assets/images/twitter.svg")),
                                          SizedBox(width: 20,),
                                          GestureDetector(
                                              onTap:(){
                                                _makeBrowser("${controller.contactData.value.contact!.facebook}");

                                              },
                                              child: SvgPicture.asset("assets/images/facebook.svg")),
                                          SizedBox(width: 20,),
                                          GestureDetector(
                                              onTap:(){
                                                _makeBrowser("${controller.contactData.value.contact!.pinterest}");

                                              },
                                              child: Image.asset("assets/images/pinterest.png",height: 18,width: 18,)),
                                          SizedBox(width: 20,),
                                          GestureDetector(
                                              onTap:(){
                                                _makeBrowser("${controller.contactData.value.contact!.instagram}");

                                              },
                                              child: Image.asset("assets/images/instagram.png",height: 15,width: 15,)),
                                          SizedBox(width: 5,),

                                        ],

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      ))
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      _makeEmail(controller.contactData.value.contact!.email!);

                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset("assets/images/email.svg"),
                                        SizedBox(width: 5,),
                                        Text("${controller.contactData.value.contact!.email}",style: introDescriptionTextStyle,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      var whatsAppNumber=controller.contactData.value.contact!.whatsapp!;
                                      _launchWhatsapp(whatsAppNumber);

                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset("assets/images/call.svg"),
                                        SizedBox(width: 5,),
                                        Text("Whatsapp",style: introDescriptionTextStyle1,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      var messenger=controller.contactData.value.contact!.messenger!;
                                      _makeMessenger(messenger);
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset("assets/images/messenger.svg"),
                                        SizedBox(width: 5,),
                                        Text("Messenger",style: introDescriptionTextStyle2,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16,),
                            Text("Contact form",style: contactPageInfoStyle,),
                            SizedBox(height: 13,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("Your name *",style: formFieldTitleStyle,),
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
                                controller: nameController,
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
                              child: Text("Email address *",style: formFieldTitleStyle,),
                            ),
                            SizedBox(height: 4,),
                            SizedBox(height: 40,child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
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
                            SizedBox(height: 9,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("Phone",style: formFieldTitleStyle,),
                            ),
                            SizedBox(height: 4,),
                            SizedBox(height: 40,child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
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
                            SizedBox(height: 9,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("Message",style: formFieldTitleStyle,),
                            ),
                            SizedBox(height: 4,),
                            TextFormField(
                              controller: messageController,
                              maxLines: 5,
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
                            ),
                            SizedBox(height: 21,),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF15375A),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10))),
                                onPressed: () async{
                                  if(accountcontroller.token.isEmpty){
                                    guestDialog(context, "You have to login first to send us a message");
                                    return;
                                  }

                                  if(nameController.text.isEmpty){
                                    showToast("Please enter name");

                                    return;
                                  }
                                  if(emailController.text.isEmpty){
                                    showToast("Please enter email");
                                    return;
                                  }
                                  if(phoneController.text.isEmpty){
                                    showToast("Please enter phone");
                                    return;
                                  }
                                  if(messageController.text.isEmpty){
                                    showToast("Please enter message");
                                    return;
                                  }
                                  LoadingProgress.start(context);
                                  var response=await sendContactMessage(nameController.text, emailController.text, phoneController.text, messageController.text);
                                  LoadingProgress.stop(context);
                                  if(response.statusCode==201){
                                    showToast("Message sent successfully");
                                    Navigator.of(context).pop();
                                  }else{
                                    showToast("Message sent failed");
                                  }

                                },
                                child: Text(
                                  "Send",
                                  style: detailPageButtonTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }))


                ],
              ),
            ),
            Positioned(
                right: 20,
                top: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width*0.45,
                child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
            ),


          ],
        ),
      ),

    );
  }
}
