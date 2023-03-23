import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:path_provider/path_provider.dart';
import '../../api/api_call.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../account/account_settings_page.dart';
import '../account/account_settings_page1.dart';
import '../contact/contact_us__page.dart';
import '../faq/faq_page.dart';
import '../orders/orders_page.dart';
import '../sign_in/sign_in_page.dart';
import '../terms_and_policy/terms_and_conditions_page.dart';
import '../wallet/wallet_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int index=0;
  bool open=true;
  String role="";
  final controller=Get.put(AccountController());

  @override
  void initState(){
    super.initState();
    getRole();
    controller.getToken();
  }
  getRole()async{
    role=await getStringPrefs(ROLE);

    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                 SizedBox(height: 20,width: 50,),
                 Text("menu",style: productPageTitleTextStyle,).tr(),
                 SizedBox(height: 20,width: 50,)
               ],
             ),
             SizedBox(height: 20,),
             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                   children: [
                     SizedBox(height: 40,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=1;
                           if(controller.token.value.isEmpty){
                             guestDialog(context, "youMustLoginFirstForAccountSetting");
                             return;
                           }


                             Future.delayed(Duration(milliseconds: 50));
                             Navigator.of(context,rootNavigator: true).push(PageTransition(child: AccountSettingsPage1(home: true,), type: PageTransitionType.fade));




                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: index==1?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset("assets/images/profile.svg",color: index==1?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("accountSettings",style: index==1?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),

                     SizedBox(height: 19,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=2;
                           if(controller.token.value.isEmpty){
                             guestDialog(context, "youMustLoginFirstForSeeingOrderHistory").tr();
                             return;
                           }

                             Future.delayed(Duration(milliseconds: 50));
                             Navigator.of(context,rootNavigator: true).push(PageTransition(child: OrderPage(), type: PageTransitionType.fade));

                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==2?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset("assets/images/order.svg",color: index==2?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("orders",style: index==2?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),


                     role!='general'?SizedBox(height: 19,):SizedBox(),
                     role!='general'?GestureDetector(
                       onTap: (){
                         setState(() {
                           index=4;
                           if(controller.token.value.isEmpty){
                             guestDialog(context, "youMustLoginFirstForWallet").tr();
                             return;
                           }
                             Future.delayed(Duration(milliseconds: 50));
                             Navigator.of(context,rootNavigator: true).push(PageTransition(child: WalletPage(), type: PageTransitionType.fade));

                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==4?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset("assets/images/wallet.svg",color: index==4?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("wallet",style: index==4?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ):SizedBox(),




                     SizedBox(height: 19,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=7;

                             Future.delayed(Duration(milliseconds: 50));
                             Navigator.of(context).push(PageTransition(child: FAQPage(), type: PageTransitionType.fade));

                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==7?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             Icon(Icons.question_mark,color: index==7?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("faq",style: index==7?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),

                     SizedBox(height: 19,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=8;
                           Future.delayed(Duration(milliseconds: 50));
                           Navigator.of(context,rootNavigator: true).push(PageTransition(child: ContactUsPage(), type: PageTransitionType.fade));

                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==8?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             Icon(Icons.contact_page,color: index==8?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("contactUs",style: index==8?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),

                     SizedBox(height: 19,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=9;
                           Future.delayed(Duration(milliseconds: 50));
                           Navigator.of(context,rootNavigator: true).push(PageTransition(child: TermsAndConditions(), type: PageTransitionType.fade));

                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==9?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             Icon(Icons.security,color: index==9?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("termsAndConditions",style: index==9?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),
                     controller.token.value.isNotEmpty?SizedBox(height: 19,):SizedBox(),
                     controller.token.value.isNotEmpty?GestureDetector(
                       onTap: (){
                         setState(() {
                           index=11;
                           showDialog(context: context, builder: (context){
                             return Dialog(
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(15),

                               ),
                               child: Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Text("alert",).tr(),
                                     SizedBox(height: 30,),
                                     Text("yourAccountWillNoLongerAvailableSoYouWillNot").tr(),
                                     SizedBox(height: 20,),
                                     Row(
                                       children: [
                                         Expanded(child: ElevatedButton(

                                           onPressed: (){
                                             Navigator.of(context).pop();
                                           },
                                           child: Text("cancel",style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                                           style: ElevatedButton.styleFrom(
                                               primary: Color(0xFF262324)
                                           ),
                                         )),
                                         SizedBox(width: 10,),
                                         Expanded(child: ElevatedButton(
                                           style: ElevatedButton.styleFrom(
                                               primary: Color(0xFF15375A)
                                           ),
                                           onPressed: ()async{
                                             LoadingProgress.start(context);
                                             var response= await sendDelete();
                                             LoadingProgress.stop(context);
                                             if(response.statusCode==200){
                                               showToast("accountDeleted").tr();
                                               await clearPrefsData();
                                               Navigator.of(context).pop();
                                               Navigator.of(context).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                                             }else{
                                               showToast("failed").tr();
                                             }

                                           },
                                           child: Text("yes",style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                                         )),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             );
                           });
                         });

                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==11?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             Icon(Icons.delete,color: index==11?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text("deleteAccount",style: index==11?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ):SizedBox(),
                     SizedBox(height: 19,),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           index=6;
                           if(controller.token.value.isEmpty){
                             Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                             return;
                           }
                           showDialog(context: context, builder: (context){
                             return Dialog(
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(15),

                               ),
                               child: Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Text("areYouSureYouWantToLogout",style: introDescriptionTextStyle,).tr(),
                                     SizedBox(height: 30,),
                                     Row(
                                       children: [
                                         Expanded(child: ElevatedButton(

                                           onPressed: (){
                                             Navigator.of(context,rootNavigator: true).pop();
                                           },
                                           child: Text("cancel",style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                                           style: ElevatedButton.styleFrom(
                                               primary: Color(0xFF262324)
                                           ),
                                         )),
                                         SizedBox(width: 10,),
                                         Expanded(child: ElevatedButton(
                                           style: ElevatedButton.styleFrom(
                                               primary: Color(0xFF77CEDA)
                                           ),
                                           onPressed: ()async{
                                             await clearPrefsData();
                                             Get.delete<AccountController>();
                                             Navigator.of(context,rootNavigator: true).pop();
                                             Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                                           },
                                           child: Text("yes",style: TextStyle(color: Colors.white,fontSize: 14),).tr(),
                                         )),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             );
                           });


                         });
                       },
                       child: Container(
                         height: 40,
                         padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                         width: MediaQuery.of(context).size.width*0.7,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: index==6?Color(0xFFE1EEF0):backgroundColor
                         ),
                         child: Row(
                           children: [
                             controller.token.value.isNotEmpty?SvgPicture.asset("assets/images/logout.svg",color: index==6?Color(0xFF15375A):Color(0xFFD8A3DD),):
                             Icon(Icons.login,color: index==6?Color(0xFF15375A):Color(0xFFD8A3DD),),
                             SizedBox(width: 14,),
                             Text(controller.token.value.isNotEmpty?"logOut":"login",style: index==6?cartPageSpinnerTextStyle:detailPageHeadingTextStyle1).tr(),

                           ],
                         ),
                       ),
                     ),


                   ],
                 ),
               ),
             )
           ],
         ),
       )
     ],
    );
  }
}
