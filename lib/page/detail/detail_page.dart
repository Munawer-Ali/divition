import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../model/cart_model/cart_model_item.dart';
import '../../model/search/search_data.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../check_out/cart_controller.dart';
import '../check_out/check_out_page.dart';
import '../widget/balance_widget.dart';

class DetailPage extends StatefulWidget {
  SearchL categoryList;

   DetailPage({Key? key,required this.categoryList,}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  int initial_count = 1;
  final cartController=Get.put(CartController());
  final accountcontroller=Get.put(AccountController());
  int toggle=0;
  AnimationController? _con;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  final playerController=TextEditingController();
  final countController=TextEditingController();
  String symbol="";
  String role="";
  String name="";
  bool buyNowEnabled=false;
  bool loading=false;
  FocusNode focusNode=FocusNode();
  @override
  void initState() {

    super.initState();
    countController.text=initial_count.toString();
    getSymbol();
    print("$imageBaseUrl/${widget.categoryList.image}");
  }
  getSymbol()async{
    symbol=await getStringPrefs(SYMBOL);
    role=await getStringPrefs(ROLE);
    setState((){});
  }
  @override
  void dispose(){
    super.dispose();
    focusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.5,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.network(
                    '$imageBaseUrl/${widget.categoryList.image}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top-10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "details",
                        style: productPageTitleTextStyle,
                      ).tr(),
                      SizedBox(
                        height: 20,
                        width: 50,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
               top: 100,
                left: 0,
                right: 0,
                child:
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: "$imageBaseUrl/${widget.categoryList.image}",
                      height: 145.h,
                      width: 109.h,
                      fit: BoxFit.cover,

                      imageBuilder: (context, imageProvider) =>
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,),
                            ),
                          ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          width: 145,
                          height: 109,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFE8E8E8)
                          ),
                          child: Icon(Icons.image,size: 60,),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image,size: 100,),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.32),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    color: backgroundColor),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${widget.categoryList.title}",
                            style: detailPageTitleTextStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 92.w,
                            height: 30,
                            child: Center(
                              child: Text(
                                "description",
                                style: detailPageDescTextStyle,
                              ).tr(),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF15375A),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Html(data: widget.categoryList.description!),

                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.categoryList.customerPrice} $symbol",
                                style: detailPagePriceTextStyle,
                              ),
                              Container(
                                height: 44,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFF),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xFFC4C4C4), width: 0.5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          onPressed: () {
                                            focusNode.unfocus();
                                            if (initial_count >= 2) {
                                              setState(() {
                                                initial_count--;
                                                countController.text=initial_count.toString();
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.remove,color: Colors.black,)),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 55,
                                      height: 40,
                                      child: TextField(
                                        focusNode: focusNode,
                                        controller: countController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        onChanged: (val){
                                          if(val.isEmpty){
                                            return;
                                          }
                                          initial_count=int.parse(val);

                                          setState((){});
                                        },
                                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Color(0xFF15375A),),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(top: 2.5)
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          onPressed: () {
                                            focusNode.unfocus();
                                            setState(() {
                                              initial_count++;
                                              countController.text=initial_count.toString();
                                            });
                                          },
                                          icon: Icon(Icons.add,color: Colors.black,)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker"||
                        widget.categoryList.category!.type=="top-up-no-api" ?SizedBox(height: 10,):SizedBox(),
                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker"||
                        widget.categoryList.category!.type=="top-up-no-api"?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("playerId".toString().replaceAll(":", ""),style: formFieldTitleStyle,).tr(),
                    ):SizedBox(),
                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker"||
                        widget.categoryList.category!.type=="top-up-no-api"?SizedBox(height: 6,):SizedBox(),
                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker"||
                        widget.categoryList.category!.type=="top-up-no-api"?Container(
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
                        controller: playerController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            )
                        ),
                      ),
                    ):SizedBox(),
                    SizedBox(
                      height: 18,
                    ),
                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker" ?Text("playerNameName",style: TextStyle(fontSize: 14,color: Colors.black),).tr( namedArgs: {
                      "name": name
                    }):SizedBox(),
                    SizedBox(height: 10,),

                    widget.categoryList.category!.type=="top-up"||
                        widget.categoryList.category!.type=="top-up-jawaker"?SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFBC985C),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                ),
                                onPressed: ()async{
                                  if(playerController.text.isEmpty){
                                    showToast("pleaseEnterPlayerId").tr();
                                    return;
                                  }
                                  setState((){
                                    loading=true;
                                  });
                                  var response;
                                  if(widget.categoryList.category!.type=="top-up-jawaker"){
                                    response=await sendPlayerIdAndGetNameForJawker(playerController.text);
                                  }else{
                                    response=await sendPlayerIdAndGetName(playerController.text);
                                  }
                                  setState((){
                                    loading=false;
                                  });
                                  if(response.statusCode==200){

                                    var data=jsonDecode(response.body);
                                    var name1=data['palyer_name'];
                                    print(name1);
                                    if(name1=="Not found"){
                                      setState((){
                                        name=name1;
                                        buyNowEnabled=false;
                                      });
                                      return;
                                    }
                                    if(name1=="Player number not valid"){
                                      setState((){
                                        name=name1;
                                        buyNowEnabled=false;
                                      });
                                      return;
                                    }
                                    else{
                                      setState((){
                                        name=name1;
                                        buyNowEnabled=true;
                                      });
                                    }

                                  }else{
                                    showToast("somethingWrongPleaseTryAgain").tr();
                                  }







                                },
                                child: widget.categoryList.category!.type=="top-up-jawaker"?Text("Jawaker",style: productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,):SvgPicture.asset("assets/images/pbgbtn.svg")
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF15375A),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: buyNowEnabled?() async{
                                if(accountcontroller.token.value.isEmpty){
                                  guestDialog(context, "youMustHaveToLoginFirstToBuyThisProduct").tr();
                                  return;
                                }
                                if(playerController.text.isEmpty){
                                  showToast("pleaseEnterPlayerId").tr();
                                  return;
                                }
                                if(initial_count.toString().isEmpty){
                                  showToast("cartQuantityCannotBeEmpty").tr();
                                  return;
                                }

                                if(initial_count==0){
                                  showToast("cartQuantityCannotBe0").tr();
                                  return;
                                }
                                LoadingProgress.start(context);
                                var response=await sendAddCart(widget.categoryList.id.toString(), initial_count.toString(),playerController.text);
                                LoadingProgress.stop(context);
                                if(response.statusCode==200){
                                  var data=jsonDecode(response.body);
                                  var message=data['message'];
                                  showToast(message);
                                  Navigator.of(context).push(PageTransition(child: CheekOutPage(playerName: name, playerId: playerController.text,), type: PageTransitionType.fade));
                                }else{
                                  var data=jsonDecode(response.body);
                                  var message=data['error'];
                                  showToast(message);
                                }


                              }:null,
                              child: Text(
                                "buyNow",
                                style: detailPageButtonTextStyle,
                              ).tr(),
                            ),
                          ),

                        ],
                      ),
                    ):SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF15375A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async{

                          if(accountcontroller.token.value.isEmpty){
                            guestDialog(context, "youMustHaveToLoginFirstToBuyThisProduct").tr();
                            return;
                          }
                          if(widget.categoryList.category!.type=="top-up"&&playerController.text.isEmpty){
                            showToast("pleaseEnterPlayerId").tr();
                            return;
                          }
                          if(widget.categoryList.category!.type=="top-up-no-api"&&playerController.text.isEmpty){
                            showToast("pleaseEnterPlayerId").tr();
                            return;
                          }
                          if(initial_count.toString().isEmpty){
                            showToast("cartQuantityCannotBeEmpty").tr();
                            return;
                          }
                          if(initial_count==0){
                            showToast("cartQuantityCannotBe0").tr();
                            return;
                          }
                         LoadingProgress.start(context);
                          print(widget.categoryList.id);
                          var response=await sendAddCart(widget.categoryList.id.toString(), initial_count.toString(),playerController.text);
                         LoadingProgress.stop(context);
                          if(response.statusCode==200){
                            var data=jsonDecode(response.body);
                            var message=data['message'];
                            showToast(message);
                            Navigator.of(context).push(PageTransition(child: CheekOutPage(playerId: playerController.text, playerName: name,), type: PageTransitionType.fade));
                          }else{
                            var data=jsonDecode(response.body);
                            var message=data['error'];
                            showToast(message);
                          }


                        },
                        child: Text(
                          "buyNow",
                          style: detailPageButtonTextStyle,
                        ).tr(),
                      ),
                    ),
                    SizedBox(height: 40,)
                  ],
                ),
              ),
              Positioned(
                  right: 20,
                  top: MediaQuery.of(context).padding.top-10,
                  width: MediaQuery.of(context).size.width*0.45,
                  child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
              ),
              loading?Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: widget.categoryList.category!.type=="top-up-jawaker"?Image.asset("assets/images/jawaker.gif"):Image.asset("assets/images/loader.gif"),
                    ),
                  ],
                ),
              ):SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
