import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divisioniosfinal/page/search/search_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../model/search/search_data.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../check_out/check_out_page.dart';
import '../detail/detail_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller=Get.put(SearchController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  int toggle=0;
  AnimationController? _con;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  int initial_count = 1;
  double height=120;
  double width=100;
  bool itemClickable=true;
  bool loading=false;
  final playerIdController=TextEditingController();
  var playerName="";
  bool buyNowEnabled=false;
  bool enabled=true;
  var role="";
  String symbol="";
  final searchController=TextEditingController();
  bool descriptionEnabled=true;
  @override
  void initState() {

    super.initState();
    internetController.startMonitoring();
    controller.getData(true, "");
    getRole();
  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    symbol=await getStringPrefs(SYMBOL);
    setState((){});
  }
  @override
  void dispose(){
    super.dispose();
    Get.delete<SearchController>();
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
          body:  Stack(
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
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(

                          icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                          splashRadius: 20,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },),
                        Text(context.locale.toString().contains("en") ? "Search" : "البحث",style: productPageTitleTextStyle,).tr(),
                        SizedBox(height: 20,width: 50,)
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (val)async{
                        await Future.delayed(Duration(seconds: 1));
                        controller.getData(true, val);
                      },
                      decoration: InputDecoration(
                        hintText: context.locale.toString().contains("en") ? "Search" : "البحث",
                        hintStyle: TextStyle(fontSize: 13),
                        isDense: true,
                        contentPadding: EdgeInsets.all(5),
                        prefixIcon: SvgPicture.asset("assets/images/search.svg",fit: BoxFit.scaleDown,),
                        filled: true,
                        fillColor: Color(0xFFE1ECEF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFD9D9D9),width: 0.5)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFD9D9D9),width: 0.5)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFD9D9D9),width: 0.5)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 21,),
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
                          title: 'internetError',
                          description: 'internetNotFound',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.internetError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/no_internet_lottie.json',
                          title: 'internetError',
                          description: 'internetNotFound',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.serverError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'serverError',
                          description: 'pleaseTryAgainLater',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.somethingWrong.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'somethingWentWrong',
                          description: 'pleaseTryAgainLater',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    }else  if(controller.timeoutError.value==true){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'timeout',
                          description: 'pleaseTryAgain',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    }
                    else  if(controller.loading.value==false&&controller.order.isEmpty&&searchController.text.isNotEmpty){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/empty_lottie.json',
                          title: 'noData',
                          description: 'noDataFound',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,searchController.text);
                          },
                          status: 0,
                        ),
                      );
                    }
                    else  if(searchController.text.isEmpty){
                      return Center(
                        child: Text("explore",style: TextStyle(fontSize: 18),).tr()
                      );
                    }
                    else{
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.order.length,
                          itemBuilder: (context,index){

                            return GestureDetector(


                                onTap: itemClickable==true?(){
                                  playerName="";
                                  playerIdController.text="";
                                  toolTip=false;
                                  setState((){
                                    height=130;
                                    width=120;
                                    buyNowEnabled=false;
                                    isTap=true;
                                    if(isTap==true){
                                      tap=index;
                                    }
                                    //else{
                                    //   tap=null;
                                    // }

                                  });
                                }:null,
                                child: tap==index?Container(
                                  margin: EdgeInsets.only(left: 15,right: 14,bottom: (index==controller.order.length-1)?30:10),
                                  padding: EdgeInsets.only(left: 5,top: 11,bottom: 11,right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF77CEDA).withOpacity(0.2)
                                        )
                                      ]
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(



                                            child: CachedNetworkImage(
                                              imageUrl: "$imageBaseUrl/${controller.order[index].image}",
                                              height: height,
                                              width: width,
                                              fit: BoxFit.fill,

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
                                                  width: height,
                                                  height: width,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Color(0xFFE8E8E8)
                                                  ),
                                                  child: Icon(Icons.image,size: 60,),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.image,size: 100,),
                                            ),),
                                          SizedBox(width: 12,),
                                          Expanded(child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Expanded(
                                                    child:Row(children: [
                                                      Text("marketPrice",style:productListPageTitleStyle,).tr(),
                                                      SizedBox(width: 5,),
                                                      Text("${controller.order[index].customerPrice} $symbol",style:productListPriceStyle,).tr(),

                                                    ],),

                                                  ),
                                                  role!='general'?GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        toolTip=!toolTip;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: Color(0xFF262324)
                                                      ),
                                                      child: Center(child: Text(symbol,style: TextStyle(color: Colors.white),)),
                                                    ),
                                                  ):SizedBox()
                                                ],
                                              ),
                                              SizedBox(height: 2,),
                                              controller.order[index].category!.type=="top-up"?SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context).size.width*0.35,
                                                child: TextFormField(
                                                  style: TextStyle(fontSize: 14,height: 1.5),
                                                  controller: playerIdController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: "Player ID",
                                                      hintStyle: productListPageHintStyle,
                                                      contentPadding: EdgeInsets.all(5),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: BorderSide(color: Color(0xFFDCDCDC))
                                                      )
                                                  ),
                                                ),
                                              ):SizedBox(height: 40,),
                                              Text(" $playerName",style: TextStyle(fontSize: 14),),
                                              SizedBox(height: 6,),
                                              Row(
                                                children: [
                                                  controller.order[index].category!.type=="top-up"?Expanded(flex: 3,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary: Color(0xFFBC985C),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5)
                                                            )
                                                        ),
                                                        onPressed: enabled?()async{
                                                          setState((){

                                                            loading=true;
                                                            enabled=false;
                                                          });
                                                          if(playerIdController.text.isEmpty){
                                                            setState((){
                                                              loading=false;
                                                              enabled=true;
                                                            });
                                                            showToast("pleaseEnterPlayerId").tr();
                                                            return;
                                                          }
                                                          setState((){
                                                            itemClickable=false;
                                                            descriptionEnabled=false;
                                                          });
                                                          var response=await sendPlayerIdAndGetName(playerIdController.text);
                                                          setState((){
                                                            itemClickable=true;
                                                            descriptionEnabled=true;
                                                            loading=false;
                                                            enabled=true;
                                                          });
                                                          if(response.statusCode==200){
                                                            var data=jsonDecode(response.body);
                                                            var name=data['palyer_name'];
                                                            if(name!="Not found"){
                                                              buyNowEnabled=true;
                                                              playerName=name;
                                                            }else{
                                                              playerName=name;
                                                              buyNowEnabled=false;
                                                            }

                                                            setState((){});
                                                          }else{
                                                            showToast("failed").tr();
                                                          }





                                                        }:null,
                                                        child: SvgPicture.asset("assets/images/pbgbtn.svg")
                                                    ),
                                                  ),):SizedBox(),
                                                  SizedBox(width: 5,),
                                                  Expanded(flex: 4,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Color(0xFF15375A),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5)
                                                          )
                                                      ),
                                                      onPressed: buyNowEnabled||controller.order[index].category!.type=='code'?() async{
                                                        setState((){
                                                          //loading=true;
                                                          enabled=false;
                                                          descriptionEnabled=false;
                                                        });
                                                        LoadingProgress.start(context);
                                                        var response=await sendAddCart(controller.order[index].id.toString(), "1",playerIdController.text);
                                                        setState((){
                                                          itemClickable=true;
                                                          buyNowEnabled=true;
                                                          //loading=false;
                                                          enabled=true;
                                                          descriptionEnabled=true;
                                                        });
                                                        LoadingProgress.stop(context);
                                                        if(response.statusCode==200){
                                                          var data=jsonDecode(response.body);
                                                          var message=data['message'];
                                                          showToast(message);
                                                          Navigator.of(context).push(PageTransition(child: CheekOutPage(playerId: playerIdController.text, playerName: playerName,), type: PageTransitionType.fade));
                                                        }else{
                                                          var data=jsonDecode(response.body);
                                                          var message=data['error'];
                                                          showToast(message);
                                                        }
                                                      }:null,
                                                      child: Text("buyNow",style: productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,).tr(),
                                                    ),
                                                  ),),
                                                  SizedBox(width: 5,),
                                                  Expanded(flex: 4,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Color(0xFF262324),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5)
                                                          )
                                                      ),
                                                      onPressed:descriptionEnabled? (){
                                                        Navigator.of(context).push(PageTransition(child: DetailPage(categoryList: controller.order[index],), type: PageTransitionType.fade));
                                                      }:null,
                                                      child: Text("description",style: productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,).tr(),
                                                    ),
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      toolTip? context.locale.toString().contains("en")?Positioned(
                                        top: 30,
                                        right: 0,
                                        child: SizedBox(
                                          child: Column(

                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding:EdgeInsets.only(right: 10),
                                                  child: RotatedBox(
                                                    quarterTurns: 0,
                                                    child: ClipPath(
                                                      clipper: ArrowClip(),
                                                      child: Container(
                                                        height: 10,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF262324),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF262324),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                                child: Center(
                                                  child: Text(
                                                    "salesPriceGettooltippricecontrollercategorylistindexSymbol",
                                                    style: productListToolTiptStyle,
                                                  ).tr( namedArgs: {
                                                    "price":getTooltipPrice(controller.order[index]).toString(),
                                                    "symbol":symbol,
                                                  }
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ):
                                      Positioned(
                                        top: 30,
                                        left: 10,
                                        child: SizedBox(
                                          child: Column(

                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding:EdgeInsets.only(right: 10),
                                                  child: RotatedBox(
                                                    quarterTurns: 0,
                                                    child: ClipPath(
                                                      clipper: ArrowClip(),
                                                      child: Container(
                                                        height: 10,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF262324),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF262324),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                                child: Center(
                                                  child: Text(
                                                    "salesPriceGettooltippricecontrollercategorylistindexSymbol",
                                                    style: productListToolTiptStyle,
                                                  ).tr( namedArgs: {
                                                    "price":getTooltipPrice(controller.order[index]).toString(),
                                                    "symbol":symbol,
                                                  }
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ):SizedBox()
                                    ],
                                  ),
                                ):Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,bottom: (index==controller.order.length-1)?30:10),
                                  padding: EdgeInsets.only(left: 11,top: 11,bottom: 11,right: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF77CEDA).withOpacity(0.2)
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(



                                        child: CachedNetworkImage(
                                          imageUrl: "$imageBaseUrl/${controller.order[index].image}",
                                          height: 120,
                                          width: 100,
                                          fit: BoxFit.fill,

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
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Color(0xFFE8E8E8)
                                              ),
                                              child: Icon(Icons.image,size: 60,),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.image,size: 100,),
                                        ),),
                                      SizedBox(width: 12,),
                                      Expanded(child: Column(

                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text(controller.order[index].title!,style: productListTitleTextStyle,),

                                          SizedBox(height: 13,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${controller.order[index].customerPrice!} $symbol",style: productListPriceTextStyle,),
                                              controller.order[index].outOfStock==true?Container(

                                                decoration: BoxDecoration(
                                                    color:Color(0xFFDA0200),

                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text("outOfStock",style: productListOutTextStyle,).tr(),
                                                padding: EdgeInsets.all(5),

                                              ):SizedBox(),
                                            ],
                                          )

                                        ],
                                      ))
                                    ],
                                  ),
                                )
                            );
                          }
                      );
                    }
                  })),


                ],
              ),
              Positioned(
                  right: 20,
                  top: MediaQuery.of(context).padding.top,
                  width: MediaQuery.of(context).size.width*0.45,
                  child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
              ),
              loading?Center(
                child: Image.asset("assets/images/loader.gif"),
              ):SizedBox()



            ],
          )
      ),

    );
  }
  //secret_key
  //public_key

  getTooltipPrice(SearchL categoryList) {

    return (double.parse(categoryList.wholesalerPrice??"0.0")-categoryList.specialDiscount.toDouble());
  }
}
class ArrowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

